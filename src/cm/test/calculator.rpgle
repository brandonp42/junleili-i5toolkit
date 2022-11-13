     /**
      * @file calculator.rpgle
      *
      * call CLLE module CALCULATE.
      */
     d val             s             15p 5
     d rtn             s             15p 5

     c     'input value' dsply                   val
     c                   callb     'CALCULATE'
     c                   parm                    rtn
     c                   parm                    val
     c     'result value'dsply                   rtn
     c                   seton                                        lr
