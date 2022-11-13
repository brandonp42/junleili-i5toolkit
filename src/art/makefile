# This file is part of i5/OS Programmer's Toolkit.
# 
# Copyright (C) 2010, 2011  Junlei Li (李君磊).
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
# makefile of directory art
#

BIN_LIB=
MAKERULES=rules.mk
RPGLEFLAGS=dbgview(*all) replace(*yes) incdir('/usr/local/include/rpg')
RPGFLAGS=genopt(*list *atr)

TARGETS=who u whoami jobi jobi2 testuept filluept hello vldeml

all: $(TARGETS)
	@echo "compilation done -- art"

clean:
	/usr/bin/rmflnk $(TARGETS)
