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
      * @file t057.rpgle
      *
      * test of index management instructions
      */

      /if defined(*crtbndrpg)
     h  dftactgrp(*no)
      /endif

      /copy mih-comp
      /copy mih-inx

     d tmpl            ds                  likeds(crtinx_tmpl_t)
     d                                     based(tmpl_ptr)
     d tmpl_ptr        s               *
     d tmpl_len        s             10i 0
     d inx             s               *
     d optlist         ds                  likeds(inx_option_list_t)
     d                                     based(opt_ptr)
     d len_off         ds                  likeds(
     d                                       inx_entry_length_offset_t)
     d                                     based(pos_ptr)
     d opt_ptr         s               *
     d pos_ptr         s               *
     d entry           s             32a
     d inx_attr        ds                  likeds(matinxat_tmpl_t)
     d                                     based(inx_attr_ptr)
     d inx_attr_ptr    s               *
     d mod_opt         ds                  likeds(modinx_tmpl_t)

      /free

           // allocate and initilize inx desc tmpl (1)
           tmpl_len = %size(crtinx_tmpl_t);
           tmpl_ptr = %alloc(tmpl_len);
           propb(tmpl_ptr : x'00' : tmpl_len);
           tmpl.bytes_in = tmpl_len;
           tmpl.obj_type = x'0E01';     // object type/subtype
           tmpl.obj_name = 'NIHAO';     // index name
           tmpl.crt_opt  = x'00000000'; // creation option
               // bit 0 = 0, existence attribute = temporary
               // bit 1 = 0, space attribute = fixed-length
           tmpl.spc_size = x'000000';   // do NOT have associated space
           tmpl.init_spc_val = x'00';
           tmpl.perf_cls = x'01000000';
           tmpl.ext_offset = 0;
           tmpl.inx_attr = x'70';       // index attribute
               // bit 0 = 0, entry length attribute = fixed-length
               // bit 1 = 1, immediate update = yes
               // bit 2 = 1, key insertion = yes
               // bit 3 = 1, entry format = index entries can
               //     contains both pointers and scalar data
           tmpl.arg_len  = 32;          // entry length = 32
           tmpl.key_len  = 8;           // key length = 8
           // create index NIHAO
           crtinx(inx : tmpl_ptr);

           // insert a couple of entries into NIHAO (2)
           entry = 'OBJD0200'
                   + '00010002'
                   + 'abcdABCD'
                   + 'ooooPPPP';        // key = 'OBJD0200'
           opt_ptr = %alloc(10);
           optlist.rule_opt   = x'0002'; // insert with replacement
           optlist.arg_len    = 32;
           optlist.arg_offset = 0;
           optlist.occ_cnt    = 1;
           insinxen(inx : %addr(entry) : opt_ptr);
             // on successful insersion, OPTLIST.RTN_CNT is set to 1

           entry = 'OBJD0400'
                   + '00080002'
                   + 'xxxxYYYY'
                   + 'zzzzQQQQ';        // key = 'OBJD0400'
           insinxen(inx : %addr(entry) : opt_ptr);

           // try to find out the entry with key value 'OBJD0200' (3)
           opt_ptr = %realloc(opt_ptr : 14);
           optlist.rule_opt   = x'0001'; // look for an equal entry
           optlist.arg_len    = 8;
           optlist.arg_offset = 0;
           optlist.occ_cnt    = 1;
           entry = 'OBJD0200';     // specify key value

           fndinxen( %addr(entry)
                   : inx
                   : opt_ptr
                   : %addr(entry) );
           if optlist.rtn_cnt > 0;
               dsply 'index entry found' '' entry;
           endif;

           // remove entry '0BJD0200...' from index NIHAO (4)
           rmvinxen( %addr(entry)
                   : inx
                   : opt_ptr
                   : %addr(entry) );

           dealloc opt_ptr;

           // retrieve index attributes (5)
           tmpl_len = %size(matinxat_tmpl_t);
           inx_attr_ptr = %alloc(tmpl_len);
           inx_attr.bytes_in = tmpl_len;
           matinxat(inx_attr_ptr : inx);
             // INX_ATTR.ENTRIES_INSERTED = 2
             // INX_ATTR.ENTRIES_REMOVED = 1
             // INX_ATTR.FIND_OPERATIONS = 1

           // modify index NIHAO (6)
           mod_opt.mod_sel  = x'40'; // modify immediate update attr
           mod_opt.new_attr = x'00'; // do not immediate update
           mod_opt.reserved = x'0000';
           modinx(inx : %addr(mod_opt));

           dealloc inx_attr_ptr;

           // destroy index NIHAO (7)
           desinx(inx);

           dealloc tmpl_ptr;
           *inlr = *on;
      /end-free
