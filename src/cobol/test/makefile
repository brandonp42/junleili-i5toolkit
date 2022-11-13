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
# makefile of directory cobol/test
#

BIN_LIB=
MAKERULES=rules.mk
CBLLEFLAGS=option(*nomonoprc) dbgview(*all) replace(*yes) incdir('/usr/local/include/cobol' '.')
CBLFLAGS=genopt(*list *atr)
CLFLAGS=genopt(*list *xref)
MIFLAGS=incdir('.')

TARGETS=cbl001 cbl002 cbl003 cbl004 cbl005 cbl006 cbl007 cbl008 cbl009 cbl010 \
	cbl011 cbl012 cbl013 cbl014 cbl015 cbl016

all: $(TARGETS)
	@echo "compilation done -- cobol/test"

clean:
	rmflnk $(TARGETS)

#cbl002: cbl002.cblle
#	system "crtbndcbl pgm($@) srcstmf(cbl002.cblle) $(CBLLEFLAGS) bnddir(QC2LE)"
#	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.pgm $@

cbl009: cbl009.module cbl013.module
	system "crtpgm $@ module(cbl009 cbl013)"
	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.pgm $@
