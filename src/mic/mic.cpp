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
 * @file mic.cpp
 *
 */

# include <mic.hpp>

# include <unistd.h>
# include <fcntl.h>

# ifdef __OS400__
#   include <qprcrtpg.h>
#   include <qusec.h>
#   include <qmhrtvm.h>
#   include <qmhsndpm.h>
#   include <qusrjobi.h>
#   include <quslspl.h>
#   include <quscrtus.h>
#   include <qusptrus.h>
#   include <recio.h>
#   include <quscrtui.h>
#   include <qusaddui.h>
#   include <qusrtvui.h>
# else
#   include <os400-mock.h>
# endif

/// EMI/MIC version number, used internally
unsigned short mic_version_ = 0x0002;

/**
 * map from builtin-name to builtin-number
 *
 * entry format:
 *  - builtin name, char(30)
 *  - builtin number, char(4), nnnn, 表示ubin(2)
 */
char builtin_name_number_map_[] = {

  "MEMCPY                        0001"
  "SENDMSG                       0002"
};

char* mic::get_builtin_number_by_name(const char *name) {

  using namespace mic;

  char number[4 + 1] = {0};
  char bname[_MAX_MIC_BUILTIN_NAME + 1] = {0};
  copy_bytes_with_padding(bname, name, _MAX_MIC_BUILTIN_NAME, _WS);

  char *pos = strstr(builtin_name_number_map_, bname);
  if(pos == NULL)
    return NULL;

  pos += _MAX_MIC_BUILTIN_NAME;

  memcpy(number, pos, 4);

  return NULL; //strdup(number);
}

void mic::phase_a0(const char *input, char *output, size_t len) {

  int i = 0, j = 0;
  char *cur = (char*)input;
  bool cmt = false;
  char *end_cmt = NULL;

  memset(output, 0, len);

  for(i = 0; i < len && *(cur + 1) != 0; i++, cur++) {

    if(cmt) {

      // find end-comment sequence '*/'
      if(strncmp(cur, _END_OF_COMMENT, 2) == 0) {

        cmt = !cmt;
        cur += 1;
      }

      continue;

    } else {

      if(strncmp(cur, _BEGIN_OF_COMMENT, 2) == 0) {

        cmt = !cmt;
        cur += 1;
        continue;
      }

      // control characters
      if(strchr(_CONTROL_CHARS, *cur) != NULL)
        output[j] += _WS;
      else
        output[j] += *cur;
      j++;
    }
  }

} // end of phase_a0()

size_t mic::phase_a1(mic::stmtlist_t& stmts, char* input) {

  using namespace std;

  char *tok;
  const char *delimiter = _STMT_DELIMITER;
  char *cur = strtok_r(input, delimiter, &tok);
  string text;
  while(cur != NULL) {

    if(strspn(cur, _WSS) == strlen(cur)) { // in case of empty statement

      cur = strtok_r(NULL, delimiter, &tok);
      continue;
    }

    text = cur;
    text += _STMT_DELIMITER;
    stmts.push_back(stmt_t("", text));

    cur = strtok_r(NULL, delimiter, &tok);
  }

  return stmts.size();

} // end of phase_a1()

bool mic::is_include(const std::string& s, std::string& inc_path)
  throw(mic::compiler_ex_t, mic::internal_ex_t)
{

  using namespace std;
  using namespace mic;

  string ex_info;
  char c = _SLASH;
  char *text = strdup(s.c_str());

  // leading '/'
  size_t pos = strspn(text, _WSS);
  if(text[pos] != _SLASH)
    return false;

  // keyword include
  // tokenize by: '/', ' ', '"'
  char *tok;
  char inc_delimiters[] =
# ifdef __OS400__
    "\x61\x40\x7F";
# else
    "/ \"";
# endif
  char *str = strtok_r(text, inc_delimiters, &tok);
  if(strcmp(str, _KEYWORD_INCLUDE) != 0)
    return false;

  // determine path name of the source unit to include
  int offset = str - text;
  text = strdup(s.c_str());
  text += offset + strlen(_KEYWORD_INCLUDE);

  regex_t reg;
  regex_t reg2;
  char *pattern =
# ifdef __OS400__
    "\x7F\x4B\x5C\x7F";
# else
    "\".*\"";
# endif
  char *pattern2 =
# ifdef __OS400__
    "\xBA\xB0\x40\xBB\x5C\xBA\xB0\x5E\x40\xBB";
# else
    "[^ ]*[^; ]";
# endif
  int r = regcomp(&reg, pattern, 0);
  if(r != 0) {

    ex_info = "regcomp() failed, pattern -- ";
    ex_info += pattern;
    throw internal_ex_t(ex_info);
  }

  r = regcomp(&reg2, pattern2, 0);
  if(r != 0) {

    ex_info = "regcomp() failed, pattern -- ";
    ex_info += pattern2;
    throw internal_ex_t(ex_info);
  }

  regmatch_t m;
  r = regexec(&reg, text, 1, &m, 0);
  regfree(&reg);

  if(r == 0) {
    inc_path = string((text + m.rm_so + 1), m.rm_eo - m.rm_so - 2); // erase \"
  } else {

    // try pattern2
    r = regexec(&reg2, text, 1, &m, 0);
    regfree(&reg2);
    if(r != 0) {

      ex_info = "invalid include directive -- ";
      ex_info += s;
      throw compiler_ex_t(ex_info);
    }

    inc_path = string((text + m.rm_so), m.rm_eo - m.rm_so);
  }

  return true;

} // end of is_include()

