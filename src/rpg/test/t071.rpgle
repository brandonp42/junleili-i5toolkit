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
      * @file t071.rpgle
      *
      * test _ATMCADD4/8, _ATMCAND4/8, and _ATMCOR4/8
      */
     h dftactgrp(*no)

      /copy mih54

     d a               s             10i 0 inz(7)
     d b               s             20i 0 inz(7)
     d c               s             10u 0 inz(7)
     d d               s             20u 0 inz(7)
     d r1              s             10i 0
     d r2              s             20i 0
     d r3              s             10u 0
     d r4              s             20u 0

      /free
      /if defined(*v5r4m0)
           r1 = atmcadd4(a : 1);  // r1 = 7, a = 8
           r1 = atmcadd4(a : -1); // r1 = 8, a = 7
           r2 = atmcadd8(b : 1);  // r2 = 7, b = 8
           r2 = atmcadd8(b : -1); // r2 = 8, b = 7
           r3 = atmcand4(c : 0);  // r3 = 7, c = 0
           r4 = atmcand8(d : 0);  // r4 = 7, d = 0
           r3 = atmcor4(c : 7);   // r3 = 0, c = 7
           r4 = atmcor8(d : 7);   // r4 = 0, d = 7
      /endif
           *inlr = *on;
      /end-free
