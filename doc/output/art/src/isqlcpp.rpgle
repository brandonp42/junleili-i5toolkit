     /*
      * @file isqlcpp.rpgle
      *
      * commmand processing program for CL command ISQL
      */

     h dftactgrp(*no)

     d i_main          pr                  extpgm('ISQLCPP')
     d   sql                        256a
     d   sqlcod                      10i 0 options(*nopass)

     /* structure Qus_EC_t */
     d qusec_t         ds           256    qualified
     d   bytes_in                    10i 0
     d   bytes_out                   10i 0
     d   exid                         7a
     d   reserved                     1a
     d   ex_data                    240a

     /* input checking procedure */
     d input_check     pr              n

     /*
      * do_request
      *  - send SQL request to server program ISQLSVR
      *  - receive the SQLCOD returned by ISQLSVR
      *  - report result message to the user
      *
      * @pre sql
      * @return sqlcod
      */
     d do_request      pr            10i 0

     /* send message to interactive user */
     d sendmsg         pr
     d   msg                        256a

     d i_main          pi
     d   sql                        256a
     d   sqlcod                      10i 0 options(*nopass)

     d msg             s            256a
     d rtn             s             10i 0

      /free

          if input_check();
              rtn = do_request();
          endif;

          sendmsg(msg);

          // return SQLCOD to the caller when parameter sqlcod is specified
          if %parms() > 1;
              sqlcod = rtn;
          endif;

          *inlr = *on;
      /end-free
     /* eof - i_main() */

     /* procedure input_check() */
     p input_check     b
     d input_check     pi              n

      /free
          if sql = *blanks;
              msg = 'Empty SQL statement';
              return *off;
          endif;

          return *on;
      /end-free
     p input_check     e

     /* procedure do_request() */
     p do_request      b

     d q_entry         ds                  qualified
     d   sql                        256a
     d   sqlcod                      10i 0
     d   ch_sqlcod                    4a   overlay(sqlcod)

     d uuid_template   ds                  qualified
     d   bytes_in                    10u 0 inz(32)
     d   bytes_out                   10u 0
     d   reserved                     8a   inz(x'0000000000000000')
     d   uuid                        16a

     d genuuid         pr                  extproc('_GENUUID')
     d   template                      *   value

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
     d key_order       s              2a   inz('EQ')                            /* key order: >= parameter @key */
     d key_len         s              3p 0 inz(16)
     d key             s             16a
     d sender_info...
     d   _len          s              3p 0 inz(0)                               /* no sender info */
     d sender_info     s              1a
     d ec              ds                  likeds(qusec_t)

     d do_request      pi            10i 0
      /free

          // generate UUID
          genuuid(%addr(uuid_template));

          // enqueue DTAQ ISQL
          entry_len = 256;
          qname = 'ISQL';
          q_entry.sql = sql;
          qsnddtaq(  qname
                   : qlib
                   : entry_len
                   : q_entry.sql
                   : key_len
                   : uuid_template.uuid );

          // dequeue DTAQ ISQL
          clear ec;
          ec.bytes_in = 256;
          qname = 'ISQLR';
          entry_len = 4;
          qrcvdtaq(  qname
                   : qlib
                   : entry_len
                   : q_entry.ch_sqlcod
                   : timeout
                   : key_order
                   : key_len
                   : uuid_template.uuid
                   : sender_info_len
                   : sender_info );
          if ec.bytes_out <> 0;
              msg = 'QRCVDTAQ() failed with exception ID: '
                       + ec.exid;
              return -9999;
          endif;

          // set msg according to returned SQLCOD
          if q_entry.sqlcod < 0;
              msg = 'SQL statement failed with SQLCOD '
                       + %char(q_entry.sqlcod);
          elseif q_entry.sqlcod > 0;
              msg = 'SQL statement succeeded with SQLCOD '
                       + %char(q_entry.sqlcod);
          else;
              msg = 'SQL statement succeeded';
          endif;

          return q_entry.sqlcod;
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

     d sendmsg         pi
     d   msg                        256a

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

      /free

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

     /* eof - isqlcpp.rpgle */
