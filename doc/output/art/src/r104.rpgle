     /*
      * @file r104.rpgle
      *
      * enqueue USRQ Q31
      */
     h dftactgrp(*no)

     /* my protoype */
     d i_main          pr                  extpgm('R104')
     d   p_key                        8a
     d   p_text                      64a

     d q               s               *
     d option          ds            34    qualified
     d   type                         2a   inz(x'0A02')                         /* USRQ's MI object type: hex 0A02 */
     d   name                        30a   inz('Q31')                           /* USRQ name */
     d   auth                         2a   inz(x'0000')
     /* prototype of MI instruction RSLVSP */
     d rslvsp          pr                  extproc('_RSLVSP2')
     d   syp                           *
     d   option                        *   value
     /* prototype of MI instruction ENQ */
     d enq             pr                  extproc('_ENQ')
     d   q                             *
     d   prefix                        *   value
     d   text                          *   value

     d prefix          ds                  qualified                            /* message prefix */
     d   text_len                    10i 0                                      /* length of message text */
     d   key                          8a   inz('00000001')                      /* key data */
     d text            s             64a   inz('hi, i''m rpg program R104:p')   /* message text */

     d i_main          pi
     d   p_key                        8a
     d   p_text                      64a

      /free

          rslvsp(q : %addr(option));

          prefix.key = p_key;
          text = p_text;
          enq(q : %addr(prefix) : %addr(text));

          *inlr = *on;
      /end-free
     /* eof - r104.rpgle */
