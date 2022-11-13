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
      * @file t093.rpgle
      *
      * Test of _MATAOL.
      *
      * To test T093, try to allocate different types of locks on
      * *USRQ THD0 like the following:
      * @code
      * ALCOBJ OBJ((THD0 *USRQ *EXCL))
      * ALCOBJ OBJ((THD0 *USRQ *SHRRD))
      * ALCOBJ OBJ((THD0 *USRQ *SHRNUP)
      * @endcode
      *
      * Call T093, the output is the following.
      * @code
      * DSPLY  Number of locks materialized        3
      * *N
      * DSPLY      1    LENR
      * *N
      * DSPLY      2    LSRD
      * *N
      * DSPLY      3    LSRO
      * @endcode
      */

     h dftactgrp(*no)

      /copy mih52
     d usrq            s               *
     d tmpl_ptr        s               *
     d tmpl            ds                  likeds(mataol_tmpl_t)
     d                                     based(tmpl_ptr)
     d pos             s               *
     d lockd           ds                  likeds(mataol_lock_desc_t)
     d                                     based(pos)
     d ind             s              5u 0
     d TMPL_LEN        c                   256
     d lock_types      s             20a   inz('LSRD+
     d                                          LSRO+
     d                                          LSUP+
     d                                          LEAR+
     d                                          LENR')
     d lock_type       s              4a   dim(5)
     d subscript       s              5u 0

      /free
           // resolve system pointer to *USRQ THD0
           rslvsp_tmpl.obj_type = x'0A02';
           rslvsp_tmpl.obj_name = 'THD0';
           rslvsp2(usrq : rslvsp_tmpl);

           // allocate storage for materialization templates
           tmpl_ptr = %alloc(TMPL_LEN);
           propb(tmpl_ptr : x'00' : TMPL_LEN);
           tmpl.bytes_in = TMPL_LEN;

           // materailize allocated locks on *USRQ object THD0
           mataol(tmpl : usrq);
             // tmpl.cur_lock_state = x'C8', 11001000

           dsply 'Number of locks materialized' '' tmpl.num_lockd;

           pos = tmpl_ptr + mataol_lockd_offset;
           cpybytes(%addr(lock_type) : %addr(lock_types) : 20);
           for ind = 1 to tmpl.num_lockd;
               // check lock_type
               subscript = tstbts(%addr(lockd.lock_type) : 0) * 1
                           + tstbts(%addr(lockd.lock_type) : 1) * 2
                           + tstbts(%addr(lockd.lock_type) : 2) * 3
                           + tstbts(%addr(lockd.lock_type) : 3) * 4
                           + tstbts(%addr(lockd.lock_type) : 4) * 5;
               dsply ind '' lock_type(subscript);

               pos += mataol_lockd_length;
           endfor;

           dealloc tmpl_ptr;
           *inlr = *on;
      /end-free
