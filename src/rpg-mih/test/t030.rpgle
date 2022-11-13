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
      * @file t030.rpgle
      *
      * Materialize a PROCPTR
      */

      /copy mih52

     d i_main          pr                  extpgm('T030')
     d     pptr                        *

     d info_ptr        s               *
     d info            ds                  likeds(matptr_procptr_info_t)
     d                                     based(info_ptr)

     d sysptr_info_ptr...
     d                 s               *
     d sysptr_info     ds                  likeds(matptr_sysptr_info_t)
     d                                     based(sysptr_info_ptr)

     d i_main          pi
     d     pptr                        *

      /free

           // allocate storage for MATPTR template
           info_ptr = modasa(matptr_procptr_info_length);
           info.bytes_in = matptr_procptr_info_length;

           // materialize input PROCPTR
           matptr(info_ptr : pptr);

           // check returned PROCPTR attributes
           dsply 'module number' '' info.mod_num;
           dsply 'procedure number' '' info.proc_num;

           sysptr_info_ptr = modasa(matptr_sysptr_info_length);
           sysptr_info.bytes_in = matptr_sysptr_info_length;

           // retrieve containing program's name and library
           matptr(sysptr_info_ptr : info.pgm);
           dsply 'program name' '' sysptr_info.obj_name;
           dsply 'library name' '' sysptr_info.ctx_name;

           // AG mark:       info.ag_mark
           // ... ...

           *inlr = *on;
      /end-free
