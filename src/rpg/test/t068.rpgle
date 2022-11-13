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
      * @file t068.rpgle
      *
      * test of CDD
      */
     h dftactgrp(*no)

      /copy mih-comp
      /copy mih-dattim

      * user code
     d tmpl            ds                  likeds(
     d                                       dt_compute_duration_tmpl_t)
     d                                     based(tmpl_ptr)
     d tmpl_ptr        s               *
     d tmpl_len        s              5u 0
     d offset          s              5u 0
     d ddat_ptr        s               *
     d ddat1           ds                  likeds(saa_ddat1_t)
     d                                     based(ddat_ptr)
     d ddat2           ds                  likeds(saa_ddat2_t)
     d                                     based(ddat_ptr)

      * USA date
     d feb             s             10a   inz('02/05/2008')
     d mar             s             10a   inz('09/06/2010')
     d dur             s              8p 0

      /free
           // allocate storage for instruction template
           tmpl_len = datetime_ddat_list_offset
                      + 16
                      + (4 + saa_ddat1_len)   // DDAT for op1
                      + (4 + saa_ddat2_len) ; // DDATs for op2, 3
           tmpl_ptr = %alloc(tmpl_len) ;

           // init instruction template
           tmpl.tmpl_size = tmpl_len ;
           tmpl.op1_ddat_index = 1   ;
           tmpl.op2_ddat_index = 2   ;
           tmpl.op3_ddat_index = 2   ;
           tmpl.op2_length     = 10  ;
           tmpl.op3_length     = 10  ;
           tmpl.ddat_list_len  = 16 + 2 * 4
             + saa_ddat1_len
             + saa_ddat2_len   ; // length of entire DDAT list
           tmpl.ddats          = 2   ;

           // init DDATs
           offset = 16 + 2 * 4 ; // start from the beginning of DDAT list
           tmpl.ddat_offsets(1) = offset ;
           ddat_ptr = tmpl_ptr
             + datetime_ddat_list_offset + offset  ;
           propb(ddat_ptr : x'00' : saa_ddat1_len) ;
           ddat1.fmt_code = x'0014'      ; // date duration

           offset += saa_ddat1_len       ;
           tmpl.ddat_offsets(2) = offset ;
           ddat_ptr = tmpl_ptr
             + datetime_ddat_list_offset + offset  ;
           propb(ddat_ptr : x'00' : saa_ddat2_len) ;
           ddat2.fmt_code = x'0001'      ; // USA date
           ddat2.date_sep = '/'          ;
           ddat2.calendar_table_offset =
             saa_ddat2_caltbl_offset     ;
           ddat2.era_table_elements = 1  ;
           ddat2.era_origin_date =
             saa_origine_date            ;
           ddat2.era_name = saa_era_name ;
           ddat2.calendar_table_elements = 2 ;
           ddat2.gregorian_effective_date =
             saa_origine_date            ;
           ddat2.gregorain_calendar_type =
             gregorian_calendar_type ;
           ddat2.null_effective_date =
             gregorian_end_date          ;
           ddat2.null_calendar_type =
             null_calendar_type          ;

           cdd(%addr(dur) : %addr(mar) : %addr(feb) : tmpl) ;
           dsply 'durantion' '' dur;
             // DSPLY  durantion       20701
             // two years, seven months, and one day.

           dealloc tmpl_ptr     ;
           *inlr = *on;
      /end-free
