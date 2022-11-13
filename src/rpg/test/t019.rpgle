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
      * @file t019.rpgle
      *
      * test of pcoptr()
      */

     h dftactgrp(*no)

      /copy mih-prcthd

     d pco_ptr         s               *
     d pco             ds                  qualified
     d                                     based(pco_ptr)
     d     sept_ptr                    *
     d                               48a
     d     qtemp                       *
      * system entry point table
     d septs           s               *   dim(7000)
     d                                     based(pco.sept_ptr)
     d qclrdtaq        s               *

      /free

           pco_ptr = pcoptr();
           // or
           // pco_ptr = pcoptr2();

           // locate system pointer to QCLRDTAQ
           qclrdtaq = septs(2899);

           // check qtemp and qclrdtaq

           *inlr = *on;
      /end-free
