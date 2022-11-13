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
      * @file t059.rpgle
      *
      * test of xlateb and setsppfp
      */

     h dftactgrp(*no) bnddir('QC2LE')

      /copy mih52

     d cvthc           pr                  extproc('cvthc')
     d     receiver                    *   value
     d     source                      *   value
     d     length                    10i 0 value

     d str             s              3a   inz('abc')
     d hexstr          s             16a
     /* system pointer to *tbl ascii */
     d                 ds
     d   ascii_tbl                     *
     d   funny_ptr                     *   overlay(ascii_tbl:1)
     d                                     procptr
     d table_ptr       s               *

      /free

           // resolve table object (hex 1906) ASCII (1)
           rslvsp_tmpl.obj_type = x'1906';
           rslvsp_tmpl.obj_name = 'ASCII';
           rslvsp2(ascii_tbl : rslvsp_tmpl);

           // access data content stored in *tbl ASCII (2)
           table_ptr = setsppfp(funny_ptr);

           // before translation
           cvthc(%addr(hexstr) : %addr(str) : 6);
           dsply 'EBCDIC' '' hexstr;

           xlateb(%addr(str) : table_ptr : 3); // (3)

           // after translation
           cvthc(%addr(hexstr) : %addr(str) : 6);
           dsply 'ASCII' '' hexstr;

           *inlr = *on;
      /end-free
