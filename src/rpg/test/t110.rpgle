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
      * @file t110.rpgl
      *
      * Test of MATAU.
      */

     h dftactgrp(*no)

      /copy mih-comp
      /copy mih-ptr
      /copy mih-auth

     d tmpl            ds                  likeds(matau_tmpl_t)
     d opt             ds                  likeds(matau_option_t)
     d opt_ptr         s               *   inz(%addr(opt))
     d pgm             s               *

      /free
           rslvsp_tmpl.obj_name = 'T110';
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp2 (pgm : rslvsp_tmpl);

           tmpl.bytes_in = %size(matau_tmpl_t);
           matau2(tmpl : pgm);
             // check tmpl.public_auth
             // e.g. hex 3F10

           propb(%addr(opt) : x'00' : %size(opt));
           opt.flag = x'8000';
           rslvsp_tmpl.obj_name = 'QSECOFR';
           rslvsp_tmpl.obj_type = x'0801';
           rslvsp2 (opt.usrprf : rslvsp_tmpl);
           matau1(tmpl : pgm : opt_ptr);
             // check tmpl.private_auth
             // MCH6801 under QSECURITY 40 or above

           *inlr = *on;
      /end-free
