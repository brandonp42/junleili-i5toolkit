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
      * @file t011.rpgle
      *
      * test of callpgmv
      */

      /copy mih54

     d qmhsndpm        s               *
     d argv            s               *   dim(10)

     d qusec_t         ds           256    qualified
     d     bytes_in                  10i 0
     d     bytes_out                 10i 0
     d     exid                       7a
     d     reserved                   1a
     d     exdata                   240a
     d qusec_len       c                   256

     d msgid           s              7a   inz('CPF9898')
     d msgf            s             20a   inz('QCPFMSG   QSYS')
     d msgtext         s             32a   inz('test of callpgmv')
     d msgtextlen      s             10i 0 inz(32)
     d msgtype         s             10a   inz('*INFO')
     d call_stk        s             10a   inz('*PGMBDY')
     d call_stk_cnt    s             10i 0 inz(1)
     d msgkey          s              4a
     d ec              ds                  likeds(qusec_t)

      /free

           // resolove *PGM QMHSNDPM
           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = 'QMHSNDPM';
           rslvsp2(qmhsndpm : rslvsp_tmpl);

           // call QMHSNDPM
           argv(1) = %addr(msgid      );
           argv(2) = %addr(msgf       );
           argv(3) = %addr(msgtext    );
           argv(4) = %addr(msgtextlen );
           argv(5) = %addr(msgtype    );
           argv(6) = %addr(call_stk   );
           argv(7) = %addr(call_stk_cnt);
           argv(8) = %addr(msgkey     );
           argv(9) = %addr(ec         );
      /if defined(*V5R4M0)
           ec.bytes_in = qusec_len;
           callpgmv(qmhsndpm : argv : 9);
      /endif
           *inlr = *on;
      /end-free
