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
      * @file t146.rpgle
      *
      * Test of _MATPG. Materialize HLL symbol table.
      *
      * @param[in] pgm-name, CHAR(10)
      * @param[in] pgm-type, CHAR(2). MI object type of pgm-name.
      *            e.g. x'0201', x'0202', ...
      *
      * @attention Note that *SQLPKGs are in the system domain.
      */
     h dftactgrp(*no)

     fQSYSPRT   o    f  132        disk

      /copy mih52

     d i_t146          pr                  extpgm('T146')
     d    pgm_name                   10a
     d    pgm_type                    2a

     d rcv             ds                  likeds(matpg_tmpl_t)
     d                                     based(bufptr)
     d bufptr          s               *
     d len             s             10i 0
     d pgmptr          s               *
     d msg             s             80a
     d lst_fld1        s             10a
     d lst_fld2        s             10a
     d lst_fld3        s             16a
     d lst_fld4        s             10a
     d i               s             10i 0
     d buckets         s             10i 0 based(sym_start)
     d bucket          s             10i 0 based(pos)
     d pos             s               *
     d sym_ptr         s               *
     d sym_start       s               *
     d sym             ds                  likeds(symtbl_base_t)
     d                                     based(sym_ptr)
     d                 ds
     d sym_len                        5u 0
     d sym_len_lo                     1a   overlay(sym_len:2)
     d obj_type        s              2a

      * @pre sym_ptr
     d parse_symbol_entry...
     d                 pr

     d i_t146          pi
     d     pgm_name                  10a
     d     pgm_type                   2a

      /free
           if %parms() > 1;
               obj_type = pgm_type;
           else;
               obj_type = x'0201';
           endif;

           rslvsp_tmpl.obj_type = obj_type;
           rslvsp_tmpl.obj_name = pgm_name;
           rslvsp2(pgmptr : rslvsp_tmpl);

           len = 8;
           bufptr = modasa(len);
           rcv.bytes_in = len;
           matpg(rcv : pgmptr);

           len = rcv.bytes_out;
           bufptr = modasa(len);
           rcv.bytes_in = len;
           matpg(rcv : pgmptr);

           // program name
           msg = 'HLL Symobl Table';
           except OBVREC;
           msg = 'Program name: ' + pgm_name;
           except OBVREC;

           // has HLL symbol table?
           if tstbts(%addr(rcv.obsv_attr) : 4) = 0;
               msg = 'HLL symbol table is NOT available.';
               except OBVREC;
               *inlr = *on;
               return;
           endif;

           sym_start = bufptr + rcv.symtbl_offset;
           len = rcv.symtbl_len;

           pos = sym_start + 4;
           msg = 'ODT Ref   MI Inst   Symbol Name     Symbol Org';
           except OBVREC;
           for i = 1 to buckets;
               if bucket = -1;
                   pos += 4;
                   iter;
               endif;

               sym_ptr = sym_start + bucket;
               parse_symbol_entry();

               pos += 4; // next hash bucket
           endfor;

           *inlr = *on;
      /end-free

     oQSYSPRT   e   nLR      OBVREC
     o                       msg

     oQSYSPRT   e   nLR      LSTREC
     o                       lst_fld1
     o                       lst_fld2
     o                       lst_fld3
     o                       lst_fld4

     p parse_symbol_entry...
     p                 b
     d                 pi

      /free
               if tstbts(%addr(sym.flag) : 0) = 0; // sym.num is an MI instruction number
                   lst_fld1 = *blanks;
                   lst_fld2 = %char(sym.num);
               else; // sym.num is an ODT reference
                   lst_fld1 = %char(sym.num);
                   lst_fld2 = *blanks;
               endif;

               sym_len = 0;
               sym_len_lo = sym.len;
               lst_fld3 = %subst(sym.name : 1 : sym_len);

               // Symbol origin
               if tstbts(%addr(sym.flag) : 1) = 0; // compiler generated
                   lst_fld4 = 'Compiler';
               else;
                   lst_fld4 = 'Source';
               endif;

               except LSTREC;

               // locate next entry in the current chain
               if sym.next_entry_offset <> -1;
                   sym_ptr = sym_start + sym.next_entry_offset;
                   parse_symbol_entry();
               endif;

      /end-free

     p parse_symbol_entry...
     p                 e

     /**
      * examples:
      * > call t146 t143rpg
      * HLL Symobl Table
      * Program name: T143RPG
      * ODT Ref   MI Inst   Symbol Name     Symbol Org
      * 240                 ZIGNDECD        Source
      *           22        *GETIN          Source
      * 23                  ARR             Source
      * 76                  *MONTH          Source
      * 24                  WHR             Source
      * 72                  *DATE           Source
      * 17                  *INXX           Source
      * 20                  *IN             Source
      *           89        S.ARR           Source
      *           138       *CANCL          Source
      * 87                  M.*YEAR         Source
      * 85                  M.*DAY          Source
      *           84        *DETL           Source
      *           37        *TOTC           Source
      * 86                  M.*MONTH        Source
      * 78                  *DAY            Source
      * 13                  *ON             Source
      * 83                  M.UYEAR         Source
      * 80                  M.UDATE         Source
      *           38        *TOTL           Source
      * 118                 ZPGMSTUS        Source
      * 79                  UDAY            Source
      * 77                  UMONTH          Source
      * 262                 C.PGMJTM        Source
      * 82                  M.UMONTH        Source
      * 73                  UDATE           Source
      * 22                  *IN91           Source
      * 19                  *INLR           Source
      * 30                  WORK.           Source
      * 16                  *INIT           Source
      * 263                 C*DATE          Source
      * 14                  *OFF            Source
      *           39        *OFL            Source
      * 75                  UYEAR           Source
      *           41        *DETC           Source
      * 74                  *YEAR           Source
      * 81                  M.UDAY          Source
      *           146       *TERM           Source
      * 84                  M.*DATE         Source
      *
      * > call t146 t142cl
      * HLL Symobl Table
      * Program name: T142CL
      * ODT Ref   MI Inst   Symbol Name     Symbol Org
      * 22                  &PRM1           Source
      * 21                  &MSG            Source
      * 24                  &PRM2           Source
      * 27                  &STR            Source
      * 26                  &MSGPTR         Source
      *
      * > call t146 spr77
      * HLL Symobl Table
      * Program name: SPR77
      * ODT Ref   MI Inst   Symbol Name     Symbol Org
      * 22                  ARR             Source
      * 14                  F-POS           Source
      * 2                   B               Source
      * 24                  BARR            Source
      * 20                  B2              Source
      * 23                  FIND            Source
      *           23        SEE-YOU         Source
      * 1                   A               Source
      * 18                  F-UNOR          Source
      *           8         GT              Source
      * 25                  START           Source
      * 15                  F-NEG           Source
      * 21                  B3              Source
      * 17                  F-NAN           Source
      * 19                  B1              Source
      * 7                   F               Source
      * 16                  F-ZER           Source
      */
