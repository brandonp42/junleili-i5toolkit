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
      * @file t003.rpgle
      *
      * test of andstr(), orstr(), xorstr()
      */

     h dftactgrp(*no)
      /copy mih52

     d str1            s              1a
     d str2            s              1a
     d result          s              1a

      /free

          str1 = x'96';   // 10010110
          str2 = x'CA';   // 11001010
          andstr(result : str1 : str2 : 1);
          dsply 'andstr:' '' result; // x'82'

          str1 = x'61';   // 01100001
          str2 = x'88';   // 10001000
          orstr(result : str1 : str2 : 1);
          dsply 'orstr:' '' result; // x'E9', 11101001

          str1 = x'65';   // 01100101
          str2 = x'82';   // 10000010
          xorstr(result : str1 : str2 : 1);
          dsply 'xorstr:' '' result; // x'E7', 11100111

          *inlr = *on;
      /end-free
