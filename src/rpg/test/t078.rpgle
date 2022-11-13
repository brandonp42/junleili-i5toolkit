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
      * @file t078.rpgle
      *
      * Test of _RETTHCNT, _TSTINLTH, and _TESTINTR.
      *
      */
     h dftactgrp(*no)

      /copy mih52

     d cnt             s             10u 0
     d init_thd        s             10i 0
     d int_info        s             10u 0

      /free
           cnt = retthcnt();
           dsply 'threads' '' cnt;

           init_thd = tstinlth();
           dsply 'initial thread flag' '' init_thd;

           int_info = testintr();
           dsply 'pending interrupt info' '' int_info;

           *inlr = *on;
      /end-free
