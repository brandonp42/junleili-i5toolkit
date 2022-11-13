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
      * @file t128.rpgle
      *
      * Test of MATRMD with option hex 17 -- materializing
      * storage allocation and deallocation info of each task and
      * thread.
      *
      * Example output of this program:
      * @code
      * 4 > call t128                                                   
      *     Thd/Task  Task name                          Pages allocated/deallocated/delta.                              
      *     Init Thd  QTFTP00092QTCP      214306         2368709/76273/2292436.
      *     Init Thd  QTFTP05416QTCP      215776         1782037/29557/1752480.
      *     2nd Thd   QYPSPFRCOLQSYS      214455         1653271/6014/1647257. 
      *     Init Thd  SCPF      QSYS      000000         282297/472817/0.              
      *     2nd Thd   QYPSPFRCOLQSYS      214455         123122/19824/103298.     
      *     LIC Task  JO-EVALUATE-TSK0                   99081/99060/21.   
      *     2nd Thd   QYPSPFRCOLQSYS      214455         97701/18834/78867.
      *     LIC Task  JO-EVALUATE-TSK1                   96081/96044/37.   
      *     LIC Task  VTMTS0003                          3275/0/3275.  
      *     Init Thd  QSQSRVR   QUSER     269126         3250/513/2737.
      *     Init Thd  QSQSRVR   QUSER     268301         2525/55/2470.
      *     Init Thd  QSQSRVR   QUSER     267975         2525/55/2470.
      * @endcode
      */

     h dftactgrp(*no)

      /copy mih52
     d sendmsg         pr
     d     text                       1a   options(*varsize)
     d     len                       10i 0 value

     d opt             ds                  likeds(matrmd_option_t)
     d tmpl            ds                  likeds(matrmd_tmpl17_t)
     d                                     based(ptr)
     d ptr             s               *
     d pos             s               *
     d alloc_info      ds                  likeds(stg_alloc_info_t)
     d                                     based(pos)
     d len             s             10u 0
     d i               s             10u 0
     d msg             s             80a

      /free
           opt = *allx'00';
           opt.val = x'17';

           len = %size(tmpl);
           ptr = modasa(len);
           tmpl.bytes_in = len;
           tmpl.req_func = 1;  // Sorted by storage allocation
           matrmd(tmpl : opt);

           len = tmpl.bytes_out;
           ptr = modasa(len);
           tmpl.bytes_in = len;
           tmpl.req_func = 1;
           matrmd(tmpl : opt);

           pos = ptr + %size(matrmd_tmpl17_t);
           msg = 'Thd/Task  Task name                          '
             + 'Pages allocated/deallocated/delta';
           sendmsg(msg : 80);
           for i = 1 to tmpl.total_number_of_tasks_and_threads;
               msg = *blanks;

               // thread or LIC task?
               select;
               when alloc_info.flag = x'0000';
                   %subst(msg:1:10) = '2nd Thd';
               when alloc_info.flag = x'4000';
                   %subst(msg:1:10) = 'Init Thd';
               when alloc_info.flag = x'8000';
                   %subst(msg:1:10) = 'LIC Task';
               when alloc_info.flag = x'C000';
                   %subst(msg:1:10) = 'Reserved';
               other;
                   // Oops!?
               endsl;

               %subst(msg : 11 : 32) = alloc_info.task_name;
               %subst(msg : 46) = %char(alloc_info.allocated_pages)
                 + '/' + %char(alloc_info.deallocated_pages)
                 + '/' + %char(alloc_info.delta_pages);

               sendmsg(msg : 80);
               pos += %size(stg_alloc_info_t);
           endfor;

           *inlr = *on;
      /end-free

     p sendmsg         b
     d                 pi
     d     text                       1a   options(*varsize)
     d     len                       10i 0 value

      * error code structure used by i5/OS APIs
     d qusec_t         ds                  qualified
     d     bytes_in                  10i 0
     d     bytes_out                 10i 0
     d     msg_id                     7a
     d                                1a

      * prototype of OPM API QMHSNDPM
     d qmhsndpm        pr                  extpgm('QMHSNDPM')
     d     msgid                      7a
     d     msgf                      20a
     d     msg_data                   1a   options(*varsize)
     d     msg_data_len...
     d                               10i 0
     d     msg_type                  10a
     d     stk_entry                 10a
     d     stk_cnt                   10i 0
     d     msg_key                    4a
     d     ec                              likeds(qusec_t)

     d msgid           s              7a   inz('CPF9898')
     d msgf            s             20a   inz('QCPFMSG   QSYS')
     d msg_type        s             10a   inz('*INFO')
     d stk_entry       s             10a   inz('*PGMBDY')
     d stk_cnt         s             10i 0 inz(1)
     d msg_key         s              4a
     d ec              ds                  likeds(qusec_t)

      /free
           ec.bytes_in = 16;
           qmhsndpm ( msgid
                    : msgf
                    : text
                    : len
                    : msg_type
                    : stk_entry
                    : stk_cnt
                    : msg_key
                    : ec );

      /end-free
     p sendmsg         e
