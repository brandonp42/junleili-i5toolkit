     /**
      * This file is part of i5/OS Programmer's Toolkit.
      *
      * Copyright (C) 2009  Junlei Li.
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
      * @file t031.rpgle
      *
      * test of MATCTX.
      * retrieve *USRPRFs from the machine context (of system ASP)
      */

      /copy mih52

      * SPCPTR to receiver
     d rcv_ptr         s               *
     d rcv_info        ds                  likeds(matctx_receiver1_t)
     d                                     based(rcv_ptr)

     d obj_info        ds                  qualified
     d                                     based(rcv_ptr)
     d     type                       2a
     d     name                      30a

     d option          ds                  likeds(matctx_option_t)
     d BUF_LEN         c                   x'010000'
     d num             s             10i 0
     d ind             s             10i 0

      /free

           propb(%addr(option) : x'00' : matctx_option_length);
           // receive object's symbol identifications
           option.sel_flag = x'05';
           // select by object's type code
           option.sel_criteria = x'01';
           // type code of a *USRPRF object is x'08'
           option.obj_type = x'08';

           // allocate storage for receiver
           rcv_ptr = modasa(BUF_LEN);       // 1Mb
           rcv_info.bytes_in = BUF_LEN;

           // mertialize the machine context for *USRPRFs
           matctx1 (rcv_ptr : option);

           // display returned *USRPRFs
           num = (rcv_info.bytes_out - matctx_offset1) / %size(obj_info);
           rcv_ptr += matctx_offset1;
           for ind = 1 to num;
               dsply 'user profile' '' obj_info.name;
               rcv_ptr += %size(obj_info);
           endfor;

           *inlr = *on;
      /end-free
