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
      * @file t098.rpgle
      *
      * Mapping CL lock states to those of MI.
      */

     h dftactgrp(*no)

      /copy mih52
     d lock_request    ds                  likeds(lock_request_tmpl_t)
     d                                     based(ptr)
     d ptr             s               *
     d pos             s               *
     d to_lock         s               *   based(pos)
     d lock_state      s              1a   based(pos)
     d TMPL_LEN        c                   128
     d lock_types      s              1a   dim(5)
     d ind             s              5i 0

      /free
           ptr = %alloc(TMPL_LEN);
           propb(ptr : x'00' : TMPL_LEN);
           lock_request.num_requests = 1;
           lock_request.offset_lock_state
             = min_lock_request_tmpl_length
               + %size(to_lock);
           lock_request.time_out = 20 * sysclock_one_second;
           lock_request.lock_opt = x'4000';

           // lock what?
           pos = ptr + min_lock_request_tmpl_length;
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T087' ;
           rslvsp2(to_lock : rslvsp_tmpl);

           // lock T087 with different lock types
           lock_types(1) = x'81'; // LSRD (*SHRRD)
           lock_types(2) = x'41'; // LSRO (*SHRNUP)
           lock_types(3) = x'21'; // LSUP (*SHRUPD)
           lock_types(4) = x'11'; // LEAR (*EXCLRD)
           lock_types(5) = x'09'; // LENR (*EXCL)
           pos = ptr + lock_request.offset_lock_state;
           for ind = 1 to 5;
               lock_state = lock_types(ind);
               lockobj(lock_request);

               dsply 'check lock status ...' '' lock_state;
               unlockobj(lock_request);
           endfor;

           *inlr = *on;
      /end-free
