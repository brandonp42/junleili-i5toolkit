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
      * @file t083.rpgle
      *
      * Test of _RSLVDP3.
      */
     h dftactgrp(*no)

      /copy mih52
     d spc_ptr         s               *
     d ext_data_obj    s             24a   based(spc_ptr)
     d                 ds
     d proc_ptr                        *   procptr
     d dta_ptr                         *   overlay(proc_ptr)
     d asf             s               *
     d pgm             s               *
     d obj_name        s             32a   inz('VVV')

      /free
           // resolve program object T083_B
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T083_B';
           rslvsp2(pgm : rslvsp_tmpl);

           // activate program T083_B
           actpg(asf : pgm);

           // resolve external data object VVV
           rslvdp3(dta_ptr : obj_name : pgm);

           // abtain space pointer from dta_ptr
           spc_ptr = setsppfp(proc_ptr);

           dsply 'external data object' '' ext_data_obj;

           *inlr = *on;
      /end-free
