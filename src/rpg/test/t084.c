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
 * @file t084.c
 *
 * Test of _RETTSADR.
 *
 * output:
 * pointer value: 00000080040880A0
 *
 * @remark crtbndc teraspace(*yes *notsifc)
 */

# include <stdlib.h>
# include <stdio.h>
# include <string.h>

# pragma linkage(_RETTSADR, builtin)
void *__ptr64 _RETTSADR(void *);

// or include  <mih/rettsadr.h>

int main() {

  void * tera_ptr = NULL;
  void * __ptr64  rtn_ptr  = NULL;
  char ptr_val[8] = {0};
  int i = 0;

  tera_ptr = _C_TS_malloc(1024);
  rtn_ptr = _RETTSADR(tera_ptr);

  printf("pointer value: ");
  memcpy(ptr_val, &rtn_ptr, 8);
  for(; i < 8; i++) {

    printf("%02X", ptr_val[i]);
  }
  printf("\x25");

  _C_TS_free(tera_ptr);
  return 0;
}
