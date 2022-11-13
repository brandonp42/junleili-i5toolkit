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
 * @file loadinx.cpp
 */

# include <iostream>
# include <fstream>
# include <string>

# ifdef __OS400__
#   include <qusec.h>
#   include <quscrtui.h>
#   include <qusaddui.h>
#   include <qusrtvui.h>
# else
#   include <os400-mock.h>
# endif // defined __OS400__

# include <builtin-fmt.hpp>

# define _MIC_ECLEN          256

int main() {

  static const unsigned ent_len_len = 8 + _MIC_MAX_BUILTIN_STMTS * 8;

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

    printf("failed to read index header, %7.7s\x25",
           ec->Exception_Id
           );
    free(output);
    free(empty);
    // @todo throw
    return 1;
  }

  builtin_index_t inxh;
  memcpy(&inxh, output + 8, _MIC_BUILTIN_INX_LEN);
  free(output);

  // @todo check inxh.min_mic_ver_, inxh.max_mic_ver_, throw exception

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
      // @todo throw
      break;
    }

    builtin_header_t bh;
    memcpy(&bh, output + 8, _MIC_BUILTIN_INX_LEN);
    free(output);

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

      // @todo ...
      // read each stmt from stmt_ptr
      std::string stmt(stmt_ptr + _MIC_BUILTIN_KEY);
      std::cout << ind
                << ": "
                << stmt
                << std::endl;
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

      // @todo ...
      // read each stmt from stmt_ptr
      std::string stmt(stmt_ptr + _MIC_BUILTIN_KEY);
      std::cout << ind
                << ": "
                << stmt
                << std::endl;
    }
    free(output);

  } // end of for(inxh.num_builtins_)

  /*
   * read builtin stmts: replacement, body
   *  - rep: key >= x'02,bnum,0000'
   *  - rep: key <= x'02,bnum,(num-stmt - 1)'
   */

  free(empty);
  return 0;
}
