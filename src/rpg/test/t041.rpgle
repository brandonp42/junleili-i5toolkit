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
      * @file t041.rpgle
      *
      * test of heap management instructions
      */

     h dftactgrp(*no)
      /copy mih52

     d CEEGTST         pr
     d     heap_id                   10i 0
     d     size                      10i 0
     d     ptr                         *
     d     fc                        12a   options(*omit)

     d crt_tmpl        ds                  likeds(crths_tmpl_t)
     d                                     based(crt_tmpl_ptr)
     d crt_tmpl_ptr    s               *
     d heap_id         s             10i 0
     d mark            s               *
     d mark2           s               *
     d len             s             10i 0
     d ptr             s               *
     d buf             ds            32    based(ptr)
     d ptr2            s               *
     d buf2            ds            32    based(ptr2)

      /free

           // create a new heap space by instruction CRTHS
           crt_tmpl_ptr = modasa(96);
           propb(crt_tmpl_ptr : x'00' : 96);
           crt_tmpl.max_alloc  = x'FFF000';  // 16M - 1 page
           crt_tmpl.min_bdry   = 16;
           crt_tmpl.crt_size   = 0;          // use system default value
           crt_tmpl.ext_size   = 0;          // use system default value
           crt_tmpl.domain     = x'0000';    // system should chose the domain
           crt_tmpl.crt_option = x'2CF1F0000000';
                                    // normal allocation strategy
                                    // allow heap space mark
                                    // transfer the machine default storage transfer size
                                    // do not create the heap space in the PAG
                                    // initialize allocations
                                    // overwrite freed allocations
                                    // allocation value, '1'
                                    // freed value, '0'
           crths(heap_id : crt_tmpl);

           // mark heap space
           sethssmk(mark : heap_id);

           // allocate heap storage
           len = x'A00000';         // 10MB
           CEEGTST(heap_id : len : ptr : *omit);

           sethssmk(mark2: heap_id);

           CEEGTST(heap_id : len : ptr2: *omit);

           // free heap storage by mark
           frehssmk(mark2);                  // heap storage pointed to by ptr2 is freed
           buf = 'ptr is NOT freed!';        // heap storage pointed to by ptr is NOT freed!

           frehssmk(mark);                   // heap storage pointed to by ptr is freed

           // destroy heap space
           deshs(heap_id);

           *inlr = *on;
      /end-free
