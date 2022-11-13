     /*
      * @file r102.rpgle
      *
      * DTAQ Q23，类型为基于键值出列，entry长度64，key长度8，
      * 不含发送作业标识信息。
      *
      * 出列DTAQ Q23中键值大于'00000001'的entry，并保留DTAQ中的entry。
      */

     /* structure Qus_EC_t */
     d qusec_t         ds           256    qualified
     d   bytes_in                    10i 0
     d   bytes_out                   10i 0
     d   exid                         7a
     d   reserved                     1a
     d   ex_data                    240a

     /* prototype of API QRCVDTAQ */
     d qrcvdtaq        pr                  extpgm('QRCVDTAQ')
     d   qname                       10a
     d   qlib                        10a
     d   entry_len                    5p 0
     d   entry                       64a   options(*varsize)
     d   timeout                      5p 0
     d   key_order                    2a   options(*nopass)                     /* optional parameter group 1 */
     d   key_len                      3p 0 options(*nopass)
     d   key                          8a   options(*nopass:*varsize)            /* input/output parameter */
     d   sender_info...
     d     _len                       3p 0 options(*nopass)
     d   sender_info                  1a   options(*nopass:*varsize)
     d   remove_msg                  10a   options(*nopass)                     /* optional parameter group 2 */
     d   receiver_len                 5p 0 options(*nopass)
     d   ec                                likeds(qusec_t)
     d                                     options(*nopass)

     d qname           s             10a   inz('Q23')
     d qlib            s             10a   inz('LSBIN')
     d entry_len       s              5p 0
     d entry           s             64a
     d timeout         s              5p 0 inz(-1)                              /* dequeue infinitely */
     d key_order       s              2a   inz('GT')                            /* key order: >= parameter @key */
     d key_len         s              3p 0 inz(8)
     d key             s              8a   inz('00000001')
     d sender_info...
     d   _len          s              3p 0 inz(0)                               /* no sender info */
     d sender_info     s              1a
     d remove_msg      s             10a   inz('*NO')                           /* do NOT remove message from DTAQ */
     d receiver_len    s              5p 0 inz(64)
     d ec              ds                  likeds(qusec_t)
     d msg             s             16a

      /free
          ec.bytes_in = 256;
          qrcvdtaq(  qname
                   : qlib
                   : entry_len
                   : entry
                   : timeout
                   : key_order
                   : key_len
                   : key
                   : sender_info_len
                   : sender_info
                   : remove_msg
                   : receiver_len
                   : ec );

           msg = %subst(entry : 1 : 16);
           dsply key '*EXT' msg;

          *inlr = *on;
      /end-free
     /* eof - r102.rpgle */
