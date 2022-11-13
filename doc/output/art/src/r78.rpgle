     /*
      * @file r78.rpgle
      *
      * 操作user queue Q31, 和r104.rpgle配着用吧
      */
     h dftactgrp(*no)

     d i_main          pr                  extpgm('R78')
     d   key                          8a   options(*varsize)

     /* prototype of MI instruction RSLVSP */
     d rslvsp          pr                  extproc('_RSLVSP2')
     d   syp                           *
     d   option                        *   value

     d q               s               *
     d option          ds            34    qualified
     d   type                         2a   inz(x'0A02')
     d   name                        30a   inz('Q31')
     d   auth                         2a   inz(x'0000')

     d deq             pr                  extproc('_DEQWAIT')
     d   prefix                        *   value
     d   text                          *   value
     d   q                             *

     d prefix          ds            37    qualified
     d   enqueue_time                 8a
     d   timeout                      8a
     d   text_len                    10i 0
     d   acc_sts                      1a   inz(x'D8')
     d   key_in                       8a
     d   key_out                      8a

     d text            s             64a
     d msg             s             16a

     d i_main          pi
     d   key                          8a   options(*varsize)
      /free

          // rlsvsp
          rslvsp(q : %addr(option));

          // deq
          prefix.key_in = key;
          deq(%addr(prefix) : %addr(text) : q);
          msg = %subst(text : 1 : 16);

          dsply prefix.key_out '' msg;
          *inlr = *on;
      /end-free
     /* eof */
