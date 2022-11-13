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
      * @file t053.rpgle
      *
      * test of index management instructions
      */

      /if defined(*crtbndrpg)
     h  dftactgrp(*no)
      /endif
     h bnddir('QC2LE')

      /copy mih-comp
      /copy mih-ptr
      /copy mih-mutex

     d cvthc           pr                  extproc('cvthc')
     d     receiver                    *   value
     d     source                      *   value
     d     length                    10i 0 value

     d mtx             ds                  likeds(mutex_t)
     d crtopt          ds                  likeds(crtmtx_option_t)
     d desopt          s             10i 0 inz(0)
     d buf             s             32a
     d rtn             s             10i 0
     d synptr_attr     ds                  likeds(
     d                                       matptr_synptr_info_t)

      /free
           mtx.name = 'Hello mutex';
           propb (%addr(crtopt) : x'00' : %size(crtopt));
           crtopt.name_opt       = x'01';
           crtopt.keep_valid_opt = x'00';
           crtopt.recursive_opt  = x'01';
           rtn = crtmtx(mtx : %addr(crtopt)); // (1)

           if rtn <> 0;
               // crtmtx failed
           endif;

           // materialize attrubtes of mtx (2)
           synptr_attr.bytes_in = min_synptr_info_len;
           matptr(synptr_attr : mtx.syn_ptr);
             // SYNPTR_ATTR.SYN_OBJ_TYPE = hex 0001 (mutex)

           // lock mutex (3)
           rtn = lockmtx(mtx : *null);
             // now use DSPJOB OPTION(*MUTEX) to check job mutexes

           // unlock mutex
           rtn = unlkmtx(mtx);

           // destroy mutex
           desopt = 0;
           rtn = desmtx(mtx : %addr(desopt));

           *inlr = *on;
      /end-free
