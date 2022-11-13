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
      * @file t048.rpgle
      *
      * test of CVTEFN
      */

      /if defined(*crtbndrpg)
     h dftactgrp(*no)
      /endif

      /copy mih52
     d p               s              8p 3
     d rcv_attr        s              7a   inz(x'03030800000000')
     d str             s             10a   inz('$35.65-')
     d len             s             10u 0
     d mask            s              3a   inz('$,.')

      /free
           len = %len(%trim(str));
           cvtefn( %addr(p)
                 : rcv_attr
                 : %addr(str)
                 : len
                 : mask );

           dsply str '' p;
             // DSPLY  $35.65-          35650-
           *inlr = *on;
      /end-free
