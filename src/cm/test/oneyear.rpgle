     /**
      * @file oneyear.rpgle
      *
      * increase the ages of all experts by 1.
      */
     fEXPERTS   uf   e           k disk

      /free
           setll *loval REC;
           dow '1';
               read REC;
               if %eof(EXPERTS);
                   leave;
               endif;

               AGE += 1;
               update REC;
           enddo;

           *inlr = *on;
      /end-free
