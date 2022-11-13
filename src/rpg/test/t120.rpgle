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
      * @file t120.rpgle
      *
      * Test of _MATMATR1.
      *  - machine serial number
      *  - time-of-day clock with clock-offset
      *  - NETA (network attributes)
      *  - IPL request status
      *  - LIC VRM
      */

     h dftactgrp(*no)

      /copy mih52
      * machine serial number
     d srlnbr          ds                  likeds(
     d                                       matmatr_machine_srlnbr_t)
     d clock           ds                  likeds(
     d                                       matmatr_clock_offset_t)
     d neta            ds                  likeds(matmatr_net_attr_t)
     d ipl_req         ds                  likeds(matmatr_ipl_req_t)
     d elic            ds                  likeds(matmatr_elic_id_t)
     d vrm             ds                  likeds(matmatr_lic_vrm_t)
     d opt             s              2a
     d len             s              5u 0

      /free
           opt = x'0004';  // machine serial number
           srlnbr.bytes_in = %size(srlnbr);
           matmatr(srlnbr : opt);
           dsply 'machine serial number' '' srlnbr.srlnbr;

           // time-of-day clock with clock-offset
           opt = x'0101';
           clock.bytes_in = %size(clock);
           matmatr(clock : opt);

           // network attributes, 0130
           len = %size(matmatr_net_attr_t); // 198
           opt = x'0130';
           neta.bytes_in = len;
           matmatr(neta : opt);

           // electronic license id
           opt = x'01FC';
           elic.bytes_in = %size(elic);
           matmatr(elic : opt);
           dsply 'Electronic license ID' '' elic.elic_id;

           // lic vrm
           opt = x'020C';
           vrm.bytes_in = %size(vrm);
           matmatr(vrm : opt);
           dsply 'LIC VRM' '' vrm.lic_vrm;

           // ipl request status
           opt = x'0168';
           ipl_req.bytes_in = %size(ipl_req);
           matmatr(ipl_req : opt);
           dsply 'Current IPL type' '' ipl_req.cur_ipl_type;

           *inlr = *on;
      /end-free
