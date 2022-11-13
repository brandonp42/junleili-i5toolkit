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
      * @file t141.rpgle
      *
      * Test of _MATPG. Materialize the instruction stream of an OPM program.
      */
     h dftactgrp(*no)

      /copy mih52
     d rcv             ds                  likeds(matpg_tmpl_t)
     d                                     based(bufptr)
     d bufptr          s               *
     d len             s             10i 0
      * OPM MI program
     d t141a           s               *
     d inst_ptr        s               *
     d inst_comp       ds                  qualified
     d                                     based(inst_ptr)
     d     num                       10i 0
     d     arr                        5u 0 dim(2000)

      /free
           len = %size(rcv);
           dsply 'length of matpg_tmpl_t' '' len;

           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'T141A';
           rslvsp2(t141a : rslvsp_tmpl);

           len = 8;
           bufptr = modasa(len);
           rcv.bytes_in = len;
           matpg(rcv : t141a);

           len = rcv.bytes_out;
           bufptr = modasa(len);
           rcv.bytes_in = len;
           matpg(rcv : t141a);
             // check rcv

           // instruction stream component
           inst_ptr = bufptr + rcv.inst_stream_offset;
             // num = 30
             // inst_ptr:x 30
             //   0000001E 38461000 00012000 00021846
             //   40000001 20010003 02A10000 0260
             // arr(1) = h'3846', CMPNV op-code number = 1046, CMPNVI (1846)
             // 

           *inlr = *on;
      /end-free

     /**
      * 5722SS1 V5R4M0 060210                                Generated Output                                 10/11/15 17:43:55  Page     1
      *  SEQ   INST Offset    Generated Code     *... ... 1 ... ... 2 ... ... 3 ... ... 4 ... ... 5 ... ... 6 ... ... 7 ... ... 8   Break
      * 00001                                             DCL DD A PKD(7,5) AUTO INIT(P'15.67')                                 ;
      * 00002                                             DCL DD POSITIVE-FLAG CHAR(1) AUTO INIT('0')                           ;
      * 00003                                             DCL DD ONE-FLAG CHAR(1) AUTO INIT('0')                                ;
      * 00004  0001 000004  3846 1000 0001 2000           CMPNV(I) A, 0 / HI(POSITIVE-FLAG)                                     ;
      *                     0002
      * 00005  0002 00000E  1846 4000 0001 2001           CMPNV(I) A, 1 / EQ(ONE-FLAG)                                          ;
      *                     0003
      * 00006                                             BRK "SEE-YOU"                                                         ;  SEE-YOU
      * 00007  0003 000018  02A1 0000                     RTX *                                                                 ;  SEE-YOU
      * 00008  0004 00001C  0260                          PEND                                                                  ;  SEE-YOU
      * 5722SS1 V5R4M0 060210                                Generated Output                                 10/11/15 17:43:55  Page     2
      *  ODT  ODT Name                                         Attributes and ODV/OES Entries
      *  0001 A                                                DATA OBJECT,AUTOMATIC,PACKED(7,5),INTERNAL,INITIAL VALUE.
      *                                                        09030004/4405071567000F
      *  0002 POSITIVE-FLAG                                    DATA OBJECT,AUTOMATIC,CHARACTER(1),INTERNAL,INITIAL VALUE.
      *                                                        0904000B/440001F0
      *  0003 ONE-FLAG                                         DATA OBJECT,AUTOMATIC,CHARACTER(1),INTERNAL,INITIAL VALUE.
      *                                                        0904000F/440001F0
      * 5722SS1 V5R4M0 060210                                Generated Output                                 10/11/15 17:43:55  Page     3
      *  MSGID    ODT   ODT Name                                          Semantics and ODT Syntax Diagnostics
      * 5722SS1 V5R4M0 060210                                Generated Output                                 10/11/15 17:43:55  Page     4
      * ODT  ODT Name                         SEQ Cross Reference       (* Indicates Where Defined)
      * 0001 A                                                1* 4 5
      * 0003 ONE-FLAG                                         3* 5
      * 0002 POSITIVE-FLAG                                    2* 4
      */
