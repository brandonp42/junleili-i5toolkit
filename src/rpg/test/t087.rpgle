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
      * @file t087.rpgle
      *
      * Test of recursive locks via CHKLKVAL/CLRLKVAL.
      */
     h dftactgrp(*no)

      /copy mih54
     d lck             s             20i 0
     d f               pr
     d     old_val                   20i 0 value
     d     new_val                   20i 0 value

      /free
           f(0 : 1);
           *inlr = *on;
      /end-free

     p f               b
     d f               pi
     d     old_val                   20i 0 value
     d     new_val                   20i 0 value

     d max_depth       c                   5

      /free
      /if not defined(*v5r2m0)

           // Try to acquire lock.
           dow chklkval(lck : old_val : new_val) = 1;
               // wait for a small time quantum.
           enddo;

           // Execute mutually exclusive program logics
           // or access shared resources.
           // ... ...

           dsply 'Current recursion depth' '' new_val;

           if new_val > max_depth;  // Check recursion depth.
               clrlkval(lck : old_val);
               return;
           else;
               f(old_val + 1 : new_val + 1);
           endif;

           // Release lock.
           clrlkval(lck : old_val);

      /endif
      /end-free
     p f               e
