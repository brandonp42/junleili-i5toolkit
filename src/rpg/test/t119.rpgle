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
      * @file t119.rpgle
      *
      * ACTBPGM can NOT be used to reinitialize static variables in ILE RPG programs.
      *
      * @remark ILE RPG program T119A increase a subprocedure-local
      *         static variable val each time it is invoked.
      */

      /if defined(*crtbndrpg)
     h dftactgrp(*no)
      /endif

      /copy mih52
     d pgm             s               *
     d act_dfn         ds                  likeds(actbpgm_dfn_t)
     d t119a           pr                  extpgm('T119A')
      /free
           // activate ILE RPG program T119A
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T119A';
           rslvsp2(pgm : rslvsp_tmpl);
           actbpgm(act_dfn : pgm);

           // call T119A for three times
           t119a();  // val = 7
           t119a();  // val = 8
           t119a();  // val = 9

           // re-initialize static storage of T119A
           actbpgm(act_dfn : pgm);

           // call T119A again
           t119a();  // val = 10

           *inlr = *on;
      /end-free
