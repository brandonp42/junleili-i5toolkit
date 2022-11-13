     /**
      * This file is part of i5/OS Programmer's Toolkit.
      *
      * Copyright (C) 2010, 2011  Junlei Li.
      *
      * i5/OS Programmer's Toolkit is free software: you can redistribute it and/or modify
      * it under the terms of the GNU General Public License as published by
      * the Free Software Foundation, either version 3 of the License, or
      * (at your option) any later version.
      *
      * i5/OS Programmer's Toolkit is distributed in the hope that it will be useful,
      * but WITHOUT ANY WARRANTY; without even the implied warranty of
      * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
      * GNU General Public License for more details.
      *
      * You should have received a copy of the GNU General Public License
      * along with i5/OS Programmer's Toolkit.  If not, see <http://www.gnu.org/licenses/>.
      */

     /**
      * @file t072.rpgle
      *
      * test of _RINZSTAT.
      *
      * @remark _RINZSTAT only affects programs compiled with ALWRINZ(*YES).
      *
      * Output of T072:
      * @code
      * DSPLY      1             6
      * DSPLY      2             7
      * DSPLY      3             8
      * DSPLY      4             9
      * DSPLY      5            10
      * DSPLY  After RINZSTAT:             5
      * @endcode
      */

      /if defined(*crtbndrpg)
     h dftactgrp(*no)
      /endif

      /copy mih52

     d ind             s              5i 0
     d pgm             s               *
     d act_dfn         ds                  likeds(actbpgm_dfn_t)
     d rinz_tmpl       ds                  likeds(rinzstat_tmpl_t)
      * output param of ILE C PGM T072B
     d rtn             s             10i 0 inz(5)

     d t072b           pr                  extpgm('T072B')
     d     rtn                       10i 0

      /free
           // activate ILE C PGM t072b
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T072B';
           rslvsp2(pgm : rslvsp_tmpl);
           actbpgm(act_dfn : pgm);

           // call t072b for 5 times
           for ind = 1 to 5;
               t072b(rtn);
               dsply ind '' rtn;
           endfor;

           // re-initialize static storage of t072b
           rinz_tmpl.pgm = pgm;
           rinz_tmpl.agp_mark = act_dfn.agp_mark;
           rinzstat(rinz_tmpl);

           // call t072b again
           t072b(rtn);
           dsply 'After RINZSTAT:' '' rtn;

           *inlr = *on;
      /end-free
