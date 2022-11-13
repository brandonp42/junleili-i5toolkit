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
 * @file mic_ex.hpp
 *
 */

# ifndef __mic_ex_hpp__
# define __mic_ex_hpp__

namespace mic {

  struct exbase_t;
  struct compiler_ex_t;
  struct internal_ex_t;

};

/**
 * base class of MIC's exception classes
 *
 * derived from std::exception, which has the following public methods:
@code
Public Member Functions
    * exception () throw ()
    * virtual const char * what () const throw () 
@endcode

   and

@code
exception() throw() { }
virtual ~exception() throw();
@endcode

 */
struct mic::exbase_t : std::exception {

  typedef enum tag_mic_exception_type {

    unknown     = 0x00,
    information = 0x01,
    compiler    = 0x02,
    internal    = 0x03,
  } mic_ex_type_t;

  /// ctor
  exbase_t(const std::string& ex_info, const std::string& msgid = "") {

    if(msgid.length() == 0)
      ex_info_ = ex_info;
    else
      ex_info_ = "Message ID: " + msgid + ". " + ex_info;

  }

  /// implements ~()
  virtual ~exbase_t() throw() {}

  /// implements what()
  virtual const char* what() throw() {

    return ex_info_.c_str();
  }

  // my pure methods: ... ...

protected:

  std::string ex_info_;

};

/**
 * mic exceptions
 */
struct mic::compiler_ex_t : public mic::exbase_t {

  compiler_ex_t(const std::string& ex_info, const std::string& msgid = "")
    : exbase_t(ex_info, msgid)
  {}

};

/**
 * exceptions throwed by QPRCRTPG
 */
struct mic::internal_ex_t : public mic::exbase_t {

  /**
   * @param ex_info, exception informatoin
   * @param msgid, as/400 message id
   */
  internal_ex_t(const std::string& ex_info, const std::string& msgid = "")
    : exbase_t(ex_info, msgid)
  {
  }

};

# endif
