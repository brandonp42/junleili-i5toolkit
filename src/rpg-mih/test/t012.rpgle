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
      * @file t012.rpgle
      *
      * test of npm_plist()
      */

      /copy mih52

     d plist_ptr       s               *
     d desclist_ptr    s               *

     d plist           ds                  likeds(npm_plist_t)
     d                                     based(plist_ptr)

     d vv              pr            10i 0
     d     str                        5a
     d     pkd                        5p 2

     d i_main          pr                  extpgm('T012')
     d     p1                         5a
     d     p2                         5p 2

     d i_main          pi
     d     p1                         5a
     d     p2                         5p 2

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

           vv(p1 : p2);
           *inlr = *on;
      /end-free

     p vv              b
     d vv              pi            10i 0
     d     str                        5a
     d     pkd                        5p 2

     d desclist        ds                  likeds(parm_desc_list_t)
     d                                     based(desclist_ptr)
     d desclist_ptr    s               *

      /free

           plist_ptr = npm_plist();

           dsply 'sub-proc' ''  ;
	
           desclist_ptr = plist.parm_desc_list ;
           dsply 'num parms' '' desclist.argc ;

           buf_ptr = plist.argvs(1);
           dsply 'p1' '' strval;

           buf_ptr = plist.argvs(2);
           dsply 'p2' '' pkdval;

           return 99;
      /end-free
     p vv              e
