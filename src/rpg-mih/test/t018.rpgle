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
      * @file t018.rpgle
      *
      * test of memmove()
      */

      /copy mih52

     d ds              ds                  qualified
     d     p1                          *
     d     p2                          *

     d words           s             16a   inz('Hello!  World!')
     d hello           ds             8    based(ds.p1)
     d world           ds             8    based(ds.p2)
     d ptr             s               *

      /free

           // set ds.p1, ds.p2
           ds.p1 = %addr(words);
           ds.p2 = %addr(words) + 8;
           dsply hello '' world;

           // exchange 2 pointers in DS by memmove()
           // instruction MEMMOVE can be used to copy pointers!
           memmove(%addr(ptr) : %addr(ds.p1) : 16);
           memmove(%addr(ds.p1) : %addr(ds.p2) : 16);
           memmove(%addr(ds.p2) : %addr(ptr) : 16);
           dsply hello '' world;

           *inlr = *on;
      /end-free
