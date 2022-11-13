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
      * @file t064.rpgle
      *
      * test of ept54.rpgleinc
      *  - call UIM API QUILNGTX.
      */
     h dftactgrp(*no)

      /copy mih54
      /copy ept54

     d pco_ptr         s               *
     d pco             ds                  qualified
     d                                     based(pco_ptr)
     d     sept_ptr                    *
     d septs           s               *   dim(7001)
     d                                     based(pco.sept_ptr)

     d argv            s               *   dim(5)
     /* arguments of QUILNGTX */
     d text            s              8a   inz('The SEPT')
     d len             s             10i 0 inz(8)
     d msgid           s              7a   inz('CPF9898')
     d msgf            s             20a   inz('QCPFMSG   QSYS')
     d ec              s             16a

      /free
           pco_ptr = pcoptr2();

           ec = x'00000010000000000000000000000000';
           argv(1) = %addr(text);
           argv(2) = %addr(len);
           argv(3) = %addr(msgid);
           argv(4) = %addr(msgf);
           argv(5) = %addr(ec);
      /if defined(*v5r4m0)
           callpgmv( septs(ept_quilngtx) // hex 162A
                   : argv : 5);
      /endif

           *inlr = *on;
      /end-free
