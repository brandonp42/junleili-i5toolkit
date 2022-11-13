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
 * @file exobjtype.c
 *
 * convert mi object type to external object type
 */

# include <stdlib.h>
# include <stdio.h>
# include <string.h>

# include <qusec.h>
# include <qlicvttp.h>
# include <mih/cvtch.h>

# define NEW_LINE "\x25"
# define ECLEN        32

# define _usage "Usage info: convert MI (Machine Interface) object type to " \
  "external object type." NEW_LINE                                      \
  "    exobjtype xxxx" NEW_LINE                                         \
  " - xxxx, hexadecimal MI object type" NEW_LINE                        \
  NEW_LINE                                                              \
  "e.g. exobjtype 0401" NEW_LINE

static char *_err_info[8] = {
  "CPF2101 Object type *&1 not valid.",
  "CPF2102 Object type and subtype code &1 not valid.",
  "CPF219C Conversion value &1 not valid.",
  "CPF219D Object type &1 not valid external object type.",
  "CPF24B4 Severe error while addressing parameter list.",
  "CPF3C90 Literal value cannot be changed.",
  "CPF3CF1 Error code parameter not valid.",
  "Unknown error."
};

char *map_cvttp_error(const char *exid);

int accept_hex_obj_type(
                        char *mi_type,
                        char *mi_type_str,
);

int main(int argc, char *argv[]) {

  char ecb[ECLEN] = {0};
  char ex_type[10] = {"          "};
  char mi_type[2] = {0};
  Qus_EC_t *ec = (Qus_EC_t*)ecb;

  if(argc < 2) {

    printf(_usage NEW_LINE);
    return 1;
  }

  if(accept_hex_obj_type(mi_type, argv[1]) != 0) {

    printf("invalid input MI object type code %s" NEW_LINE,
           argv[1]);
    printf(_usage NEW_LINE);
    return 1;
  }

  ec->Bytes_Provided = ECLEN;
  QLICVTTP(
           "*HEXTOSYM ",
           ex_type,
           mi_type,
           ec
           );
  if(ec->Bytes_Available != 0) {

    printf("%s" NEW_LINE,
           map_cvttp_error(ec->Exception_Id));
    return 1;
  }

  printf("external object type: %10.10s" NEW_LINE,
         ex_type);
  return 0;
}

int accept_hex_obj_type(
                        char *mi_type,
                        char *mi_type_str,
                        ) {

  int i = 0;
  char ch = 0;

  // lenght should be 4
  if(strlen(mi_type_str) != 4)
    return 1;

  // contains only 0-9, A-F, a-f
  // F0-F9, C1-C6, 81-86
  for(; i < 4; i++) {

    ch = mi_type_str[i];
    if(ch >= 0x81 && ch <= 0x86) {

      ch += 0x40;
      mi_type_str[i] = ch;
    }

    if((ch >= 0xF0 && ch <= 0xF9) ||\
       (ch >= 0xC1 && ch <= 0xC6))
      continue;

    return 1;
  }

  cvtch(mi_type, mi_type_str, 4);
  return 0;
}

/**
 * map exception ID of QLICVTTP to error message
 */
char *
map_cvttp_error(
                const char *exid
                ) {

  int i = 0;
  char *rtn = _err_info[7];

  for(; i < 7; i++) {

    if(memcmp(_err_info[i], exid, 7) == 0) {

      rtn = _err_info[i] + 8;
      break;
    }
  }

  return rtn;
}
