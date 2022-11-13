# This file is part of i5/OS Programmer's Toolkit.
# 
# Copyright (C) 2010, 2011  Junlei Li.
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
# makefile of directory cl/
#

BIN_LIB=
MAKERULES=rules.mk
CBLLEFLAGS=dbgview(*all) replace(*yes)
CBLFLAGS=genopt(*list *atr)
CLFLAGS=genopt(*list *xref)
MIFLAGS=incdir('.')

TARGETS=cl001 cl002 cl003 cl004 cl005 cl006 cl007

all: $(TARGETS)
	@echo "compilation done -- cl/test"

clean:
	rmflnk $(TARGETS)

cl003: cl003.module cl003b.module
	system "crtpgm $@ module($@ cl003b)"
	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.pgm $@

# cbl002: cbl002.cblle
#	system "crtbndcbl pgm($@) srcstmf(cbl002.cblle) $(CBLLEFLAGS) bnddir(QC2LE)"
#	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.pgm $@

