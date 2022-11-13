     /**
      * @file bldinf.rpgle
      *
      * @todo desc
      */

     h dftactgrp(*no) bnddir('QC2LE')

     fBLDINF    if   e             disk
     fPGMINF    o    e             disk    rename(REC:PGMINFREC)

      /copy regex
     d reg             ds                  likeds(regex_t)
     d pattern         s            100a
     d match           ds                  likeds(regmatch_t)
     d                                     dim(5)
     d cmd_str         s            129a
     d rtn             s             10i 0
     d pos             s             10i 0
     d len             s             10i 0

      /free
           // compile regex pattern
           pattern =
             '^CRT[A-Z]+[[:blank:]]+PGM\(([A-Z0-9]+)\)[[:blank:]]+'
             + 'SRCFILE\(([A-Z0-9]+)/([A-Z0-9]+)\)'
             + x'00';
           rtn = regcomp( reg : pattern : REG_EXTENDED );

           // walk throught the BLDINF table
           dow '1';
               read REC;
               if %eof();
                   leave;
               endif;

               // try to match pattern and the EMAIL field
               cmd_str = BLDCMD + x'00';
               if regexec( reg
                         : cmd_str
                         : 4
                         : match
                         : 0
                          ) = 0;

                   clear PGMINFREC;

                   pos = match(2).rm_so + 1;
                   len = match(2).rm_eo - match(2).rm_so;
                   PGM_NAME = %subst(BLDCMD : pos : len);

                   pos = match(3).rm_so + 1;
                   len = match(3).rm_eo - match(3).rm_so;
                   SRC_LIB = %subst(BLDCMD : pos : len);

                   pos = match(4).rm_so + 1;
                   len = match(4).rm_eo - match(4).rm_so;
                   SRC_FILE = %subst(BLDCMD : pos : len);

                   write PGMINFREC; // write PGMINF
               endif;

           enddo;

           // free pattern
           regfree(reg);

           *inlr = *on;
      /end-free
