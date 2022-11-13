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
      * @file t096.rpgle
      *
      * Test of _MATSELLK.
      */

     h dftactgrp(*no)

      /copy mih52
     d tmpl            ds                  likeds(matsellk_tmpl_t)
     d                                     based(tmpl_ptr)
     d tmpl_ptr        s               *
     d pos             s               *
     d lockd           ds                  likeds(matsellk_lock_desc_t)
     d                                     based(pos)
     d ind             s              5i 0
     d lockd_offset    s              5i 0
     d TMPL_LEN        c                   4096
     d obj             s               *
     d ptr_info        ds                  likeds(matptr_suspend_info_t)
     d cl_cmd          s             32a
     d cmd_len         s             15p 5 inz(32)

      /free
           // lock *USRQ THD0
           cl_cmd = 'ALCOBJ ((THD0 *USRQ *EXCLRD))';
           exsr system;
           cl_cmd = 'ALCOBJ ((THD0 *USRQ *EXCL))';
           exsr system;

           // resolve SYSPTR to *USRQ THD0
           rslvsp_tmpl.obj_type = x'0A02';
           rslvsp_tmpl.obj_name = 'THD0';
           rslvsp2(obj : rslvsp_tmpl);

           tmpl_ptr = %alloc(TMPL_LEN);
           tmpl.bytes_in = TMPL_LEN;
           matsellk(tmpl : obj);
             // check tmpl:
             //   TMPL.CUR_LOCK_STATES = x'18' (LEAR, LENR)
             //   TMPL.NUM_LOCKD = 2

           // check lockds
           pos = tmpl_ptr + matsellk_lockd_offset;
           ptr_info.bytes_in = min_suspend_info_len;
           if tstbts(%addr(tmpl.return_fmt) : 4) = 1;
               lockd_offset = matsellk_lockd_length_exp;
           else;
               lockd_offset = matsellk_lockd_length;
           endif;
           for ind = 1 to tmpl.num_lockd;
               // check lockd:
               //   LOCKD.LOCK_TYPE=x'10', x'08' (LEAR, LENR)

               if lockd_offset = matsellk_lockd_length_exp;
                   matptr(ptr_info : lockd.suspend_ptr);
                     // check ptr_info
               endif;

               // offset to next lockd
               pos += lockd_offset;
           endfor;

           dealloc tmpl_ptr;

           // unlock *USRQ THD0
           cl_cmd = 'DLCOBJ ((THD0 *USRQ *EXCLRD))';
           exsr system;
           cl_cmd = 'DLCOBJ ((THD0 *USRQ *EXCL))';
           exsr system;

           *inlr = *on;
      /end-free

     c     system        begsr
     c                   call      'QCMDEXC'
     c                   parm                    cl_cmd
     c                   parm                    cmd_len
     c                   endsr
     /* eof */
