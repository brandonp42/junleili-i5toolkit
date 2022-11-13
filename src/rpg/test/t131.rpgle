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
      * @file t131.rpgle
      *
      * Test of SETACST.
      */

     h dftactgrp(*no)

      /copy mih-comp
      /copy mih-ptr
      /copy mih-stgrsc

     d tmpl            ds                  likeds(access_state_tmpl_t)
     d                                     based(ptr)
     d ptr             s               *

      /free
           ptr = %alloc(80);
           propb(ptr : x'00' : 80);
           tmpl.num_objs = 1;

           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T130';
           rslvsp2(tmpl.spec(1).obj : rslvsp_tmpl);
           tmpl.spec(1).state_code = x'10';
           setacst(tmpl);

           dsply 'operational object size' ''
             tmpl.spec(1).operational_object_size;

           dealloc ptr;

           *inlr = *on;
      /end-free
