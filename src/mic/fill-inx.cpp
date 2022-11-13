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
 * @file file-inx.cpp
 *

./fill-inx binx/h* binx/mem* binx/send*

 @attention builtin-number starts from 0!!

 */

# include <iostream>
# include <fstream>
# include <string>
using namespace std;

# ifdef __OS400__
# include <qusec.h>
# include <quscrtui.h>
# include <qusaddui.h>
# include <qusrtvui.h>
# endif // defined __OS400__

# include <builtin-fmt.hpp>

# define _usage "usage info:\n" \
  "\tfill-inx index-header-file builtin-files ..."

int write_index(void *ent);
int write_header(const char *file);
int write_builtin(const char *file);
void read_to_eol(std::ifstream& f, char *buf, size_t len);

# ifdef __OS400__
extern "OS"
void CRT_INX();
# else
void CRT_INX() {}
# endif

int main(int argc, char *argv[]) {

  int r = 0;

  if(argc < 3) {

    cout << _usage << endl;
    return 1;
  }

  // re-create index
  CRT_INX();

  // header
  char *header = argv[1];
  if(write_header(header) != 0) {

    cout << "failed to write index header" << endl;
    return 1;
  }

  // builtin files
  int i = 0;
  for(i = 2; i < argc; i++) {

    char *b = argv[i];
    if(write_builtin(b) != 0) {

      cout << "failed to writte builtin " << b << endl;
      r = 1;
      break;
    }
  }

  return r;
}

/**
 * format of a header file (only one line)
 * 
 *  - version number of the index
 *  - min mic version
 *  - max mic version
 *  - number of builtins in the builtin
 *  - release notes
 *
 * @remark emi/mic使用一个内部版本号，该版本号与i5toolkit的字符形式版本不同
 *         现在由 hex 0002 开始吧
 */
int write_header(const char *file) {

  using namespace std;

  int r = 0;
  builtin_index_t inx_ent;
  char notes[_MIC_BUILTIN_INX_LEN] = {0};

  ifstream in(file);
  if(!in)
    return 1;

  // builtin header
  string v;
  // clear builtin_index_t: type_, reserved_, reserved2_
  memset(&inx_ent, 0, _MIC_BUILTIN_INX_LEN);

  in >> v;
  inx_ent.index_ver_ = (unsigned short)atoi(v.c_str());
  in >> v;
  inx_ent.min_mic_ver_ = (unsigned short)atoi(v.c_str());
  in >> v;
  inx_ent.max_mic_ver_ = (unsigned short)atoi(v.c_str());
  in >> v;
  inx_ent.num_builtins_ = (unsigned short)atoi(v.c_str());
  read_to_eol(in, inx_ent.release_notes_, _MIC_BUILTIN_INX_LEN);

# ifdef __OS400__
  write_index(&inx_ent);
# else
  cout << "header info:"
       << endl
       << "\tindex version: " << inx_ent.index_ver_ << endl
       << "\tminimal EMI/MIC version supported: " << inx_ent.min_mic_ver_ << endl
       << "\tmaxinum EMI/MIC version supported: " << inx_ent.max_mic_ver_ << endl
       << "\tnumber of builtins: " << inx_ent.num_builtins_ << endl
       << "\trelease notes: " << inx_ent.release_notes_ << endl
    ;
# endif

  return r;
}

/**
 * builtin file format
 *
 *  - first line, header
      - builtin number
      - number of params
      - number of replacement stmts
      - number of body stmts
      - builtin name (less than 30 characters)
      - description
    - following lines: replacement stmts
    - following lines: body stmts
 */
int write_builtin(const char *file) {

  int r = 0;

  ifstream in(file);
  if(!in)
    return 1;

  builtin_header_t h;
  string v;
  memset(&h, 0, _MIC_BUILTIN_INX_LEN); // clear the whole structure
  h.type_[0] = _INDEX_ENTRY_TYPE_BUILTIN;

  in >> v;
  sprintf(h.builtin_num_, "%04X", atoi(v.c_str()));

  in >> v;
  h.num_param_ = (unsigned short)atoi(v.c_str());

  in >> v;
  h.num_rep_stmt_ = (unsigned short)atoi(v.c_str());

  in >> v;
  h.num_body_stmt_ = (unsigned short)atoi(v.c_str());

  in >> v;
  if(v.size() > _MAX_MIC_BUILTIN_NAME)
    v.erase(_MAX_MIC_BUILTIN_NAME);
  memcpy(h.builtin_name_, v.c_str(), v.size());

  read_to_eol(in, h.user_data_, _MAX_BUILTIN_DESC);

  // writer builtin header
# ifdef __OS400__
  write_index(&h);
# else
  cout << "builtin info:" << endl
       << "\tbuiltin number: " << h.builtin_num_ << endl
       << "\tnumber of params: " << h.num_param_ << endl
       << "\tnumber of replacement stmts: " << h.num_rep_stmt_ << endl
       << "\tnumber of body stmts: " << h.num_body_stmt_ << endl
       << "\tbuiltin name: " << h.builtin_name_ << endl
       << "\tdescription: " << h.user_data_ << endl;
# endif

  // replacement stmts
  int i = 0;
  builtin_stmt_t stmt;
  stmt.type_[0] = _INDEX_ENTRY_TYPE_STMT_REP;
  memcpy(stmt.builtin_num_, h.builtin_num_, 4);
  for(i = 0; i < h.num_rep_stmt_; i++) {

    memset(stmt.stmt_, 0, _MAX_STMT_LEN);
    stmt.stmt_num_ = (unsigned short)i;
    read_to_eol(in, stmt.stmt_, _MAX_STMT_LEN);

    write_index(&stmt);
  }

  // body stmts
  stmt.type_[0] = _INDEX_ENTRY_TYPE_STMT_BODY;
  memcpy(stmt.builtin_num_, h.builtin_num_, 4);
  for(i = 0; i < h.num_body_stmt_; i++) {

    memset(stmt.stmt_, 0, _MAX_STMT_LEN);
    stmt.stmt_num_ = (unsigned short)i;
    read_to_eol(in, stmt.stmt_, _MAX_STMT_LEN);

    write_index(&stmt);
  }

  return r;
}

/**
 * write a single entry to EMI builtin index
 *
 * 注意，没用的空间方 hex 00，不补WS
 *
 * @remark 写inx时，entry长度要给满!
 */
int write_index(void *ent) {

  int r = 0;

# ifdef __OS400__
  char ecbuf[256] = {0};
  Qus_EC_t *ec = (Qus_EC_t*)ecbuf;
  char rtn_lib[10] = {0};
  int num_added = 0;

  ec->Bytes_Provided = 256;

  QUSADDUI(
           rtn_lib,
           &num_added,
           _EMI_BUILTIN_INDEX,
           3,       // 
           ent,
           _MIC_BUILTIN_INX_LEN,  // entry length: length of 1 entry * number of entries
           NULL, // entrh lengths and offsets, ignored for fixed length index
           1,    // number of entries
           ec
           );
  if(ec->Bytes_Available != 0) {

    r = 1;
    printf("QUSADDUI() failed with exid %7.7s\x25",
           ec->Exception_Id);
  }
# endif
  return r;
}

# ifdef __OS400__
#   define _NL '\x25'
# else
#   define _NL '\n'
# endif

void read_to_eol(std::ifstream& in, char *buf, size_t len) {

  int i = 0;
  char ch = 0;

  for(i = 0; in; i++) {

    in.read(&ch, 1);
    if(ch == _NL)
      break;

    if(i < len)
      buf[i] = ch;
  }
}
