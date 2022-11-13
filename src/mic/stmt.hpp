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
 * @file stmt.hpp
 */

# ifndef __stmt_hpp__
# define __stmt_hpp__

namespace mic {

  struct stmt_t;

  /// list of stmt_t
  typedef std::list<stmt_t> stmtlist_t;

};

/**
 * ... ....
 */
struct mic::stmt_t {

  friend void phase_a3(stmtlist_t&);

  /// default ctor()
  stmt_t() {

    number_ = 0;
  }

  /**
   * ctor
   */
  stmt_t(
            const std::string& comment,
            const std::string& text
            ) :
    comment_(comment), text_(text)
  {
    number_ = 0;
  }

  /**
   * copy ctor
   */
  stmt_t(const stmt_t& v) {

    comment_ = v.comment_;
    text_ = v.text_;
    number_ = v.number_;
  }

  /// set stmt comment
  void comment(const std::string& v) {

    comment_ = v;
  }

  /// get stmt commnet
  const std::string& comment() const {

    return comment_;
  }

  /// set stmt text
  void text(const std::string& v) {

    text_ = v;
  }

  /// get stmt text
  const std::string& text() const {

    return text_;
  }

  /**
   * @param[in] previous, previous statement number
   *
   * @return statement number of current statement
   */
  int number(int previous) {

    number_ = previous + 1;
    return number_;
  }

  /// return stmt number
  int number() const {

    return number_;
  }

  /**
   * is the current statement PEND
   *
   * valid PEND statement could be:
   * @code
   * PEND;
   * LABEL: PEND;
   * @endcode
   *
   * 这里用的算法是, strtok by white space, 最后部分有PEND开始
   *
   * @attention the current statement has been processed by mic's phase A
   */
  bool is_pend(regex_t *reg) {

    bool r = false;

    regmatch_t m;
    int rtn = regexec(reg, text_.c_str(), 1, &m, 0);
    if(rtn == 0)
      r = true;

    return r;
  }

  /**
   * is the current statement contains builtin invocation
   *
   * examples of builtin invocation
   * @code
   * MULT(S) VV, %INC(IND);
   * %MEMCPY(TARGET-STR, SOURCE-STR, LENGTH);
   * @endcode
   *
   * 这里采用的算法是看是否匹配模式: %.*(.*)
   *
   * @attention the current statement has been processed by mic's phase A
   */
  bool call_builtin(std::string& b_name) {

    bool r = false;

    int rtn = 0;
    char *tmp;
    char *tok;
    const char *pattern =
# ifdef __OS400__
      "\x6C\x4B\x5C\x4D\x4B\x5C\x5D"
# else
      "%.*(.*)"
# endif
      ;
    const char *del =
# ifdef __OS400__
      "\x6C\x40\x4D"
# else
      "% ("
# endif
      ;
    regex_t reg;
    rtn = regcomp(&reg, pattern, 0);
    if(rtn != 0) {

      // throw exception
      return r;
    }

    regmatch_t m;
    rtn = regexec(&reg, text_.c_str(), 1, &m, 0);
    if(rtn == 0) {

      std::string s((text_.c_str() + m.rm_so), m.rm_eo - m.rm_so);
      // get builtin name
      tmp = strdup(s.c_str());
      tmp = strtok_r(tmp, del, &tok);
      if(tmp != NULL) {

        b_name = tmp;
        r = true;
      }
    }

    regfree(&reg);

    return r;
  }

protected:

  std::string comment_;
  std::string text_;
  int number_;

};

# endif // __stmt_hpp__

/* eof - stmt.hpp */
