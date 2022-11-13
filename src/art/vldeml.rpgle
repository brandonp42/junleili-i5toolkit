     /**
      * @file vldeml.rpgle
      *
      * Validate email address via RE.
      * @remark If compiled from IFS stream source file (CCSID=819),
      *         the RE functions won't work.
      */

     h dftactgrp(*no) bnddir('QC2LE')

     fCONTACT   uf   e             disk

      /copy regex
     d reg             ds                  likeds(regex_t)
     d pattern         s             50a
     d match           ds                  likeds(regmatch_t)
     d                                     dim(1)
     d                                     based(dummy_ptr)
     d email_str       s            129a
     d rtn             s             10i 0

      /free
           // compile regex pattern
           pattern =
             '^[[:alnum:]._-]+@[[:alnum:]._-]+\.(com|org|net)' + x'00';
           rtn = regcomp( reg : pattern : REG_EXTENDED );

           // walk throught the CONTACT table
           dow '1';
               read REC;
               if %eof();
                   leave;
               endif;

               // try to match pattern and the EMAIL field
               HAS_EMAIL = 'Y';
               email_str = EMAIL + x'00';
               if regexec( reg
                         : email_str
                         : 0
                         : match
                         : 0      // eflags = 0
                          ) <> 0;
                   HAS_EMAIL = 'N';
               endif;

               update REC;
           enddo;

           // free pattern
           regfree(reg);

           *inlr = *on;
      /end-free
