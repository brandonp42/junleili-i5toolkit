# This file is part of i5/OS Programmer's Toolkit.
# 
# Copyright (C) 2009, 2011  Junlei Li (李君磊).
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
# makefile of cm/test
#
# components:
#  - ILE PRG program uuidgen returns a character format UUID
#  - 
#  - 
#  - 
#  - 
#

BIN_LIB=lsbin
#MAKERULES=rules.mk
CLFLAGS=text($<)
# CL command ADD has a output parameter and should be used only in CL programs.
CMDFLAGS=allow(*bpgm *ipgm)
RPGLEFLAGS=dbgview(*all) replace(*yes) incdir('/usr/local/include/rpg')
TARGETS=uuidgen hello add add.cmd calculator experts.file teamates.file oneyear

all: $(TARGETS)
	@echo "end of compilation: sub-dir cm/test."

calculator: calculate.module calculator.module
	system "crtpgm $(BIN_LIB)/$@ module($(BIN_LIB)/calculator $(BIN_LIB)/calculate) actgrp(CAL) \
		text('A simple calculator program')"
	ln -s /qsys.lib/$(BIN_LIB).lib/$@.pgm $@

# RPG program ONEYEAR depends on LF EXPERTS
oneyear: experts.file

# LF EXPERTS depends on PF TEAMATES
experts.file: teamates.file

clean:
	rmflnk $(TARGETS) calculate.module calculator.module
