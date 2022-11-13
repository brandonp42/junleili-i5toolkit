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
      * @file t028.rpgle
      *
      * test of matptr()
      *
      * Materialize a SYSPTR
      */

     h dftactgrp(*no)
      /copy mih52

     d ptr             s               *
     d domain          s             10a   inz('System')

     d info_ptr        s               *
     d sysptr_info     ds                  likeds(matptr_sysptr_info_t)
     d                                     based(info_ptr)

      /free

           // resolve the SYSPTR addresses to myself
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T028';
           rslvsp2(ptr : rslvsp_tmpl);

           // allocate MATPTR template buffer
           sysptr_info.bytes_in = %size(sysptr_info);

           matptr(sysptr_info : ptr);

           // check structure sysptr_info for returned SYSPTR info
           dsply 'Library' '' sysptr_info.ctx_name;
           dsply 'Program' '' sysptr_info.obj_name;

           if tstbts(%addr(sysptr_info.ptr_target) : 0) = 1;
               // SYSPTR can be accessed from user state
               // in other words, SYSPTR is in user domain
               domain = 'User';
           endif;
           dsply 'Domain' '' domain;

           *inlr = *on;
      /end-free
