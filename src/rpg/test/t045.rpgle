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
      * @file t045.rpgle
      *
      * test of WAITTIME
      */

     h dftactgrp(*no)

      /copy mih52

     d tmpl            ds                  likeds(wait_tmpl_t)

      /free

           propb (%addr(tmpl) : x'00' : 16);
           tmpl.interval = sysclock_one_second * 10;
           tmpl.option   = x'1000';

           waittime(tmpl);

           *inlr = *on;
      /end-free
