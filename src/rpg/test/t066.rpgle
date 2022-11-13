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
      * @file t066.rpgle
      *
      * test of MATTODAT
      */
     h dftactgrp(*no)

      /copy mih54
     d tod             ds                  likeds(mattodat_utc_clock_t)
     d adj             ds                  likeds(mattodat_adjustment_t)
     d rtn             s             10i 0

      /free
      /if defined(*v5r4m0)
           tod.bytes_in = mattodat_utc_clock_len;
           rtn = mattodat(%addr(tod) : 1);

           adj.bytes_in = mattodat_adjustment_len;
           rtn = mattodat(%addr(adj) : 2);
      /endif
           *inlr = *on;
      /end-free
