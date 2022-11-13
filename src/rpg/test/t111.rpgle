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
      * @file t111.rpgle
      *
      * Test of MATAL.
      */

     h dftactgrp(*no)
      /copy mih52

     d len             s              5u 0
     d autl            s               *
     d tmpl            ds                  likeds(matal_tmpl_t)
     d opt             ds                  likeds(matal_option_t)

      /free
           rslvsp_tmpl.obj_type = x'1B01'; // *usrprf
           rslvsp_tmpl.obj_name = 'LSAU';
           rslvsp2(autl : rslvsp_tmpl);

           propb(%addr(tmpl) : x'00' : %size(tmpl));
           tmpl.bytes_in = %size(matal_tmpl_t);
           propb(%addr(opt) : x'00' : %size(opt));
           opt.flag = x'12';     // materialize number of entries
           opt.criteria = x'01'; // select by object type
           opt.type_code = x'02'; // select program objects
           matal(tmpl : autl : opt);
             // MCH6801 under QSECURITY 40 or above

           *inlr = *on;
      /end-free
