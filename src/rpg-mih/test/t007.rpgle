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
      * @file t007.rpgle
      *
      * test of strcmpnull
      */

      /copy mih52
     d str1            s             32a
     d str2            s             32a
     d flag            s             10i 0
     d msg             s             16a

      /free

          str1 = 'Tom and Jerry' + x'00'; // the bigger string
          str2 = 'Tom and jerry' + x'00';
          flag = strcmpnull(str1 : str2);

          select;
          when flag = -1;
              msg = 'str2 is greater';
          when flag = 0;
              msg = 'equal';
          when flag = 1;
              msg = 'str1 is greater';
          other;
              msg = 'impossible!';
          endsl;

          dsply 'result' '' msg;

          *inlr = *on;
      /end-free