bool mic::phase_a2(
                   mic::stmtlist_t& stmts,
                   const mic::stringlist_t& inc_dirs,
                   int& depth
                   )
  throw(mic::compiler_ex_t)
{

  using namespace std;
  using namespace mic;

  bool has_include = false;
  string stmt;
  string inc_path;
  string ex_info;

  stmtlist_t::iterator it = stmts.begin();
  stmtlist_t::iterator it_tmp;
  while(it != stmts.end()) {

    stmt = it->text();
    if(is_include(stmt, inc_path)) {

      // load included source unit
      string source = read_source_file(inc_path, inc_dirs);

      // do phase_a0() on included source unit
      const char *in = source.c_str();
      size_t len = strlen(in);
      char *out = (char*)malloc(len);

      phase_a0(in, out, len);

      // do phase_a1() on included source unit
      stmtlist_t l;
      phase_a1(l, out);
      free(out);

      // insert statements of included source unit into stmts
      string inc_title("/* ");
      inc_title += inc_path + " */";
      stmts.insert(it, stmt_t(inc_title, ""));
      stmts.insert(it, l.begin(), l.end());

      has_include = true;

      // erase include statement
      it_tmp = it;
      ++it_tmp;

      stmts.erase(it);
      it = it_tmp;

      if(it_tmp == l.end())
        break;
      else
        continue;
    } // end of if(is_include())

    ++it;
  }

  return has_include;
}

void mic::phase_a3(mic::stmtlist_t& l) {

  using namespace std;

  mic::stmtlist_t::iterator it = l.begin();
  for(; it != l.end(); ++it) {

    string& text = it->text_;
    char q_c = 0;
    bool quote = false;
    string::iterator istr = text.begin();
    for(; istr != text.end(); ++istr) {

      char& ch = *istr;

      if(quote) {

        if(ch == q_c)
          quote = false;

        continue;
      } else {

        if(ch == '\'') {

          q_c = ch;
          quote = true;
          continue;
        }

        if(ch == '"') {

          q_c = ch;
          quote = true;
          continue;
        }

        ch = toupper(ch);
      }

    }

  } // end of for(it)

} // end of phase_a3()

bool
mic::is_cond_directive(
                       const std::string &s,
                       mic::cond_directive_type_t &dir_type,
                       std::string &operand
                       ) throw(mic::compiler_ex_t)
{

  using namespace std;
  using namespace mic;

  string ex_info;
  char c = _SLASH;
  char *text = strdup(s.c_str());

  // leading '/'
  size_t pos = strspn(text, _WSS);
  if(text[pos] != _SLASH)
    return false;

  // keyword include
  // tokenize by: '/', ' ', ';'
  char *tok;
  char delimiters[] =
# ifdef __OS400__
    "\x61\x40\x5E";
# else
    "/ ;";
# endif
  char *str = strtok_r(text, delimiters, &tok);
  if(str == NULL)
    return false;

  // set dir_type
  bool check_operand = true;
  if(strcmp(str, _KEYWORD_DEFINE) == 0) // define
    dir_type = directive_define;

  else if(strcmp(str, _KEYWORD_UNDEF) == 0) // undef
    dir_type = directive_undef;

  else if(strcmp(str, _KEYWORD_IFDEF) == 0) // ifdef
    dir_type = directive_ifdef;

  else if(strcmp(str, _KEYWORD_IFNDEF) == 0) // ifndef
    dir_type = directive_ifndef;

  else if(strcmp(str, _KEYWORD_ENDIF) == 0) { // endif

    dir_type = directive_endif;
    check_operand = false;
  }
  else if(strcmp(str, _KEYWORD_ELSE) == 0) { // else

    dir_type = directive_else;
    check_operand = false;
  }
  else
      dir_type = directive_unknown;

  if(check_operand) {

    str = strtok_r(NULL, delimiters, &tok);
    if(str == NULL) // throw exception
      throw compiler_ex_t("directives /define, /undef, /ifdef, /ifndef should be followed by a macro name.");

    operand = str;
  }

  return true;

} // end of is_cond_directive()

