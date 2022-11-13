     /*
      * @file r103.rpgle
      *
      * retrieve attribtutes of a DTAQ
      * Keyed DTAQ Q23 with entry length 64, key length 8,
      * does not include sender's ID
      */
     h dftactgrp(*no)

     /* receiver structure in format RDQD0100 */
     d rdqd0100_t      ds           112    qualified
     d   bytes_...
     d     returned                  10i 0                                      /* length of attribute data returned */
     d   bytes_...
     d     available                 10i 0                                      /* length DTAQ attribute data */
     d   entry_len                   10i 0                                      /* DTAQ entry length */
     d   key_len                     10i 0                                      /* DTAQ key length */
     d   sequence                     1a                                        /* DTAQ type:        */
     d                                                                          /*   - 'F', FIIO     */
     d                                                                          /*   - 'K', Keyed    */
     d                                                                          /*   - 'L', LIFO     */
     d   include_...
     d    sender_info                 1a                                        /* include sender info or not: Y/N */
     d   force_to_stg                 1a                                        /* force to storage: Y/N */
     d   text                        50a                                        /* text description */
     d   ddm_dtaq                     1a                                        /* is q DDM DTAQ:    */
     d                                                                          /*   - '0', no       */
     d                                                                          /*   - '1', yes      */
     d   auto_reclaim                 1a                                        /* automatic reclaim storage */
     d                                                                          /*   - '0', no       */
     d                                                                          /*   - '1', yes      */
     d   reserved                     1a
     d   num_messages                10i 0                                      /* messages currently on the DTAQ */
     d   entries_...
     d     allocated                 10i 0                                      /* entries currently allocated */
     d   qname                       10a
     d   qlib                        10a
     d   max_messages                10i 0                                      /* maximum number of messages */
     d   init_...
     d     messages                  10i 0                                      /* initial number of messages */

     /* prototype of API QMHQRDQD */
     d qmhqrdqd        pr                  extpgm('QMHQRDQD')
     d   dtaq_attr                         likeds(rdqd0100_t)                   /* receiver data */
     d   receiver_len                10i 0                                      /* length of receiver data */
     d   format_name                  8a                                        /* format name               */
     d                                                                          /*   - RDQD0100, normal DTAQ */
     d                                                                          /*   - RDQD0200, DDM DTAQ    */
     d   qname_lib                   20a                                        /* DTAQ name/library, e.g.   */
     d                                                                          /*   'Q23       LSBIN     '  */

     d do_report       pr

     d dtaq_attr       ds                  likeds(rdqd0100_t)
     d len             s             10i 0 inz(112)
     d format          s              8a   inz('RDQD0100')
     d qname_lib       s             20a   inz('Q23       LSBIN')

      /free

          qmhqrdqd(  dtaq_attr
                   : len
                   : format
                   : qname_lib );

          do_report();

          *inlr = *on;
      /end-free
     /* eof - main procedure */

     p do_report       b

     /* structure Qus_EC_t */
     d qusec_t         ds           256    qualified
     d   bytes_in                    10i 0
     d   bytes_out                   10i 0
     d   exid                         7a
     d   reserved                     1a
     d   ex_data                    240a

     /* prototype of QMHSNDPM */
     d qmhsndpm        pr                  extpgm('QMHSNDPM')
     d   msgid                        7a
     d   msgf                        20a
     d   msgdata                    128a   options(*varsize)
     d   msgdata_len                 10i 0
     d   msgtype                     10a
     d   callstack_...
     d     entry                     10a
     d   callstack_...
     d     counter                   10i 0
     d   msgkey                       4a
     d   ec                                likeds(qusec_t)

     d msgid           s              7a   inz('CPF9898')
     d msgf            s             20a   inz('QCPFMSG   QSYS')
     d msgdata         s            128a
     d msgdata_len     s             10i 0
     d msgtype         s             10a   inz('*INFO')
     d callstack_...
     d   entry         s             10a   inz('*PGMBDY')
     d callstack_...
     d   counter       s             10i 0 inz(1)
     d msgkey          s              4a
     d ec              ds                  likeds(qusec_t)
     d msg             s            128a

      /free

          ec.bytes_in = 256;

          // report DTAQ entry length
          msgdata = 'Entry length: ' + %char(dtaq_attr.entry_len);
          msgdata_len = %len(%trim(msgdata));
          qmhsndpm(  msgid
                   : msgf
                   : msgdata
                   : msgdata_len
                   : msgtype
                   : callstack_entry
                   : callstack_counter
                   : msgkey
                   : ec );

          // report DTAQ key length
          msgdata = 'Key length: ' + %char(dtaq_attr.key_len);
          msgdata_len = %len(%trim(msgdata));
          qmhsndpm(  msgid
                   : msgf
                   : msgdata
                   : msgdata_len
                   : msgtype
                   : callstack_entry
                   : callstack_counter
                   : msgkey
                   : ec );

          // report more DTAQ attributes
          // ... ...

      /end-free
     p do_report       e

     /* eof - r103.rpgle */
