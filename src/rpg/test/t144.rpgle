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
      * @file t144.rpgle
      *
      * Test of _MATPG. Materialize program attributes.
      *
      * @param[in] pgm-name, CHAR(10)
      */
     h dftactgrp(*no)

      /copy mih52

     d i_t144          pr                  extpgm('T144')
     d    pgm_name                   10a

     d yes_or_no       pr             8a
     d    flag                        2a
     d    off                         5i 0 value
     d    zero_is_y                   5i 0 value

     d rcv             ds                  likeds(matpg_tmpl_t)
     d                                     based(bufptr)
     d bufptr          s               *
     d len             s             10i 0
     d pgmptr          s               *
     d inst_ptr        s               *
     d inst_comp       ds                  qualified
     d                                     based(inst_ptr)
     d     num                       10i 0
     d     arr                        5u 0 dim(2000)
     d msg             s             32a
     d an              s             10a
     d yes             c                   '*YES'
     d no              c                   '*NO'

     d i_t144          pi
     d     pgm_name                  10a

      /free

           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = pgm_name;
           rslvsp2(pgmptr : rslvsp_tmpl);

           len = 8;
           bufptr = modasa(len);
           rcv.bytes_in = len;
           matpg(rcv : pgmptr);

           len = rcv.bytes_out;
           bufptr = modasa(len);
           rcv.bytes_in = len;
           matpg(rcv : pgmptr);

           // program attributes (pgm_attr)
           msg = 'Adopt user profile';
           an = yes_or_no(rcv.pgm_attr:0:0);
           dsply msg '' an;

           msg = 'Arrays are constrained';
           an = yes_or_no(rcv.pgm_attr:1:1);
           dsply msg '' an;

           msg = 'String constraint';
           an = yes_or_no(rcv.pgm_attr:2:1);
           dsply msg '' an;

           msg = 'Propagate adoped auth';
           an = yes_or_no(rcv.pgm_attr:4:0);
           dsply msg '' an;

           msg = 'Initialize SSF';
           an = yes_or_no(rcv.pgm_attr:5:1);
           dsply msg '' an;

           msg = 'Initialize ASF';
           an = yes_or_no(rcv.pgm_attr:6:1);
           dsply msg '' an;

           msg = 'Associated journal entry';
           an = yes_or_no(rcv.pgm_attr:7:1);
           dsply msg '' an;

           msg = 'Suppress *DEC data exception';
           an = yes_or_no(rcv.pgm_attr:9:0);
           dsply msg '' an;

           msg = 'Template extension exists';
           an = yes_or_no(rcv.pgm_attr:10:0);
           dsply msg '' an;

           msg = 'Suppress previously adopted USRPRF';
           an = yes_or_no(rcv.pgm_attr:11:0);
           dsply msg '' an;

           msg = 'Template version';
           an = 'Version 0';
           if tstbts(%addr(rcv.pgm_attr) : 15) > 0;
               an = 'Version 1';
           endif;
           dsply msg '' an;

           // instruction stream component
           inst_ptr = bufptr + rcv.inst_stream_offset;

           *inlr = *on;
      /end-free

     p yes_or_no       b
     d yes_or_no       pi             8a
     d    flag                        2a
     d    off                         5i 0 value
     d    zero_is_y                   5i 0 value

     d bit_on          s               n

      /free
           bit_on = *off;
           if tstbts(%addr(flag) : off) > 0;
               bit_on = *on;
           endif;

           if zero_is_y = 1;
               bit_on = not bit_on;
           endif;

           if bit_on;
               return '*YES';
           else;
               return '*NO';
           endif;

      /end-free
     p yes_or_no       e

