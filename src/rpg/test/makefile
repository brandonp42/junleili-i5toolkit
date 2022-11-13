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
# makefile of rpg/test
#

BIN_LIB=
MAKERULES=rules.mk
RPGLEFLAGS=dbgview(*all) replace(*yes) incdir('/usr/local/include/rpg' '.')
RPGFLAGS=genopt(*list *atr)
CLFLAGS=genopt(*list *xref)
MIFLAGS=incdir('.')
# t068 is removed temporarily
TARGETS=t001 t002 t003 t004 t005 t006 t007 t008 t009 t010 t011 t012 t013 t014 t015 \
	t016 t017 t018 t019 t020 t021 t022 t023 t024 t025 t026 \
	t028 t029 t030 t031 t032 t033 t034 t035 t036 t037 t038 t039 t040 t040a \
	t041 t042 t044 t045 t046 t049 t050 t051 t052 t053 t054 t055 t056 t057 \
	t059 t060 t061 t063 t064 t065 t066 t067 t069 t070 t071 t072 t072b t073 t075.pnlgrp \
	t074 t075 t076 t077 t078 t079 t080 t081 t082 t083_b t083 \
	t084 t085 t086 t087 t088 t089 t090 t091 t092 t093 t094 \
	t095 t096 t097 t098 t099 t099up spr37 t100 t101 t102 lk.file \
	t103 t104 t105 t106 t107 t108 t109 t110 t111 t112 t113 \
	t114 t115 t116 t118a t118 t119 t119a t120 \
	t121a t121 t121b t122 t122a t123 t124 t125 t126 t127 t128 \
	t129 t130 t131 t132 t133 t134 t135 t136 t137 t138 t139 \
	t140 t141 t141a t142cl t143rpg t144 t145 t146 t147 t148 \
	t149 uandi t151 t152 t153 t154 t155 t156 t157 t158 t159 \
	t160 t161 t162 t163 t164 t165 t166

all: $(TARGETS)
	@echo "compilation done -- rpg"

clean:
	rmflnk $(TARGETS)

uandi: t150.module
	- system "crtbnddir $@"
	- system "addbnddire $@ obj((t150 *module))"
	system "chgobjd $(BIN_LIB)/$@ objtype(*bnddir) text('You need a little change :p')" # change UANDI a litttle
	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.BNDDIR $@

t099up: pfa.file

t122a: t122a.module
	system "crtsrvpgm $@ module($@) export(*all) actgrp($@) alwrinz(*yes)"
	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.srvpgm $@

t121a: t121a.module
	system "crtpgm pgm($@) module($@) actgrp($@) alwrinz(*yes)"
	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.pgm $@

t121b: t121b.module
	system "crtpgm pgm($@) module($@) actgrp($@) alwrinz(*yes)"
	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.pgm $@

t072b: t072b.module
	system "crtpgm pgm($@) module($@) actgrp(AAA) alwrinz(*yes)"
	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.pgm $@

t084: t084.c
	system "crtbndc $@ srcstmf($@.c) dbgview(*all) teraspace(*yes *notsifc)"
	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.pgm $@

t085: t085.module
	system "crtpgm pgm($@) module($@) bnddir(QC2LE)"
	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.pgm $@

t092: t092.module
	system "crtpgm pgm($@) module($@) bnddir(QC2LE)"
	ln -fs /qsys.lib/$(BIN_LIB).lib/$@.pgm $@
