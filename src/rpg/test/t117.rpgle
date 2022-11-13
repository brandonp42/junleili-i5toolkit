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
      * @file t117.rpgle
      *
      * Test of MATMDATA.
      */

     h dftactgrp(*no)

      /copy mih52
     d sleep           pr            10i 0 extproc('sleep')
     d     nsecs                     10u 0 value

     d start           s             20u 0
     d end             s             20u 0
     d dur             s             20u 0
     d local           s             20u 0
     d utc             s             20u 0
     d max_spc_size    s             10u 0

      /free
           mattod(start);
           sleep(3);
           mattod(end);

           dur = (end - start) / sysclock_one_second;
           dsply 'duration(s)' '' dur;

           matmdata(%addr(local) : x'0000');
           matmdata(%addr(utc) : x'0004');
           dur = %abs(utc - local);
           dur = dur/sysclock_one_hour;

           dsply 'Timezone diff with UTC (hours)' '' dur;

           // max space size when space alignment is
           // chosen by the machine
           matmdata(%addr(max_spc_size) : x'0003');
             // max_spc_size = 

           *inlr = *on;
      /end-free
