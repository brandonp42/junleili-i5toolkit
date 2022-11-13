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
 * @file t072b.c
 *
 * Called by T072. Returns a static scalar bin(4) and increaments the
 * value of it each time this program is invoked.
 *
 * @remark PGM T072B has the allow static storage re-initialization
 * attribute set to true and ACTGRP attribute set to AAA. See makefile
 * for details.
 */

/* static variable with initial value 5. */
int _i_static = 5;

int main(int argc, char *argv[]) {

  *(int*)argv[1] = _i_static++;
  return 0;
}
