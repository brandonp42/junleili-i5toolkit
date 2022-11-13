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
      * @file t152.rpgle
      *
      * Test of _SETCA/_RETCA. Floating pointer calculation
      * under different rounding mode.
      *
      * @todo complete this test.
      */
     h dftactgrp(*no)

      /copy mih52
     d a               s              4f
     d b               s              4f   inz(3.0)
     d ca              s             10u 0

      /free
           a = 20;
           a /= b;
           a *= b; // A =   2.000000000000E+001

           ca = retca(x'01'); // retrieve round mode
           // set round mode to 'Round towards negative infinity'
           setca(x'0020' : x'01');
           ca = retca(x'01');
           a = 20;
           a /= b;
           a *= b; // A =   1.999999809265E+001

           // set round mode to 'Round towards positive infinity'
           setca(0       : x'01');
           ca = retca(x'01');
           a = 20;
           a /= b;
           a *= b; // A =   2.000000190735E+001

           *inlr = *on;
      /end-free
