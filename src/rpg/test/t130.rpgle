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
      * @file t130.rpgle
      *
      * Test of MATCTX.
      *
      * Materialize extended attributes of a context object.
      */

     h dftactgrp(*no)

      /copy mih52
     d ctxd            ds                  likeds(matctx_receiver_ext_t)
     d                                     based(ptr)
     d ptr             s               *
     d                 ds
     d qgpl                            *
     d funny_ptr                       *   overlay(qgpl)
     d                                     procptr
     d opt             ds                  likeds(matctx_option_t)
     d obj             ds                  likeds(context_entry_full_t)
     d                                     dim(4096)
     d                                     based(pos)
     d pos             s               *
     d len             s             10u 0

      /free
           // resolve SYP to context QGPL
           rslvsp_tmpl.obj_type = x'0401';
           rslvsp_tmpl.obj_name = 'QGPL';
           rslvsp2(qgpl : rslvsp_tmpl);

           ptr = modasa(8);

           // materialize context attributes
           opt = *allx'00';
           opt.sel_flag = x'0B';  // materialize extended attrs
           ctxd.base.bytes_in = 8;
           QusMaterializeContext( ctxd
                                : funny_ptr
                                : opt );

           len = ctxd.base.bytes_out;
           ptr = modasa(len);
           ctxd.base.bytes_in = len;
           QusMaterializeContext( ctxd
                                : funny_ptr
                                : opt );

           pos = ptr + %size(ctxd);
             // check obj

           *inlr = *on;
      /end-free
