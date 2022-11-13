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
      * @file t160.rpgle
      *
      * Test of _CTSD (Compute Timestamp Duration).
      */

     h dftactgrp(*no)

      /copy mih-dattim
     d tmpl            ds                  likeds(compute_dattim_t)

      * SAA timestamps
     d children_day    s             26a   inz('2011-06-01-00.00.00.000000')
     d some_day        s             26a   inz('2011-05-29-23.59.59.555000')
     d dur             s             20p 6

      * Dates in the system internal format

      /free
           tmpl = *allx'00';
           tmpl.size = %size(tmpl);
           tmpl.op1_ddat_num = 1;
           tmpl.op2_ddat_num = 2;
           tmpl.op3_ddat_num = 2;
           tmpl.op2_len      = 26; // length os ISO date
           tmpl.op3_len      = 26;
           tmpl.ddat_list_len= 256;
           tmpl.ddats        = 2;
           tmpl.off_ddat1    = 24;
           tmpl.off_ddat2    = 140;
           tmpl.ddat1        = timestamp_duration_ddat_value;
           tmpl.ddat2        = saa_timestamp_ddat_value;

           ctsd( %addr(dur)
               : children_day
               : some_day
               : tmpl );
           dsply 'timestamp duration' '' dur;
             // DSPLY  timestamp duration           2000000445000
             // aka. 2 days and 445000 microseconds

           *inlr = *on;
      /end-free
