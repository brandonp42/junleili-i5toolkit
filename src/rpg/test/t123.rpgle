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
      * @file t123.rpgle
      *
      * Test of _MATINVAT2.
      */
     h dftactgrp(*no)

     d who_am_i        pr
      /free
           who_am_i();
           *inlr = *on;
      /end-free

     p who_am_i        b

      /copy mih-pgmexec
      /copy mih-ptr

     d inv_id          ds                  likeds(invocation_id_t)
     d susptr_info     ds                  likeds(matinvat_ptr_t)
     d sel             ds                  likeds(matinvat_selection_t)

     d ptrd            ds                  likeds(matptrif_susptr_tmpl_t)
     d mask            s              4a
     d proc_name       s             30a

      /free
           inv_id = *allx'00';
           inv_id.src_inv_offset = -1;  // caller

           sel = *allx'00';
           sel.num_attr   = 1;
           sel.attr_id    = 24;  // suspend pointer
           sel.rcv_length = 16;
           matinvat2( susptr_info
                    : inv_id
                    : sel );

           // materialize suspend ptr
           ptrd = *allx'00';
           ptrd.bytes_in = %size(ptrd);
           ptrd.proc_name_length_in = 30;
           ptrd.proc_name_ptr = %addr(proc_name);

           // materialize pointer desc
           mask = x'12200000';
             // bit 3 = 1; program name
             // bit 6 = 1; module name
             // bit 10 = 1; procedure name
           matptrif( ptrd : susptr_info.ptr : mask );

           // output pgm name, module name, and procedure name
           dsply '    Program name' '' ptrd.pgm_name;
           dsply '    Module name' '' ptrd.mod_name;

           if ptrd.proc_name_length_out > ptrd.proc_name_length_in;
               %subst(proc_name : 29 : 2) = ' <';
           endif;
           dsply '    Prodecure name' '' proc_name;

      /end-free
     p who_am_i        e
