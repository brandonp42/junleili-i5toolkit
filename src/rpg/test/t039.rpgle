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
      * @file t039.rpgle
      *
      * test of testptr()
      *
      */

     h dftactgrp(*no)
     h bnddir('QC2LE')

      /copy mih52.rpgleinc
      /copy ts.rpgleinc

     d ptr             s               *   inz(%addr(val))
     d val             s              8a
     d rtn             s             10i 0
     d msg             s             20a

      /free

           // test a 16 bytes single level storage poniter
           rtn = testptr(ptr : x'01');
           if rtn = 0;
               msg = 'SLS pointer';
           else;
               msg = 'Teraspace pointer';
           endif;
           dsply 'ptr type' '' msg;

           // test a teraspace pointer
           ptr = ts_malloc(1024);

           rtn = testptr(ptr : x'01');
           if rtn = 0;
               msg = 'SLS pointer';
           else;
               msg = 'Teraspace pointer';
           endif;
           dsply 'ptr type' '' msg;

           ts_free(ptr);

           *inlr = *on;
      /end-free
