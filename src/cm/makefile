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
# makefile of subproject SCM Tools (cm)
#
# @remark CL command CRTFRMSTMF must be compiled manually for the
#	  first time, since it is used to compile itself.
#
# @remark To utilize shell script rmflnk, you need to upload it to
# 	  your stream file system and make sure it is visible through
# 	  the PATH evironment.
#

BIN_LIB=i5toolkit
MAKERULES=../rules.mk
TARGETS=gendbfsrc stmfseu chstmfseu mtime touch unlink crtfrmstmf cmhlp.pnlgrp crtfrmstmf.cmd stmfseu.cmd

all: $(TARGETS)
	@echo "end of compilation: sub-dir cm."

# CL command STMFSEU can be used only interactively
stmfseu.cmd: stmfseu.cl-cmd cmhlp.pnlgrp
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTCMD) srcstmf('$<') \
parm('PGM($(BIN_LIB)/$*) ALLOW(*INTERACT *IPGM *IREXX *IMOD) HLPPNLGRP($(BIN_LIB)/CMHLP) HLPID(''STMFSEU'')')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.cmd" $*.cmd

crtfrmstmf.cmd: crtfrmstmf.cl-cmd cmhlp.pnlgrp
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTCMD) srcstmf('$<') \
parm('PGM($(BIN_LIB)/$*) HLPPNLGRP($(BIN_LIB)/CMHLP) HLPID(''CRTFRMSTMF'')')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.cmd" $*.cmd

clean:
	rmflnk $(TARGETS)
