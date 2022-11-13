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
# makefile of index tools
#

MIFLAGS=INCDIR('.')

BIN_LIB=
MAKERULES=rules.mk
TARGETS=dspidxd rtvidxd insidx dspidxd.cmd insidx.cmd dspidxd.pnlgrp

all: $(TARGETS)
	@echo "compilation done -- idx"

dspidxd.cmd: dspidxd.cl-cmd idxhlp.pnlgrp
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTCMD) srcstmf('$<') \
parm('PGM($(BIN_LIB)/$*) HLPPNLGRP($(BIN_LIB)/idxhlp) HLPID(''HLP/IDXD'')')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.cmd" $*.cmd

insidx.cmd: insidx.cl-cmd idxhlp.pnlgrp
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTCMD) srcstmf('$<') \
parm('PGM($(BIN_LIB)/$*) HLPPNLGRP($(BIN_LIB)/idxhlp) HLPID(''HLP/IDXD'')')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.cmd" $*.cmd

clean:
	rmflnk $(TARGETS)

#
#cmd_pnlgrp:
#	@echo "attention: compiling CL command and panel-groups ..."
#	system "CRTPNLGRP PNLGRP(I5TOOLKIT/IDXHLP) SRCFILE(LS2008/UIM) SRCMBR(*PNLGRP) INCFILE(*SRCFILE) REPLACE(*YES)"
#	system "CRTPNLGRP PNLGRP(I5TOOLKIT/DSPIDXD) SRCFILE(LS2008/UIM) SRCMBR(*PNLGRP) INCFILE(*SRCFILE) REPLACE(*YES)"
#	system "CRTCMD CMD($(OUTPUTDIR)/DSPIDXD) PGM($(OUTPUTDIR)/DSPIDXD) SRCFILE(LS2008/DEC) SRCMBR(DSPIDXD) HLPPNLGRP($(OUTPUTDIR)/IDXHLP) HLPID('HLP/IDXD')"
#	system "CRTCMD CMD($(OUTPUTDIR)/INSIDX) PGM($(OUTPUTDIR)/INSIDX) SRCFILE(LS2008/DEC) SRCMBR(INSIDX) HLPPNLGRP($(OUTPUTDIR)/IDXHLP) HLPID('HLP/IDXD')"
#