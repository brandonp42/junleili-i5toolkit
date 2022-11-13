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
      * @file t119a.rpgle
      *
      * Used by t119.rpgle.
      *
      * t119a.rpgle use a local static variable val which is increased
      * by 1 each time it is invoked.
      *
      * @remark This program uses named activation group.
      */

     h dftactgrp(*no) actgrp('T119A')

      * prototype of subprocedure func()
     d func            pr

      /free
           func();
           *inlr = *on;
      /end-free

      * implementation of subprocedure func()
     p func            b
     d                 pi
      * local static variable var
     d val             s              3p 0 inz(7)
     d                                     static

      /free
           dsply 'val =' '' val;
           val += 1;
      /end-free
     p func            e
