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
      * @file t023.rpgle
      *
      * test of xlateb(), xlateb1()
      */

     h dftactgrp(*no)
     h bnddir('QC2LE')

      /copy mih52

     d cvthc           pr                  extproc('cvthc')
     d     receiver                    *   value
     d     source                      *   value
     d     length                    10i 0 value

     d str             s              3a   inz('abc')
     d table           s            256a
     d hexstr          s             16a

     d ptr             s               *
     d str2            ds             3    based(ptr)

      /free

           // XLATEB
           cvthc(%addr(hexstr) : %addr(str) : 6);
           dsply 'EBCDIC' '' hexstr;

           // ascii table
           table =
       x'000102039C09867F978D8E0B0C0D0E0F101112139D8508871819928F1C1D1E1F'+
       x'80818283840A171B88898A8B8C050607909116939495960498999A9B14159E1A'+
       x'20A0A1A2A3A4A5A6A7A85B2E3C282B2126A9AAABACADAEAFB0B15D242A293B5E'+
       x'2D2FB2B3B4B5B6B7B8B97C2C255F3E3FBABBBCBDBEBFC0C1C2603A2340273D22'+
       x'C3616263646566676869C4C5C6C7C8C9CA6A6B6C6D6E6F707172CBCCCDCECFD0'+
       x'D17E737475767778797AD2D3D4D5D6D7D8D9DADBDCDDDEDFE0E1E2E3E4E5E6E7'+
       x'7B414243444546474849E8E9EAEBECED7D4A4B4C4D4E4F505152EEEFF0F1F2F3'+
       x'5C9F535455565758595AF4F5F6F7F8F930313233343536373839FAFBFCFDFEFF';

           xlateb(%addr(str) : %addr(table) : 3);
           cvthc(%addr(hexstr) : %addr(str) : 6);
           dsply 'ASCII' '' hexstr;

           // XLATEB1, the receiver param is overlapped with translate table
           // and the source string
           ptr = %addr(table) + 33;
           xlateb1( ptr
                   : ptr             // str2: x'818283'
                   : %addr(table)
                   : 3);
           cvthc(%addr(hexstr) : ptr : 6);
           dsply 'ASCII' '' hexstr;

           *inlr = *on;
      /end-free

