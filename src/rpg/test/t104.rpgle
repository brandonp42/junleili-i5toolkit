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
      * @file t104.rpgle
      *
      * Test of FNDRINVN.
      */

     h dftactgrp(*no)

      /copy mih52
     d rel_inv_num     s             10i 0
     d range           ds                  likeds(fndrinvn_search_range_t)
     d arg             ds                  likeds(fndrinvn_criterion_t)

      /free

           arg = *allx'00';
           arg.search_type = 2; // search type: by invocation type
           arg.option      = x'80';
             // skip current invocation
             // search for match
           arg.search_arg = x'01'; // invocation type = call external

           fndrinvn1( rel_inv_num
                    : arg );
           dsply 'most recent CALLX:' '' rel_inv_num;
             // rel_inv_num = -2

           // _FNDRINVN2
           range = *allx'00';
           range.start_inv_offset = -1; // start search from my caller
           range.inv_range = -1024; // search backword

           arg.search_type = 2; // search type: by invocation type
           arg.option      = x'80';
             // skip current invocation
             // search for match
           arg.search_arg = x'01'; // invocation type = call external

           fndrinvn2( rel_inv_num
                    : range
                    : arg );
           dsply 'most recent CALLX:' '' rel_inv_num;
             // rel_inv_num = -1

           *inlr = *on;
      /end-free
