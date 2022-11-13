     /**
      * @file t058.rpgle
      *
      * materialize a library associated index
      *
      * @remark since a library associated index is of system domain
      *         this program will fail with exception 3401 at
      *         security level 40 and above.
      */

      /if defined(*crtbndrpg)
     h  dftactgrp(*no)
      /endif

      /copy mih52
     d tmpl_len        s             10i 0
     d inx             s               *
     d optlist         ds                  likeds(inx_option_list_t)
     d                                     based(opt_ptr)
     d len_off         ds                  likeds(inx_entry_length_offset_t)
     d                                     based(pos_ptr)
     d opt_ptr         s               *
     d pos_ptr         s               *
     d entry           s             32a
     d inx_attr        ds                  likeds(matinxat_tmpl_t)
     d                                     based(inx_attr_ptr)
     d inx_attr_ptr    s               *
     d mod_opt         ds                  likeds(modinx_tmpl_t)

      /free
           // resolve library associated index object 'EMPTY'
           rslvsp_tmpl.obj_type = x'0E90';
           rslvsp_tmpl.obj_name = 'EMPTY';
           rslvsp2 (inx : rslvsp_tmpl);

           // retrieve index attributes
           tmpl_len = %size(matinxat_tmpl_t);
           inx_attr_ptr = %alloc(tmpl_len);
           inx_attr.bytes_in = tmpl_len;
           matinxat(inx_attr_ptr : inx);

           // check inx_attr.arg_len, key_len, and inx_attr

           dealloc inx_attr_ptr;

           *inlr = *on;
      /end-free
