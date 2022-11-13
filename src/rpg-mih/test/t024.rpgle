     /**
      * This file is part of i5/OS Programmer's Toolkit.
      * 
      * Copyright (C) 2009  Junlei Li.
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
      * @file t024.rpgle
      *
      * test of matpragp()
      *
      * List all AGs (activation groups) in the current job.
      */

     h bnddir('QC2LE')

      /copy mih52

     d cvthc           pr                  extproc('cvthc')
     d     receiver                    *   value
     d     source                      *   value
     d     length                    10i 0 value

     d agps            ds                  likeds(matpragp_tmpl_t)
     d                                     based(ptr)
     d ptr             s               *
     d bytes_needed    s             10i 0
     d ind             s             10i 0
     d mark            ds             4    based(mark_ptr)
     d mark_ptr        s               *
     d ch_mark         s              8a

      /free

           // get number of AGs
           // get number of bytes to alloc
           ptr = %alloc(12);
           agps.bytes_in = 12;
           matpragp(ptr);
           bytes_needed = agps.bytes_out;

           // allocate buffer and materialize AG marks
           ptr = %realloc(ptr : bytes_needed);
           agps.bytes_in = bytes_needed;
           matpragp(ptr);

           // display AG marks
           mark_ptr = ptr + 12;
           for ind = 1 to agps.agp_num;
               cvthc(%addr(ch_mark) : mark_ptr : 8);
               mark_ptr += 4;
               dsply ind '' ch_mark;
           endfor;

           dealloc ptr;  // free allocated buffer
           *inlr = *on;
      /end-free
