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
      * @file t075.rpgle
      *
      * Display a simple menu panel, t075.uim.
      */
     h dftactgrp(*no) dftname(T075)

     /* include ILE RPG header for UIM APIs, uim.rpgleinc [1] */
      /include uim

     d i_main          pr                  extpgm('T075')
     d     uim_parm                        likeds(qui_common_t)

     d apph            s              8a
     d pnlgrp          s             20a   inz('T075      *LIBL')
     d scope           s             10i 0 inz(-1)
     d exitpgm_int     s             10i 0 inz(0)
     d full_screen_help...
     d                 s              1a   inz('Y')
     d ec              ds                  likeds(qusec_t)
     d                                     based(ecptr)
     d ecptr           s               *
     d eclen           c                   64
     d rtn             s             10i 0
     d panel           s             10a   inz('MAINPANEL')
     d redisp_opt      s              1a   inz('N')
     d close_opt       s              1a   inz('M')
     d rcd_name        s             10a   inz('RCDTTL')
     d rcd_title       ds                  qualified
     d     panel_title...
     d                               50a
     d rcd_extpgm      ds                  qualified
     d     pgm                       20a
     d     pgm_name                  10a   overlay(pgm:1)
      * buffer length
     d buflen          s             10i 0
      * who am i?
     d who_am_i        pr            20a

     d i_main          pi
     d     uim_parm                        likeds(qui_common_t)
     d     uvv         ds                  likeds(qui_common_t)

      /free
           ecptr = %alloc(eclen);
           ec.bytes_in = eclen;

           // open UIM display application [2]
           quiopnda( apph : pnlgrp : scope : exitpgm_int
                   : full_screen_help : ec);

           if ec.bytes_out <> 0;
               // error handling
           endif;

           // set panel title [3]
           rcd_title.panel_title = 'Hello UIM :p';
           buflen = %size(rcd_title);
           quiputv( apph : rcd_title : buflen : rcd_name : ec);

           // set T077 as the exit pgm of function key F5 [4]
           rcd_extpgm.pgm = who_am_i();
           rcd_extpgm.pgm_name = 'T077';
           buflen = %size(rcd_extpgm);
           rcd_name = 'RCDPGM';
           quiputv( apph : rcd_extpgm : buflen : rcd_name : ec);

           // display main panel [5]
           quidspp( apph : rtn : panel : redisp_opt : ec);

           // close UIM display application [6]
           quicloa( apph : close_opt : ec);

           dealloc ecptr;
           *inlr = *on;
      /end-free

     /*
      * Subprocedure who_am_i() is designed to return the program name
      * and library name of the program currently being
      * invocated. [7]
      */
     p who_am_i        b
      /copy mih52

     d me              ds                  likeds(matpgmnm_tmpl_t)
     d pgm             ds            20    qualified
     d   obj                         10a
     d   lib                         10a

     d                 pi            20a

      /free
           propb(%addr(me) : x'00' : matpgmnm_tmpl_len);
           me.bytes_in = matpgmnm_tmpl_len;
           me.format   = 0;
           matpgmnm(me);

           pgm.obj = me.bpgm_name;
           pgm.lib = me.ctx_name;

           return pgm;
      /end-free
     p who_am_i        e
