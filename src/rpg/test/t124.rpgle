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
      * @file t124.rpgle
      *
      * Test of MATMIF.
      */
     h dftactgrp(*no)

      /copy mih54
     d basic_info      ds                  likeds(matmif_basic_tmpl_t)
     d prc_info        ds                  likeds(matmif_prc_tmpl_t)
     d len             s              5u 0

      /free
      /if not defined(*v5r2m0)
           len = %size(basic_info);
           dsply 'length of ds - 0001' '' len;

           basic_info.bytes_in = len;
           matmif(basic_info : x'0001');

           len = %size(prc_info);
           dsply 'length of ds - 0002' '' len;

           prc_info.bytes_in = len;
           matmif(prc_info : x'0002');

      /endif
           *inlr = *on;
      /end-free
