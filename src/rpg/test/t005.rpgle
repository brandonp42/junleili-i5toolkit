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
      * @file t005.rpgle
      *
      * test of atan, atanh, cot
      */

     h dftactgrp(*no)
      /copy mih52
     d f               s              8f

      /free
          f = atan(1);
          dsply 'atan(1)' '' f;

          f = atanh(0.5);
          dsply 'atanh(0.5)' '' f;

          f = cot(0.785)        ;
          dsply 'cot(0.785)' '' f ;

          f = tan(acos(0)/2);
          dsply 'tan(Pi/4)' '' f ;

          f = tanh(acos(0)/2);
          dsply 'tanh(Pi/4)' '' f ;

          *inlr = *on;
      /end-free

