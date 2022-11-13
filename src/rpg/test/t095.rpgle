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
      * @file t095.rpgle
      *
      * Test of _MATPRLK2.
      */

     h dftactgrp(*no)

      /copy mih52
     d tmpl_ptr        s               *
     d tmpl            ds                  likeds(matprlk_tmpl_t)
     d                                     based(tmpl_ptr)
     d pos             s               *
     d lockd           ds                  likeds(matprlk_lock_desc_t)
     d                                     based(pos)
     d TMPL_LEN        c                   4096
     d ind             s              5i 0
     d pcs_tmpl        ds                  likeds(
     d                                       matpratr_ptr_tmpl_t)
     d matpratr_opt    s              1a

      /free

           // allocate materialization template
           tmpl_ptr = %alloc(TMPL_LEN);
           propb(tmpl_ptr : x'00' : TMPL_LEN);
           tmpl.bytes_in = TMPL_LEN;

           // materialize PCS ptr
           matpratr_opt = x'25';
           pcs_tmpl.bytes_in = %size(matpratr_ptr_tmpl_t);
           matpratr1(pcs_tmpl : matpratr_opt);

           // materialize process locks
           matprlk2 (tmpl : pcs_tmpl.ptr);

           // check process locks
           pos = tmpl_ptr + matprlk_lockd_offset;
           for ind = 1 to tmpl.num_lockd;
               // check lockd.syp_or_spp for object or space location
               // on which a process lock is allocated.

               // check lockd.lock_type

               // offset pos to the next lock description
               pos += matprlk_lockd_length;
           endfor;

           dealloc tmpl_ptr;
           *inlr = *on;
      /end-free
