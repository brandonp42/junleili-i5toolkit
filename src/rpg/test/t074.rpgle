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
      * @file t074.rpgle
      *
      * test apiec.rpgleinc
      */

      /copy apiec
     d qusdltus        pr                  extpgm('QUSDLTUS')
     d     obj                       20a
     d     ec                              likeds(qusec_t)

     d qusdltus2       pr                  extpgm('QUSDLTUS')
     d     obj                       20a
     d     ec                              likeds(qusec200_t)

     d obj             s             20a   inz('SPCXXX    QTEMP')
     d ec              ds                  likeds(qusec_t)
     d                                     based(ecptr)
     d ec2             ds                  likeds(qusec200_t)
     d                                     based(ecptr)
     d ecptr           s               *

      /free
           ecptr = %alloc(256);
           ec.bytes_in = 256;

           // try to delete a space object thtat doesn't exist
           qusdltus(obj : ec); // check ec

           ec2.key = -1;
           ec2.bytes_in = 256;
           qusdltus2(obj : ec2); // check ec2

           dealloc ecptr;
           *inlr = *on;
      /end-free
