     /**
      * This file is part of i5/OS Programmer's Toolkit.
      *
      * Copyright (C) 2009  Junlei Li.
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
      * @file t033.rpgle
      *
      * test of teraspace APIs
      */

     h bnddir('QC2LE')

      /copy mih52
      /copy ts

     d ptr             s               *
     d val             ds                  qualified
     d                                     based(ptr)
     d     n                          9p 0
     d     str                        3a

     d pos             s               *
     d buf             ds             3    based(pos)

      /free

           ptr = ts_calloc(1 : 33554432); // allocate 32MB teraspace storage
           val.n = 95;
           val.str = 'ABC';

           ptr += 16777216; // offset 16M bytes
           val.n = 96;
           val.str = 'DEF';
           ptr -= 16777216;

           pos = findbyte(ptr : 'D'); // search for character 'D'
           dsply 'Get it!' '' buf;

           ts_free(ptr); // free allocated teraspace storage

           *inlr = *on;
      /end-free
