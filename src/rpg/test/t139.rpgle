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
      * @file t139.rpgle
      *
      * Test of _MATPRMTX.
      */

     h dftactgrp(*no)

      /copy mih52
     d rcv             ds                  likeds(matprmtx_tmpl_a_t)
     d                                     based(ptr)
     d ptr             s               *
     d ptr_tmpl        ds                  likeds(
     d                                       matpratr_ptr_tmpl_t)
     d pr_opt          s              1a   inz(x'25')
     d opt             s             10u 0
     d len             s             10i 0

      /free
           ptr = %alloc(16);
           rcv = *allx'00';
           rcv.bytes_in = 16;

           ptr_tmpl.bytes_in = %size(matpratr_ptr_tmpl_t);
           matpratr1(ptr_tmpl : pr_opt);

           opt = 0;
           matprmtx(rcv : ptr_tmpl.ptr : opt);

           dealloc ptr;
           *inlr = *on;
      /end-free
