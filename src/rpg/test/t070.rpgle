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
      * @file t070.rpgle
      *
      * Test of CHKLKVAL/CLRLKVAL. This is also an example of implementing thread
      * synchronization by using instruction CHKLKVAL and CLRLKVAL.
      *
      * @remark Note that this is a multi-threaded program.
      *         You should run this program in batch job
      *         with ALWMLTTHD param set to *YES. For
      *         example, SBMJOB CMD(CALL T070) ALWMLTTHD(*YES).
      */
     h dftactgrp(*no)

      /copy mih54
      /copy pthread

     d thd_proc        pr              *
     d     lock                      20i 0
     d u               ds                  likeds(pthread_t)
     d thd             ds                  likeds(pthread_t)
     d                                     dim(3)
     d status          s               *

     d lck             s             20i 0 inz(0)
     d rtn             s             10i 0
     d ind             s             10i 0

      /free
           // start threads
           rtn = pthread_create( thd(1)
                               : *null
                               : %paddr(thd_proc)
                               : %addr(lck) );
           if rtn <> 0;
               // error handling
               // e.g. rtn = EBUSY (3029)
           endif;

           if pthread_create( thd(2)
                            : *null
                            : %paddr(thd_proc)
                            : %addr(lck) ) <> 0
               or
              pthread_create( thd(3)
                            : *null
                            : %paddr(thd_proc)
                            : %addr(lck) ) <> 0 ;
               // error handling
           endif;

           // join threads
           for ind = 1 to 3;
               u = thd(ind);
               pthread_join(u : status);
           endfor;

           *inlr = *on;
      /end-free

     p thd_proc        b
     d                 pi              *
     d     lock                      20i 0

     d rtn             s             10i 0
     d tmpl            ds                  likeds(wait_tmpl_t)
     d                 ds
     d thd_id                         8a
     d num_tid                       20u 0 overlay(thd_id)
     d msg             s              8a

      /free
      /if defined(*v5r4m0)

           propb (%addr(tmpl) : x'00' : 16);
           tmpl.interval = sysclock_one_second;
           tmpl.option   = x'1000';

           dow chklkval(lock : 0 : 1) = 1;
               waittime(tmpl);
           enddo;

           thd_id = retthid();
           msg = %char(num_tid);
           dsply 'Yeah! I got it!' '' msg;

           clrlkval(lock : 0);
      /endif
           return *null;
      /end-free
     p thd_proc        e