bool mic::and_bool_stack(const std::stack<bool>& stk) {

  std::stack<bool> s(stk);
  while(!s.empty()) {

    if(!s.top())
      return false;

    s.pop();
  }

  return true;
}



void mic::phase_a4(mic::stmtlist_t& stmts) {

  using namespace std;
  using namespace mic;

  // condition collection
  typedef std::list<std::string> condlist_t;
  condlist_t conds;

  // condition stack
  typedef std::stack<bool> condstack_t;
  condstack_t stk;

  // ... ...
  cond_directive_type_t dir_type;
  string macro;
  condlist_t::iterator it = conds.end();
  bool status = false;
  bool erase = false;

  stmtlist_t::iterator it_stmt = stmts.begin();
  while(it_stmt != stmts.end()) {

    erase = false;
    const char *text = it_stmt->text().c_str();

    if(is_cond_directive(it_stmt->text(), dir_type, macro)) {

      erase = true;

      switch(dir_type) {
      case directive_define:
        if(and_bool_stack(stk)) // works only when *on
          conds.push_back(macro);
        break;
      case directive_undef:
        if(and_bool_stack(stk)) { // works only when *on
          it = find(conds.begin(), conds.end(), macro);
          conds.erase(it);  // erase MACRO from conds
        }
        break;
      case directive_ifdef:
        if(and_bool_stack(stk)) { // works only when *on
          it = find(conds.begin(), conds.end(), macro);
          status = (it != conds.end());
          stk.push(status);
        } else
          stk.push(false);
        break;
      case directive_ifndef:
        if(and_bool_stack(stk)) { // works only when *on
          it = find(conds.begin(), conds.end(), macro);
          status = (it == conds.end());
          stk.push(status);
        } else
          stk.push(false);
        break;
      case directive_endif:
        stk.pop();
        break;
      case directive_else:
        if(and_bool_stack(stk)) // works only when *on
          stk.top() = !stk.top();
        break;
      default:
        break;
      }

    } // if is conditional directives
    else {

      if(!stk.empty() && !and_bool_stack(stk))
        erase = true;

    }

    if(erase)
      it_stmt = stmts.erase(it_stmt);
    else
        ++it_stmt;

  } // while()

} // end of phase_a4()

std::string
mic::read_source_file(
                      const std::string& src_path,
                      const mic::stringlist_t& inc_dirs
                      )
  throw(mic::compiler_ex_t)
{

  using namespace std;
  using namespace mic;

  string ex_info;
  bool absolute = false;
  string path = src_path;

  // check path_
  size_t len = path.length();
  if(len < 1) // empty path name
    throw compiler_ex_t("empty source file path name");

  if(path.at(0) == _SLASH) {

    absolute == true;
    if(len < 2) // empty absolute path name
      throw compiler_ex_t("empty source file path name");
  }

  int job_ccsid = get_job_ccsid();

  // try path first
  bool opened = false;
  int fd = open(path.c_str(), O_RDONLY | O_TEXTDATA | O_CCSID, 0, job_ccsid);
  if(fd != -1)
    opened = true;
  else if(!absolute) { // relative path name

    // try directory names stored in inc_dirs
    stringlist_t::const_iterator it = inc_dirs.begin();
    for(; it != inc_dirs.end(); ++it) {

      string dir(*it);
      len = dir.length();
      if(dir.at(len - 1) != _SLASH)
        dir += _SLASH;

      path = dir + src_path;

      fd = open(path.c_str(), O_RDONLY | O_TEXTDATA | O_CCSID, 0, job_ccsid);
      if(fd != -1) {

        opened = true;
        break;
      }
    }

    if(!opened) {

      ex_info = "failed to read source file -- ";
      ex_info += src_path;
      throw compiler_ex_t(ex_info);
    }
  }

  // read source unit
  string source;
  char ch = 0;
  while(read(fd, &ch, 1) > 0)
    source += ch;

  close(fd);

  return source;
}

void mic::phase_a(
                  const char* source,
                  mic::stmtlist_t& stmts,
                  mic::stringlist_t inc_dirs
                  ) {

  int len = strlen(source);
  char *out = (char*)malloc(len);

  phase_a0(source, out, len);
  phase_a1(stmts, out);
  free(out);

  bool has_include = true;
  int depth = 0;
  while( has_include && depth < MAX_INCLUDE_DEPTH )
    has_include =
      phase_a2(
               stmts,
               inc_dirs,
               depth
               );

  // make upper
  phase_a3(stmts);

  // conditional directives
  phase_a4(stmts);

}

