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
      * @file t046.rpgle
      *
      * test of MATPGMNM
      */

      /if defined(*crtbndrpg)
     h dftactgrp(*no)
      /endif

      /copy mih52

     d me              ds                  likeds(matpgmnm_tmpl_t)

      /free
           propb(%addr(me) : x'00' : matpgmnm_tmpl_len);
           me.bytes_in = matpgmnm_tmpl_len;
           me.format   = 0;
           matpgmnm(me);

           dsply 'BPGM name' '' me.bpgm_name;

           *inlr = *on;
      /end-free
