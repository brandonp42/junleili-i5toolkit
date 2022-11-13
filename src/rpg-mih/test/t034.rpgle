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
      * @file t034.rpgle
      *
      * test of cprdata(), dcpdata().
      */

     h bnddir('QC2LE')

      /copy mih52

     d tmpl            ds                  likeds(cprdata_tmpl_t)
     d tmpl_ptr        s               *   inz(%addr(tmpl))
     d dcp_tmpl        ds                  likeds(dcpdata_tmpl_t)
     d dcp_tmpl_ptr    s               *   inz(%addr(dcp_tmpl))
     d src             s           4096a
     d src_ptr         s               *
     d tgt             s           4096a
     d greeting        s             16a   inz('Merry Chrismas!')
     d ind             s             10i 0
     d result          ds            16    based(src_ptr)

      /free

           // fill source string
           src_ptr = %addr(src);
           for ind = 0 by 16 to 4096;
               memcpy(src_ptr + ind : %addr(greeting) : 16);
           endfor;

           // compress data
           propb (tmpl_ptr : x'00' : DCPDATA_TMPL_LENGTH);
           tmpl.source_len = 4096;
           tmpl.target_len = 4096;
           tmpl.algorithm = 2;      // use IBM LZ1 algorithm
           tmpl.source = src_ptr;
           tmpl.target = %addr(tgt);

           cprdata(tmpl_ptr);

           // DCP
           propb (dcp_tmpl_ptr : x'00' : CPRDATA_TMPL_LENGTH);
           dcp_tmpl.result_len = 4096;
           dcp_tmpl.source = %addr(tgt);
           dcp_tmpl.target = src_ptr;

           propb (src_ptr : x'00' : 4096);
           dcpdata(dcp_tmpl_ptr);

           // check what we get in src
           dsply 'result:' '' result;

           *inlr = *on;
      /end-free
