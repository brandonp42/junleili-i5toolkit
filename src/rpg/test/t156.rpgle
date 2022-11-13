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
      * @file t156.rpgle
      *
      * Test of the extended instruction template of RSLVSP.
      *
      * @remark A_SPC is an *USRSPC owned by some other user with public authority *USE.
      */
     h dftactgrp(*no)

      /copy mih-ptr
      /copy mih-comp

     d tmpl            ds                  likeds(rslvsp_tmpl_ex)
     d obj             s               *
     d

      /free

           tmpl = *allx'00';
           tmpl.obj_type = x'1934';
           tmpl.obj_name = 'A_SPC';
           setbts(%addr(tmpl.auth) : 5); // require INSERT authority
           setbts(%addr(tmpl.opt) : 1);  // do NOT signal MCH3401

           rslvsp2(obj : tmpl);
           if obj = *null;
               dsply 'Cannot resolve ... ';
           endif;

           *inlr = *on;
      /end-free
