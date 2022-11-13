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
      * @file t162.rpgle
      *
      * Test of:
      *  - _DECD (Decrement Date)
      *  - _INCD (Increment Date)
      */

     h dftactgrp(*no)

      /copy mih-dattim
      /copy mih-spt
     d tmpl            ds                  likeds(dec_inc_dattim_t)

      * ISO date, Mar 31, 2011
     d march31         s             10a   inz('2008-03-31')
     d one_month_ago   s             10a

      * date duration, one month
     d one_month       s              8p 0 inz(00000100)

      /free
           tmpl = *allx'00';
           tmpl.size = %size(tmpl);
           tmpl.op1_ddat_num = 1;
           tmpl.op2_ddat_num = 1;
           tmpl.op3_ddat_num = 2;
           tmpl.op1_len      = 10; // ISO date
           tmpl.op2_len      = 10; // ISO date
           // length of date duration. The higher byte is the number
           // of fractional digits. The lower byte is the number of total
           // digits.
           tmpl.op3_len      = x'0008';
           tmpl.ddat_list_len= 256;
           tmpl.ddats        = 2;
           tmpl.off_ddat1    = 24;
           tmpl.off_ddat2    = 140;
           tmpl.ddat1        = iso_date_ddat_value;
           tmpl.ddat2        = date_duration_ddat_value;
           tmpl.input_ind    = x'8000'; // enable "end of month adjustment"

           decd ( one_month_ago
                : march31
                : %addr(one_month)
                : tmpl );
           dsply 'One month before Mar 31, 2008' '' one_month_ago;
               // DSPLY  One month before Mar 31, 2008    2008-02-29
               // tmpl.output_ind: x'8000'

           tmpl.input_ind    = x'0000'; // disable "end of month adjustment"
           tmpl.ddat2.month_def = 30;
           tmpl.ddat2.year_def  = 365;
           decd ( one_month_ago
                : march31
                : %addr(one_month)
                : tmpl );
           dsply 'One month before Mar 31, 2008' '' one_month_ago;
             // DSPLY  One month before Mar 31, 2008    2008-03-01

           incd ( march31
                : one_month_ago
                : %addr(one_month)
                : tmpl );
           dsply 'march31' '' march31;
             // the result is '2008-03-31', NOT '2008-04-01'

           tmpl.input_ind = x'8000'; // enable end-of-month-adjustment again
           tmpl.ddat2.month_def = 0;
           tmpl.ddat2.year_def  = 0;
           incd ( march31
                : one_month_ago
                : %addr(one_month)
                : tmpl );
           dsply 'march31' '' march31;
             // DSPLY  march31    2008-04-01

           *inlr = *on;
      /end-free
