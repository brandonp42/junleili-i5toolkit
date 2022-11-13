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
      * @file t055.rpgle
      *
      * List all program activation entries in an activation groups.
      * MI instructions used here
      *  - MATAGPAT
      *  - MATACTAT
      *  - MATPTR
      *
      * example output of T055:
      * 
      * call t055 x'0000001C'
      * Number  Library     Program.   
      * 0001    QRPLOBJ     Q96C064A54.
      * 0002    QSYS        QC2UTIL1.  
      * 0003    QSYS        QC2LOCAL.  
      * 0004    QSYS        QLEAWI.    
      * 0005    QSYS        QLETPS.    
      * 0006    QSYS        QLESPI.    
      * 0007    QSYS        QC2UTIL3.  
      * 0008    QSYS        QC2SDATA.  
      * 0009    QSYS        QLEMF.     
      * 000A    QSYS        QLECWI.    
      * 000B    QSYS        QC2POSIX.
      *  ... ...
      * 001C    QSYS        QYPPTH.      
      * 001D    QRPLOBJ     Q96C3B68A4.  
      * 001E    QSYS        QRNXIE.      
      * 001F    QSYS        QRNXUTIL.    
      * 0020    QSYS        QRNXDUMP.    
      * 0021    QSYS        QLNRXPARSE.  
      * 0022    QRPLOBJ     Q96C3E61A8.  
      * 0023    LSBIN       FEB999.      
      */

      /if defined(*crtbndrpg)
     h dftactgrp(*no)
      /endif
     h bnddir('QC2LE')

      /copy mih52

      * prototype of my PEP
     d i               pr                  extpgm('T055')
     d     agp_mark                   4a

     d cvthc           pr                  extproc('cvthc')
     d     receiver                    *   value
     d     source                      *   value
     d     length                    10i 0 value

     d sendmsg         pr
     d     text                       1a   options(*varsize)
     d     len                       10i 0 value

     d agp_basic_info...
     d                 ds                  likeds(agp_basic_attr_t)
     d agp_attr        ds                  likeds(agp_acte_list_t)
     d                                     based(agp_attr_ptr)
     d agp_attr_ptr    s               *
      * materialize program activation entries
     d agp_opt         s              1a
     d acte_num        s             10i 0
     d bytes_needed    s             10i 0
     d act_opt         s              1a   inz(x'00')
     d acte_ptr        s               *
     d acte_mark       s             10u 0 based(acte_ptr)
     d ind             s              5u 0
     d act_attr        ds                  likeds(act_basic_attr_t)
      * attributes of a system pointer
     d syp_attr        ds                  likeds(matptr_sysptr_info_t)
     d msg             s             50a
     d msg_ptr         s               *
     d MSG_LEN         c                   50

     d i               pi
     d     agp_mark                   4a

      /free
           // number of activation entries
           agp_basic_info.bytes_in = %size(agp_basic_info);
           agp_opt = x'00';
           matagpat( %addr(agp_basic_info)
                   : agp_mark
                   : agp_opt );
           acte_num = agp_basic_info.act_cnt;

           // materialize program activation entries
           agp_attr_ptr = %alloc(16);
           agp_attr.bytes_in = 16;
           agp_opt = x'02';
           matagpat( agp_attr_ptr : agp_mark : agp_opt );
           bytes_needed = agp_attr.bytes_out;
           agp_attr_ptr = %realloc(agp_attr_ptr : bytes_needed);
           agp_attr.bytes_in = bytes_needed;
           matagpat( agp_attr_ptr : agp_mark : agp_opt );

           // work with returned activation entry list
           msg_ptr = %addr(msg) + 32;
           msg = 'Number  Library     Program     Act-mark';
           sendmsg(msg : MSG_LEN);
           acte_ptr = agp_attr_ptr + 16;
           act_attr.bytes_in = %size(act_basic_attr_t);
           for ind = 1 to acte_num;
               clear msg;
               cvthc(%addr(msg) : %addr(ind) : 4);

               // materialize activation attributes
               matactat( %addr(act_attr)
                       : acte_mark
                       : act_opt );

               // materialize program name of a act entry
               syp_attr.bytes_in = %size(syp_attr);
               monitor;
                   matptr(syp_attr : act_attr.pgm);
               on-error;  // MCH6801
                   %subst(msg:9) = 'System domain program';
                   sendmsg(msg : MSG_LEN);
                   acte_ptr += 4;
                   iter;
               endmon;

               // report program library and name
               %subst(msg:9) = syp_attr.ctx_name;
               %subst(msg:21) = syp_attr.obj_name;
               cvthc(msg_ptr : %addr(act_attr.act_mark) : 8);
               sendmsg(msg : MSG_LEN);

               // offset acte_ptr to next activatio mark
               acte_ptr += 4;
           endfor;

           dealloc agp_attr_ptr;
           *inlr = *on;
      /end-free

     /* sendmsg (text : len) */ 
     p sendmsg         b
     d                 pi
     d     text                       1a   options(*varsize)
     d     len                       10i 0 value

      * error code structure used by i5/OS APIs
     d qusec_t         ds                  qualified
     d     bytes_in                  10i 0
     d     bytes_out                 10i 0
     d     msg_id                     7a
     d                                1a

      * prototype of OPM API QMHSNDPM
     d qmhsndpm        pr                  extpgm('QMHSNDPM')
     d     msgid                      7a
     d     msgf                      20a
     d     msg_data                   1a   options(*varsize)
     d     msg_data_len...
     d                               10i 0
     d     msg_type                  10a
     d     stk_entry                 10a
     d     stk_cnt                   10i 0
     d     msg_key                    4a
     d     ec                              likeds(qusec_t)

     d msgid           s              7a   inz('CPF9898')
     d msgf            s             20a   inz('QCPFMSG   QSYS')
     d msg_type        s             10a   inz('*INFO')
     d stk_entry       s             10a   inz('*PGMBDY')
     d stk_cnt         s             10i 0 inz(1)
     d msg_key         s              4a
     d ec              ds                  likeds(qusec_t)

      /free
           ec.bytes_in = 16;
           qmhsndpm ( msgid
                    : msgf
                    : text
                    : len
                    : msg_type
                    : stk_entry
                    : stk_cnt
                    : msg_key
                    : ec );

      /end-free
     p sendmsg         e
