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

.SUFFIXES: .rpg .rpgle .c .cpp .clp .clle .cmd .cl-cmd .module .pf .lf .file \
	.mi .emi .uim .pnlgrp \
	.cbl .cblle

#PRESET VARIABLES
MAKE=make

#SINGLE SUFFIX RULES
.c:
	system "crtbndc $(BIN_LIB)/$@ srcstmf('$<') $(CLEFLAGS)"
	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.pgm $@
.cpp:
	system "crtbndcpp $(BIN_LIB)/$@ srcstmf('$<') $(CPPLEFLAGS)"
	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.pgm $@
.mi:
	system "i5toolkit/mic $(BIN_LIB)/$@ srcpath($<) option(*replace *list *xref *atr) $(MIFLAGS)"
	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.pgm $@
.emi:
	system "i5toolkit/mic $(BIN_LIB)/$@ srcpath($<) option(*replace *list *xref *atr) $(MIFLAGS)"
	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.pgm $@
.rpgle:
	system "crtbndrpg $(BIN_LIB)/$@ srcstmf('$<') $(RPGLEFLAGS)"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$@.pgm" $@
.clp:
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$@) cmd(CRTCLPGM) srcstmf('$<') parm('$(CLFLAGS)')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$@.pgm" $@
.clle:
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$@) cmd(CRTBNDCL) srcstmf('$<') parm('$(CLLEFLAGS)')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$@.pgm" $@
.cl-cmd.cmd:
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTCMD) srcstmf('$<') parm('PGM($(BIN_LIB)/$*) $(CMDFLAGS)')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.cmd" $*.cmd
.rpg:
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$@) cmd(CRTRPGPGM) srcstmf('$<') parm('$(RPGFLAGS)')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$@.pgm" $@
.rpgle.module:
	system "crtrpgmod $(BIN_LIB)/$* srcstmf('$<') $(RPGLEFLAGS)"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.module" $*.module
.clle.module:
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTCLMOD) srcstmf('$<') parm('$(CLLEFLAGS)')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.module" $*.module
.c.module:
	system "crtcmod $(BIN_LIB)/$* srcstmf('$<') $(CLEFLAGS)"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.module" $*.module
.cpp.module:
	system "crtcppmod $(BIN_LIB)/$* srcstmf('$<') $(CPPLEFLAGS)"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.module" $*.module

# if target PF exists change it using CHFPF, otherwise create a new one using CRTPF
.pf.file:
	if [ -e /qsys.lib/$(BIN_LIB).lib/$*.FILE ]; then \
	  system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CHGPF) srcstmf('$<') parm('$(CHGPFFLAGS)')"; \
	else system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTPF) srcstmf('$<') parm('$(CRTPFFLAGS)')"; \
	fi
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.file" $*.file
.lf.file:
	-system "dltf file($(BIN_LIB)/$*)"
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTLF) srcstmf('$<') parm('$(CRTLFFLAGS)')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.file" $*.file
.uim.pnlgrp:
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$*) cmd(CRTPNLGRP) srcstmf('$<') parm('$(CRTPNLGRPFLAGS)')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.pnlgrp" $*.pnlgrp

.cblle:
	system "crtbndcbl $(BIN_LIB)/$@ srcstmf('$<') $(CBLLEFLAGS)"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$@.pgm" $@
.cblle.module:
	system "crtcblmod $(BIN_LIB)/$* srcstmf('$<') $(CBLLEFLAGS)"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$*.module" $*.module
.cbl:
	system "i5toolkit/crtfrmstmf obj($(BIN_LIB)/$@) cmd(CRTCBLPGM) srcstmf('$<') parm('$(CBLFLAGS)')"
	ln -fs "/qsys.lib/$(BIN_LIB).lib/$@.pgm" $@
