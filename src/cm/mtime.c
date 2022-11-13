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
 * @file mtime.c
 *
 * Returns the last modification time of an IFS object in form of
 * time_t.  Usage: call mtime parm('/ifs/object/path/name'
 * last-modification-time)
 *
 * @remark the last modification-time param is in form of time_t, aka
 * 4-byte binary.
 */

# include <stdlib.h>
# include <sys/stat.h>

int main(int argc, char *argv[]) {

  int r = 0;
  struct stat f_info;

  if(argc < 3)
    return 1;

  r = stat(argv[1], &f_info);
  if(r == 0)
    *((int*)argv[2]) = f_info.st_mtime;
  else
    *((int*)argv[2]) = 0;

  /* return value */
  if(argc >= 4)
    *((int*)argv[3]) = r;

  return r;
}
