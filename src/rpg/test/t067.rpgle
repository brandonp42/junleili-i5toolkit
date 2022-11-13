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
      * @file t067.rpgle
      *
      * test of MATMTX. Called by SPR14 (see spr14.emi).
      */
     h dftactgrp(*no)
      /copy mih52

     /* user code */
     d i_main          pr                  extpgm('T067')
     d     mtx                             likeds(mutex_t)

     d i_main          pi
     d     mtx                             likeds(mutex_t)

     d mtx_attr        ds                  likeds(matmtx_ext1_tmpl_t)
     d                                     based(tmpl_ptr)
     d tmpl_ptr        s               *
     d tmpl_len        c                   4096
     d matmtx_opt      s             10u 0

      /free
           tmpl_ptr = %alloc(tmpl_len);
           propb(tmpl_ptr : x'00' : tmpl_len);
           mtx_attr.basic_attr.bytes_in = tmpl_len;
           matmtx_opt = x'00000006';
           matmtx(tmpl_ptr : mtx : %addr(matmtx_opt));
             // check returned mutex attributes in ds mtx_attr

           dealloc tmpl_ptr;
           *inlr = *on;
      /end-free
