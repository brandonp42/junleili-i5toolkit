     /**
      * @file testre.rpgle
      *
      * Test of REGEX (RE) functions.
      *  - read pattern-string and source-string from RE
      *  - write test result into RET
      */

     h dftactgrp(*no) bnddir('QC2LE')

     fRE        if   e           k disk    rename(REC:INREC)
     fRET       o    e             disk    rename(REC:OUTREC)

     d i_main          pr                  extpgm('TESTRE')
     d                                3s 0

      /copy regex
     d reg             ds                  likeds(regex_t)
     d match           ds                  likeds(regmatch_t)
     d                                     dim(2)
     d pattern_str     s            128a
     d src_str         s            128a
     d rtn             s             10i 0
     d pos             s             10i 0
     d len             s             10i 0

     d i_main          pi
     d     inx                        3s 0

      /free
           // read pattern-string and source-string
           chain inx INREC;
           if not %found;
               *inlr = *on;
               return;
           endif;

           // compile regex pattern
           pattern_str = %trimr(PATTERN) + x'00';
             // @attention eleminate useless white spaces from the
             //            right of the RE pattern string.
           rtn = regcomp( reg : pattern_str : REG_EXTENDED );
             // check rtn ...

           src_str = %trimr(SSTR) + x'00';
           MRTN =  regexec( reg
                          : src_str
                          : 1
                          : match
                          : 0 );
           if MRTN = 0;
               pos = match(1).rm_so + 1;
               len = match(1).rm_eo - match(1).rm_so;
               MMATCH = %subst(src_str : pos : len);
           endif;

           MINX = inx;
           MTIM = %timestamp();
           write OUTREC;

           // free pattern
           regfree(reg);

           *inlr = *on;
      /end-free

     /**
      * For example, records in PF RE are like the following:
      * @code
      * INX   PATTERN                          SSTR                                                            
      * ----- -------------------------------- ----------------------------------------------------------------
      *    1  A中[A-Z]+国B                      AAAAAAA中WHENIWASYONG国BBBBBDDDEFEFE                        
      *    2  中国                              A中国B                                                        
      *    3  com\.ibm\.as400\..*\.program     com.ibm.as400.正则表达式- REGEX.program                       
      *    4  fo[o|a]t                         this is his left foot                                           
      * @endcode
      *
      * Call TESTRE like this:
      * @code
      * call testre '001'
      * call testre '002'
      * call testre '003'
      * call testre '004'
      * @endcode
      *
      * Then the test reulst stored in PF RET might like the following:
      * @code
      * MTIM                       MINX  MRTN        MMATCH                                                          
      * -------------------------- ----- ----------- ----------------------------------------------------------------
      * 2011-01-07-10.47.08.070000    1            0 A中WHENIWASYONG国B                                          
      * 2011-01-07-10.47.09.831000    2            0 中国                                                          
      * 2011-01-07-10.47.13.078000    3            0 com.ibm.as400.正则表达式- REGEX.program                       
      * 2011-01-07-10.47.15.718000    4            0 foot                                                            
      * @endcode
      */
