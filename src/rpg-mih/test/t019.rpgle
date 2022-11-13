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
      * @file t019.rpgle
      *
      * test of pcoptr()
      */

      /copy mih52

     d pco_ptr         s               *
     d sept_ptr        s               *
     d septs           s               *   dim(7000) based(sept_ptr)
     d qclrdtaq        s               *

      /free

           pco_ptr = pcoptr();
           memcpy(%addr(sept_ptr) : pco_ptr : 16);

           // locate system pointer to QCLRDTAQ
           qclrdtaq = septs(2899);

           *inlr = *on;
      /end-free
