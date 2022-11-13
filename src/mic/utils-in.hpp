/*
This file is part of i5/OS Programmer's Toolkit.

Copyright (C) 2010, 2011  Junlei Li (李君磊).

i5/OS Programmer's Toolkit is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

i5/OS Programmer's Toolkit is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with i5/OS Programmer's Toolkit.  If not, see <http://www.gnu.org/licenses/>.
*/
/**
 * @file utils-in.hpp
 *
 * inline c++ utilities
 */

# ifndef __utils_in_hpp_
# define __utils_in_hpp_

#  include <time.h>
#  include <cpp-common.hpp>

namespace mic {

  /**
   * replace all <var>to_replace</var> in <var>src</var> with
   * <var>replacement</var>.
   *
   * @param[in,out] src, string to be scanned
   * @parma[in] to_replace, ...
   * @parma[in] replacement, ...
   */
  inline
  void replace_all(
                   std::string& src,
                   const char *to_replace,
                   const char *replacement
                   ) {

    size_t to_rep_len = strlen(to_replace);
    size_t rep_len = strlen(replacement);
    size_t pos = 0;
    char *found = NULL;
    char *text = (char*)src.c_str();
    char *start = text;

    found = strstr(text, to_replace);
    while(found != NULL) {

      src.replace(found - start, to_rep_len, replacement);
      text = found + rep_len;

      found = strstr(text, to_replace);
    }
  }

  /**
   * trim from right
   *
   * @return string length after trim
   */
  inline
  size_t trimr(char *str, char* to_trim = _WSS) {

    size_t pos = strcspn(str, to_trim);
    if(pos < strlen(str))
      str[pos] = 0;

    return pos;
  }

  /**
   * returns current time string in format: CYYMMDDHHMMSS
   */
  inline
  void get_current_time13(char *t){
    time_t now;
    time(&now);
    struct tm* p = localtime(&now);
    sprintf(t, "%c%02d%02d%02d%02d%02d%02d",
            (p->tm_year < 100) ? '0' : '1',
            (p->tm_year < 100) ? p->tm_year : (p->tm_year - 100),
            p->tm_mon + 1,
            p->tm_mday,
            p->tm_hour,
            p->tm_min,
            p->tm_sec
            );
  }

  /**
     useful only in runmic.c
  */
  inline
  void
  copy_bytes_with_padding(
                          char* output,
                          const char* source,
                          size_t output_length,
                          char  pad
                          ) {

    // @todo input checking

    size_t cpylen = strlen(source);
    cpylen = (cpylen < output_length) ? cpylen : output_length;

    memset(output, pad, output_length);
    memcpy(output, source, cpylen);

  }

};

# endif // !defined __utils_in_hpp_
