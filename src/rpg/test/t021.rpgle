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
      * @file t021.rpgle
      *
      * test of testrpl()
      */

     h dftactgrp(*no)
      /copy mih52

     d org             c                   'tom cruise'
     d str             s             16a
     d cmp             s              2a   inz('tc')
     d rpl             s              2a   inz('TC')

      /free

           str = org;
           // replace all 't' in str to 'T', all 'c' to 'C'
           //   by using MI instruction
           //   Test and Replace Characters (TSTRPLC).
           testrpl(%addr(str)
                   : 16
                   : %addr(cmp)
                   : %addr(rpl)
                   : 2 );
           dsply org '' str;
             // str='Tom Cruise'

           *inlr = *on;
      /end-free
