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
      * @file t035.rpgle
      *
      * test of TS APIs, cprdata(), dcpdata().
      */

     h bnddir('QC2LE')

      /copy mih52
      /copy ts

     d tmpl            ds                  likeds(cprdata_tmpl_t)
     d tmpl_ptr        s               *   inz(%addr(tmpl))
     d dcp_tmpl        ds                  likeds(dcpdata_tmpl_t)
     d dcp_tmpl_ptr    s               *   inz(%addr(dcp_tmpl))
     d*BUF_LEN         c                   x'02000000'                          32MB
     d*BUF_LEN         c                   x'015FF000'                          16MB - 4KB
     d BUF_LEN         c                   x'00FF0000'                          16MB - 64KB
     d len             s             10i 0
     d src_ptr         s               *
     d tgt_ptr         s               *
     d greeting        s             16a   inz('Merry Chrismas!')
     d ind             s             10i 0
     d result          ds            16    based(src_ptr)

      /free

           // fill source string
           src_ptr = ts_calloc(1 : BUF_LEN);
           tgt_ptr = ts_calloc(1 : BUF_LEN);
           len = BUF_LEN;
           for ind = 0 by 16 to len;
               memcpy(src_ptr + ind : %addr(greeting) : 16);
           endfor;

           // compress data
           propb (tmpl_ptr : x'00' : DCPDATA_TMPL_LENGTH);
           tmpl.source_len = BUF_LEN;
           tmpl.target_len = BUF_LEN;
           tmpl.algorithm = 2;      // use IBM LZ1 algorithm
           tmpl.source = src_ptr;
           tmpl.target = tgt_ptr;

           cprdata(tmpl_ptr);

           // DCP
           propb (dcp_tmpl_ptr : x'00' : CPRDATA_TMPL_LENGTH);
           dcp_tmpl.result_len = BUF_LEN;
           dcp_tmpl.source = tgt_ptr;
           dcp_tmpl.target = src_ptr;

           propb (src_ptr : x'00' : BUF_LEN);
           dcpdata(dcp_tmpl_ptr);

           // check what we get in src
           dsply 'result:' '' result;

           *inlr = *on;
      /end-free
