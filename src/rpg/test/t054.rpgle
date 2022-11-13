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
      * @file t054.rpgle
      *
      * test of ACTPG.
      *
      * OPM program SPR1_A:
      * @code
      * DCL DD HELLO CHAR(32) INIT(
      *         "hello, hello, hello how are you?"
      * );
      * PEND;
      * @endcode
      *
      * (1) layout of an OPM program's static storage frame (SSF)
      * (2) resolve OPM MI program SPR1_A
      * (3) activate OPM program SPR1_A using ACTPG, and then access
      *     SSF of SPR1_A
      */

      /if defined(*crtbndrpg)
     h  dftactgrp(*no)
      /endif

      /copy mih54
     /* layout of an OPM program's static storage frame (SSF) (1) */
     d ssf_t           ds                  qualified
     d   header                      64a
     d   data                        32a

     d pgm             s               *
     d ssf             ds                  likeds(ssf_t)
     d                                     based(ssf_ptr)
     d ssf_ptr         s               *
     d argv            s               *   dim(1)

      /free

           // resolve OPM MI program SPR1_A (2)
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'SPR1_A'; // OPM PGM uses static storage
           rslvsp2 (pgm : rslvsp_tmpl);

           // activate OPM program SPR1_A (3)
           actpg (ssf_ptr : pgm);
           dsply 'Static variable' '' ssf.data;

      /if defined(*v5r4m0)
           callpgmv(pgm : argv : 0);
      /endif

           // deactivate OPM program SPR1_A
           deactpg1 (pgm);
             // pgm SPR1_A is deactivated;
             // see activation entries of AG x'00000002'

           deactpg2();
             // MCH4421: Invalid operation for program.
           *inlr = *on;
      /end-free
