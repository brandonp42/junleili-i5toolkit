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
      * @file t099.rpgle
      *
      * Test of _MATPRECL. You can test this program along with t099up.rpgle.
      */

     h dftactgrp(*no)

      /copy mih52
     d selection       ds                  likeds(matprecl_process_tmpl_t)
     d tmpl            ds                  likeds(mat_record_lock_tmpl_t)
     d                                     based(tmpl_ptr)
     d tmpl_ptr        s               *
     d pos             s               *
     d lockd           ds                  likeds(record_lock_desc_t)
     d                                     based(pos)
     d TMPL_LEN        c                   1024
     d pcs_tmpl        ds                  likeds(
     d                                       matpratr_ptr_tmpl_t)
     d matpratr_opt    s              1a
     d ind             s             10i 0

      /free
           tmpl_ptr = %alloc(TMPL_LEN);
           propb(tmpl_ptr : x'00' : TMPL_LEN);
           tmpl.bytes_in = TMPL_LEN;
           propb(%addr(selection) : x'00' : %size(selection));

           // materialize PCS ptr
           matpratr_opt = x'25';
           pcs_tmpl.bytes_in = %size(matpratr_ptr_tmpl_t);
           matpratr1(pcs_tmpl : matpratr_opt);
           cpybwp(%addr(selection.pcs) : %addr(pcs_tmpl.ptr) : 16);
           selection.lock_sel = x'C0';
           selection.format_opt = x'80'; // use 4-byte number of locks

           // materialize process record locks
           matprecl(tmpl : selection);
           pos = tmpl_ptr + min_reclock_tmpl_length;
           for ind = 1 to tmpl.locks_held_4;
               // check obj, rrn, lock_state, and lock_info

               pos += record_lockd_length;
           endfor;

           dealloc tmpl_ptr;
           *inlr = *on;
      /end-free
