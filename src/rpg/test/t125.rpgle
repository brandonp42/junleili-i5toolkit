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
      * @file t125.rpgle
      *
      * Test of ENSOBJ.
      *
      * CL command to create *USRSPC T125:
      * CALL PGM(QUSCRTUS) PARM('T125      *CURLIB' 'ROBUST' X'00001000'
      *        X'00' '*CHANGE' 'i''m robust :)')
      */
     h dftactgrp(*no)

      /copy mih52
     d                 ds
     d spc                             *
     d funny_ptr                       *   procptr
     d                                     overlay(spc)
     d greeting        s             16a   based(spcptr)
     d spcptr          s               *

      /free
           rslvsp_tmpl.obj_type = x'1934';
           rslvsp_tmpl.obj_name = 'T125';
           rslvsp2(spc : rslvsp_tmpl);

           // retrieve space pointer addressing T125
           spcptr = setsppfp(funny_ptr);

           // write T125 and and ensure data to persistent storage media
           greeting = 'To be robust :)';
           ensobj(spc);

           *inlr = *on;
      /end-free
