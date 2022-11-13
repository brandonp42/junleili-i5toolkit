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
      * @file t069.rpgle
      *
      * test of CTD
      */
     h dftactgrp(*no)

      /copy mih-dattim

     d tmpl            ds                  likeds(compute_dattim_t)

      * ISO time
     d morning         s             10a   inz('07.50.11')
     d evening         s             10a   inz('19.11.12')
     d dur             s              6p 0

      /free
           tmpl = *allx'00';
           tmpl.size = %size(tmpl);
           tmpl.op1_ddat_num = 1;
           tmpl.op2_ddat_num = 2;
           tmpl.op3_ddat_num = 2;
           tmpl.op2_len      = 8; // length os ISO time
           tmpl.op3_len      = 8;
           tmpl.ddat_list_len= 256;
           tmpl.ddats        = 2;
           tmpl.off_ddat1    = 24;
           tmpl.off_ddat2    = 140;
           tmpl.ddat1        = time_duration_ddat_value;
           tmpl.ddat2        = iso_time_ddat_value;

           ctd( %addr(dur)
              : evening
              : morning
              : tmpl );

           dsply 'durantion' '' dur;
             // DSPLY  durantion    112101

           *inlr = *on;
      /end-free
