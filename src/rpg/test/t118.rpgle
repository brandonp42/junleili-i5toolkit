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
      * @file t118.rpgle
      *
      * This program shows how to reinitialize static storage of an OPM
      * program via MI instruction ACTPG.
      *
      * @remark T118A is an OPM MI program that uses a static Bin(2) scalar.
      *         val. Initial value of val is 7. T118A increase val's value
      *         by 1 each time it is invoked.
      */

     h dftactgrp(*no)

      /copy mih52

      * system pointer to T118A
     d opm_pgm         s               *
     d ssf             ds                  qualified
     d                                     based(ssf_ptr)
     d   header                      64a
     d   val                          5i 0
     d ssf_ptr         s               *
      * prototype of T118A
     d t118a           pr                  extpgm('T118A')

      /free
           // activate OPM MI program T118A
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T118A';
           rslvsp2(opm_pgm : rslvsp_tmpl);
           actpg(ssf_ptr : opm_pgm);
           dsply 'Static variable VAL' '' ssf.val;
             // val = 7

           // call T118A
           t118a();

           // check val's value
           dsply 'Static variable VAL' '' ssf.val;
             // val = 8

           // reactivate T118A to reset static variable val
           actpg(ssf_ptr : opm_pgm);

           // check val's value
           dsply 'Static variable VAL' '' ssf.val;
             // val = 7

           *inlr = *on;
      /end-free
