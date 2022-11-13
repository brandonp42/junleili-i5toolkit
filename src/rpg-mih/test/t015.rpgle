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
      * @file t015.rpgle
      *
      * test of exp(), log(), mpyadd(), mpysub(), power()
      */

      /copy mih52

     d f               s              8f

      /free

          // exp() and log()
          f = exp(2)            ;
          dsply 'exp(2):' '' f  ;

          f = log(f)            ;
          dsply 'log(f):' '' f  ;

          // mpyadd() and mpysub()
      /if defined(*v5r4m0)
          f = mpyadd(2.1 : 7.5 : 16.9);
          dsply 'MPYADD' '' f;

          f = mpysub(2.1 : 7.5 : 16.9);
          dsply 'MPYSUB' '' f;
      /endif

          f = power(2 : 32);
          dsply '2^32' '' f;

          *inlr = *on;
      /end-free
