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
      * @file t137.rpgle
      *
      * Test of:
      *  - rpg_cmpptrt. Test against system pointer.
      *  - rpg_testptr. Test a procedure pointer.
      *  - testptr. Test against teraspace pointer.
      *  - setspfp.
      *    - set system pointer from a system pointer
      *    - set system pointer from a label pointer
      */

     h dftactgrp(*no) bnddir('QC2LE')

      /copy mih52
      /copy ts
     d func            pr

     d                 ds
     d rpg                             *   procptr
     d t137                            *   overlay(rpg)
     d lbl                             *   overlay(rpg)
     d tsptr           s               *
     d me              s               *
     d r               s             10i 0

      /free
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T137';
           rslvsp2 (t137 : rslvsp_tmpl);

           // is it a system pointer?
           r = rpg_cmpptrt(x'01' : rpg);  // r = 1

           // if it points to a procedure expecting optimized procedure
           // parameter passing
           rpg = %paddr(func);
           r = rpg_testptr(rpg : x'00'); // r = 0

           // if tsptr points to teraspace?
           tsptr = ts_malloc(32);
           r = testptr(tsptr : x'01'); // r = 1
           ts_free(tsptr);

           // set system pointer from a system pointer
           rslvsp2 (t137 : rslvsp_tmpl);
           me = rpg_setspfp(rpg);
             // check me: me points to PGM T137

           // set system pointer from a label pointer
           setjmp2(lbl);
           // @attention using setspfp with a label pointer will raise MCH3601!
           // me = setspfp(lbl);
           me = rpg_setspfp(rpg);
              // check me: me points to PGM T137

           *inlr = *on;
      /end-free

     p func            b
     d func            pr
     p func            e
