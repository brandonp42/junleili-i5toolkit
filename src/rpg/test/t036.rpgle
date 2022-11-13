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
      * @file t036.rpgle
      *
      * test of stream file APIs
      */

     h dftactgrp(*no)

      /copy stmf

     d path            s             50a
     d fd              s             10i 0
     d str             s             32a

      /free

           // save compressed data to IFS file
           path = '/home/ljl/tmp/abc/a.txt' + x'00';
           str  = 'ni hao :p';
           fd = stmf_creat(%addr(path) : x'0180');
           if fd <> -1;
               stmf_write(fd : %addr(str) : %len(%trim(str)));
               stmf_close(fd);
           endif;

           *inlr = *on;
      /end-free
