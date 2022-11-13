     /**
      * This file is part of i5/OS Programmer's Toolkit.
      *
      * Copyright (C) 2009  Junlei Li.
      *
      * i5/OS Programmer's Toolkit is free software: you can redistribute it and/or modify
      * it under the terms of the GNU General Public License as published by
      * the Free Software Foundation, either version 3 of the License, or
      * (at your option) any later version.
      *
      * i5/OS Programmer's Toolkit is distributed in the hope that it will be useful,
      * but WITHOUT ANY WARRANTY; without even the implied warranty of
      * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
      * GNU General Public License for more details.
      *
      * You should have received a copy of the GNU General Public License
      * along with i5/OS Programmer's Toolkit.  If not, see <http://www.gnu.org/licenses/>.
      */

     /**
      * @file t037.rpgle
      *
      * test of pthread APIs
      *
      * CL command to run t037:
      * SBMJOB CMD(CALL T037) ALWMLTTHD(*YES)
      *
      * Reply program T037 via MSGQ QSYSOPR.
      */

     h dftactgrp(*no)

      /copy pthread
     d func            pr              *
     d     param                       *   value

     d thd             ds                  likeds(pthread_t)

     d hello           s             16a   inz('ni hao, RPG :p')
     d rtn             s             10i 0
     d status          s               *

      /free

           rtn = pthread_create(%addr(thd)
                               : *null
                               : %paddr(func)
                               : %addr(hello) );
           if rtn <> 0;
               // error handling
           endif;

           pthread_join(thd : status);
           *inlr = *on;
      /end-free

     p func            b
     d func            pi              *
     d     param                       *   value

     d greeting        s             16a   based(param)

      /free

           dsply 'proc func()' '' greeting;

           return *null;
      /end-free
     p func            e
