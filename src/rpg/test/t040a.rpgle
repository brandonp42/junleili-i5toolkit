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
      * @file t040a.rpgle
      *
      * test of matinvat()
      *
      * call prgram T040
      */

     h dftactgrp(*no)

     d func            pr

      /free
           func();
           *inlr = *on;
      /end-free

     p func            b
     d func            pi

     d tom_sawyer      ds
     d     fb                         4a   inz('Tom')
     d     fc                         8a   inz('Sawyer')

     c                   call      'O45'
     c     'tom_sawyer'  dsply                   tom_sawyer
     p func            e
