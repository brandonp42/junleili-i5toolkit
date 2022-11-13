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
      * @file t056.rpgle
      *
      * test of TESTTOBJ. Output of program T056:
      * @code
      * DSPLY  QWCBT01 (19D0)    permanent object
      * *N                                       
      * DSPLY  QDMCQ (19EF)      temporary object
      * *N                                       
      * DSPLY  QTEMP (04C1)      permanent object
      * *N                                       
      * DSPLY  QMIRQ (0AEF)      temporary object
      * *N                                       
      * DSPLY  QINTER (1909)     permanent object
      * @endcode
      */

      /if defined(*crtbndrpg)
     h  dftactgrp(*no)
      /endif

      /copy mih52

     d pco_ptr         s               *
     d pco             ds                  qualified
     d                                     based(pco_ptr)
     d     ept_ptr                     *
     d     qwcbt01                     *
     d     qdmcq                       *
     d                                 *
     d     qtemp                       *
     d                                 *   dim(3)
     d     qmirq                       *
     d                                 *   dim(24)
     d     qinter                      *

     d ind             s             10i 0
     d msg             s             20a   dim(2)

      /free
           msg(1) = 'permanent object';
           msg(2) = 'temporary object';

           pco_ptr = pcoptr2();

           ind = testtobj(pco.qwcbt01) + 1;
           dsply 'QWCBT01 (19D0)' '' msg(ind);

           ind = testtobj(pco.qdmcq) + 1;
           dsply 'QDMCQ (19EF)  ' '' msg(ind);

           ind = testtobj(pco.qtemp) + 1;
           dsply 'QTEMP (04C1)  ' '' msg(ind);

           ind = testtobj(pco.qmirq) + 1;
           dsply 'QMIRQ (0AEF)  ' '' msg(ind);

           ind = testtobj(pco.qinter) + 1;
           dsply 'QINTER (1909) ' '' msg(ind);

           *inlr = *on;
      /end-free
