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
      * @file t051.rpgle
      *
      * test of system builtin _LBCPYNV and _LBCPYNVR
      */

      /if defined(*crtbndrpg)
     h dftactgrp(*no)
      /endif

      /copy mih52

     d flt             s              8f
     d flt_attr        s              7a
     d bin             s             10i 0
     d bin_attr        s              7a
     d pkd             s              9p 2 inz(667788.99)
     d pkd_attr        s              7a

      /free
           flt_attr = x'01000800000000';
           pkd_attr = x'03020900000000';
           lbcpynv( %addr(flt)
                  : flt_attr     // receiver attributes
                  : %addr(pkd)
                  : pkd_attr     // source attributes
                  );
           dsply 'float value' '' flt;
             // +6.677889900000000E+005

           bin_attr = x'00000400000000';
           lbcpynv ( %addr(bin)
                   : bin_attr    // signed binary attributes
                   : %addr(pkd)
                   : pkd_attr    // signed binary attributes
                   );
           dsply 'signed binary value' '' bin;
             // 667788

           // copy and round
           lbcpynvr( %addr(bin)
                   : bin_attr    // signed binary attributes
                   : %addr(pkd)
                   : pkd_attr    // signed binary attributes
                   );
           dsply 'signed binary value' '' bin;
             // 667789

           *inlr = *on;
      /end-free
