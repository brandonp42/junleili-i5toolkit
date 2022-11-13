     /*
      * @file renq11.rpgle
      *
      * call PGM ENQ11 for 1000 times
      */

     d b               s               z
     d e               s               z
     d ind             s             10i 0
     d dur             s             15p 0

     c                   eval      b = %timestamp()
     c                   call      'ENQ11'
     c                   eval      e = %timestamp()
     c                   eval      dur = %diff(e : b : *ms)

     c     'microseconds'dsply                   dur
     c                   seton                                          lr
     /* eof - renq11.rpgle */
