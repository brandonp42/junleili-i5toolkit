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
      * @file t001.rpgle
      *
      * test of acos, cos, cosh, sin, sinh
      */

     h dftactgrp(*no)
      /copy mih52
     d f               s              8f

      /free
          f = acos(0.5);
          dsply 'acos:' '' f;

          f = cos(f);
          dsply 'cos:' '' f;

          f = cosh(f);
          dsply 'cosh:' '' f;

          f = acos(0);  // Pi/2
          f = sin(f);
          dsply 'sin(Pi/2):' '' f;

          f = sinh(acos(0));
          dsply 'sinh(Pi/2):' '' f;

          *inlr = *on;
      /end-free
