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
      * @file t013.rpgle
      *
      * test of cpybytes(), cpybo(), strcpynull()
      */

      /copy mih52

     d str1            s             16a
     d str2            s             12a   inz('morning')
     d str_ptr         s               *

     d some_ds_t       ds                  qualified
     d     aval                       8a
     d     pval                       5p 2

     d ds1             ds                  likeds(some_ds_t)
     d ds2             ds                  likeds(some_ds_t)

      /free

           // copy character scalars
           cpybytes(%addr(str1) : %addr(str2) : 8);
           dsply 'cpybytes' '' str1;

           str_ptr = %addr(str1) + 3 ;
           cpybo(str_ptr : %addr(str2) : 8);
           dsply 'cpybo' '' str1;

           // copy data structures
           ds2.aval = '*^_^*';
           ds2.pval = -32.1;
           cpybytes( %addr(ds1) : %addr(ds2)
                    : %size(some_ds_t) );
           dsply ds1.aval '' ds1.pval;

           // strcpynull()
           str2 = 'strcpynull' + x'00' ;
           strcpynull(str1 : str2)     ;
           dsply 'strcpynull' '' str1  ;

           *inlr = *on;
      /end-free
