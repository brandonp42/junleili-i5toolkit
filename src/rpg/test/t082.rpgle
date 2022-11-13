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
      * @file t082.rpgle
      *
      * Test of _MATPTRL. This test program finds out the locations of
      * pointers within a data structure.
      */
     h dftactgrp(*no)

      /copy mih52
     d buf             ds
     d     a                          3a   inz('abc')
     d                                5a
     d     b                         20u 0 inz(7788)
     d     c                           *   inz(%addr(buf))

     d len             s             10i 0 inz(%size(buf))
     d result          ds                  likeds(matptrl_tmpl_t)

      /free
           propb(%addr(result) : x'00' : %size(result));
           result.bytes_in = %size(result);
           matptrl( result
                  : %addr(buf)
                  : len);
              // result.bitmap = x'4000...'

           *inlr = *on;
      /end-free
