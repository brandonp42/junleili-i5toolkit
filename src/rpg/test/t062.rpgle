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
      * @file t062.rpgle
      *
      * test of __setjmp2; generate label pointer
      */

     h dftactgrp(*no)

      /copy mih52

     d label           s               *
     d ptr_info        ds                  likeds(
     d                                       matptr_lblptr_info_t)
     d                                     based(info_ptr)
     d info_ptr        s               *

      /free
           // set label pointer
           setjmp2(label);

           // materialize attributes of LBLPTR label
           info_ptr = %alloc(min_lblptr_info_len);
           ptr_info.bytes_in = min_lblptr_info_len;
           matptr (info_ptr : label);
             // ptr_info.stmts(1) = 1456
             // refer to stmt ID in source listing

           dealloc info_ptr;
           *inlr = *on;
      /end-free
