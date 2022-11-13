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
      * @file t107.rpgle
      *
      * Mutually exclusive lock implemented via the CHKLKVAL and
      * CLRLKVAL instructions.  The lock object is represented by a
      * 8-byte signed binary scalar stored in a user space object
      * (*USRSPC) whose MI object type code and sub-type code is hex
      * 1934.  Multiple jobs can run this program to access shared
      * resource concurrently.  In this example, the shared storage
      * protected the mutex is another 8-byte signed binary scalar
      * stored in same *USRSPC object as the mutex.
      *
      * @remark Source of PF LK is lk.pf.
      */

     h dftactgrp(*no)

     fLK        o    e             disk

      /copy mih54
     d                 ds
     d spc                             *
     d pspc                            *   procptr
     d                                     overlay(spc)
     d spp             s               *
     d                 ds                  based(spp)
     d lock                          20i 0
     d count                         20i 0
     d w               ds                  likeds(wait_tmpl_t)
     d end_time        s               z

      /free
      /if not defined(*v5r2m0)
           // log start time
           JID = 'START';
           ETIM = %timestamp();
           write REC;

           // locate bin(8) scalar stored in space object LK
           rslvsp_tmpl.obj_type = x'1934';
           rslvsp_tmpl.obj_name = 'LK';
           rslvsp2(spc : rslvsp_tmpl);
           spp = setsppfp(pspc);

           // init
           propb(%addr(w) : x'00' : %size(w));
           w.interval = sysclock_eight_microsec;
           w.option   = x'2000'; // Remain in current MPL set

           dow count < x'01000000';  // 16M

               // try to acquire lock
               dow chklkval(lock : 0 : 1) = 1;
                   waittime(w);    // wait and remain in current MPL set
               enddo;

               count += 1;
               syncstg(0);

               // release lock
               clrlkval(lock : 0);
           enddo;

           // log end time
           JID = 'END';
           end_time = %timestamp();
           MSECS = %diff(end_time : ETIM : *ms);
           ETIM = end_time;
           write REC;

      /endif
           *inlr = *on;
      /end-free
