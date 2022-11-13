     /*
      * @file r105.rpgle
      *
      * enqueue DTAQ Q27
      *
      */
     h dftactgrp(*no)

     d i_main          pr                  extpgm('R105')
     d   priority                     2a
     d   delay                        2p 0
     d   msg                         14a

     /* prototype of API QSNDDTAQ */
     d qsnddtaq        pr                  extpgm('QSNDDTAQ')
     d   qname                       10a
     d   qlib                        10a
     d   entry_len                    5p 0
     d   entry                       16a   options(*varsize)
     d   key_len                      3p 0 options(*nopass)
     d   key                          2a   options(*nopass:*varsize)

     d qname           s             10a   inz('Q27')
     d qlib            s             10a   inz('LSBIN')
     d entry_len       s              5p 0 inz(16)
     d key_len         s              3p 0 inz(2)

     /* queue entry format, used both by the client and the server */
     d q_format        ds                  qualified
     d   dly_time                     2p 0                                      /* how long to    */
     d   msg                         14a                                        /* greeting words */

     d i_main          pi
     d   priority                     2a
     d   delay                        2p 0
     d   msg                         14a

      /free

          q_format.dly_time = delay;
          q_format.msg      = msg;
          qsnddtaq(  qname
                   : qlib
                   : entry_len
                   : q_format
                   : key_len
                   : priority );

          *inlr = *on;
      /end-free
     /* eof - r105.rpgle */
