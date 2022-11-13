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
      * @file t063.rpgle
      *
      * test of __setjmp, longjmp
      */

     h dftactgrp(*no) bnddir('QC2LE')

      /copy mih52

     d pos             ds                  likeds(jmp_buf_t)
     d rtn             s             10i 0

     /* prototype of ILE C procedure longjmp */
     d longjmp         pr                  extproc('longjmp')
     d   jmp_buf                           likeds(jmp_buf_t)
     d   val                         10i 0 value
     d err_ind         s               n   inz(*off)

     d i_always_fail   pr

      /free
           // save current stack environment
           if setjmp(pos) <> 0;
               // longjmp() has been invoked
               // to resume from error condition
               err_ind = *on;
           else;
               // invoke procedure i_always_fail()
               i_always_fail();
           endif;

           if err_ind;
               // error occurs
           endif;

           *inlr = *on;
      /end-free

     /* procedure i_always_fail */
     p i_always_fail   b
     d                 pi
      /free
           // assume that unrecoverable error occurs here
           // call longjmp to recover stack environment before
           // procedure i_always_fail was invoked
           longjmp(pos : -1);
      /end-free
     p i_always_fail   e

