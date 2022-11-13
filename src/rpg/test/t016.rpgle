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
      * @file t016.rpgle
      *
      * test of findbyte(), memchr(), strchrnull()
      */

     h dftactgrp(*no)
      /copy mih52

     d str             s             16a   inz(*blank)
     d haha            s            256a   inz(*all'haha')
     d pos             s               *
     d offset          s             10u 0
      * debug
     d cmp             s             10i 0

      /free

           // findbyte()
           pos = findbyte(%addr(str) : x'00') ;
           offset = pos - %addr(str)   ;
           dsply 'offset' '' offset    ;

           // memchr()
           str = 'ABC' + x'00'              ;
           pos = memchr(%addr(str) : x'00' : 16) ;
           // is pos a null pointer?
           cmp = cmpptrt(x'00' : pos)            ;
           if cmp = 1                ;
               dsply 'not found' ''  ;
           else                      ;
               offset = pos - %addr(str) ;
               dsply 'offset' '' offset  ;
           endif                         ;

           // strchrnull()
           str = 'ABC' + x'00'              ;
           pos = strchrnull(%addr(str) : x'C2') ; // find 'B'
           // is pos a null pointer?
           cmp = cmpptrt(x'00' : pos)            ;
           if cmp = 1                ;
               dsply 'not found' ''  ;
           else                      ;
               offset = pos - %addr(str) ;
               dsply 'offset' '' offset  ;
           endif                         ;

           *inlr = *on;
      /end-free
