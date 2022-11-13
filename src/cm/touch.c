/*
 * This file is part of i5/OS Programmer's Toolkit.
 * 
 * Copyright (C) 2010, 2011  Junlei Li (李君磊).
 * 
 * i5/OS Programmer's Toolkit is free software: you can redistribute it
 * and/or modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * i5/OS Programmer's Toolkit is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with i5/OS Programmer's Toolkit.  If not, see
 * <http://www.gnu.org/licenses/>.
 */

/**
 * @file touch.c
 *
 * open/create a stream file with specified CCSID
 *
 * @param [in] path-name, null-terminated path name
 * @param [in] ccsid, bin(2)
 * @param [out] return value, bin(4), 0 if successful
 *
 * @return errno
 */

# include <stdlib.h>
# include <errno.h>
# include <fcntl.h>

int main(int argc, char *argv[]) {

  int fd = 0;
  short ccsid = 0;

  if(argc < 4)
    return -1;

  ccsid = *((short*)argv[2]);
  fd = open(argv[1],
            O_RDWR | O_CREAT | O_CCSID,
            S_IRUSR | S_IWUSR,
            ccsid);
  if(fd == -1) {
    *((int*)argv[3]) = errno;
    return errno;
  }

  close(fd);
  return 0;
}
