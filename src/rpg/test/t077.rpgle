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
      * @file t077.rpgle
      *
      * Function key handling exit-program of T075.
      */

      /copy apiec
      /copy uim
     d i_main          pr                  extpgm('T077')
     d     uim_parm                        likeds(qui_fkc_t)

     d rcd_title       ds                  qualified
     d     panel_title...
     d                               50a
     d rcd_name        s             10a
     d ec              ds                  likeds(qusec_t)
     d                                     based(ecptr)
     d ecptr           s               *
     d eclen           c                   64
     d buflen          s             10i 0

     d i_main          pi
     d     uim_parm                        likeds(qui_fkc_t)

      /free
           if uim_parm.basic.call_type <> 1; // processes a function key
               *inlr = *on;
               return;
           endif;

           ecptr = %alloc(eclen);
           ec.bytes_in = eclen;

           select;
           when uim_parm.func_key = 5; // F5
               rcd_title.panel_title = 'Hello UIM ' +
                                       %char(%timestamp());
               rcd_name = 'RCDTTL';
               buflen = %size(rcd_title);
               quiputv( uim_parm.basic.apph
                      : rcd_title
                      : buflen
                      : rcd_name
                      : ec);
           other;
           endsl;

           dealloc ecptr;
           *inlr = *on;
      /end-free
