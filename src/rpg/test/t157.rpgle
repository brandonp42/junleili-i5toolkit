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
      * @file t157.rpgle
      *
      * Test of _NPMPARMLISTADDR.
      * Retrieve operational descriptors during a procedure call.
      */

     h dftactgrp(*no)
      /copy mih-pgmexec
      /copy mih-comp

      * a procedure that accepts parameters by references
      * with operational descriptors
     d byref           pr            10i 0 extproc('BYREF')
     d                                     opdesc
     d     str                      500a   options(*varsize)
     d     st1                      500a   options(*varsize)
     d     st2                      500a   options(*varsize)
     d     st3                      500a   options(*varsize)
     d     pkd                        5p 2

     d desclist_ptr    s               *
     d plist_ptr       s               *
     d plist           ds                  likeds(npm_plist_t)
     d                                     based(plist_ptr)

     d p1              s              5a   inz('ABc')
     d p2              s             15a   inz('ABc')
     d p3              s             25a   inz('ABc')
     d p4              s             35a   inz('ABc')
     d pk              s              5p 2 inz(97.5)

      /free
           // use CALLP to call procedure byref()
           byref(p1 : p2 : p3 : p4 : pk);
      /end-free
      * use CALLB(D)
     c                   callb(D)  'BYREF'
     c                   parm                    p1
     c                   parm                    p2
     c                   parm                    p3
     c                   parm                    p4
     c                   parm                    pk

      /free
           *inlr = *on;
      /end-free

     p byref           b                   export
     d byref           pi            10i 0 opdesc
     d     str                      500a   options(*varsize)
     d     st1                      500a   options(*varsize)
     d     st2                      500a   options(*varsize)
     d     st3                      500a   options(*varsize)
     d     pkd                        5p 2

     d desclist        ds                  likeds(parm_desc_list_t)
     d                                     based(desclist_ptr)
     d desclist_ptr    s               *
     d desc            ds                  qualified
     d                                     based(desclist_ptr)
     d     pnum                      10u 0
     d                               28a
     d     whoptr                      *
     d ohw             s           1024a

     d CEEDOD          pr
     d   pos                         10i 0 const
     d   desctype                    10i 0
     d   datatype                    10i 0
     d   descinf1                    10i 0
     d   descinf2                    10i 0
     d   datalen                     10i 0
     d   fc                          12a   options(*omit)

     d desctype        s             10i 0
     d datatype        s             10i 0
     d descinf1        s             10i 0
     d descinf2        s             10i 0
     d datalen         s             10i 0

      /free

           plist_ptr = npm_plist();

           desclist_ptr = plist.parm_desc_list ;
           // dsply 'num parms' '' desclist.argc ;
           cpybytes(%addr(ohw) : desc.whoptr : 8*4 );
             // the beginning 32 bytes of ohw is:
             //   02020000 00000005 02020000 0000000F
             //   02020000 00000019 02020000 00000023
             // which are 4 entries corresponding to this procedures's
             // 4 variable-length character parameters.

           // using CEE API CEEDOD, we can get the same result
           // showed above.
           CEEDOD( 1
                 : desctype
                 : datatype
                 : descinf1
                 : descinf2
                 : datalen
                 : *omit );

           CEEDOD( 4
                 : desctype
                 : datatype
                 : descinf1
                 : descinf2
                 : datalen
                 : *omit );

           return 99;
      /end-free
     p byref           e
