     /*
      * @file r106.rpgle
      *
      * deq R106
      *
      * queue message format
      *  - delay, pkd(2,0), delay time
      *  - msg, char(14), message from the client
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

     /* queue entry format, used both by the client and the server */
     d q_format        ds                  qualified
     d   dly_time                     2p 0                                      /* how long to    */
     d   msg                         14a                                        /* greeting words */

     d qname           s             10a   inz('Q27')
     d qlib            s             10a   inz('LSBIN')
     d entry_len       s              5p 0 inz(16)
     d timeout         s              5p 0 inz(-1)                              /* dequeue infinitely */
     d key_order       s              2a   inz('GE')                            /* key order: >= parameter @key */
     d key_len         s              3p 0 inz(2)
     d key             s              2a   inz('00')
     d sender_info...
     d   _len          s              3p 0 inz(0)                               /* no sender info */
     d sender_info     s              1a
     d priority        s             16a

     d qcmdexc         pr                  extpgm('QCMDEXC')
     d   cmd                         64a   options(*varsize)
     d   cmdlen                      15p 5

     d dlyjob_cmd      s             64a
     d len             s             15p 5

     d QUIT_CMDS       c                   'q Q qu QU quit QUITT'
     d KEY_ARG         c                   '01'

      /free

          dow '1';

              key = KEY_ARG;
              // deq DTAQ Q27
              qrcvdtaq(  qname
                       : qlib
                       : entry_len
                       : q_format
                       : timeout
                       : key_order
                       : key_len
                       : key
                       : sender_info_len
                       : sender_info );

              // should i quit?
              if %scan( %trim(q_format.msg) : QUIT_CMDS ) > 0;
                  priority = 'Priority: 100';
                  q_format.msg = 'see you :)';
                  dsply priority '' q_format.msg;
                  leave;
              endif;

              // delay job
              dlyjob_cmd = 'DLYJOB ' + %char(q_format.dly_time);
              len = %len(%trim(dlyjob_cmd));
              qcmdexc(dlyjob_cmd : len);

              // display message
              priority = 'Priority: ' + key;
              dsply priority '' q_format.msg;

          enddo;

          *inlr = *on;
      /end-free
     /* eof - r106.rpgle */
