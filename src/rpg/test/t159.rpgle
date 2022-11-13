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
      * @file t159.rpgle
      *
      * Test of _CVTD (Convert Date).
      */

     h dftactgrp(*no)

      /copy mih-dattim
     d tmpl            ds                  likeds(convert_dattim_t)

      * ISO date
     d children_day    s             10a   inz('2011-06-01')
     d labor_day       s             10a   inz('2011-05-01')

      * system internal date
     d int_date        s             10u 0 inz(0)

      * Dates in the system internal format

      /free
           tmpl = *allx'00';
           tmpl.size = %size(tmpl);
           tmpl.op1_ddat_num = 1;
           tmpl.op2_ddat_num = 2;
           tmpl.op1_len      = 4;  // internal date
           tmpl.op2_len      = 10; // length os ISO date
           tmpl.ddat_list_len= 256;
           tmpl.ddats        = 2;
           tmpl.off_ddat1    = 24;
           tmpl.off_ddat2    = 140;
           tmpl.ddat1        = internal_date_ddat_value;
           tmpl.ddat2        = iso_date_ddat_value;

           cvtd( %addr(int_date)
               : %addr(children_day)
               : tmpl );
           dsply 'Internal date value of the Children''s Day'
               '' int_date;
               // DSPLY  Internal date value of the Children's Day       2455714

           cvtd( %addr(int_date)
               : %addr(labor_day)
               : tmpl );
           dsply 'Internal date value of the Labor Day'
               '' int_date;
               // DSPLY  Internal date value of the Labor Day       2455683
               // The date duration is: 2455714 - 2455683 = 31 days

           *inlr = *on;
      /end-free
