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
      * @file t061.rpgle
      *
      * test of ACTBPGM, MATACTEX
      */

     h dftactgrp(*no)

      /copy mih52

     d dfn             ds                  likeds(actbpgm_dfn_t)
     d mar14a          s               *
     d haha_ptr        s               *   procptr
     /* procedure exported by *srvpgm MAR14A (1) */
     d haha            pr                  extproc(haha_ptr)
     d   msg                          8a
     d rtn             s             10u 0
     d msg             s              8a   inz('Ahu')

      /free
           // resolve *srvpgm mar14a (2)
           rslvsp_tmpl.obj_type = x'0203';
           rslvsp_tmpl.obj_name = 'MAR14A';
           rslvsp2(mar14a : rslvsp_tmpl);

           // activate *srvpgm (3)
           actbpgm(dfn : mar14a);

           // locate procedure haha exported by *srvpgm mar14a (4)
           matactex( dfn.act_mark   // activation mark
                   : 1              // by export ID
                   : 1              // export ID
                   : *null          // name operand, not used
                   : haha_ptr       // returned procedure pointer
                   : rtn );
           if rtn = 1;
               // invoke procedure haha (5)
               haha(msg);
           endif;

           *inlr = *on;
      /end-free
