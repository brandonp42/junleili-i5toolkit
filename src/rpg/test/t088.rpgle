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
      * @file t088.rpgle
      *
      * Test of _LOCK and _UNLOCK.
      */

     h dftactgrp(*no)

      /copy mih52
     d pos             s               *
     d tmpl_ptr        s               *
     d tmpl            ds                  likeds(lock_request_tmpl_t)
     d                                     based(tmpl_ptr)
     d objs            s               *   based(pos)
     d                                     dim(2)
     d lock_states     s              1a   based(pos)
     d                                     dim(2)
     d an              s              1a   inz('y')

      /free
           tmpl_ptr = %alloc(80);
           propb(tmpl_ptr : x'00' : 80);
           tmpl.num_requests = 2;
           tmpl.offset_lock_state = min_lock_request_tmpl_length
                                    + 16 * 2;
           tmpl.time_out = 20 * sysclock_one_second;
           tmpl.lock_opt = x'4000'; // 01000000,00000000
             // bit 7 of lock_opt = 0; no extension template

           // specify objects to lock
           pos = tmpl_ptr + min_lock_request_tmpl_length;
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

           // unlock objects
           unlockobj(tmpl);

           dealloc tmpl_ptr;
           *inlr = *on;
      /end-free