void mic::load_builtins(mic::builtinmap_t& m) {

  using namespace mic;
  using namespace std;

  static const int ent_len_len = 8 + _MIC_MAX_BUILTIN_STMTS * 8;

  // load all builtins
  char ecbuf[_MIC_ECLEN] = {0};
  Qus_EC_t *ec = (Qus_EC_t*)ecbuf;
  int bytes_returned;
  int bytes_avail;
  char *empty = NULL;
  int rtn_entries = 0;
  char lib_rtn[11] = {0};
  char search_criteria_between[_MIC_BUILTIN_KEY * 2] = {0};
  char search_criteria_equal[_MIC_BUILTIN_KEY] = {0}; // here-today
  int search_type = 1; // 1=equal, 8=between
  char *output = NULL;
  int i = 0;
  int ind = 0;
  char *stmt_ptr = NULL;
  string ex_info;

  ec->Bytes_Provided = _MIC_ECLEN;

  // allocate a large enough 'Entry lengths and entry offsets' buffer
  empty = (char*)malloc(ent_len_len);

  // read index header: key == x'00,00000000,0000'
  output = (char*)malloc(8 + _MIC_BUILTIN_INX_LEN);
  // set key value
  memset(search_criteria_equal, 0, _MIC_BUILTIN_KEY);
  search_type = 1;
  QUSRTVUI(
           output,
           _MIC_BUILTIN_INX_LEN,
           empty,
           ent_len_len,
           &rtn_entries,
           lib_rtn,
           _EMI_BUILTIN_INDEX,
           "IDXE0100",
           1,     // we need only one entry
           search_type,  // 1=equal
           search_criteria_equal,   // key == x'00,00000000,0000'
           _MIC_BUILTIN_KEY,
           0,
           ec
           );
  if(rtn_entries == 0 || ec->Bytes_Available != 0) {

    free(output);
    free(empty);
    throw internal_ex_t("failed in read EMI/MIC builtin index");
  }

  builtin_index_t inxh;
  memcpy(&inxh, output + 8, _MIC_BUILTIN_INX_LEN);
  free(output);

  // check inxh.min_mic_ver_, inxh.max_mic_ver_, throw exception
  if(mic_version_ > inxh.max_mic_ver_ || mic_version_ < inxh.min_mic_ver_) {

    throw internal_ex_t("invalid EMI/MIC builtin index version");
  }

  /*
   * read each builtin header: key == x'01,000000Fn,0000'
   *
   * pre-condition: inxh.num_builtins_
   */
  for(i = 0; i < inxh.num_builtins_; i++) {

    search_type = 1;  // 1=equal
    output = (char*)malloc(8 + _MIC_BUILTIN_INX_LEN);
    sprintf(search_criteria_equal, "\x01%04X\x00\x00", i);

    // read each builtin header
    QUSRTVUI(
             output,
             _MIC_BUILTIN_INX_LEN,
             empty,
             ent_len_len,
             &rtn_entries,
             lib_rtn,
             _EMI_BUILTIN_INDEX,
             "IDXE0100",
             1,            // we need only one entry, the builtin header
             search_type,  // 1=equal
             search_criteria_equal,   // key == x'01,000000Fn,0000'
             _MIC_BUILTIN_KEY,
             0,
             ec
             );
    if(rtn_entries == 0 || ec->Bytes_Available != 0) {

      free(output);
      free(empty);

      ex_info = "failed to read builtin header: " + string(search_criteria_equal + 1, 4);
      throw internal_ex_t(ex_info);
    }

    builtin_header_t bh;
    memcpy(&bh, output + 8, _MIC_BUILTIN_INX_LEN);
    free(output);

    // instantiate a builtin_t
    builtin_t b(
                string(bh.builtin_name_),
                string(bh.builtin_num_, 4),
                bh.num_param_
                );

    // read builtin's replacement stmts
    int ind = 0;
    search_type = 8;
    int output_len = 8 + _MIC_BUILTIN_INX_LEN * bh.num_rep_stmt_;
    output = (char*)malloc(output_len);
    // first criteria
    memcpy(search_criteria_between, "\x02\x00\x00\x00\x00\x00\x00", _MIC_BUILTIN_KEY);
    memcpy(search_criteria_between + 1, bh.builtin_num_, 4);
    // second criteria
    sprintf(search_criteria_between + _MIC_BUILTIN_KEY,
            "\x02%4.4s",
            bh.builtin_num_
            );
    *(unsigned short*)(search_criteria_between + _MIC_BUILTIN_KEY + 5) =
      bh.num_rep_stmt_ - 1;
    QUSRTVUI(
             output,
             output_len,
             empty,
             ent_len_len,
             &rtn_entries,
             lib_rtn,
             _EMI_BUILTIN_INDEX,
             "IDXE0100",
             4095,         // max number of entries
             search_type,  // 1=equal
             search_criteria_between,
             _MIC_BUILTIN_KEY,
             _MIC_BUILTIN_KEY,
             ec
             );

    char *stmt_ptr = output + 8;
    for(ind = 0;
        rtn_entries != 0 && ind < bh.num_rep_stmt_;
        ind++, stmt_ptr += _MIC_BUILTIN_INX_LEN) {

      b.rep_stmts_.push_back(stmt_t("", string(stmt_ptr + _MIC_BUILTIN_KEY)));

    }
    free(output);

    // read builtin's body stmts
    search_type = 8;
    output_len = 8 + _MIC_BUILTIN_INX_LEN * bh.num_body_stmt_;
    output = (char*)malloc(output_len);
    // first criteria
    memcpy(search_criteria_between, "\x03\x00\x00\x00\x00\x00\x00", _MIC_BUILTIN_KEY);
    memcpy(search_criteria_between + 1, bh.builtin_num_, 4);
    // second criteria
    sprintf(search_criteria_between + _MIC_BUILTIN_KEY,
            "\x03%4.4s",
            bh.builtin_num_
            );
    *(unsigned short*)(search_criteria_between + _MIC_BUILTIN_KEY + 5) =
      bh.num_body_stmt_ - 1;
    QUSRTVUI(
             output,
             output_len,
             empty,
             ent_len_len,
             &rtn_entries,
             lib_rtn,
             _EMI_BUILTIN_INDEX,
             "IDXE0100",
             4095,         // max number of entries
             search_type,  // 1=equal
             search_criteria_between,
             _MIC_BUILTIN_KEY,
             _MIC_BUILTIN_KEY,
             ec
             );
    stmt_ptr = output + 8;
    for(ind = 0;
        rtn_entries != 0 && ind < bh.num_body_stmt_;
        ind++, stmt_ptr += _MIC_BUILTIN_INX_LEN) {

      b.body_.push_back(stmt_t("", string(stmt_ptr + _MIC_BUILTIN_KEY)));

    }
    free(output);

    // insert builtin b into builtinmap_t m
    m.insert(builtinmap_t::value_type(string(bh.builtin_name_), b));

  } // end of for(inxh.num_builtins_)

  free(empty);

}

