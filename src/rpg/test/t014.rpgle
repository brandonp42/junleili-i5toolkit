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
      * @file t014.rpgle
      *
      * test of strncpynull(), strncpynullpad()
      */

     h dftactgrp(*no)
     h bnddir('QC2LE')

      /copy mih52

     d cvthc           pr                  extproc('cvthc')
     d     receiver                    *   value
     d     source                      *   value
     d     length                    10i 0 value

     d tgt             s              8a
     d src             s              8a
     d result          s             16a

      /free

           src = 'ABC' + x'00';
           strncpynull(tgt : src : 8);
           cvthc(%addr(result) : %addr(tgt) : 16);
           dsply 'strncpynull' '' result;

           tgt = *BLANK;
           strncpynullpad(tgt : src : 8);
           cvthc(%addr(result) : %addr(tgt) : 16);
           dsply 'strncpynullpad' '' result;

           *inlr = *on;
      /end-free
