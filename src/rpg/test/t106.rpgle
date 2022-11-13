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
      * @file t106.rpgle
      *
      * Implement reetrant mutually exclusive lock via the CHKLKVAL
      * and CLRLKVAL instructions.
      *
      * The lock object is represented by a 8-byte signed binary
      * scalar stored in a user space object (*USRSPC) whose MI object
      * type code and sub-type code is hex 1934.  Multiple jobs can
      * run this program to access shared resource concurrently.  In
      * this example, the shared storage protected by the mutex is
      * another 8-byte signed binary scalar stored in same *USRSPC
      * object as the mutex.
      */

     h dftactgrp(*no)

      /copy mih54

     /* Acquire a mutually exclusive lock recursively. */
     d recursive_lock...
     d                 pr
     d     old_value                 20i 0
     d     new_value                 20i 0
     d     wait_tmpl                       likeds(wait_tmpl_t)

     /* Release a mutually exclusive lock recursively. */
     d recursive_unlock...
     d                 pr
     d     old_value                 20i 0
     d     new_value                 20i 0
     d     wait_tmpl                       likeds(wait_tmpl_t)

     d                 ds
     d spc                             *
     d pspc                            *   procptr
     d                                     overlay(spc)
     d spp             s               *
     d                 ds                  based(spp)
     d lock                          20i 0
     d count                         20i 0
     d w               ds                  likeds(wait_tmpl_t)
     d old_val         s             20i 0 inz(0)
     d new_val         s             20i 0 inz(1)

      /free

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
               recursive_lock(old_val : new_val : w);
               recursive_lock(old_val : new_val : w);

               count += 1;
               syncstg(0);

               // release lock
               recursive_unlock(old_val : new_val : w);
               recursive_unlock(old_val : new_val : w);
           enddo;

           *inlr = *on;
      /end-free

     /* Implementation of procedure recursive_lock. */
     p recursive_lock  b

     d                 pi
     d     old_value                 20i 0
     d     new_value                 20i 0
     d     wait_tmpl                       likeds(wait_tmpl_t)

      /free
      /if not defined(*v5r2m0)
           // Acquire lock.
           dow chklkval(lock : old_value : new_value) = 1;
               waittime(wait_tmpl);
           enddo;
      /endif

           // Increase old_value and new_value by 1.
           old_value += 1;
           new_value += 1;
      /end-free
     p recursive_lock  e

     /* Implementation of procedure recursive_unlock. */
     p recursive_unlock...
     p                 b

     d                 pi
     d     old_value                 20i 0
     d     new_value                 20i 0
     d     wait_tmpl                       likeds(wait_tmpl_t)

      /free
           // Decrease old_value and new_value by 1.
           old_value -= 1;
           new_value -= 1;

      /if not defined(*v5r2m0)
           // Release lock.
           clrlkval(lock : old_value);
      /endif
      /end-free
     p recursive_unlock...
     p                 e

