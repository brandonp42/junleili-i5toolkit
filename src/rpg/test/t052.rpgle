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
      * @file t052.rpgle
      *
      * test of system builtin INVP
      */

      /if defined(*crtbndrpg)
     h dftactgrp(*no)
      /endif
     h bnddir('QC2LE')

      /copy mih52

     d inv_ptr         s               *
     d buf             s             32a

     d cvthc           pr                  extproc('cvthc')
     d     receiver                    *   value
     d     source                      *   value
     d     length                    10i 0 value

      /free
           inv_ptr = invp(0);
           cvthc( %addr(buf) : %addr(inv_ptr) : 32);

           dsply 'INVPTR' '' buf;
             // A000000000000099F15F4C1B6E001070
           *inlr = *on;
      /end-free

