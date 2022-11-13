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
      * @file filluept.rpgle
      *
      */
     h dftactgrp(*no)

      /copy mih52
     d                 ds
     d uept                            *
     d uept_fellow                     *   procptr
     d                                     overlay(uept)
     d uept_ptr        s               *
     d uepts           s               *   dim(3)
     d                                     based(uept_ptr)
     d qgpl            s               *

      /free
           // resolve UEPT
           rslvsp_tmpl.obj_type = x'1934';
           rslvsp_tmpl.obj_name = 'UEPT';
           rslvsp2(uept : rslvsp_tmpl);

           // retrieve a space pointer addressing the
           // associated space of the UEPT.
           uept_ptr = setsppfp(uept_fellow);

           // save system pointers to user programs
           // into the UEPT
           rslvsp_tmpl.obj_type = x'0401';
           rslvsp_tmpl.obj_name = 'QGPL';
           rslvsp2(qgpl : rslvsp_tmpl);

           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'PGMA';
           rslvsp4(uepts(1) : rslvsp_tmpl : qgpl);

           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'PGMB';
           rslvsp4(uepts(2) : rslvsp_tmpl : qgpl);

           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'PGMC';
           rslvsp4(uepts(3) : rslvsp_tmpl : qgpl);

           *inlr = *on;
      /end-free
