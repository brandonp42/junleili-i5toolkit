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
      * @file t090.rpgle
      *
      * Test of _LOCKSL1 and _UNLOCKSL1.
      *
      * @remark T090 locks at the same location in the space pointer
      *         to the SEPT object, QINSEPT. Try to call T090 from two
      *         different jobs to see the result.
      */

     h dftactgrp(*no)

      /copy mih52

     d ptr             s               *
      * LENR lock
     d request         s              1a   inz(x'08')
     d an              s              1a   inz('y')

      /free
           ptr = sysept();
           locksl1(ptr : request);

           dsply 'release lock?' '' an;

           unlocksl1(ptr : request);
           *inlr = *on;
      /end-free
