     /**
      * This file is part of i5/OS Programmer's Toolkit.
      *
      * Copyright (C) 2009  Junlei Li.
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
      * @file t022.rpgle
      *
      * test of testsubset()
      */

      /copy mih52

     d str1            s              5a   inz('jenny')
     d str2            s              5a   inz('JENNY')
     d str3            s              3a   inz(x'818283')
     d str4            s              3a   inz(x'939293')
     d rtn             s             10u 0

      /free

           rtn = testsubset(%addr(str1) : %addr(str2) : 5); // rtn = 1
           rtn = testsubset(%addr(str3) : %addr(str4) : 3); // rtn = 1

           *inlr = *on;
      /end-free
