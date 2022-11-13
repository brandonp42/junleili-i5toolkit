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
      * @file t138.rpgle
      *
      * Test of _MATSOBJ.
      */

     h dftactgrp(*no)

      /copy mih-ptr
      /copy mih-mchobs

     d len             s             10i 0
     d tmpl            ds                  likeds(matsobj_tmpl_t)
     d pgm_obj         s               *
     d start           s               *   inz(%addr(tmpl))
     d pos             s               *

      /free
           len = %size(tmpl);
           dsply 'DS MATSOBJ_TMPL_T' '' len;

           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T137';
           rslvsp2(pgm_obj : rslvsp_tmpl);

           tmpl.bytes_in = %size(tmpl);
           matsobj(tmpl : pgm_obj);

           pos = %addr(tmpl.domain);
           len = pos - start;
           dsply 'offset of domain' '' len;

           pos = %addr(tmpl.obj_size2);
           len = pos - start;
           dsply 'offset of obj_size2' '' len;

           *inlr = *on;
      /end-free
