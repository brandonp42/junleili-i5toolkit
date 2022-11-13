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
 * @file t150.c
 *
 * @todo introduction ...
 * @todo t150.rpgleinc
 */

# include <stdlib.h>
# include <string.h>

unsigned short cvt_bits2 ( char *src,
                           unsigned bytes,
                           unsigned offset,
                           unsigned len
                           ) {

  unsigned short r = 0;

  if(bytes > 2 || (offset + len) > 16)
    return (unsigned short)-1;

  memcpy(&r, src, bytes);
  r <<= offset;
  r >>= 16 - len;

  return r;
}

/**
 * @fn cvt_bits4
 *
 * @return unsigned bin(4)
 */
unsigned int cvt_bits4 ( char *src,
                         unsigned bytes,
                         unsigned offset,
                         unsigned len
                         ) {

  unsigned int r = 0;

  if(bytes > 4 || (offset + len) > 32)
    return (unsigned)-1;

  memcpy(&r, src, bytes);
  r <<= offset;
  r >>= 32 - len;

  return r;
}
