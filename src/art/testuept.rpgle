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
      * @file testuept.rpgle
      *
      */
     h dftactgrp(*no)

      /copy mih54
     d                 ds
     d uept                            *
     d uept_fellow                     *   procptr
     d                                     overlay(uept)
     d uept_ptr        s               *
     d uepts           s               *   dim(3)
     d                                     based(uept_ptr)
     d argv            s               *   dim(3)

      /free
           // resolve UEPT
           rslvsp_tmpl.obj_type = x'1934';
           rslvsp_tmpl.obj_name = 'UEPT';
           rslvsp2(uept : rslvsp_tmpl);
           uept_ptr = setsppfp(uept_fellow);

           // ...
      /if not defined(*v5r2m0)
           callpgmv( uepts(1)
                   : argv
                   : 0 );
      /endif

           *inlr = *on;
      /end-free
