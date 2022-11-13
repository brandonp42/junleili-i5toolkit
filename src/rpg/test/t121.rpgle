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
      * @file t121.rpgle
      *
      *  - Activate T121A
      *  - Locate static variable i_static in T121A
      *  - Call T121A
      *  - Check the value of i_static
      * /

     h dftactgrp(*no)

      /copy mih52
      * prototype of T121A
     d t121a           pr                  extpgm('T121A')
     d pgm             s               *
     d act_dfn         ds                  likeds(actbpgm_dfn_t)
     d ssf_list        ds                  likeds(act_ssf_list_t)
     d attr            s              1a
     d init_val        c                   'All good wishes'
      * here ds: str + i_static(10u0)
     d                 ds                  based(pos)
     d nail_str                      16a
     d i_static                      10u 0
     d pos             s               *
     d ssf_data        s          32766a   based(ssf_ptr)
     d ssf_ptr         s               *
     d offset          s              5p 0
     d eoff            s              5p 0
     d loff            s              5p 0
     d coff            s              5p 0
     d rinz_tmpl       ds                  likeds(rinzstat_tmpl_t)

      /free
           // activate ILE RPG program T121A
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T121A';
           rslvsp2(pgm : rslvsp_tmpl);
           actbpgm(act_dfn : pgm);

           // call ... once
           t121a();

           // retrieve T121A's SSF list
           attr = x'01';  // materialize SSF list
           ssf_list.bytes_in = %size(ssf_list);
           matactat(%addr(ssf_list) : act_dfn.act_mark : attr);
           ssf_ptr = ssf_list.ssf_ent(1).ssf_ptr;
           // find estr
           offset = %scan('export me' : ssf_data);
           if offset > 0;
               eoff = offset - 1;
               pos = ssf_ptr + offset - 1;
               dsply nail_str '' i_static;
           endif;

           // find lstr
           offset = %scan('local one' : ssf_data);
           if offset > 0;
               loff = offset - 1;
               pos = ssf_ptr + offset - 1;
               dsply nail_str '' i_static;
           endif;

           // find good wishes
           offset = %scan(init_val : ssf_data);
           if offset > 0;
               coff = offset - 1;
               pos = ssf_ptr + offset - 1;
               dsply nail_str '' i_static;
           endif;

           // RINZSTAT
           rinz_tmpl.pgm = pgm;
           rinz_tmpl.agp_mark = act_dfn.agp_mark;
           rinzstat(rinz_tmpl);

           pos = ssf_ptr + eoff;
           dsply nail_str '' i_static;
             // exported static vars are resetted by RINZSTAT

           pos = ssf_ptr + loff;
           dsply nail_str '' i_static;
             // local static vars can NOT be resetted by RINZSTAT

           pos = ssf_ptr + coff;
           dsply nail_str
             '' i_static;
             // common static vars can NOT be resetted by RINZSTAT

           *inlr = *on;
      /end-free
