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
      * @file t145.rpgle
      *
      * Test of _MATPG. Materialize BOM info.
      *
      * @param[in] pgm-name, CHAR(10)
      */
     h dftactgrp(*no)

     fQSYSPRT   o    f  132        disk

      /copy mih52

     d i_t145          pr                  extpgm('T145')
     d    pgm_name                   10a

     d yes_or_no       pr            10a
     d    flag                        1a
     d    off                         5i 0 value
     d    zero_is_y                   5i 0 value

     d rcv             ds                  likeds(matpg_tmpl_t)
     d                                     based(bufptr)
     d bufptr          s               *
     d len             s             10i 0
     d pgmptr          s               *
     d msg             s             32a
     d an              s             10a
     d i               s             10i 0
     d yes             c                   '*AVAIL'
     d no              c                   '*UNAVAIL'
     d bome            ds                  likeds(bom_entry0_t)
     d                                     based(pos)
     d pos             s               *

     d i_t145          pi
     d     pgm_name                  10a

      /free
           rslvsp_tmpl.obj_type = x'0201';
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
           msg = 'Program name';
           an = pgm_name;
           except OBVREC;

           // has template extension?
           msg = 'Template extension exists';
           an = yes_or_no(rcv.pgm_attr:10:0);

           // BOM format
           msg = 'BOM table format';
           an = 'OLD';
           if tstbts(%addr(rcv.bom_flags):0) > 0;
               an = 'NEW';
           endif;
           except OBVREC;

           // observation attributes (obsv_attr)
           msg = 'Instruction stream';
           an = yes_or_no(rcv.obsv_attr:0:0);
           except OBVREC;

           msg = 'ODV';
           an = yes_or_no(rcv.obsv_attr:1:0);
           except OBVREC;

           msg = 'OES';
           an = yes_or_no(rcv.obsv_attr:2:0);
           except OBVREC;

           msg = 'BOM table';
           an = yes_or_no(rcv.obsv_attr:3:0);
           except OBVREC;

           msg = 'Symbol table';
           an = yes_or_no(rcv.obsv_attr:4:0);
           except OBVREC;

           msg = 'OMT table';
           an = yes_or_no(rcv.obsv_attr:6:0);
           except OBVREC;

           // is old format BOM?
           if tstbts(%addr(rcv.bom_flags):0) > 0;
               *inlr = *on;
               return;
           endif;

           msg = 'BOM Table';
           an = *blank;
           except OBVREC;
           msg = 'MI Instruction Number';
           an = 'HLL STMT';
           except OBVREC;

           len = rcv.bom_len;
           i = 1;
           pos = bufptr + rcv.bom_offset;
           dow len > 0;
               if tstbts(%addr(bome.mi_inst) : 0) > 0;
                   // HLL stmt num is in numeric format
                   clrbts(%addr(bome.mi_inst) : 0);
                   msg = %char(bome.mi_inst);
                   an  = %char(bome.hll_stmt_num);
                   pos += 2 + 2;
                   len -= 2 + 2;
               else;
                   msg = %char(bome.mi_inst);
                   an  = %subst(bome.hll_stmt_name:1:rcv.bom_ent_len);
                   pos += 2 + rcv.bom_ent_len;
                   len -= 2 + rcv.bom_ent_len;
               endif;

               except OBVREC;
               i += 1;
           enddo;

           *inlr = *on;
      /end-free

     oQSYSPRT   e   nLR      OBVREC
     o                       msg
     o                       an

     p yes_or_no       b
     d yes_or_no       pi            10a
     d    flag                        1a
     d    off                         5i 0 value
     d    zero_is_y                   5i 0 value

     d bit_on          s               n

      /free
           bit_on = *off;
           if tstbts(%addr(flag) : off) > 0;
               bit_on = *on;
           endif;

           if zero_is_y = 1;
               bit_on = not bit_on;
           endif;

           if bit_on;
               return yes;
           else;
               return no;
           endif;

      /end-free
     p yes_or_no       e

     /**
      * examples:
      * > call t145 t143rpg
      *  Program name                    T143RPG
      *  BOM table format                OLD
      *  Instruction stream              *AVAIL
      *  ODV                             *AVAIL
      *  OES                             *AVAIL
      *  BOM table                       *AVAIL
      *  Symbol table                    *AVAIL
      *  OMT table                       *UNAVAIL
      *  BOM Table
      *  MI Instruction Number           HLL STMT
      *  1                               .ENTRY
      *  3                               .STOP
      *  5                               PROG DS
      *  5                               .DUMP
      *  22                              *GETIN
      *  30                              .ERX
      *  37                              *TOTC
      *  38                              *TOTL
      *  39                              *OFL
      *  41                              *DETC
      *  42                              200
      *  43                              300
      *  44                              400
      *  45                              500
      *  46                              600
      *  47                              700
      *  56                              800
      *  69                              900
      *  82                              1000
      *  84                              *DETL
      *  89                              .SORT
      *  89                              S.ARR
      *  103                             *INIT
      *  134                             .SENDMSG
      *  138                             *CANCL
      *  146                             *TERM
      *  150                             .FILERR
      *  151                             .ERR
      *  178                             .END0002
      *  182                             .END0001
      *  185                             .DEACTPG
      *  192                             .EXCPTON
      * 
      * > call t145 t142cl
      *  Program name                    T142CL
      *  BOM table format                OLD
      *  Instruction stream              *AVAIL
      *  ODV                             *AVAIL
      *  OES                             *AVAIL
      *  BOM table                       *AVAIL
      *  Symbol table                    *AVAIL
      *  OMT table                       *UNAVAIL
      *  BOM Table
      *  MI Instruction Number           HLL STMT
      *  10                              1100
      *  15                              1200
      *  22                              1300
      *  27                              1400
      *  34                              1600
      *  42                              1700
      * 
      * > call t145 spr77
      *  Program name                    SPR77
      *  BOM table format                OLD
      *  Instruction stream              *AVAIL
      *  ODV                             *AVAIL
      *  OES                             *AVAIL
      *  BOM table                       *AVAIL
      *  Symbol table                    *AVAIL
      *  OMT table                       *UNAVAIL
      *  BOM Table
      *  MI Instruction Number           HLL STMT
      *  20                              XOR
      *  22                              TSTBTS
      */
