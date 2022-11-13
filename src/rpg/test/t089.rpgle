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
      * @file t089.rpgle
      *
      * Test of _LOCK and _UNLOCK.
      */

     h dftactgrp(*no)

      /copy mih52
     d pos             s               *
     d tmpl_ptr        s               *
     d tmpl            ds                  likeds(
     d                                       lock_request_tmpl_ext_t)
     d                                     based(tmpl_ptr)
     d unlock_tmpl_ptr...
     d                 s               *
     d unlock_tmpl     ds                  likeds(lock_request_tmpl_t)
     d                                     based(unlock_tmpl_ptr)
     d objs            s               *   based(pos)
     d                                     dim(2)
     d lock_states     s              1a   based(pos)
     d                                     dim(2)
     d an              s              1a   inz('y')

      /free
           tmpl_ptr = %alloc(80);
           propb(tmpl_ptr : x'00' : 80);
           tmpl.num_requests = 2;
           tmpl.offset_lock_state = 32 + 16 * 2; // 64
           tmpl.lock_opt = x'4100';  // 01000000,00000000
           tmpl.ext_opt = x'00';

           // specify objects to unlock
           pos = tmpl_ptr + 32;
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T087';
           rslvsp2(objs(1) : rslvsp_tmpl);

           rslvsp_tmpl.obj_type = x'0A02';
           rslvsp_tmpl.obj_name = 'THD0';  // *USRQ THD0
           rslvsp2(objs(2) : rslvsp_tmpl);

           // specify lock states
           pos = tmpl_ptr + tmpl.offset_lock_state;
           lock_states(1) = x'09'; // LENR lock on objs(1)
           lock_states(2) = x'11'; // LEAR lock on objs(2)

           // lock objs
           lockobj(tmpl);

           dsply 'objects locked.' '' an;

           unlock_tmpl_ptr = %alloc(64);
           propb(unlock_tmpl_ptr : x'00' : 64);
           unlock_tmpl.num_requests = 2;
           unlock_tmpl.offset_lock_state = 16 + 16 * 2; // 48
           unlock_tmpl.lock_opt = x'0000';
           cpybwp( unlock_tmpl_ptr + 16
                 : tmpl_ptr + 32
                 : 16 * 2 );
           cpybwp( unlock_tmpl_ptr + unlock_tmpl.offset_lock_state
                 : tmpl_ptr + tmpl.offset_lock_state
                 : 2 );

           // unlock objs
           unlockobj(unlock_tmpl);

           dealloc unlock_tmpl_ptr;
           dealloc tmpl_ptr;
           *inlr = *on;
      /end-free
