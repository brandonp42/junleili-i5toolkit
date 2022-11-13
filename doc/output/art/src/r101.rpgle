     /*
      * @file r101.rpgle
      * enqueue DTAQ Q23(keyed, key length=8, entry length=64)
      */

     /* prototype of API QSNDDTAQ */
     d qsnddtaq        pr                  extpgm('QSNDDTAQ')
     d   qname                       10a
     d   qlib                        10a
     d   entry_len                    5p 0
     d   entry                       64a   options(*varsize)
     d   key_len                      3p 0
     d   key                          8a   options(*varsize)

     d qname           s             10a   inz('Q23')
     d qlib            s             10a   inz('LSBIN')
     d entry_len       s              5p 0 inz(64)
     d entry           s             64a
     d key_len         s              3p 0 inz(8)
     d key             s              8a

      /free
          entry = 'abc';
          key = '00000002';
          qsnddtaq(qname
                   : qlib
                   : entry_len
                   : entry
                   : key_len
                   : key );

          *inlr = *on;
      /end-free
     /* eof */
