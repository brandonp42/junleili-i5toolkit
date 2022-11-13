     /*
      * @file renq12.rpgle
      *
      * enqueue DTAQ Q12 for 1000 times
      */

     d b               s               z
     d e               s               z
     d ind             s             10i 0
     d dur             s             15p 0

     c                   eval      b = %timestamp()
     c                   for       ind = 1 to 1000  by 1
     c                   call      'QSNDDTAQ'
     c                   parm      'Q12'         qname            10
     c                   parm      'LSBIN'       qlib             10
     c                   parm      64            entlen            5 0
     c                   parm      *all'1'       ent              64
     c                   endfor
     c                   eval      e = %timestamp()
     c                   eval      dur = %diff(e : b : *ms)

     c     'microseconds'dsply                   dur
     c                   seton                                          lr
     /* eof */
