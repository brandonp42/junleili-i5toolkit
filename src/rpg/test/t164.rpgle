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
      * @file t164.rpgle
      *
      * Test of:
      *  - _DECTS (Decrement Timestamp)
      *  - _INCTS (Increment Timestamp)
      *
      * Here a timestamp is decremented/incremented by a timestamp duration.
      */

     h dftactgrp(*no)

      /copy mih-dattim
      /copy mih-spt
     d tmpl            ds                  likeds(dec_inc_dattim_t)

      * SAA timestamp, Mar 31, 2011
     d march31         s             26a   inz('2008-03-31-00.00.00.000000')
     d one_month_ago   s             26a

      * timestamp duration, one month
     d one_month       s             20p 6 inz(100000000.000000)

      /free
           tmpl = *allx'00';
           tmpl.size = %size(tmpl);
           tmpl.op1_ddat_num = 1;
           tmpl.op2_ddat_num = 1;
           tmpl.op3_ddat_num = 2;
           tmpl.op1_len      = 26; // SAA timestamp
           tmpl.op2_len      = 26; // SAA timestamp
           // length of date duration. The higher byte is the number
           // of fractional digits. The lower byte is the number of total
           // digits.
           tmpl.op3_len      = x'0614'; // pkd(20,6)
           tmpl.ddat_list_len= 256;
           tmpl.ddats        = 2;
           tmpl.off_ddat1    = 24;
           tmpl.off_ddat2    = 140;
           tmpl.ddat1        = saa_timestamp_ddat_value;
           tmpl.ddat2        = timestamp_duration_ddat_value;
           tmpl.input_ind    = x'8000'; // enable "end of month adjustment"

           dects( one_month_ago
                : march31
                : %addr(one_month)
                : tmpl );
           dsply '1 month before 08/03/31' '' one_month_ago;
               // DSPLY  1 month before 08/03/31    2008-02-29-00.00.00.000000
               // tmpl.output_ind: x'8000'

           tmpl.input_ind    = x'0000'; // disable "end of month adjustment"
           tmpl.ddat2.month_def = 30;
           tmpl.ddat2.year_def  = 365;
           dects( one_month_ago
                : march31
                : %addr(one_month)
                : tmpl );
           dsply '1 month before 08/03/31' '' one_month_ago;
             // DSPLY  1 month before 08/03/31    2008-03-01-00.00.00.000000

           incts( march31
                : one_month_ago
                : %addr(one_month)
                : tmpl );
           dsply 'march31' '' march31;
             // DSPLY  march31    2008-03-31-00.00.00.000000

           tmpl.input_ind = x'8000'; // enable end-of-month-adjustment again
           tmpl.ddat2.month_def = 0;
           tmpl.ddat2.year_def  = 0;
           incts( march31
                : one_month_ago
                : %addr(one_month)
                : tmpl );
           dsply 'march31' '' march31;
             // DSPLY  march31    2008-04-01-00.00.00.000000

           *inlr = *on;
      /end-free
