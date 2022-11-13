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
      * @file t085.rpgle
      *
      * Test of _RETTSADR.
      */
      /if defined (*crtbndrpg)
     h dftactgrp(*no)
      /endif

      /copy ts
      /copy mih54
     d tera_ptr        s               *
     d ptr_val         s              8a

      /free

           tera_ptr = ts_malloc(1024);
      /if not defined(*v5r2m0)
           ptr_val  = rettsadr(tera_ptr);
      /endif

           ts_free(tera_ptr);

           *inlr = *on;
      /end-free