void mic::phase_b(
                  mic::stmtlist_t& stmts,
                  mic::builtinmap_t& b_map
                  )
  throw(mic::compiler_ex_t, mic::internal_ex_t)
{

  using namespace mic;
  using namespace std;

  string b_name;
  stringlist_t b_used;
  string ex_info;
  stmtlist_t::iterator it_pend = stmts.end();
  regex_t reg;

  if(regcomp(&reg, "PEND[ ]*;", 0) != 0)
    throw internal_ex_t("regcomp() failed in mic's phase b");

  stmtlist_t::iterator it = stmts.begin();
  builtinmap_t::iterator b_it;
  for(; it != stmts.end(); ++it) {

    stmt_t& s = *it;

    // pend?
    if(s.is_pend(&reg)) {

      it_pend = it;
      break;
    }

    // call builtin?
    if(s.call_builtin(b_name)) {

      b_it = b_map.find(b_name);
      if(b_it == b_map.end()) {

        ex_info = "undefined builtin name -- ";
        ex_info += b_name;
        regfree(&reg);
        throw compiler_ex_t(ex_info);
      }

      builtin_t &b = b_it->second;
      b.replace(stmts, it, b_used);
    }
  }

  if(it_pend == stmts.end()) {

    ex_info = "PEND instruction missed";
    ex_info += b_name;
    regfree(&reg);
    throw compiler_ex_t(ex_info);
  }

  stringlist_t::iterator s_it = b_used.begin();
  for(; s_it != b_used.end(); ++s_it) {

    b_it = b_map.find(*s_it);
    if(b_it == b_map.end())
      ; // throw exception, un-defined builtin name; but it seems IMPOSSIBLE

    builtin_t &b = b_it->second;
    stmts.insert(it_pend, b.body().begin(), b.body().end());
  }

  regfree(&reg);

}

void mic::dump_stmts(
                     const mic::stmtlist_t& stmts,
                     std::string& output
                     ) {

  using namespace std;
  using namespace mic;

  output.clear();

  stmtlist_t::const_iterator it = stmts.begin();
  for(; it != stmts.end(); ++it)
    output += it->comment() + it->text();

}

void mic::dump_stmts2(
                      const stmtlist_t& stmts,
                      const std::string& path
                      ) {

  using namespace std;
  using namespace mic;

  ofstream output(path.c_str());

  stmtlist_t::const_iterator it = stmts.begin();
  for(; it != stmts.end(); ++it)
    output << it->comment() << it->text() << endl;

  output.close();
}

void mic::dump_stmts3(
                      const stmtlist_t& stmts
                      ) {

  using namespace std;
  using namespace mic;

  stmtlist_t::const_iterator it = stmts.begin();
  for(; it != stmts.end(); ++it)
    cout << it->comment() << it->text() << endl;

}

