     /*
      * @file isqlcpp2.rpgle
      *
      */
     h dftactgrp(*no)

     d sql_param_t     ds                  qualified
     d   sql_len                     10i 0
     d   sql                      32767a

     d i_main          pr                  extpgm('ISQLCPP2')
     d   sql_parm                          likeds(sql_param_t)
     d   sqlcod                      10i 0 options(*nopass)

     /* structure Qus_EC_t */
     d qusec_t         ds           256    qualified
     d   bytes_in                    10i 0
     d   bytes_out                   10i 0
     d   exid                         7a
     d   reserved                     1a
     d   ex_data                    240a

     /*
      * do_request
      *  - send SQL request to server program ISQLSVR2
      *  - receive the SQLCOD returned by ISQLSVR2
      *  - report result message to the user
      *
      * @pre sql
      * @return sqlcod
      */
     d do_request      pr            10i 0

     /* send message to interactive user */
     d sendmsg         pr
     d   msg                        256a

     /*
      * prototype of procedure resolve_qs
      * @return boolean, *on if both the request USRQ and the reply
      *         USRQ are resolved.
      */
     d resolve_qs      pr              n

     /* request USRQ ISQL2 */
     d request_q       s               *

     /* reply USRQ ISQLR2 */
     d reply_q         s               *

     d msg             s            256a
     d rtn             s             10i 0

     d i_main          pi
     d   sql_parm                          likeds(sql_param_t)
     d   sqlcod                      10i 0 options(*nopass)

      /free

          // resolve request q, reply q
          if resolve_qs();
              rtn = do_request();
          endif;

          sendmsg(msg);

          // return SQLCOD to the caller when parameter sqlcod is specified
          if %parms() > 1;
              sqlcod = rtn;
          endif;

          *inlr = *on;
      /end-free

     /* procedure resolve_qs() */
     p resolve_qs      b
     /* prototype of MI instruction RSLVSP */
     d rslvsp          pr                  extproc('_RSLVSP2')
     d   syp                           *
     d   option                        *   value

     d resolve_option  ds            34    qualified
     d   type                         2a   inz(x'0A02')
     d   name                        30a
     d   auth                         2a   inz(x'0000')

     d rtn             s               n

     d resolve_qs      pi              n
      /free

          rtn = *on;

          // resolve request q, reply q
          monitor;   // monitor MCH3401
              resolve_option.name = 'ISQL2';
              rslvsp(request_q : %addr(resolve_option));
              resolve_option.name = 'ISQLR2';
              rslvsp(reply_q : %addr(resolve_option));
          on-error;
              msg = 'Failed to resolve request user queue' +
                    ' or reply user queue';
              rtn = *off;
          endmon;

          return rtn;
      /end-free
     p resolve_qs      e

     /* procedure do_request() */
     p do_request      b

     d uuid_template   ds                  qualified
     d   bytes_in                    10u 0 inz(32)
     d   bytes_out                   10u 0
     d   reserved                     8a   inz(x'0000000000000000')
     d   uuid                        16a

     d genuuid         pr                  extproc('_GENUUID')
     d   template                      *   value

     /* prototype of MI instruction ENQ */
     d enq             pr                  extproc('_ENQ')
     d   q                             *
     d   prefix                        *   value
     d   text                          *   value

     /* prototype of MI instruction DEQ */
     d deq             pr                  extproc('_DEQWAIT')
     d   prefix                        *   value
     d   text                          *   value
     d   q                             *

     /* enq prefix */
     d enq_prefix      ds            20    qualified
     d   text_len                    10i 0
     d   key                         16a

     /* deq prefix */
     d deq_prefix      ds            53    qualified
     d   enqueue_time                 8a
     d   timeout                      8a
     d   text_len                    10i 0
     d   acc_sts_mod                  1a   inz(x'D8')                           /* deq infinitely */
     d   key_in                      16a
     d   key_out                     16a

     /* request data */
     d request         ds                  qualified
     d   sql_len                     10u 0
     d   reserved                     8a                                        /* align to 16 bytes boundary */
     d   sql_ptr                       *
     d request_ptr     s               *   inz(%addr(request))

     /* reply message from ISQLSVR2 */
     d reply           ds            16    qualified
     d   sqlcod                      10i 0

     d do_request      pi            10i 0

      /free

          // generate UUID
          genuuid(%addr(uuid_template));

          // enqueue SQL statement to USRQ ISQL2
          enq_prefix.text_len = 16;
          enq_prefix.key = uuid_template.uuid;
          request.sql_len = sql_parm.sql_len;
          request.sql_ptr = %addr(sql_parm.sql);
          enq(request_q : %addr(enq_prefix) : %addr(request_ptr));

          // dequeue SQLCOD from USRQ ISQLR2
          deq_prefix.key_in = uuid_template.uuid;
          deq(%addr(deq_prefix) : %addr(reply) : reply_q);

          // set msg according to returned SQLCOD
          if reply.sqlcod < 0;
              msg = 'SQL statement failed with SQLCOD '
                       + %char(reply.sqlcod);
          elseif reply.sqlcod > 0;
              msg = 'SQL statement succeeded with SQLCOD '
                       + %char(reply.sqlcod);
          else;
              msg = 'SQL statement succeeded';
          endif;

          return reply.sqlcod;
      /end-free
     p do_request      e

     /* procedure sendmsg() */
     p sendmsg         b

     /* prototype of QMHSNDPM */
     d qmhsndpm        pr                  extpgm('QMHSNDPM')
     d   msgid                        7a
     d   msgf                        20a
     d   msgdata                    512a   options(*varsize)
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
     d msgdata_len     s             10i 0
     d msgtype         s             10a   inz('*INFO')
     d callstack_...
     d   entry         s             10a   inz('*PGMBDY')
     d callstack_...
     d   counter       s             10i 0 inz(1)
     d msgkey          s              4a
     d ec              ds                  likeds(qusec_t)

     d cmd             s            512a
     d len             s             15p 5

     d sendmsg         pi
     d   msg                        256a

      /free

          clear ec;
          ec.bytes_in = 256;

          msgdata_len = %len(%trim(msg));
          qmhsndpm(  msgid
                   : msgf
                   : msg
                   : msgdata_len
                   : msgtype
                   : callstack_entry
                   : callstack_counter
                   : msgkey
                   : ec );

      /end-free
     p sendmsg         e

     /* eof - isqlcpp2.rpgle */
