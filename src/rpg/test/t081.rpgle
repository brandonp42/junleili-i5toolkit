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
      * @file t081.rpgle
      *
      * Test of _CMPPTRA.
      */

     h dftactgrp(*no)

      /copy mih52
      * pointing to auto variable
     d auto_ptr        s               *
      * pointing to a static variable
     d stat_ptr        s               *   inz(%addr(stat))
     d stat            s              1a
      * addressing the associated space of T081
     d ass_spc_ptr     s               *
     d                 ds
     d     pgm                         *
     d     funny_ptr                   *   procptr
     d                                     overlay(pgm)
     d r               s             10i 0
     d                 ds
     d pgm2                            *
     d funny_ptr2                      *   procptr overlay(pgm2)

     d set_auto_ptr    pr
     d     ptr                         *

      /free
           set_auto_ptr(auto_ptr);
           r = cmpptra(auto_ptr : stat_ptr);
               // r = 1; pointers address the same object, the PCS
               // of the MI process (the current job)

           // get a SPCPTR addressing program T081's associated space
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T081' ;
           rslvsp2(pgm : rslvsp_tmpl);
           ass_spc_ptr = setsppfp(funny_ptr);

           r = cmpptra(auto_ptr : ass_spc_ptr);
               // r = 0; auto_ptr addresses the PCS object the current
               // MI process; while ass_spc_ptr addresses the primary
               // associated space of program object T081.

           // compare 2 system pointers
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T081' ;
           rslvsp2(pgm2 : rslvsp_tmpl);
           r = rpg_cmpptra(funny_ptr : funny_ptr2);
             // r = 1

           *inlr = *on;
      /end-free

     p set_auto_ptr    b
     d                 pi
     d     ptr                         *

     d i_am_automatic  s              1a

      /free
           ptr = %addr(i_am_automatic);
      /end-free
     p set_auto_ptr    e
