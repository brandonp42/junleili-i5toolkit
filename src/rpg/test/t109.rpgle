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
      * @file t109.rpgle
      *
      * This program has the same program logic with that of t107,
      * except that i5/OS pointer-based mutex is adopted to implement
      * mutex primitive.
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
     d                               20i 0
     d count                         20i 0
     d mtx_spp         s               *
     d mtx             ds                  likeds(mutex_t)
     d                                     based(mtx_spp)
     d end_time        s               z

      /free
           // log start time
           JID = 'START';
           ETIM = %timestamp();
           write REC;

           // locate bin(8) scalar stored in space object LK
           rslvsp_tmpl.obj_type = x'1934';
           rslvsp_tmpl.obj_name = 'LK';
           rslvsp2(spc : rslvsp_tmpl);
           spp = setsppfp(pspc);

           // locate mutex object created by t108
           rslvsp_tmpl.obj_type = x'1934';
           rslvsp_tmpl.obj_name = 'MTX';
           rslvsp2(spc : rslvsp_tmpl);
           mtx_spp = setsppfp(pspc);

           dow count < x'01000000';  // 16M

               // try to acquire lock
               lockmtx(mtx : *null);

               count += 1;
               syncstg(0);

               // release lock
               unlkmtx(mtx);
           enddo;

           // log end time
           JID = 'END';
           end_time = %timestamp();
           MSECS = %diff(end_time : ETIM : *ms);
           ETIM = end_time;
           write REC;

           *inlr = *on;
      /end-free
