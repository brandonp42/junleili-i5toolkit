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
# makefile of subproject queue tools
#

MIFLAGS=INCDIR('.' '../ref')
CRTPNLGRPFLAGS=INCFILE(QGPL/I5TOOLSRC)

BIN_LIB=
MAKERULES=rules.mk
TARGETS=qattr qmsg dspusrqmsg dspdtaqmsg qmdtl clrusrq \
	enqusrq dequsrq \
	dspqathlp.pnlgrp dspqat.pnlgrp dspqm.pnlgrp \
	dspqd.cmd dspqmsg.cmd clrusrq.cmd enqusrq.cmd

all: $(TARGETS)
	@echo "compilation done -- q"

dspqd.cmd: dspqathlp.pnlgrp dspqat.pnlgrp
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTCMD) srcstmf('$<') \
parm('PGM($(BIN_LIB)/QATTR) HLPPNLGRP($(BIN_LIB)/dspqathlp) HLPID(''HELP/ABT'')')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.cmd" $*.cmd

dspqmsg.cmd: dspqathlp.pnlgrp dspqm.pnlgrp
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTCMD) srcstmf('$<') \
parm('PGM($(BIN_LIB)/QMSG) HLPPNLGRP($(BIN_LIB)/dspqathlp) HLPID(''HELP/ABTQM'')')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.cmd" $*.cmd

clrusrq.cmd: dspqathlp.pnlgrp
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTCMD) srcstmf('$<') \
parm('PGM($(BIN_LIB)/CLRUSRQ) HLPPNLGRP($(BIN_LIB)/dspqathlp) HLPID(''HLP/CLQ'')')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.cmd" $*.cmd

enqusrq.cmd: dspqathlp.pnlgrp
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTCMD) srcstmf('$<') \
parm('PGM($(BIN_LIB)/ENQUSRQ) HLPPNLGRP($(BIN_LIB)/dspqathlp) HLPID(''HLP/ENQ'')')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.cmd" $*.cmd

clean:
	rmflnk $(TARGETS)
