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
      * @file t113.rpgle
      *
      * Test of TESTAU.
      */

     h dftactgrp(*no)

      /copy mih52
     d tmpl            ds                  likeds(testau_object_tmpl_t)
     d tmpl_ptr        s               *   inz(%addr(tmpl))
     d auth            s              2a
     d auth_req        s              2a
     d rtn             s             10i 0

      /free
           propb(%addr(tmpl) : x'00' : %size(tmpl));

           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T112';
           rslvsp2(tmpl.object : rslvsp_tmpl);

           auth_req = x'FFFC';  // request for all authorities to T112
           tmpl.relative_invocation_number = -1; // previous invocation
           rtn = testau2(auth : tmpl_ptr : auth_req);
             // rtn = 0; auth = x'FF9C'

           rtn = testau1(tmpl.object : auth_req) ;
             // rtn = 0

           auth_req = x'FF9C';
           rtn = testau2(auth : tmpl.object : auth_req);
             // rtn = 1; auth = x'FF9C'

           rtn = testau1(tmpl_ptr : auth_req) ;
             // rtn = 1

           *inlr = *on;
      /end-free
