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
      * @file who.rpgle
      *
      * Test of who_am_i().
      *
      * Output of WHO:
      * @code
      * DSPLY  Program:         QGPL/WHO 
      * DSPLY  Module:          QTEMP/WHO 
      * DSPLY  Procedure:       WHO       
      * DSPLY  Statement ID:            81
      * DSPLY  Job ID:          TEA       ABC       268988
      * DSPLY  Thread ID:       0000000000000030          
      * @endcode
      */
      /if defined(*crtbndrpg)
     h dftactgrp(*no) bnddir('QC2LE')
      /endif

     /**
      * DS used by who_am_i() to represent program info.
      */
     d pgm_info_t      ds                  qualified
     d     ctx                       30a
     d     name                      30a

     /**
      * DS used by who_am_i() to represent module info.
      */
     d module_info_t   ds                  qualified
     d     name                      30a
     d     qualifier                 30a

     /**
      * DS used to represent variable length procedure name.
      */
     d proc_name_t     ds                  qualified
     d                                     based(dummy_ptr)
     d     len                        5u 0
     d     name                   32767a

     /**
      * DS used to represent statement ID list.
      */
     d stmt_list_t     ds                  qualified
     d                                     based(dummy_ptr)
     d     num                        5u 0
     d     stmt                      10i 0 dim(1024)

     /* Job ID and thread ID. */
     d job_id_thread_id_t...
     d                 ds                  qualified
     d     jid                       30a
     d     tid                        8a

     /**
      * Who am I?
      *
      * @param [out] pgm_info, returned program info.
      * @param [out] mod_info, returned module info.
      * @param [out] proc_name, returned procedure name.
      * @param [out] stmst, returned statement ID list.
      * @param [out] MI process (job) id and thread id.
      * @param [in]  inv_offset, offset of target invocation.
      *              -1 if no passed, which means who_am_i()'s caller.
      *
      * @return 1-byte invocation type.
      *         hex 00 = Non-bound program
      *         hex 01 = Bound program
      *         hex 02 = Bound service program
      *         hex 04 = Java program
      *         hex FF = invalid input parameters
      */
     d who_am_i        pr             1a
     d     pgm_info                        likeds(pgm_info_t)
     d     mod_info                        likeds(module_info_t)
     d     proc_name                       likeds(proc_name_t)
     d     stmts                           likeds(stmt_list_t)
     d     job_thd_id                      likeds(job_id_thread_id_t)
     d                                     options(*nopass)
     d     inv_offset                10i 0 value options(*nopass)

     d cvthc           pr                  extproc('cvthc')
     d     receiver                    *   value
     d     source                      *   value
     d     length                    10i 0 value

     d pgm_info        ds                  likeds(pgm_info_t)
     d mod_info        ds                  likeds(module_info_t)
     d proc_name       ds                  likeds(proc_name_t)
     d                                     based(proc_name_ptr)
     d proc_name_ptr   s               *
     d stmts           ds                  likeds(stmt_list_t)
     d                                     based(stmts_ptr)
     d stmts_ptr       s               *
     d thread          ds                  likeds(job_id_thread_id_t)
     d pgm_type        s              1a
     d msg             s             30a

      /free

           proc_name_ptr = %alloc(2 + 128);
           proc_name.len = 128;

           stmts_ptr = %alloc(2 + 4 * 4); // for up to 4 statement ids
           stmts.num = 4;

           pgm_type = who_am_i( pgm_info
                              : mod_info
                              : proc_name
                              : stmts
                              : thread );

           // check returned information
           // program info
           msg = %trim(%subst(pgm_info.ctx : 1 : 10)) + '/'
                 + %subst(pgm_info.name : 1 : 10);
           dsply 'Program:     ' '' msg;

           if pgm_type > x'00';
               // module info
               msg = %trim(%subst(mod_info.qualifier : 1 : 10)) + '/'
                     + %subst(mod_info.name : 1 : 10);
               dsply 'Module:      ' '' msg;

               // procedure name
               msg = %subst(proc_name.name : 1 : proc_name.len);
               dsply 'Procedure:   ' '' msg;

               // first statement ID in stmt id list
               dsply 'Statement ID:' '' stmts.stmt(1);
           endif;

           // job id and thread id
           dsply 'Job ID:      ' '' thread.jid;
           // thread.tid
           cvthc(%addr(msg) : %addr(thread.tid) : 16);
           dsply 'Thread ID:   ' '' msg;

           dealloc proc_name_ptr;
           dealloc stmts_ptr;
           *inlr = *on;
      /end-free

     /* implementation of who_am_i */
     p who_am_i        b                   export

      /copy mih52

     d who_am_i        pi             1a
     d     pgm_info                        likeds(pgm_info_t)
     d     mod_info                        likeds(module_info_t)
     d     proc_name                       likeds(proc_name_t)
     d     stmts                           likeds(stmt_list_t)
     d     job_thd_id                      likeds(job_id_thread_id_t)
     d                                     options(*nopass)
     d     inv_offset                10i 0 value options(*nopass)

     d inv_id          ds                  likeds(invocation_id_t)
     d susptr          ds                  likeds(matinvat_ptr_t)
     d sel             ds                  likeds(matinvat_selection_t)
     d ptrd            ds                  likeds(matptrif_susptr_tmpl_t)
     d mask            s              4a
     d pcs_tmpl        ds                  likeds(matpratr_ptr_tmpl_t)
     d matpratr_opt    s              1a   inz(x'25')
     d syp_attr        ds                  likeds(matptr_sysptr_info_t)

      /free
           // initialize invocation id
           inv_id = *allx'00';
           if %parms() > 5;
               if inv_offset > 0;
                   return x'FF';
               endif;
               inv_id.src_inv_offset = inv_offset;
           else;
               inv_id.src_inv_offset = -1;  // caller's invocation
           endif;

           // materialize suspend pointer of target invocation
           sel = *allx'00';
           sel.num_attr   = 1;
           sel.attr_id    = 24;  // suspend pointer
           sel.rcv_length = 16;
           matinvat2( susptr
                    : inv_id
                    : sel );

           // materialize suspend ptr
           ptrd = *allx'00';
           ptrd.bytes_in = %size(ptrd);
           ptrd.proc_name_length_in = proc_name.len;
           ptrd.proc_name_ptr = %addr(proc_name.name);
           ptrd.stmt_ids_in = stmts.num;
           ptrd.stmt_ids_ptr = %addr(stmts.stmt);
           mask = x'5B280000';  // 01011011,00101000,00000000,00000000
             // bit 1 = 1, materialize program type
             // bit 3 = 1, materialize program context
             // bit 4 = 1, materialize program name
             // bit 6 = 1, materialize module name
             // bit 7 = 1, materialize module qualifier
             // bit 10 = 1, materialize procedure name
             // bit 12 = 1, materialize statement id list
           matptrif( ptrd : susptr.ptr : mask );

           // set output parameters
           pgm_info.ctx       = ptrd.pgm_ctx;
           pgm_info.name      = ptrd.pgm_name;
           mod_info.name      = ptrd.mod_name;
           mod_info.qualifier = ptrd.mod_qual;
           proc_name.len      = ptrd.proc_name_length_out;
           stmts.num          = ptrd.stmt_ids_out;

           // if job id and thread id is requested
           if %parms() > 4;
               exsr rtv_job_thd_id;
           endif;

           // return materialized program type
           return ptrd.pgm_type;

           // retrieve job id and thread id
           begsr rtv_job_thd_id;

               // retrieve the PCS pointer of the current MI process
               pcs_tmpl.bytes_in = %size(pcs_tmpl);
               matpratr1(pcs_tmpl : matpratr_opt);

               // retrieve the name of the PCS ptr, aka job ID
               syp_attr.bytes_in = %size(syp_attr);
               matptr(syp_attr : pcs_tmpl.ptr);
               job_thd_id.jid = syp_attr.obj_name;

               job_thd_id.tid = retthid(); // thread id
           endsr;

      /end-free
     p who_am_i        e
