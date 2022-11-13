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
      * @file t038.rpgle
      *
      * test of thread-specific APIs
      *
      * CL command to run t038:
      * SBMJOB CMD(CALL T038) ALWMLTTHD(*YES)
      *
      */

     h dftactgrp(*no)
     h bnddir('QC2LE')

      /copy mih52
      /copy pthread.rpgleinc
      /copy ts.rpgleinc

     /* thread function */
     d thread_main     pr              *
     d     param                       *   value

     /* TLS destructor */
     d tls_destructor  pr
     d     tls                         *   value

     /* procedure that consume allocated TLS storage */
     d func            pr
     d     tls_key                   10i 0 value

     d thd             ds                  likeds(pthread_t)
     d                                     dim(2)

     d thd_parm_ds_t   ds                  qualified
     d   tls_size_ind                 1a
     d   tls_key                     10i 0

     d thd_parm        ds                  likeds(thd_parm_ds_t)
     d                                     dim(2)
     d tls_key         s             10i 0
     d rtn             s             10i 0
     d status          s               *
     d tls_rls_proc    s               *   procptr

      /free

           // create TLS key
           tls_rls_proc = %paddr(tls_destructor);
           rtn = pthread_key_create(tls_key : tls_rls_proc);
           if rtn <> 0;
               // error handling
           endif;

           // launch child threads
           thd_parm(1).tls_key      = tls_key;
           thd_parm(1).tls_size_ind = 'S'; // small TLS allocation
           thd_parm(2).tls_key      = tls_key;
           thd_parm(2).tls_size_ind = 'L'; // large TLS allocation

           rtn = pthread_create( thd(1)
                               : *null
                               : %paddr(thread_main)
                               : %addr(thd_parm(1)) );
           if rtn <> 0;
               // error handling
           endif;
           rtn = pthread_create( thd(2)
                               : *null
                               : %paddr(thread_main)
                               : %addr(thd_parm(2)) );
           if rtn <> 0;
               // error handling
           endif;

           // wait for child threads
           pthread_join(thd(1) : status);
           pthread_join(thd(2) : status);

           rtn = pthread_key_delete(tls_key);

           *inlr = *on;
      /end-free

     p thread_main     b
     d thread_main     pi              *
     d     param                       *   value

     d thd_parm        ds                  likeds(thd_parm_ds_t) based(param)
     d tls             s               *
     d SMALL_TLS_ALC   c                   32
     d LARGE_TLS_ALC   c                   33554432                             32MB

      /free

           // allocate TLS
           pthread_lock_global_np();
           if thd_parm.tls_size_ind = 'S';
               tls = %alloc(SMALL_TLS_ALC);
           elseif thd_parm.tls_size_ind = 'L';
               tls = ts_malloc(LARGE_TLS_ALC);
           else;
               // error handling
           endif;

           pthread_unlock_global_np();

           // set TLS
           pthread_setspecific(thd_parm.tls_key : tls);

           // call func() which consume allocated TLS
           func(thd_parm.tls_key);

           return *null;
      /end-free
     p thread_main     e

     p tls_destructor  b
     d tls_destructor  pi
     d     tls                         *   value

     d rtn             s             10i 0

      /free
           // is TLS storage a teraspace allocation
           rtn = testptr(tls : x'01');

           if rtn = 0;  // TLS storage is allocated from the default heap
               dealloc tls;
           else;        // TLS storage is allocated from Teraspace
               ts_free(tls);
           endif;

      /end-free
     p tls_destructor  e

     /* procedure that consume allocated TLS storage */
     p func            b
     d func            pi
     d     tls_key                   10i 0 value

     d cvthc           pr                  extproc('cvthc')
     d     receiver                    *   value
     d     source                      *   value
     d     length                    10i 0 value

     d                 ds
     d tid                            8a
     d num_tid                       20u 0 overlay(tid)
     d tls             s               *
     d greeting        s             32a   based(tls)

      /free

           // get TLS storage
           tls = pthread_getspecific(tls_key);

           // consume TLS storage
           tid = retthid();
           greeting = 'From ' + %char(num_tid) + ': Ni hao!';
           dsply 'Greetings' '' greeting;

      /end-free
     p func            e
     /* EOF */
