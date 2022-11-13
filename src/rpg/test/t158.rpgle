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
      * @file t158.rpgle
      *
      * Test of _CDD (Compute Date Duration).
      */

     h dftactgrp(*no)

      /copy mih-dattim
     d tmpl            ds                  likeds(compute_dattim_t)

      * ISO date
     d children_day    s             10a   inz('2011-06-01')
     d labor_day       s             10a   inz('2011-05-01')
     d dur             s              8p 0

      * Dates in the system internal format

      /free
           tmpl = *allx'00';
           tmpl.size = %size(tmpl);
           tmpl.op1_ddat_num = 1;
           tmpl.op2_ddat_num = 2;
           tmpl.op3_ddat_num = 2;
           tmpl.op2_len      = 10; // length os ISO date
           tmpl.op3_len      = 10;
           tmpl.ddat_list_len= 256;
           tmpl.ddats        = 2;
           tmpl.off_ddat1    = 24;
           tmpl.off_ddat2    = 140;
           tmpl.ddat1        = date_duration_ddat_value;
           tmpl.ddat2        = iso_date_ddat_value;

           cdd( %addr(dur)
              : children_day
              : labor_day
              : tmpl );
           dsply 'date duration' '' dur;
             // DSPLY  date duration         100
             // aka. one month

           *inlr = *on;
      /end-free
