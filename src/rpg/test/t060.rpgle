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
      * @file t060.rpgle
      *
      * test of CPYECLAP
      *
      * - truncate a dbcs string
      *
      * output
      * @code
      * DSPLY  EVAL      同循
      * *N                           
      * DSPLY  CPYECLAP  同 (yes/no)
      * @endcode
      */

      /if defined(*crtbndrpg)
     h dftactgrp(*no)
      /endif

      /copy mih52

     d pad             ds                  likeds(cpyeclap_pad_t)
     d reply           ds
     d   answer                       4a
     d   next_fld                     8a   inz('(yes/no)')
     d rcv_ptr         s               *
     /* DBCS string: '同意' (Aproved) */
     d yes             s              6a   inz(x'0E574C59E10F')
     d src_ptr         s               *
      * scalar type: Open; length: 4 (1)
     d rcv_attr        s              7a   inz(x'09000400000000')
      * scalar type: Open; length: 6 (2)
     d src_attr        s              7a   inz(x'09000600000000')

      /free

           // set var ANSWER with op code eval (3)
           answer = yes;
           dsply 'EVAL' '' reply;
             // answer = x'0E574C59'

           // set scalar attributes into data pointers(4)
           rcv_ptr = setdp(%addr(answer) : rcv_attr);
           src_ptr = setdp(%addr(yes) : src_attr);
           pad = x'404040';

           // copy YES to ANSWER with truncation using CPYECLAP (5)
           cpyeclap( rcv_ptr : src_ptr : pad);
             // answer = x'0E574C0F'

           dsply 'CPYECLAP' '' reply;
           *inlr = *on;
      /end-free
