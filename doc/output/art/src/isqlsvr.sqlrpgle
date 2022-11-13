     /*
      * @file isqlsvr.sqlrpgle
      *
      * - dequeue SQL request from DTAQ ISQL
      * - process SQL statement
      * - reply client with SQLCOD
      */
     /* to use activation group scope commitment control */
     h dftactgrp(*no) actgrp('ISQLSVR')

     /*
      * procedure server_client
      *
      * - dequeue SQL request from DTAQ ISQL
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
     d   sql                        256a   options(*varsize)

      /free

          dow serve_client();
          enddo;

          *inlr = *on;
      /end-free
     p serve_client    b

     /* structure Qus_EC_t */
     d qusec_t         ds           256    qualified
     d   bytes_in                    10i 0
     d   bytes_out                   10i 0
     d   exid                         7a
     d   reserved                     1a
     d   ex_data                    240a

     /* prototype of API QSNDDTAQ */
     d qsnddtaq        pr                  extpgm('QSNDDTAQ')
     d   qname                       10a
     d   qlib                        10a
     d   entry_len                    5p 0
     d   entry                        1a   options(*varsize)
     d   key_len                      3p 0 options(*nopass)
     d   key                          1a   options(*nopass:*varsize)

     /* prototype of API QRCVDTAQ */
     d qrcvdtaq        pr                  extpgm('QRCVDTAQ')
     d   qname                       10a
     d   qlib                        10a
     d   entry_len                    5p 0
     d   entry                        1a   options(*varsize)
     d   timeout                      5p 0
     d   key_order                    2a   options(*nopass)                     /* optional parameter group 1 */
     d   key_len                      3p 0 options(*nopass)
     d   key                          1a   options(*nopass:*varsize)            /* input/output parameter */
     d   sender_info...
     d     _len                       3p 0 options(*nopass)
     d   sender_info                  1a   options(*nopass:*varsize)
     d   remove_msg                  10a   options(*nopass)                     /* optional parameter group 2 */
     d   receiver_len                 5p 0 options(*nopass)
     d   ec                                likeds(qusec_t)
     d                                     options(*nopass)

     d qname           s             10a
     d qlib            s             10a   inz('*LIBL')
     d entry_len       s              5p 0
     d timeout         s              5p 0 inz(-1)                              /* dequeue infinitely */
     d key_order       s              2a   inz('GE')                            /* key order: >= parameter @key */
     d key_len         s              3p 0 inz(16)
     d key             s             16a
     d sender_info...
     d   _len          s              3p 0 inz(0)                               /* no sender info */
     d sender_info     s              1a
     d ec              ds                  likeds(qusec_t)

     d q_entry         ds                  qualified
     d   sql                        256a
     d   sqlcod                      10i 0
     d   ch_sqlcod                    4a   overlay(sqlcod)

     d uuid            s             16a
     d msg             s             26a
     d rtn             s              1a
     d QUIT_CMDS       c                   'q Q qu QU quit QUITT'
     d KEY_ARG         c                   x'00000000000000000000000000000000'

     d serve_client    pi              n
      /free

          rtn = *on;

          // dequeue client request from DTAQ ISQL
          clear ec;
          ec.bytes_in = 256;
          qname = 'ISQL';
          entry_len = 256;
          uuid = KEY_ARG;
          qrcvdtaq(  qname
                   : qlib
                   : entry_len
                   : q_entry.sql
                   : timeout
                   : key_order
                   : key_len
                   : uuid
                   : sender_info_len
                   : sender_info );
          if ec.bytes_out <> 0;
              // error handling
              msg = 'QRCVDTAQ failed: '
                       + ec.exid;
              dsply 'Error' '' msg;
              return *off;
          endif;

          // should i quit?
          if %scan(%trim(q_entry.sql) : QUIT_CMDS) > 0;
              rtn = *off;
          else;
              // run sql statement
              q_entry.sqlcod = run_sql(q_entry.sql);
          endif;

          // enqueue reply to DTAQ ISQLR
          entry_len = 4;
          qname = 'ISQLR';
          qsnddtaq(  qname
                   : qlib
                   : entry_len
                   : q_entry.ch_sqlcod
                   : key_len
                   : uuid );

          return rtn;
      /end-free
     p serve_client    e

     p run_sql         b
     d run_sql         pi            10i 0
     d   sql                        256a   options(*varsize)

     c/exec sql prepare stmt from :sql
     c/end-exec
     c                   if        sqlcod < 0
     c                   return    sqlcod
     c                   endif
     c/exec sql execute stmt
     c/end-exec

     c                   return    sqlcod
     p run_sql         e
     /* eof - isqlsvr.sqlrpgle