void mic::phase_c(
                  mic::stmtlist_t& stmts,
                  mic_cmd_param_t& mic_parm
                  )
  throw(mic::internal_ex_t)
{

  using namespace std;
  using namespace mic;

  string src_stream;
  dump_stmts(stmts, src_stream);

  Qus_EC_t *ec = (Qus_EC_t *)malloc(_MIC_ECLEN);
  memset(ec, 0, _MIC_ECLEN);
  ec->Bytes_Provided = _MIC_ECLEN;

  char srcpf[] = {"QADBXRDBD QSYS      "};
  char srcmbr[] = {"GENUINE_LS"};
  char modtime[] = {"1000101000000"};

  QPRCRTPG(
           (char*)src_stream.c_str(),
           src_stream.length(),
           mic_parm.pgm_,
           mic_parm.text_,
           srcpf,
           srcmbr,
           modtime,         // sorry, the source never changes :p
           mic_parm.output_,
           1,
           mic_parm.public_auth_,
           mic_parm.options_.opts_,
           mic_parm.options_.num_,
           ec
           );
  if(ec->Bytes_Available != 0) {

    string ex_info = retrieve_exception_description(ec);
    string msgid(ec->Exception_Id, 7);
    free(ec);
    throw internal_ex_t(ex_info, msgid);
  }


  free(ec);

}

# ifdef __OS400__
void print_splf(Qus_SPLF0300_t* splfinfo) {

  using namespace mic;

  char cmd[256] = {0};
  int r = 0;
  char job_num[6 + 1] = {0};
  char job_user[10 + 1] = {0};
  char job_name[10 + 1] = {0};
  _RFILE *fp = NULL;
  _RIOFB_T *fb = NULL;
  char buf[_MIC_LIST_FILE_RLEN] = {0};

  // crtpf
  sprintf(cmd,
          "CRTPF FILE("_MIC_LIST_FILE") RCDLEN(132) "
          "FILETYPE(*DATA) IGCDTA(*YES)"
          );
  system(cmd);

  memcpy(job_num,  splfinfo->Job_Number, 6);
  trimr(job_num);
  memcpy(job_user, splfinfo->User_Name, 10);
  trimr(job_user);
  memcpy(job_name, splfinfo->Job_Name, 10);
  trimr(job_name);
  // cpysplf
  sprintf(cmd,
          "CPYSPLF FILE(%10.10s) TOFILE(%s) "
          "JOB(%s/%s/%s) SPLNBR(%d)",
          splfinfo->Spooled_File_Name,
          _MIC_LIST_FILE,
          job_num,
          job_user,
          job_name,
          splfinfo->Spooled_File_Nbr
          );
  if(system(cmd) != 0) {

    report_exception(exbase_t::unknown, "CPYSPLF failed", true);
    return;
  }

  // print _MIC_LIST_FILE
  fp = _Ropen(_MIC_LIST_FILE, "rr, rtncod=y");
  if(fp == NULL) {

    report_exception(exbase_t::unknown,
                     "failed to open "_MIC_LIST_FILE, true);
    return;
  }

  fb = _Rreadf(fp, buf, fp->buf_length, __DFT);
  while(fb->num_bytes == fp->buf_length) {

    printf("%132.132s"_NLS, buf);
    fb = _Rreadn(fp, buf, fp->buf_length, __DFT);
  }

  _Rclose(fp);

  // dltspf
  sprintf(cmd,
          "DLTSPLF FILE(%10.10s) "
          "JOB(%s/%s/%s) SPLNBR(%d)",
          splfinfo->Spooled_File_Name,
          job_num,
          job_user,
          job_name,
          splfinfo->Spooled_File_Nbr
          );
  system(cmd);

}

