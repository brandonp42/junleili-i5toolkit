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
      * @file t027.rpgle
      *
      * test of modasa(), matptr()
      */

     h dftactgrp(*no)
      /copy mih52

     d a               s             35a
     d b               s             12a
     d ptr             s               *
     d len             s             10i 0

     d info_ptr        s               *
     d spcptr_info     ds                  likeds(matptr_spcptr_info_t)
     d                                     based(info_ptr)

      /free

           ptr = %addr(a);
           len = matptr_spcptr_info_length;
           info_ptr = modasa(len);
           spcptr_info.bytes_in = matptr_spcptr_info_length;

           matptr(info_ptr : ptr);

           // check structure spcptr_info for returned SPCPTR info

           *inlr = *on;
      /end-free
