     /*
      * @file savjoblog.rpgle
      *
      * @remark 需要退出时，向DTAQ JOBLOGNTF入列个QUIT
      *          e.g. CALL PGM(QSNDDTAQ) PARM('JOBLOGNTF'
      *                 'LSBIN' X'00010F' 'QUIT')
      *
      */
     h dftactgrp(*no)

     /*
      * dequeue a notification message from DTAQ JOBLOGNTF
      *
      * @return *on if okey, *off if notified to quit.
      */
     d deq_notify      pr              n
     /*
      * copy joblog to PF JOBLOG;
      * delete spooled file.
      */
     d wrk_with_splf   pr

     /* Notification information */
     d notify          ds           128    qualified
     d   func_code                   10a
     d   rec_type                     2a
     d   job_id                      26a
     d   splf_name                   10a
     d   splf_num                    10i 0

      /free

          dow deq_notify();
              wrk_with_splf();
          enddo;

          *inlr = *on;
      /end-free

     /* deq_notify() */
     p deq_notify      b
     /* prototype of API QRCVDTAQ */
     d qrcvdtaq        pr                  extpgm('QRCVDTAQ')
     d   qname                       10a
     d   qlib                        10a
     d   qentrylen                    5p 0
     d   qentry                     128a
     d   timeout                      5p 0

     d qname           s             10a   inz('JOBLOGNTF')
     d qlib            s             10a   inz('LSBIN')
     d qentrylen       s              5p 0 inz(128)
     d timeout         s              5p 0 inz(-1)
     d quit            c                   'QUIT'

     d deq_notify      pi              n

      /free

          qrcvdtaq( qname
                   : qlib
                   : qentrylen
                   : notify
                   : timeout );

          if %subst(notify.func_code : 1 : 4) = quit;
              return *off;
          endif;

          return *on;
      /end-free
     p deq_notify      e

     p wrk_with_splf   b
     /* prototype of API QCMDEXC */
     d qcmdexc         pr                  extpgm('QCMDEXC')
     d   cmdstr                     128    options(*varsize)
     d   cmdlen                      15p 5

     d cmd             s            128a
     d len             s             15p 5
     d jid             s             28a

      /free

          jid = %subst(notify.job_id:21:6)
                + '/'
                + %trim(%subst(notify.job_id:11:10))
                + '/'
                + %trim(%subst(notify.job_id: 1:10));

          monitor;

          // copy spooled file to PF JOBLOG
          cmd = 'CPYSPLF FILE('
                + %trim(notify.splf_name)
                + ') TOFILE(LSBIN/JOBLOG) JOB('
                + %trim(jid)
                + ') SPLNBR('
                + %char(notify.splf_num)
                + ') MBROPT(*ADD)';
          len = %len(%trim(cmd));
          qcmdexc(cmd : len);

          // delete spooled file
          cmd = 'DLTSPLF FILE('
                + %trim(notify.splf_name)
                + ') JOB('
                + %trim(jid)
                + ') SPLNBR('
                + %char(notify.splf_num)
                + ') ';
          len = %len(%trim(cmd));
          qcmdexc(cmd : len);

          on-error;
          endmon;

      /end-free
     p wrk_with_splf   e
     /* eof */
