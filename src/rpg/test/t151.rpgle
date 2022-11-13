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
      * @file t151.rpgle
      *
      * Test of _MATPG. ODT analysis (scalar data objects).
      */
     h dftactgrp(*no) bnddir('UANDI')

      /copy mih52
      /copy uandi

     d pep             pr                  extpgm('T151')
     d     pgm_name                  10a

     d parse_odt       pr
     d                                 *   value

     d rcv             ds                  likeds(matpg_tmpl_t)
     d                                     based(bufptr)
     d bufptr          s               *
     d len             s             10i 0
      * OPM MI program
     d pgm             s               *
     d odv_ptr         s               *
     d oes_ptr         s               *
     d odv_len         s             10u 0 based(odv_ptr)
     d i               s             10i 0

     d pep             pi
     d     pgm_name                  10a

      /free

           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = pgm_name;
           rslvsp2(pgm : rslvsp_tmpl);

           len = 8;
           bufptr = modasa(len);
           rcv.bytes_in = len;
           matpg(rcv : pgm);

           len = rcv.bytes_out;
           bufptr = modasa(len);
           rcv.bytes_in = len;
           matpg(rcv : pgm);
             // check rcv

           odv_ptr = bufptr + rcv.odv_offset;
           oes_ptr = bufptr + rcv.oes_offset;

           odv_ptr += 4;
           for i = 1 to rcv.num_odv1;
               parse_odt(odv_ptr);
               odv_ptr += 4;
           endfor;

           *inlr = *on;
      /end-free

     p parse_odt       b

      /copy mip
     d odve            ds                  based(odv_ptr)
     d                                     likeds(odv_entry_t)
     d sc_info         ds                  likeds(scalar_info_t)
     d f2              s              5u 0
     d b2              s              5u 0
     d a2              s              2a
     d a3              s              3a
     d len             s              5u 0
     d f4              s             10u 0
     d grp_1           s               n   inz(*on)
     d has_oes         s               n   inz(*off)
     d has_oes_ext     s               n   inz(*off)
     d rep_bit         s               n   inz(*off)
     d oes_start       s               *
     d app_pos         s               *
     d oes_hdr         s              1a   based(oes_start)
     d oes_ext         s              1a
      * current offset into the OES (start from OES_START)
     d cur_oes_off     s             10u 0

     d parse_odt       pi
     d     odv_ptr                     *   value

      /free
           clear sc_info;

           f2 = cvt_bits2(odve.hi:2:0:4);
           b2 = cvt_bits2(odve.hi:2:13:3);
           if f2 = 0;       // group-1
               sc_info.type = b2;
           elseif f2 = 9;  // group-2
               sc_info.type = b2;
               setbts(%addr(sc_info.type) : 7);
           else;  // not a scalar
               return;
           endif;

           // addr attr
           sc_info.addr = cvt_bits2(odve.hi:2:5:3); // bits 5-7

           // boundary attr
           sc_info.bdry = cvt_bits2(odve.hi:2:9:3); // bits 9-11

           // ABN
           sc_info.opt  = '0';
           if tstbts(%addr(odve.hi):8) > 0;
               sc_info.opt = '1';
           endif;

           // use system initial value or not?
           sc_info.sys_init_val = '0';
           if tstbts(%addr(odve.hi):12) > 0;
               sc_info.sys_init_val = '1';
           endif;

           // has corresponding OES entries
           if tstbts(%addr(odve.hi):4) > 0;
               has_oes = *on;
               oes_start = oes_ptr + odve.oes_offset;
               app_pos = oes_start + 1;
               if tstbts(%addr(oes_hdr) : 7) > 0;
                   has_oes_ext = *on;
                   memcpy(%addr(oes_ext) : oes_start + 1 : 1);
                   app_pos += 1;
               endif;
           endif;

           // scalar length
           if not has_oes;  // when there's NO OES, the lower 2 bytes of ODV is ...
               // znd or pkd
               a2 = odve.scalar_len;
               if sc_info.type = x'0003' or sc_info.type = x'0004';
                   sc_info.length_hi = cvt_bits2(a2 : 2 : 0 : 8);
                   sc_info.length_lo = cvt_bits2(a2 : 2 : 8 : 8);
               else;
                   sc_info.length = cvt_bits2(a2 : 2 : 0 : 16);
               endif;
           endif;

           // OES appendages
           if not has_oes;
               return;
           endif;

           // name attr
           if tstbts(%addr(oes_hdr) : 0) > 0;
               memcpy(%addr(len) : app_pos : 2);
               sc_info.name_len = len;
               sc_info.name_off = app_pos - oes_ptr + 2;

               // offset app_pos
               app_pos += 2 + len;
           endif;

           // Scalar Length Appendage
           if tstbts(%addr(oes_hdr) : 1) > 0;
               if has_oes_ext and tstbts(%addr(oes_ext) : 1) > 0;
                   memcpy(%addr(a3) : app_pos : 3);
                   sc_info.length = cvt_bits4(a3:3:0:24);

                   app_pos += 3;
               else;
                   memcpy(%addr(a2) : app_pos : 2);
                   if sc_info.type = x'0003' or sc_info.type = x'0004';
                       sc_info.length_hi = cvt_bits2(a2 : 2 : 0 : 8);
                       sc_info.length_lo = cvt_bits2(a2 : 2 : 8 : 8);
                   else;
                       sc_info.length = cvt_bits2(a2 : 2 : 0 : 16);
                   endif;

                   app_pos += 2;
               endif;
           endif;

           // array appendage
           if tstbts(%addr(oes_hdr) : 2) > 0;
               sc_info.arr_flag = '1';

               memcpy(%addr(sc_info.arr_elem) : app_pos : 4);
               memcpy(%addr(sc_info.aeo) : app_pos + 4 : 2);
               if has_oes_ext and tstbts(%addr(oes_ext) : 2) > 0;
                   memcpy(%addr(sc_info.arr_lb) : app_pos + 6 : 4);  // lower bound
                   memcpy(%addr(sc_info.arr_ub) : app_pos + 10 : 4); // upper bound
               endif;
           endif;

           // base appendage
           if tstbts(%addr(oes_hdr) : 3) > 0;
               memcpy(%addr(sc_info.base_odt) : app_pos : 2);
           endif;

           // pos appendage
           if tstbts(%addr(oes_hdr) : 4) > 0;
               memcpy(%addr(sc_info.pos_val) : app_pos : 2);
           endif;

           // initial-value appendage
           if tstbts(%addr(oes_hdr) : 5) > 0;
               if tstbts(%addr(oes_hdr) : 6) > 0; // replaction bit
                   rep_bit = *on;
               else;
                   rep_bit = *off;
               endif;

               if NOT rep_bit;
                   if sc_info.arr_flag and sc_info.length > 32767;
                       // @where
                   else;
                   endif;
               else;
                   // use replication format
               endif;
           endif;

      /end-free
     p parse_odt       e
