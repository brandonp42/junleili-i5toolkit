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
      * @file t135.rpgle
      *
      * Test of MATS and MODS.
      */

     h dftactgrp(*no)

      /copy mih-ptr
      /copy mih-comp
      /copy mih-spc

     d uept            s               *
     d tmpl            ds                  likeds(mats_tmpl_t)
     d mod_tmpl        ds                  likeds(mods_tmpl_t)
     d auto_extend     s               n   inz(*off)

      /free

           rslvsp_tmpl.obj_type = x'1934';
           rslvsp_tmpl.obj_name = 'UEPT';
           rslvsp2(uept : rslvsp_tmpl);

           tmpl.bytes_in = %size(tmpl);
           mats(tmpl : uept);

           // check creation options of target space object

           // Automatically extend space
           if tstbts(%addr(tmpl.crt_option) : 14) > 0;
               auto_extend = *on;
           else;
               mod_tmpl = *allx'00';
               // Modify automatically extend space attribute
               setbts(%addr(mod_tmpl.selection) : 6);
               // Automatically extend space = Yes
               setbts(%addr(mod_tmpl.attr) : 3);
               mods2(uept : mod_tmpl);
           endif;

           *inlr = *on;
      /end-free
