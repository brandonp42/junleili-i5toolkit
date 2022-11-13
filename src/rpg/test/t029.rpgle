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
      * @file t029.rpgle
      *
      * test of matptr()
      *
      * call program T030.
      */

     h dftactgrp(*no)
     h bnddir('QC2LE')

     d t030            pr                  extpgm('T030')
     d     ppp                         *   procptr

     d increase        pr
     d     num                       10i 0

     d ptr             s               *   procptr

      /free

           ptr = %paddr(increase);
           t030(ptr);

           // call T030 with procptr addressing a
           // libc procedure
           ptr = %paddr('printf');
           t030(ptr);

           *inlr = *on;
      /end-free

     p increase        b
     d increase        pi
     d     num                       10i 0

     c                   eval      num = num + 1
     c                   return

     p increase        e
