# This file is part of i5/OS Programmer's Toolkit.
# 
# Copyright (C) 2009  Junlei Li (李君磊).
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
# makefile of mic
#

% : %.rpgle
	system "crtbndrpg pgm($(OUTPUTDIR)/$@) srcstmf('$(CURDIR)/$<') $(RPGFLAGS)"
	ln -fs "/qsys.lib/$(OUTPUTDIR).lib/$@.pgm" $@

# CURDIR=$(shell pwd)
MIHDIR=/usr/local/include/rpg
RPGFLAGS=incdir('$(MIHDIR)' '$(CURDIR)') replace(*yes)

RM=del

TARGETS=t001 t002 t003 t004 t005 t006 t007 t008 t009 t010 t011 t012 t013 t014 t015 \
	t016 t017 t018 t019 t020 t021 t022 t023 t024 t025 \
	t028 t029 t030 t031 t032 t033 t034 t035 t036 t037 t039

all: $(TARGETS)
	@echo "compilation done -- rpg-mih"

clean:
	$(RM) $(TARGETS)
