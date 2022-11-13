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
      * @file t155.rpgle
      *
      * Test of _MATPG. Materialize the OMT component of an OPM MI program.
      */
     h dftactgrp(*no)

     fQSYSPRT   o    f  132        disk

      /copy mih52
     d pep             pr                  extpgm('T155')
     d     pgm_name                  10a

     d rcv             ds                  likeds(matpg_tmpl_t)
     d                                     based(bptr)
     d bptr            s               *
     d len             s             10u 0
     d pgm             s               *
     d omt_ptr         s               *
     d omte            ds                  likeds(omt_entry_t)
     d                                     based(omt_ptr)
     d i               s             10i 0
     d addr_type       s             10a
     d offset          s             10s 0
     d num_bas         s              5s 0
     d odt_num         s              5s 0
     d b4              s             10i 0
     d ws              s              1a

     d pep             pi
     d     pgm_name                  10a

      /free
           // resolve target OPM PGM
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = pgm_name;
           rslvsp2(pgm : rslvsp_tmpl);

           // ...
           len = 8;
           bptr = modasa(len);
           rcv.bytes_in = len;
           matpg(rcv : pgm);

           len = rcv.bytes_out;
           bptr = modasa(len);
           rcv.bytes_in = len;
           matpg(rcv : pgm);

           // is the OMT component materializable?
           if tstbts(%addr(rcv.obsv_attr) : 5) = 0;
               *inlr = *on;
               return;
           endif;

           omt_ptr = bptr + rcv.omt_offset;
           except OMTREC;

           for i = 1 to rcv.num_odv1;

               odt_num = i;

               // check omt entry: addr-type, offset-from-base, ...
               select;
               when omte.addr_type = x'00';
                   addr_type = 'STATIC';
               when omte.addr_type = x'01';
                   addr_type = 'AUTO';
               when omte.addr_type = x'02';
                   addr_type = 'SPCPTR';
               when omte.addr_type = x'03';
                   addr_type = 'PARM';
               when omte.addr_type = x'04';
                   addr_type = 'PCO';
               other;
                   addr_type = 'UNKNOWN';
               endsl;

               b4 = 0;
               memcpy(%addr(b4) + 1 : %addr(omte.offset) : 3);
               offset = b4;

               num_bas = omte.basee;

               except OMTREC;

               omt_ptr += %size(omt_entry_t);
           endfor;

           *inlr = *on;
      /end-free

     oQSYSPRT   e            OMTREC
     o                       odt_num
     o                       ws
     o                       addr_type
     o                       ws
     o                       offset
     o                       ws
     o                       num_bas