void mic::print_listinfo(const char *start_from, const char* prtf) {

  bool i = false;
  Qus_EC_t *ec = NULL;
  int copy = 0;
  char *ptr = NULL;
  int *listdata_offset = NULL; // 0x7C
  int *num_listentry = NULL;   // 0x84
  int *listentry_size = NULL;  // 0x88
  Qus_SPLF0300_t *splfinfo = NULL;

  ec = (Qus_EC_t*)malloc(_MIC_ECLEN);
  memset(ec, 0, _MIC_ECLEN);
  ec->Bytes_Provided = _MIC_ECLEN;

  QUSCRTUS(
           _MIC_LIST_SPC,
           "USRSPC    ",
           _MIC_LIST_SPC_SIZE,
           "\x00",
           "*EXCLUDE  ",
           "                                                  ",
           "*YES      ",
           ec
           );
  if(ec->Bytes_Available != 0) {

    report_exception(exbase_t::unknown,
                     "failed to creat space "_MIC_LIST_SPC,
                     true);
    return;
  }

  QUSLSPL(
          _MIC_LIST_SPC,
          "SPLF0300",
          "*ALL      ", // user name
          "*ALL                ", // 26a, job id
          "*STD      ", // type: *STD
          "          ", // User-specified data, do NOT use '*ALL'!
          ec,
          "                          ", // op grp 2
          NULL,
          0,
          0,  // ASP number, op grp 3
          "*CURRENT", // system name, op grp 4
          start_from, // start_date, time before phase C
          start_from + 7, // start_time
          "*LAST  ",
          "      "
          );
  if(ec->Bytes_Available != 0) {

    free(ec);
    report_exception(exbase_t::unknown,
                     "failed to list splf",
                     true);
    return;
  }

  QUSPTRUS(
           _MIC_LIST_SPC,
           &ptr,
           ec
           );

  listdata_offset = (int*)(ptr + 0x7C);
  num_listentry = (int*)(ptr + 0x84);
  listentry_size = (int*)(ptr + 0x88);

  splfinfo = (Qus_SPLF0300_t*)(
                               ptr
                               + *listdata_offset
                               + (*num_listentry - 1) * sizeof(Qus_SPLF0300_t)
                               );
  // @todo in csse that the real spooled file name is not
  // the same with mic_cmd_param_t::output_
  Qus_SPLF0300_t *last_splfinfo = splfinfo;
  for(i = 0; i < *num_listentry; i++, splfinfo--) {

    if(memcmp(splfinfo->Spooled_File_Name, prtf, 10) == 0) {

      copy = true;
      break;
    }
  }

  if(copy)
    print_splf(splfinfo);
  else if(*num_listentry > 0) // use the last spooled file
    print_splf(last_splfinfo);

  free(ec);
}

# else
void mic::print_listinfo(const char *start_from, const char* prtf) {

  printf("call print_listinfo() ... "_NLS);
}
# endif // if defined __OS400__

std::string mic::retrieve_exception_description(void* api_error_code) {

  using namespace std;

  Qus_EC_t *ec = (Qus_EC_t*)api_error_code;
  char *ex_data = (char*)ec + 16;
  Qmh_Rtvm_RTVM0100_t *info = NULL;
  string r;
  char ecbuf[_MIC_ECLEN] = {0};
  Qus_EC_t *this_ec = (Qus_EC_t*)ecbuf;
  string original_exid(ec->Exception_Id, 7);

  static const int INFO_LEN = 4096;
  info = (Qmh_Rtvm_RTVM0100_t*)malloc(INFO_LEN);
  memset(info, 0, INFO_LEN);
  info->Bytes_Available = INFO_LEN;
  this_ec->Bytes_Provided = _MIC_ECLEN;

  QMHRTVM(
          info,
          INFO_LEN,
          "RTVM0100",
          ec->Exception_Id,
          "QCPFMSG   QSYS      ",    // only for CPF and MCH messages
          ex_data,
          ec->Bytes_Available - 16,  // minus the header length of Qus_EC_t (16 bytes)
          "*YES      ",
          "*NO       ",
          this_ec
          );
  if(this_ec->Bytes_Available != 0) {

    free(info);
    r = "QMHRTVM() failed with excecption ID "
      + string(this_ec->Exception_Id, 7)
      + ", previous exception ID is "
      + original_exid
      + _NLS;
    return r;
  }

  char *info_ptr = (char*)info + 24;
  r = string(info_ptr, info->Length_Message_Returned)
    + _NLS
    + string(info_ptr + info->Length_Message_Returned, info->Length_Help_Returned)
    + _NLS;
 end:
  free(info);
  return r;
}

void mic::report_exception(
                           exbase_t::mic_ex_type_t type,
                           const std::string& info,
                           bool from_shell
                           ) {

  using namespace std;

  static const char* ex_type_names[] = {
    "unknown error",
    "", // information
    "compiler error",
    "internal error"
  };

  string str("mic: ");
  str += ex_type_names[type];
  str += " -- " + info;
  if(from_shell) {

    if(type == exbase_t::information)
      cout << str << endl;
    else
      cerr << str << endl;

    return;
  }

  // QMHSNDPM
  Qus_EC_t *ec = NULL;
  char msgkey[4] = {0};

  ec = (Qus_EC_t*)malloc(_MIC_ECLEN);
  memset(ec, 0, _MIC_ECLEN);
  ec->Bytes_Provided = _MIC_ECLEN;

  QMHSNDPM(
           "CPF9898",
           "QCPFMSG   QSYS      ",
           (char*)str.c_str(),
           str.size(),
           "*INFO     ",
           "*PGMBDY   ",
           1,
           msgkey,
           ec
           );

  free(ec);
}

int mic::get_job_ccsid() {

  Qwc_JOBI0400_t jobi;
  jobi.Bytes_Avail = sizeof(Qwc_JOBI0400_t);
  QUSRJOBI(
           &jobi,
           jobi.Bytes_Avail,
           "JOBI0400",
           "*                         ",
           "                "
           );

  return jobi.Coded_Char_Set_ID;
}

