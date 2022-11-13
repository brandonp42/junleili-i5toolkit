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
      * @file t032.rpgle
      *
      * test of MATAUU.
      * retrieve privately authorized USRPRF to a PGM object
      */

     h dftactgrp(*no)
      /copy mih52

     d mat_opt         s              1a   inz(x'32')
     d tmpl            ds                  likeds(matauu_tmpl_t)
     d                                     based(tmpl_ptr)
     d tmpl_ptr        s               *
     d authd           ds                  likeds(auth_desc_long_t)
     d                                     based(authd_ptr)
     d authd_ptr       s               *

     d dec10           s               *
     d len             s             10i 0
     d ind             s             10i 0

     d i_main          pr                  extpgm('T032')
     d     pgm_name                  10a                 
                                                         
     d i_main          pi                                
     d     pgm_name                  10a                 

      /free

           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = pgm_name;
           rslvsp2(dec10 : rslvsp_tmpl);

           // materialize privately authorized profiles
           // using long description entry format
           mat_opt = x'32';

           // how many bytes we need to allocate?
           tmpl_ptr = modasa(8);
           tmpl.bytes_in = 8;
           matauu(tmpl_ptr : dec10 : mat_opt);
           len = tmpl.bytes_out;

           // really allocate receiver buffer
           tmpl_ptr = modasa(len);
           tmpl.bytes_in = len;
           matauu(tmpl_ptr : dec10 : mat_opt);

           // report returned privately authorized users
           authd_ptr = tmpl_ptr + 16;
           for ind = 1 to tmpl.num_private_users;
               dsply 'Privately Authed User' '' authd.usrprf_name;
               authd_ptr += AUTH_DESC_LONG_LENGTH;
           endfor;

           *inlr = *on;
      /end-free
