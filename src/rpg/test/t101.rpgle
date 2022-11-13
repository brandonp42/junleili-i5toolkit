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
      * @file t101.rpgle
      *
      * Test of _MATINVS2.
      * Meterialize the call stack of the current thread.
      */
     h dftactgrp(*no)

      /copy mih52
     d dsp_proc_name   pr
     d     susptr                      *
     d len             s             10i 0
     d ptr             s               *
     d pos             s               *
     d tmpl            ds                  likeds(matinvs_tmpl_t)
     d                                     based(ptr)
     d inve            ds                  likeds(invocation_entry_t)
     d                                     based(pos)
     d i               s             10i 0

      /free
           ptr = %alloc(min_matinvs_tmpl_length);
           tmpl.bytes_in = min_matinvs_tmpl_length;
           matinvs2(tmpl);

           len = tmpl.bytes_out;
           ptr = %realloc(ptr : len);
           tmpl.bytes_in = len;
           matinvs2(tmpl);

           // check each call stack entry
           pos = ptr + min_matinvs_tmpl_length;
           for i = 1 to tmpl.entries;
               dsply 'invocation entry: ' '' inve.inv_num;
               dsp_proc_name(inve.suspend_ptr);

               pos += invocation_entry_length;
           endfor;

           dealloc ptr;
           *inlr = *on;
      /end-free

     p dsp_proc_name   b

     d dsp_proc_name   pi
     d     susptr                      *

     d ptrd            ds                  likeds(matptrif_susptr_tmpl_t)
     d mask            s              4a
     d proc_name       s             30a

      /free

           // init pointer description
           ptrd = *allx'00';
           ptrd.bytes_in = %size(ptrd);
           ptrd.proc_name_length_in = 30;
           ptrd.proc_name_ptr = %addr(proc_name);

           // materialize pointer desc
           mask = x'12200000';
             // bit 3 = 1; program name
             // bit 6 = 1; module name
             // bit 10 = 1; procedure name
           matptrif( ptrd : susptr : mask );

           // output pgm name, module name, and procedure name
           dsply '    Program name' '' ptrd.pgm_name;
           dsply '    Module name' '' ptrd.mod_name;

           if ptrd.proc_name_length_out > ptrd.proc_name_length_in;
               %subst(proc_name : 29 : 2) = ' <';
           endif;
           dsply '    Prodecure name' '' proc_name;

      /end-free
     p dsp_proc_name   e

