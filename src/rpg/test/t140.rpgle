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
      * @file t140.rpgle
      *
      * @remark 导出 regex 函数的 srvpgm 是 QC2POSIX
      *
      * Result
      * @code
      * > EVAL match
      *   MATCH.RM_SO(1) = 4
      *   MATCH.RM_SS(1) = 0
      *   MATCH.(1) = '  '
      *   MATCH.RM_EO(1) = 6
      *   MATCH.RM_ES(1) = 0
      *   MATCH.(1) = '  '
      *   MATCH.RM_SO(2) = -1
      *   MATCH.RM_SS(2) = 0
      *   MATCH.(2) = '  '
      *   MATCH.RM_EO(2) = -1
      *   MATCH.RM_ES(2) = 0
      *   MATCH.(2) = '  '
      * @endcode
      */

     h dftactgrp(*no) bnddir('QC2LE')

      /copy regex
     d setlocale       pr              *   extproc('setlocale')
     d     category                  10i 0 value
     d     loc_name                    *   value

     d old_loc         s             64a   based(prtn)
     d cn_loc          s             64a
     d prtn            s               *
     d len             s             10u 0
     d rtn             s             10i 0
     d reg             ds                  likeds(regex_t)
     d pattern         s             16a
     d str             s             32a   inz('abcdAB中CDaaaa')
     d match           ds                  likeds(regmatch_t)
     d                                     dim(2)

      /free
       //  prtn = setlocale(-1 : *null);
       //  cn_loc = '/QSYS.LIB/ZH_CN.LOCALE' + x'00';
       //  prtn = setlocale(-1 : %addr(cn_loc));
           // compile ...
           %str(%addr(pattern) : 16) = 'A.*D';
           rtn = regcomp(reg : pattern : 0);

           str = *allx'00';
           %str(%addr(str) : 16) =
             'aaaaAB' + x'8586' + 'CDbbb';
           rtn = regexec(reg : str : 2 : match : 0);

           str = *allx'00';
           %str(%addr(str) : 16) =
             'aaaaAB' + x'0506' + 'CDbbb';
           rtn = regexec(reg : str : 2 : match : 0);

           str = *allx'00';
           %str(%addr(str) : 16) =
             'aaaaAB中CDbbbb';
           rtn = regexec(reg : str : 2 : match : 0);

           // binary match
           pattern = *allx'00';
           %str(%addr(pattern) : 16) =
             x'5A' + '.*' + x'E6';
         //  x'5AE6' + '.*' + x'5AC1';
         //  x'0E5AE6' + '.*' + x'5AC10F';
           rtn = regcomp(reg : pattern : 0);
           str     = *allx'00';
           %str(%addr(str) : 16) =
             'aa' + x'5A' + 'aaa' + x'E6';
           rtn = regexec(reg : str : 2 : match : 0);

           // binary match with SO, SI
           pattern = *allx'00';
           %str(%addr(pattern) : 16) =
             '早上';
           rtn = regcomp(reg : pattern : 0);
           str     = *allx'00';
           %str(%addr(str) : 32) =
             'start' +
             '早上' + 'middle' + '晚上' + 'end';
           rtn = regexec(reg : str : 2 : match : 0);

           regfree(reg);

           // binary match -- UTF-8
           pattern = *allx'00';
           %str(%addr(pattern) : 16) =
             x'E4BDA0';  // 你
           rtn = regcomp(reg : pattern : 0);
           str     = *allx'00';
           %str(%addr(str) : 32) =
             x'6162E4BDA0E5A5BD6364'; // ab你好cd

           rtn = regexec(reg : str : 2 : match : 0);

           regfree(reg);
           *inlr = *on;
      /end-free
