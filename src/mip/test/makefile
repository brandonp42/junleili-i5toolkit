# This file is part of i5/OS Programmer's Toolkit.
# 
# Copyright (C) 2009  Junlei Li (李君磊).
# 
# i5/OS Programmer's Toolkit is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# i5/OS Programmer's Toolkit is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with i5/OS Programmer's Toolkit.  If not, see <http://www.gnu.org/licenses/>.

#
# makefile of subproject OPM MI Disassembler (mip)
#
# @remark CL command CRTFRMSTMF must be compiled manually for the first time, since it is used to compile itself.
#

BIN_LIB=i5toolkit
MAKERULES=../rules.mk
TARGETS=tmip01 tmip02 tmip03 tmip04

all: $(TARGETS)
	@echo "end of compilation: sub-dir mip."

clean:
	rmflnk $(TARGETS)
