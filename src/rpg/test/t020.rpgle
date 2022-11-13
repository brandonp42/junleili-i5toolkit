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
      * @file t020.rpgle
      *
      * test of retca(), setca()
      */

     h dftactgrp(*no)
      /copy mih52

     d f1              s              8f   inz(99.5)
     d f2              s              8f
     d ca              s             10u 0

      /free

           monitor;
               f1 /= f2;
           on-error;
               // get exception occurance status
               ca = retca(x'02');  // ca = x'00000C00'
                                   // byte 2 = x'0C'
                                   // bit 4 = 1, Floating-point zero divide
                                   // bit 6 = 1, Floating-point invalid operand
           endmon;

           // get current exception mask            
           ca = retca(x'08');      // ca = x'3A000000', byte 1 = x'3A'
                                   // bit 2 = 1, Floating-point overflow
                                   // bit 3 = 1, Floating-point underflow
                                   // bit 4 = 1, Floating-point zero divide
                                   // bit 6 = 1, Floating-point invalid operand

           // clear exception masks to suppress all floating-point exceptions
           setca(x'00000000' : x'08');
           f1 /= f2;
           dsply 'after setca()';  // no floating-point exception detected!

           *inlr = *on;
      /end-free
