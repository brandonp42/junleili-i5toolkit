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
      * @file t065.rpgle
      *
      * test of ept54.rpgle
      *  - call Operational Assistant API Send Message (QEZSNDMG)
      */
     h dftactgrp(*no)

      /copy mih54
      /copy ept54

     d ept_ptr         s               *
     d septs           s               *   dim(7001)
     d                                     based(ept_ptr)
     d argv            s               *   dim(1)

      /free
           // address the SEPT
           ept_ptr = sysept();

      /if defined(*v5r4m0)
           // call Operational Assistant API Send Message (QEZSNDMG)
           callpgmv( septs(EPT_QEZSNDMG)
                   : argv
                   : 0);
      /endif

           *inlr = *on;
      /end-free
