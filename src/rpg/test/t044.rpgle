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
      * @file t044.rpgle
      *
      * test of SETDP and SETDPADR
      */

      /if defined(*CRTBNDRPG)
     h dftactgrp(*no)
      /endif

      /copy mih-ptr
      /copy mih-dtaptr

     d attr            s              7a   inz(x'09000700000000')
     d val             s             18a   inz('abcdefghijklmn')
     d ptr             s               *

     d tmpl            ds                  likeds(matptr_dtaptr_info_t)

      /free

           ptr = setdp(%addr(val) : attr);
             // PTR = DP :FC1A1FCD7201ED20
           tmpl.bytes_in = %size(tmpl);
           matptr (tmpl : ptr);

           // tmpl.dta_type   = hex 09, Open
           // tmpl.dta_length = hex 0007
           // tmpl.obj_type   = hex 1AEF, *QTPCS

           ptr = setdpadr(ptr : %addr(val) + 3);
             // PTR = DP :FC1A1FCD7201ED23

           *inlr = *on;
      /end-free
