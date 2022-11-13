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
      * @file t042.rpgle
      *
      * test of mathsat()
      */

     h dftactgrp(*no)

      /copy mih-comp
      /copy mih-pgmexec
      /copy mih-heap

     d heap_id         s             10i 0
     d ptr             s               *

     d crt_tmpl_ptr    s               *
     d crt_tmpl        ds                  likeds(crths_tmpl_t)
     d                                     based(crt_tmpl_ptr)

     d inv_tmpl_ptr    s               *
     d inv_tmpl        ds                  likeds(matinvat_selection_t)
     d                                     based(inv_tmpl_ptr)

     d agp             ds                  likeds(matinvat_agp_mark_t)

     d mat_tmpl_ptr    s               *
     d mat_tmpl        ds                  likeds(mathsat_tmpl_t)
     d                                     based(mat_tmpl_ptr)
     d hid             ds                  likeds(heap_id_t)
     d mat_sel         s              1a

      /free

           // create AG based-heap
           crt_tmpl_ptr = modasa(crths_tmpl_len);
           crt_tmpl = *allx'00';
           crt_tmpl.max_alloc  = x'FFF000';  // 16M - 1 page
           crt_tmpl.min_bdry   = 16;
           crt_tmpl.crt_size   = 0;
           crt_tmpl.ext_size   = 0;
           crt_tmpl.domain     = x'0000';
           crt_tmpl.crt_option = x'2CF1F0000000';
           crths(heap_id : crt_tmpl);

           ptr = alchss(heap_id : 4096); // allocate 4KB heap stroage

           // get AG mark
           inv_tmpl_ptr = modasa(matinvat_selection_length);
           propb( inv_tmpl_ptr
                 : x'00'
                 : matinvat_selection_length );
           inv_tmpl.num_attr   = 1;
           inv_tmpl.flag1      = x'00';
           inv_tmpl.ind_offset = 0;
           inv_tmpl.ind_length = 0;
           inv_tmpl.attr_id    = 14;  // materialize AG mark
           inv_tmpl.flag2      = x'00';
           inv_tmpl.rcv_offset = 0;
           inv_tmpl.rcv_length = 4;

           matinvat(agp : inv_tmpl);

           // materialize AG based-heap attributes
           mat_tmpl_ptr = modasa(mathsat_tmpl_len);
           propb(mat_tmpl_ptr : x'00' : mathsat_tmpl_len);
           mat_tmpl.bytes_in = mathsat_tmpl_len;

           hid.agp_mark = agp.agp_mark;
           hid.heap_id = heap_id;
           mat_sel = x'00'; // materialize basic heap attrs
           mathsat(mat_tmpl_ptr : %addr(hid) : mat_sel);
           //
           // materialized AG-based heap attributes:
           //
           //     mat_tmpl.max_alloc = 16773120 
           //     mat_tmpl.min_bdry = 16        
           //     mat_tmpl.crt_size = 8192      
           //     mat_tmpl.ext_size = 4096      
           //     mat_tmpl.domain = 1           
           //     mat_tmpl.crt_option = x'2CF1F0000000'
           //     mat_tmpl.cur_out_alc = 1      
           //     mat_tmpl.num_realc = 0     
           //     mat_tmpl.num_free = 0      
           //     mat_tmpl.num_alc = 1       
           //     mat_tmpl.max_out_alc = 1   
           //     mat_tmpl.stg_unit_size = 24
           //     mat_tmpl.num_marks = 0     
           //     mat_tmpl.num_ext = 0       

           frehss(ptr)   ;
           deshs(heap_id);

           *inlr = *on;
      /end-free
