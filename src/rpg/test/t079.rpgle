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
      * @file t079.rpgle
      *
      * Retrieve run priority of the current MI process.
      *
      * Call this program directly or first change the RUNPTY attribute of
      * the current MI project like the following:
      * @code
      * CHGJOB RUNPTY(55)
      * @endcode
      */
     h dftactgrp(*no)

      /copy mih52
     d tmpl            ds                  likeds(
     d                                       process_priority_t)
     d opt             s              1a
     d                 ds
     d      priority                  5u 0
     d      low_pri                   1a   overlay(priority:2)

      /free
           opt = x'0E';
           tmpl.bytes_in = %size(process_priority_t);

           matpratr1(tmpl : opt);
           priority = 0;
           low_pri = tmpl.priority;
           priority -= 156;

           dsply 'Process priority' '' priority;
           *inlr = *on;
      /end-free
