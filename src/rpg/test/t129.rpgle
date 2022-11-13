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
      * @file t129.rpgle
      *
      * Test of _MATCTX2.
      * List objects in QTEMP
      */

     h dftactgrp(*no)

      /copy mih52
     d qtemp           s               *
     d tmpl            ds                  likeds(matctx_receiver_t)
     d                                     based(ptr)
     d ptr             s               *
     d obj             ds                  likeds(context_entry_full_t)
     d                                     based(pos)
     d pos             s               *
     d syp             s               *   based(pos) dim(90)
     d opt             ds                  likeds(matctx_option_t)
     d len             s             10u 0
     d num             s             10u 0
     d i               s             10u 0

      /free
           qtemp = qtempptr();

           ptr = modasa(%size(matctx_receiver_t));
           opt = *allx'00';
           opt.sel_flag = x'02'; // materialize system pointers only
           tmpl.bytes_in = %size(matctx_receiver_t);

           matctx2(tmpl : qtemp : opt);
           len = tmpl.bytes_out;
           ptr = modasa(len);
           tmpl.bytes_in = len;
           matctx2(tmpl : qtemp : opt);

           pos = ptr + %size(matctx_receiver_t);
           // check array SYP

           // materialize both system pointers and symbolic object IDs
           opt.sel_flag = x'03';
           len = %size(matctx_receiver_t);
           tmpl.bytes_in = len;
           matctx2(tmpl : qtemp : opt);
           len = tmpl.bytes_out;
           ptr = modasa(len);
           tmpl.bytes_in = len;
           matctx2(tmpl : qtemp : opt);

           num = (tmpl.bytes_out - %size(matctx_receiver_t))
                 / %size(context_entry_full_t);
           pos = ptr + %size(matctx_receiver_t);
           for i = 1 to num;
               dsply i '' obj.objid.name;

               pos += %size(context_entry_full_t);
           endfor;

           *inlr = *on;
      /end-free
