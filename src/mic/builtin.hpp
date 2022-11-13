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
 * @file builtin.hpp
 *
 * describes a mic builtin
 */

# ifndef __builtin_hpp__
# define __builtin_hpp__

namespace mic {

  struct builtin_t;

  /// map of builtin_t
  typedef std::map<std::string, builtin_t> builtinmap_t;

};

/**
 * mic builtin
 */
struct mic::builtin_t {

  friend void load_builtins(builtinmap_t&);

  /// ctor
  builtin_t(
            const std::string& name,
            const std::string& bnum,
            unsigned short num_parms = 0
            ) {

    name_ = name;
    bnum_ = bnum;
    num_parms_ = num_parms;
  }

  /**
     replace user code with CALLIs
      - parse user's builin invocation: e.g. %memcpy(str, "huhu", 4);
      - 用regexp, strtok_r取出参数和参数个数，个数不对throw exception
      - 对rep_stmts_中各 stmt 做参数替换, :1, :2, ....
      - remove掉 stmt 中 user code，insert 替换后的 stmt 集合
        - 对于builtin return value被用作operand的 stmt，不remove,
          在 stmt 中替换 builtin 调用为 builtin return value
      - body呢? 应该在参数中加个 builtin_section，指最终出现在
        source stream里的整个 builtin section, 含所有builtins，
        那么，一个builtin是否已经在这里出现过如何标识?

     procedure
     @code
     stmt_t& stmt = *it;
     // parse 出 builtin invocation 字串
     // regex: '%.*(.*)'
     string b_inv_str(stmt.text().c_str() + start, length);

     // 是否用作instruction operand，看
     bool as_operand = false;

     // parse 出builtin调用参数列表 op_list
     // 如果参数个数不符，throw exception

     // 遍历 rep_stmts_，COPY构造新stmt_t rr ，用 op_list 中各参数替换 rr 中 :1, :2, ... :n
     // 之后，将替换后的 rr 插入 stmts (by it)

     // 替换 b_inv_str
     string text = stmt.text();
     if(as_operand)
       text.replace(start, length, @nnnn-#RTN); // builtin_t::rtn_val_name()
     else
       text.replace();
     stmt.text(text);

     // 处理 b_used，找(by name)，没有则 push_back

     @endcode

   */
  void replace(
               stmtlist_t& stmts,
               stmtlist_t::iterator it,
               stringlist_t& b_used
               );

  /**
   * returns the name of a builtin's return value
   */
  std::string return_value_name() {

# ifdef __OS400__
    std::string r("\x7C");
    r += bnum_ + "\x60\x7B\xD9\xE3\xD5";
# else
    std::string r("@");
    r += bnum_ + "-#RTN";
# endif

    return r;
  }

  /// returns builtin body
  const stmtlist_t& body() { return body_; }

protected:

  /// builtin name
  std::string name_;

  /// builtin number
  std::string bnum_;

  /// 用于替换的 stmt 集合
  stmtlist_t rep_stmts_;

  /// builtin body
  stmtlist_t body_;

  /// number of builtin parameters
  unsigned short num_parms_;

};

# endif // !defined __builtin_hpp__
/* eof - builtin.hpp */
