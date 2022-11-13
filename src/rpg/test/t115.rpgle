     /**
      * This file is part of i5/OS Programmer's Toolkit.
      *
      * Copyright (C) 2010, 2011  Junlei Li.
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
      * @file t115.rpgle
      *
      * Test of TESTEAU.
      */

     h dftactgrp(*no)

      /copy mih52
     d rel_inv         s              5i 0
     d auth_rtn        ds                  likeds(testeau_auth_tmpl_t)
     d auth_req        ds                  likeds(testeau_auth_tmpl_t)
     d rtn             s             10i 0

      /free
           auth_req = *allx'00';
           setbts(%addr(auth_req.spec_auth_tmpl)
                 : 0); // special auth *ALLOBJ

           rtn = testeau3(auth_rtn : auth_req);
           rtn = testeau4(auth_req);

           *inlr = *on;
      /end-free
