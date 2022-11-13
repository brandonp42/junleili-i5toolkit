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
      * @file t116.rpgle
      *
      * Test of TESTULA
      */

     h dftactgrp(*no)

      /copy mih52
      *
     d obj             s               *
     d receiver        ds                  likeds(testula_receiver_tmpl_t)
     d                                     based(rcv_ptr)
     d rcv_ptr         s               *
     d auth_req        ds                  likeds(testula_option_tmpl_t)
     d                                     based(opt_ptr)
     d opt_ptr         s               *
     d uid_ptr         s               *
     d qsecofr         s             10u 0 based(uid_ptr)
     d len             s              5i 0
     d rtn             s             10i 0

      /free
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T116';
           rslvsp2(obj  : rslvsp_tmpl);

           len = %size(testula_receiver_tmpl_t);
           rcv_ptr = %alloc(len);
           receiver.bytes_in = len;

           len = %size(testula_option_tmpl_t) + 4;
           opt_ptr = %alloc(len);
           propb(opt_ptr : x'00' : len);
           auth_req.num_group_pfrs = 0;
           auth_req.required_auth = x'2010';
             // require both object management and
             // execute authorities;
           auth_req.indicator = x'40';
             // profiles are prepresented by uid/gid
           // set uid of QSECOFR in test option template
           uid_ptr = opt_ptr + %size(testula_option_tmpl_t);
           qsecofr = 0;

           rtn = testula(receiver : obj : auth_req);
             // exception hex 4401 (MCH6801) under QSECURITY 40 or above

           dealloc rcv_ptr;
           dealloc opt_ptr;

           *inlr = *on;
      /end-free