# ifdef __OS400__
void mic::get_cur_lib(char *curlib) {

  memset(curlib, _WS, 10);

  static const size_t L = 1024;
  Qwc_JOBI0700_t *info = (Qwc_JOBI0700_t*)malloc(L);
  memset(info, 0, L);
  info->Bytes_Avail = L;

  QUSRJOBI(
           info,
           L,
           "JOBI0700",
           "*                         ",
           "                "
           );
  size_t offset = 80 + 11 * (info->Libs_In_Syslibl + info->Prod_Libs);
  memcpy(curlib, (char*)info + offset, 10);

  free(info);

}
# else
void mic::get_cur_lib(char *curlib) {}
# endif

void mic::builtin_t::replace(
                             mic::stmtlist_t& stmts,
                             mic::stmtlist_t::iterator it,
                             mic::stringlist_t& b_used
                             ) {

  using namespace mic;
  using namespace std;

  int r = 0;
  string ex_info;
  stmt_t& stmt = *it;
  const char *stmt_text = stmt.text().c_str();
  int b_inv_str_start = 0, b_inv_str_length = 0;
  string origin_stmt_label, origin_stmt_body;

  // pase builtin invocation string
  regex_t reg;
  const char *pattern =
# ifdef __OS400__
    "\x6C\x4B\x5C\x4D\x4B\x5C\x5D"
# else
    "%.*(.*)"
# endif
    ;
  r = regcomp(&reg, pattern, 0);
  if(r != 0) {

    // throw exception
    return;
  }

  regmatch_t m;
  r = regexec(&reg, stmt_text, 1, &m, 0);
  regfree(&reg);
  if(r != 0) {

    // throw exception
    return;
  }

  b_inv_str_start = m.rm_so;
  b_inv_str_length = m.rm_eo - m.rm_so;
  string b_inv_str(stmt_text + b_inv_str_start, b_inv_str_length);

  // is builtin invocation string used as an instruction operand
  bool as_operand = false;
  string pre(stmt_text, b_inv_str_start);
  size_t pos = pre.find_first_of(_COLON);
  if(pos != string::npos) { // there's a LABEL

    origin_stmt_label = pre.substr(0, pos + 1);
    pre.erase(0, pos + 1);

    origin_stmt_body = string(stmt_text + pos + 1);
    b_inv_str_start -= pos + 1;
  } else
    origin_stmt_body = stmt_text;

  if(pre.find_first_not_of(_WS) == string::npos)
    as_operand = false; // pre is BLANK
  else
    as_operand = true;  // pre is NOT blank

  // parse parameter list passed by builtin's caller
  stringlist_t plist;
  char *inv = strdup(b_inv_str.c_str());
  inv[b_inv_str.find_first_of(_RIGHT_BRAKET)] = 0;
  inv += b_inv_str.find_first_of(_LEFT_BRAKET) + 1;
  char *tokptr;
  char *del = 
# ifdef __OS400__
    "\x6B\x40"
# else
    ", "
# endif
    ;
  char *tok = strtok_r(inv, del, &tokptr);
  while(tok != NULL) {

    plist.push_back(tok);
    tok = strtok_r(NULL, del, &tokptr);
  }

  // check number of parameters
  if(plist.size() != num_parms_) { // invalid parameter number

    ex_info = "invalid number of parameters when invoking builtin %";
    ex_info += name_;
    throw compiler_ex_t(ex_info);
  }

  // replace statements in rep_stmts_
  stmtlist_t::iterator it_rep = rep_stmts_.begin();
  for(int cnt = 0; it_rep != rep_stmts_.end(); ++it_rep, cnt++) {

    stmt_t rstmt(*it_rep);
    string rtext = rstmt.text();
    stringlist_t::iterator sit = plist.begin();
    int parm_index = 1;
    char parm_str[8] = {0};
    for(; sit != plist.end(); ++sit, parm_index++) {

      sprintf(parm_str,
# ifdef __OS400__
              "\x7A\x6C\x84"
# else
              ":%d"
# endif
              , parm_index
              ); // here
      replace_all(rtext, parm_str, sit->c_str());
    }

    if(cnt == 0)
      rtext = origin_stmt_label + rtext;
    rstmt.text(rtext);
    stmts.insert(it, rstmt);

  } // end of for it_rep

  // replace builtin invocation string
  string b_inv_rep;
  if(as_operand) {
    b_inv_rep = return_value_name();
    origin_stmt_body.replace(b_inv_str_start, b_inv_str_length, b_inv_rep);
  } else
    origin_stmt_body = ";"; // clear origin_stmt_body
  it->text(origin_stmt_body);

  // handle b_used
  bool registerd = false;
  stringlist_t::iterator sit = b_used.begin();
  for(; sit != b_used.end(); ++sit) {

    if(name_.compare(*sit) == 0) {

      registerd = true;
      break;
    }
  }

  if(!registerd)
    b_used.push_back(name_);

} // end of replace()

/* eof - mic.cpp */
