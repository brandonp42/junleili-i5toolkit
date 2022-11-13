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
      * @file t132.rpgle
      *
      * Test of libiconv APIs.
      */
     h dftactgrp(*no)

      /copy iconv
     d cd              ds                  likeds(iconv_t)
     d tocode          ds                  likeds(qtqcode_t)
     d fromcode        ds                  likeds(qtqcode_t)
     d rtn             s             10i 0
     d ustr            s              8a   inz(x'6161626263636464')
     d inbufptr        s               *   inz(%addr(ustr))
     d inlen           s             10u 0 inz(8)
     d str             s              8a
     d outbufptr       s               *   inz(%addr(str))
     d outlen          s             10u 0 inz(8)

      /free
           tocode = *allx'00';
           tocode.ccsid = 935;
           fromcode = *allx'00';
           fromcode.ccsid = 1208;
           cd = QtqIconvOpen(tocode : fromcode);
             // check cd.rtn

           rtn = iconv( cd
                      : inbufptr
                      : inlen
                      : outbufptr
                      : outlen );
           dsply 'EBCDIC string' '' str;

           rtn = iconv_close(cd);
           *inlr = *on;
      /end-free
