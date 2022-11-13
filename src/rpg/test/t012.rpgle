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
      * @file t012.rpgle
      *
      * test of npm_plist()
      */

     h dftactgrp(*no)
      /copy mih-pgmexec

      * a procedure that accepts parameters by references
     d byref           pr            10i 0
     d     str                        5a
     d     pkd                        5p 2

      * a procedure that accepts parameters by values
     d byval           pr
     d     str                        5a   value
     d     znd                        3s 0 value
     d     pkd                        5p 2 value

     d i_main          pr                  extpgm('T012')
     d     p1                         5a
     d     p2                         5p 2

     d i_main          pi
     d     p1                         5a
     d     p2                         5p 2

     d desclist_ptr    s               *
     d plist_ptr       s               *
     d plist           ds                  likeds(npm_plist_t)
     d                                     based(plist_ptr)
     d buf_ptr         s               *
     d buf             ds           256    based(buf_ptr)
     d     strval                     5a
     d     pkdval                     5p 2 overlay(strval)

     d dl              ds                  likeds(parm_desc_list_t)
     d                                     based(mptr)           
     d mptr            s               *

      /free

           plist_ptr = npm_plist();

           dsply 'main proc' '' ;

           mptr = plist.parm_desc_list ;
           dsply 'num parms' '' dl.argc ;

           // pass parameters by references
           byref(p1 : p2);

           // pass parameters by values
           byval(p1 : 65 : p2);

           *inlr = *on;
      /end-free

     p byref           b
     d byref           pi            10i 0
     d     str                        5a
     d     pkd                        5p 2

     d desclist        ds                  likeds(parm_desc_list_t)
     d                                     based(desclist_ptr)
     d desclist_ptr    s               *
     d ref_ptr_ptr     s               *
     d ref_ptr_arr     s               *   dim(2)
     d                                     based(ref_ptr_ptr)

      /free

           plist_ptr = npm_plist();

           desclist_ptr = plist.parm_desc_list ;
           dsply 'num parms' '' desclist.argc ;

           ref_ptr_ptr = %addr(plist.argvs);
           buf_ptr = ref_ptr_arr(1);
           dsply 'p1' '' strval;

           buf_ptr = ref_ptr_arr(2);
           dsply 'p2' '' pkdval;

           return 99;
      /end-free
     p byref           e

     p byval           b

      * a procedure that accepts parameters by values
     d byval           pi
     d     str                        5a   value
     d     znd                        3s 0 value
     d     pkd                        5p 2 value

     d parm_ptr        s               *
     d desclist        ds                  likeds(parm_desc_list_t)
     d                                     based(desclist_ptr)
     d desclist_ptr    s               *

      *
      * parameters passed to procedure byval().
      * @remark Note that each parameter is aligned on its natural boundary.
      *
     d my_parms        ds                  qualified
     d                                     based(parm_ptr)
      * char(5) is aligned to 8-byte boundary
     d     str                        5a
     d                                3a
      * znd(3,0) is aligned to 4-byte boundary
     d     znd                        3s 0
     d                                1a
      * pkd(5,2) is aligned to 4-byte boundary
     d     pkd                        5p 2

      /free
           plist_ptr = npm_plist();
           parm_ptr = %addr(plist.argvs);

           desclist_ptr = plist.parm_desc_list ;
           dsply 'num parms' '' desclist.argc ;

           dsply 'str' '' my_parms.str;
           dsply 'znd' '' my_parms.znd;
           dsply 'pkd' '' my_parms.pkd;
      /end-free
     p byval           e
