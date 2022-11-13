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
# makefile of subproject space tools (spc)
#
# @remark CL command CRTFRMSTMF must be compiled manually for the first time, since it is used to compile itself.
#

BIN_LIB=i5toolkit
MAKERULES=../rules.mk
TARGETS=chgusrspc chgusvcp spchlp.pnlgrp chgusrspc.cmd dsppnl.cmd

all: $(TARGETS)
	@echo "end of compilation: sub-dir spc."

# @todo HLPPNLGRP($(BIN_LIB)/spchlp) HLPID(''HLP/CHG'')')
chgusrspc.cmd: chgusrspc.cl-cmd chgusrspc chgusvcp spchlp.pnlgrp
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTCMD) srcstmf('$<') \
parm('PGM($(BIN_LIB)/$*) VLDCKR($(BIN_LIB)/CHGUSVCP) HLPPNLGRP($(BIN_LIB)/spchlp) HLPID(''HLP/CHG'')')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.cmd" $*.cmd

dsppnl.cmd: dsppnl.cl-cmd spchlp.pnlgrp
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTCMD) srcstmf('$<') \
parm('PGM($(BIN_LIB)/$*) VLDCKR($(BIN_LIB)/CHGUSVCP) HLPPNLGRP($(BIN_LIB)/spchlp) HLPID(''HLP/DSPPNL'')')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.cmd" $*.cmd

clean:
	rmflnk $(TARGETS)
