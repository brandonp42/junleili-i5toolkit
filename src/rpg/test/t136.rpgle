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
      * @file t136.rpgle
      *
      * Test of QusMaterializeContext, listing objects in QSYS.
      */

     h dftactgrp(*no) bnddir('QC2LE')

      /copy mih52
     d opt             ds                  likeds(matctx_option_t)
     d rcv             ds                  likeds(matctx_receiver_t)
     d                                     based(bufptr)
     d bufptr          s               *
     d objd            ds                  likeds(context_entry_full_t)
     d                                     based(pos)
     d pos             s               *
     d len             s             10i 0
     d num             s             10i 0
     d i               s             10i 0
     d                 ds
     d ctx                             *
     d ctx2                            *   procptr overlay(ctx)

     d sendmsg         pr
     d     text                       1a   options(*varsize)
     d     len                       10i 0 value

     d cvthc           pr                  extproc('cvthc')
     d                                2a   options(*varsize)
     d                                1a   options(*varsize)
     d                               10i 0 value

     d                 ds 
     d msg                           40a
     d type                           2a   overlay(msg)
     d subtype                        2a   overlay(msg:4)
     d obj_name                      30a   overlay(msg:7)

      /free
           rslvsp_tmpl.obj_type = x'0401';
           rslvsp_tmpl.obj_name = 'QSYS';
           rslvsp2(ctx : rslvsp_tmpl);

           opt = *allx'00';
           opt.sel_flag = x'07';
           opt.sel_criteria = x'40';

           bufptr = modasa(8);
           rcv.bytes_in = 8;
           QusMaterializeContext(rcv : ctx2 : opt);

           len = rcv.bytes_out;
           bufptr = modasa(len);
           rcv.bytes_in = len;
           QusMaterializeContext(rcv : ctx2 : opt);

           // check materialized contex entries
           pos = bufptr + 96;
           // check objd
           num = (rcv.bytes_out - 96) / %size(objd);
           for i = 1 to num;
               cvthc(type : objd.objid.type_code : 2);
               cvthc(subtype : objd.objid.subtype_code : 2);
               obj_name = objd.objid.name;

               sendmsg(msg : 40);
               pos += %size(objd);
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
