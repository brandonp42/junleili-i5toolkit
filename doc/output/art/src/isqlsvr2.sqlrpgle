     /*
      * @file isqlsvr.sqlrpgle
      *
      * - dequeue SQL request from USRQ ISQL2
      * - process SQL statement
      * - reply client with SQLCOD
      */
     /* to use activation group scope commitment control */
     h dftactgrp(*no) actgrp('ISQLSVR2')

     /*
      * prototype of procedure resolve_qs
      * @return boolean, *on if both the request USRQ and the reply
      *         USRQ are resolved.
      */
     d resolve_qs      pr              n

     /*
      * procedure server_client
      *
      * - dequeue SQL request from USRQ ISQL2
      * - process SQL statement
      * - reply client with SQLCOD
      *
      * @return boolean, *off if the main procedure should quit.
      */
     d serve_client    pr              n

     /*
      * procedure run_sql()
      *
      * @return SQLCOD
      */
     d run_sql         pr            10i 0
     d   the_sql                   5000a   options(*varsize)

     /* request USRQ ISQL2 */
     d request_q       s               *
     /* reply USRQ ISQLR2 */
     d reply_q         s               *
     d msg             s             26a

      /free

          // resolve request q and reply q
          if not resolve_qs();
              msg = 'Failed to resolve user queues';
              dsply '' '' msg;
              *inlr = *on;
              return;
          endif;

          // serves client
          dow serve_client();
          enddo;

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
          monitor;
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

     p serve_client    b
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
     d   acc_sts_mod                  1a   inz(x'DA')                           /* deq infinitely, key relation:'GE' */
     d   key_in                      16a
     d   key_out                     16a

     /* request data */
     d request         ds                  qualified
     d                                     based(request_ptr)
     d   sql_len                     10u 0
     d   reserved                     8a                                        /* align to 16 bytes boundary */
     d   sql_ptr                       *
     d request_ptr     s               *
     d sql_str         ds                  based(request.sql_ptr)
     d                                     qualified
     d   string                   32767a

     /* reply message to ISQLCPP2 */
     d reply           ds            16    qualified
     d   sqlcod                      10i 0

     d quit_cmd        s              4a
     d rtn             s               n
     d QUIT_CMDS       c                   'q Q qu QU quit QUITT'
     d MIN_KEY_VALUE   c                   x'00000000000000000000000000000000'  /* 16 bytes */
     d sql             s          32767a

     d serve_client    pi              n

      /free

          rtn = *on;

          // dequeue client's request from USRQ ISQL2
          deq_prefix.text_len = 16;
          deq_prefix.key_in = MIN_KEY_VALUE;
          deq(%addr(deq_prefix) : %addr(request_ptr) : request_q);

          // run sql statement
          sql = %subst(sql_str.string : 1 : request.sql_len);
          quit_cmd = %subst(sql : 1 : 4);
          if %scan(%trim(quit_cmd) : QUIT_CMDS) > 0;
              rtn = *off;
          else;
              reply.sqlcod = run_sql(sql);
          endif;

          // enqueue reply message to USRQ ISQLR2
          enq_prefix.text_len = 4;
          enq_prefix.key = deq_prefix.key_out;
          enq(reply_q : %addr(enq_prefix) : %addr(reply));

          return rtn;
      /end-free
     p serve_client    e

     p run_sql         b
     d run_sql         pi            10i 0
     d   the_sql                   5000a   options(*varsize)

     c/exec sql prepare stmt from :the_sql
     c/end-exec
     c                   if        sqlcod < 0
     c                   return    sqlcod
     c                   endif
     c/exec sql execute stmt
     c/end-exec

     c                   return    sqlcod
     p run_sql         e

     /* eof - isqlsrv2.sqlrpgle */
