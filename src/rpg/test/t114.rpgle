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
      * @file t114.rpgle
      *
      * Materialize all USRPRFs and corresponding uids/gids.
      */
     h dftactgrp(*no)

      /copy mih52
     d sendmsg         pr
     d     text                       1a   options(*varsize)
     d     len                       10i 0 value

     d dsp_prf         pr
     d     prf_info                        likeds(matupid_usrprf_long_t)

     d sel             ds                  likeds(matupid_select_tmpl_t)
     d tmpl            ds                  likeds(matupid_tmpl_t)
     d                                     based(ptr)
     d ptr             s               *
     d prf_info        ds                  likeds(matupid_usrprf_long_t)
     d                                     based(pos)
     d pos             s               *
     d len             s             10u 0
     d i               s             10u 0
     d msg             s             32a

      /free
           propb(%addr(sel) : x'00' : %size(sel));
           sel.fmt_option = x'02';
           sel.type_option = x'80';

           len = %size(tmpl);
           ptr = %alloc(len);
           tmpl.bytes_in = len;
           // get number of bytes needed
           matupid(tmpl : sel);
           len = tmpl.bytes_out;
           ptr = %realloc(ptr : len);
           tmpl.bytes_in = len;
           matupid(tmpl : sel);

           // check what we get
           pos = ptr + %size(tmpl);

           msg = *all' ';
           msg = 'USRPRF Name    uid/gid     Type';
           sendmsg(msg : 32);

           // user profiles and uids
           for i = 1 to tmpl.num_uids;
               dsp_prf(prf_info);
               pos += %size(prf_info);
           endfor;

           // user profiles and gids
           for i = 1 to tmpl.num_gids;
               dsp_prf(prf_info);
               pos += %size(prf_info);
           endfor;

           dealloc ptr;
           *inlr = *on;
      /end-free

     p dsp_prf         b
     d                 pi
     d     prf_info                        likeds(matupid_usrprf_long_t)

      /free
           msg = *all' ';

           %subst(msg:1:10) = %subst(prf_info.prf_name:1:10);
           %subst(msg:16:12) = %char(prf_info.id);
           if prf_info.id_type = x'01';
               %subst(msg:28:3) = 'uid';
           else;
               %subst(msg:28:3) = 'gid';
           endif;

           sendmsg(msg : 32);
      /end-free
     p dsp_prf         e

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
