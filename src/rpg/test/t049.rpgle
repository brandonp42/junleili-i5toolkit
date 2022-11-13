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
      * @file t049.rpgle
      *
      * test of CPYECLAP
      */

      /if defined(*crtbndrpg)
     h dftactgrp(*no)
      /endif

      /copy mih52

      * user code
     d pad             ds                  likeds(cpyeclap_pad_t)
     d answer          s             30a
     d rcv_ptr         s               *
     d yes             s              6a   inz(x'0E574C59E10F')
     d src_ptr         s               *
      * data type: Open; length: 30
     d rcv_attr        s              7a   inz(x'09001E00000000')
      * data type: Open; length:  6
     d src_attr        s              7a   inz(x'09000600000000')

      /free
           rcv_ptr = setdp(%addr(answer) : rcv_attr);
           src_ptr = setdp(%addr(yes) : src_attr);

           pad = x'40516B';
           cpyeclap( rcv_ptr : src_ptr : pad);

           dsply 'answer' '' answer;
           *inlr = *on;
      /end-free
