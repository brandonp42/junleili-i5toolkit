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
 * @file rlink.c
 *
 * Neighter QShell nor PASE does not have a readlink utility.
 * This utility is designed to be a QShell version readlink.
 * When working in PASE environment, you can utilize this
 * utitlity by using pase command qsh or qsh_out. For example
 * qsh_ouit -c "readlink some-symbolic-link".
 *
 * You may test this utility by the following steps:
 *  - In QShell, type: ln -s /qsys.lib/somelib.lib/rlink.pgm /usr/bin/readlink
 *  - In QShell, type readlink /usr/bin/readlink
 */

# include <stdlib.h>
# include <stdio.h>
# include <unistd.h>

# ifndef __OS400__
#  error "This utility is supposed to be use in i5/OS QShell or PASE environment only."
# endif

int main(int argc, char *argv[]) {

  int len = 0;
  char *buf = NULL;

  if(argc < 2 ||\
     (len = readlink(argv[1], NULL, 0)) < 0) {
    printf("\x25");
    return 1;
  }

  buf = malloc(len + 1);
  buf[len] = 0;
  len = readlink(argv[1], buf, len);

  printf("%s\x25", buf);

  free(buf);
  return 0;
}
