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
      * @file t102.rpgle
      *
      * Test of _MATINVS1.
      * Meterialize the call stack of the initial thread of another process.
      */
     h dftactgrp(*no)

      /copy mih52
     d len             s             10i 0
     d ptr             s               *
     d pos             s               *
     d tmpl            ds                  likeds(matinvs_tmpl_t)
     d                                     based(ptr)
     d inve            ds                  likeds(invocation_entry_t)
     d                                     based(pos)
     d i               s             10i 0
     d spc_spr37       ds                  qualified
     d                                     based(spp)
     d      pcs                        *
     d spp             s               *
      * system pointer to *USRSPC *LIBL/SPR37.
     d                 ds
     d spr37                           *
     d funny_ptr                       *   procptr
     d                                     overlay(spr37:1)

      /free
           // load another process' pcs from space object spr37
           rslvsp_tmpl.obj_type = x'1934';
           rslvsp_tmpl.obj_name = 'SPR37';
           rslvsp2(spr37 : rslvsp_tmpl);
           spp = setsppfp(funny_ptr);
             // check pcs

           ptr = %alloc(min_matinvs_tmpl_length);
           tmpl.bytes_in = min_matinvs_tmpl_length;
           matinvs1(tmpl : spc_spr37.pcs);

           len = tmpl.bytes_out;
           ptr = %realloc(ptr : len);
           tmpl.bytes_in = len;
           matinvs1(tmpl : spc_spr37.pcs);

           // check each call stack entry
           pos = ptr + min_matinvs_tmpl_length;
           for i = 1 to tmpl.entries;
               // check inve

               pos += invocation_entry_length;
           endfor;

           dealloc ptr;
           *inlr = *on;
      /end-free
