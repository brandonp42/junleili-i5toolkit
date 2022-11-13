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
      * @file t024.rpgle
      *
      * List all AGs (activation groups) in the current job.
      * MI instructions used here
      *  - MATPRAGP
      *  - MATAGPAT
      *  - TSTBTS
      *
      * example output of T024:
      *
      * call t024                                                  
      * Number  AGP Mark  Domain  AGP Name                        .
      * 0001    00000001  *SYS                                    .
      * 0002    00000002  *USER                                   .
      * 0003    00000012  *SYS    QLGLOCAL                        .
      * 0004    00000017  *USER   QILE                            .
      * 0005    0000001C  *USER   SPRING                          .
      * 0006    0000001E  *SYS    QTESAGRP                        .
      * 0007    0000001F  *SYS    QTESTIFC                        .
      * 0008    00000022  *SYS    QTESGUI                         .
      */

      /if defined(*crtbndrpg)
     h dftactgrp(*no)
      /endif
     h bnddir('QC2LE')

      /copy mih52

     d cvthc           pr                  extproc('cvthc')
     d     receiver                    *   value
     d     source                      *   value
     d     length                    10i 0 value

     d sendmsg         pr
     d     text                       1a   options(*varsize)
     d     len                       10i 0 value

     d agps            ds                  likeds(matpragp_tmpl_t)
     d                                     based(ptr)
     d ptr             s               *
     d bytes_needed    s             10i 0
     d ind             s              5i 0
     d agp_mark        s              4a   based(mark_ptr)
     d mark_ptr        s               *
     d msg             s             50a
     d MSG_LEN         c                   58
     d agp_attr        ds                  likeds(agp_basic_attr_t)
     d attr_sel        s              1a   inz(x'00')

      /free

           // get number of AGs and number of bytes to alloc
           ptr = %alloc(12);
           agps.bytes_in = 12;
           matpragp(ptr);
           bytes_needed = agps.bytes_out;

           // allocate buffer and materialize AG marks
           ptr = %realloc(ptr : bytes_needed);
           agps.bytes_in = bytes_needed;
           matpragp(ptr);

           // display AG marks and AG names
           msg = 'Number  AGP Mark  Domain  AGP Name' ;
           sendmsg(msg : MSG_LEN) ;
           propb(%addr(agp_attr) : x'00' : %size(agp_attr));
           agp_attr.bytes_in = %size(agp_attr);
           mark_ptr = ptr + 12;
           for ind = 1 to agps.agp_num;
               clear msg ;
               cvthc(%addr(msg) : %addr(ind) : 4);
               cvthc(%addr(msg) + 8 : mark_ptr : 8);

               // get activation group name and domain
               matagpat( %addr(agp_attr)
                       : agp_mark
                       : attr_sel );
               if tstbts(%addr(agp_attr.agp_attr) : 1) = 0;
                   %subst(msg:19:5) = '*USER';
               else;
                   %subst(msg:19:4) = '*SYS';
               endif;
               %subst(msg:27) = agp_attr.agp_name;

               sendmsg(msg : MSG_LEN) ;

               // offset to next AGP mark
               mark_ptr += 4;
           endfor;

           dealloc ptr;  // free allocated buffer
           *inlr = *on;
      /end-free

     /* sendmsg (text : len) */ 
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
