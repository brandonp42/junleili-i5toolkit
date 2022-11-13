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
      * @file t126.rpgle
      *
      * Test of MATRMD.
      */

     h dftactgrp(*no)

      /copy mih52
     d prc_util        ds                  likeds(matrmd_tmpl01_t)
     d stg_cnt         ds                  likeds(matrmd_tmpl03_t)
     d tmsp            ds                  likeds(matrmd_tmpl04_t)
     d addr            ds                  likeds(matrmd_tmpl08_t)
     d msp             ds                  likeds(matrmd_tmpl09_t)
     d                                     based(buf_ptr)
     d msp_rsv         ds                  likeds(matrmd_tmpl0c_t)
     d                                     based(buf_ptr)
     d opt             ds                  likeds(matrmd_option_t)
     d buf_ptr         s               *
     d msp_info        ds                  likeds(msp_info_t)
     d                                     based(pos)
     d rsv_pool        ds                  likeds(msp_mch_reserved_t)
     d                                     based(pos)
     d pos             s               *
     d hours           s             20u 0
     d len             s             10u 0
     d i               s             10i 0
     d msg             s             30a
     d sz              s             12p 2

      /free

           // processor utilization
           prc_util = *allx'00';
           prc_util.bytes_in = %size(prc_util);
           opt = *allx'00';
           opt.val = x'01';
           matrmd(prc_util : opt);

           hours = prc_util.prc_time / sysclock_one_hour;
           dsply 'Processor time since IPL' '' hours;

           // storage management counters
           stg_cnt.bytes_in = %size(stg_cnt);
           opt.val = x'03';
           matrmd(stg_cnt : opt);

           // storage transient pool information
           tmsp.bytes_in = %size(tmsp);
           opt.val = x'04';
           matrmd(tmsp : opt);
           dsply 'Transient MSP' '' tmsp.msp_num;

           // Machine Address Threshold Data
           addr.bytes_in = %size(addr);
           opt.val = x'08';
           matrmd(addr : opt);

           // information of main storage pools (with opt hex 09)
           len = %size(msp);
           buf_ptr = modasa(len);
           msp.bytes_in = len;
           opt.val = x'09';
           matrmd(msp : opt);

           len = msp.bytes_out;
           buf_ptr = modasa(len);
           msp.bytes_in = len;
           matrmd(msp : opt);
             // MSP.MACHINE_MINIMUM_TRANSFER_SIZE = 4096
             // MSP.MAXIMUM_NUMBER_OF_POOLS = 64        
             // MSP.CURRENT_NUMBER_OF_POOLS = 64        
             // MSP.MAIN_STORAGE_SIZE = 949508          
             // MSP.POOL_1_MINIMUM_SIZE = 33382         

           pos = buf_ptr + %size(matrmd_tmpl09_t);
           for i = 1 to msp.current_number_of_pools;
               // check msp_info
               msg = 'Pool ' + %char(i);
               if msp_info.pool_size <> 0;
                   eval(h) sz = msp_info.pool_size * 4096 / 1024 / 1024;
                   dsply msg '' sz;
               endif;

               pos += %size(msp_info_t);
           endfor;

           // Machine Reserved Storage Pool Information (opt hex 0C)
           len = %size(msp_rsv);
           buf_ptr = modasa(len);
           msp_rsv.bytes_in = len;
           opt.val = x'0C';
           matrmd(msp_rsv : opt);

           len = msp_rsv.bytes_out;
           buf_ptr = modasa(len);
           msp_rsv.bytes_out = len;
           matrmd(msp_rsv : opt);

           pos = buf_ptr + %size(matrmd_tmpl0c_t);
           for i = 1 to msp_rsv.cur_pools;
               // check rsv_pool

               pos += %size(rsv_pool);
           endfor;

           *inlr = *on;
      /end-free
