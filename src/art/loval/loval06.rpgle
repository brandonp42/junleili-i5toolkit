     fLOVAL05   if   e           k disk

     d                 ds
     d a                              4a   inz(x'FF800000')
     d neg_inf                        4f   overlay(a)

      /free
           setll *start LOVAL05;
           read REC;
           dsply 'INF REC' '' A1;

           setll neg_inf REC;
           reade neg_inf REC;
           if not %eof();
               dsply 'INF REC' '' A1;
           endif;

           *inlr = *on;
      /end-free
