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
      * @file t086.rpgle
      *
      * Test of instruction CMPSW.
      */
     h dftactgrp(*no)

      /copy mih52
     d stg             s              1a   inz(x'81')
     d old_val         s              1a
     d new_val         s              1a   inz(x'C1')
     d stg4            s              4a   inz(x'81828384')
     d old_val4        s              4a
     d new_val4        s              4a   inz(x'C1C2C3C4')

      /free
           // _CMPSWP1
           old_val = stg;
           dow cmpswp1(old_val : stg : new_val) = 0; // while not EQUAL
               new_val = x'C1';
           enddo;

           dsply 'new value of shared storage' '' stg;

           // _CMPSWP4
           old_val = stg;
           dow cmpswp4(old_val4 : stg4 : new_val4) = 0; // while not EQUAL
               new_val = x'C1C2C3C4';
           enddo;

           dsply 'new value of shared storage' '' stg4;

           *inlr = *on;
      /end-free
