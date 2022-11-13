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
      * @file t040.rpgle
      *
      * test of matinvat()
      *
      * CRTBNDRPG PGM(T040) SRCSTMF(... ...)
      *           INCDIR('/usr/local/include/rpg')
      *
      * @attention Program T040 makes changes to its caller program's
      *            automatic storage. It should be called by T040A.
      */

     h dftactgrp(*no)
      /copy mih52

     d asf_tmpl        ds                  likeds(matinvat_selection_t)
     d                                     based(asf_tmpl_ptr)
     d asf_tmpl_ptr    s               *
     d asf_rcv         ds                  likeds(matinvat_asf_receiver_t)
     d asf_rcv_ptr     s               *   inz(%addr(asf_rcv))

     d spcptr_info     ds                  likeds(matptr_spcptr_info_t)
     d ptr             s               *
     d buf             ds         32767    based(ptr)
     d str12           ds            12    based(ptr)
     d pos             s             10i 0

      /free

           // init asf_tmpl
           asf_tmpl_ptr = modasa(matinvat_selection_length);
           propb(asf_tmpl_ptr
                 : x'00'
                 : matinvat_selection_length);

           asf_tmpl.num_attr   = 1;
           asf_tmpl.flag1      = x'00';
           asf_tmpl.ind_offset = 0;
           asf_tmpl.ind_length = 0;
           asf_tmpl.attr_id    = 2;
           asf_tmpl.flag2      = x'00';
           asf_tmpl.rcv_offset = 0;
           asf_tmpl.rcv_length = 16;

           // locate space pointer to ASF
           matinvat(asf_rcv : asf_tmpl);

           // retrieve current offset into ASF SPCPTR
           spcptr_info.bytes_in = %size(spcptr_info);
           matptr(spcptr_info : asf_rcv.asf_ptr);

           // offset to the start of ASF SPCPTR
           ptr = asf_rcv.asf_ptr;
           ptr -= spcptr_info.offset;

           // find 'Tom Sawyer' and change it
           pos = %scan('Tom Sawyer' : buf);
           if pos <> 0;  // modify caller program's automatic storage
               ptr += pos - 1;
               str12 = 'Mark Twain';
           endif;

           *inlr = *on;
      /end-free
