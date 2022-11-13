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
      * @file t165.rpgle
      *
      * Test of _CRTS (Create Space).
      * This program create a permanent space object that doesn't reside
      * in any context.
      *
      * @pre To avoid the Object domain violation exception (hex 4401),
      *      run this program under security level 30 or lower, or
      *      change the compiled program to system state before calling it.
      */

      /if defined(*crtbndrpg)
     h dftactgrp(*no)
      /endif

      /copy mih-spc
      /copy mih-comp

     d tmpl            ds                  likeds(crts_tmpl_t)
     d romio           s               *

      /free
           propb(%addr(tmpl) : x'00' : %size(tmpl));
           tmpl.bytes_in    = %size(tmpl);
           tmpl.obj_type    = x'1934'; // *USRSPC
           tmpl.obj_name    = 'Romio';
           tmpl.crt_opt     = x'C0020000';
             // x'C0020000'
             // bit 0 = 1, permanent
             // bit 1 = 1, variable-length
             // bit 2 = 0, addressability is not inserted into context
             // bit 7 = 0, does not specify the initial owner, so the owner
             //            of the created space object is the current USRPRF
             // bit 14 = 1, automatically expand space
           tmpl.spc_size    = x'1000'; // 4KB
           tmpl.init_val    = x'00';

           crts(romio : tmpl);
             // reomio: 'SYP:Romio                         :1934 ...'

           dess(romio); // destroy romio in case that is becomes an orphan :p

           *inlr = *on;
      /end-free
