#! /bin/sh

#
# @file cpy-proct.sh
#
# Copy the content of QPROCT (V5R4) into *USRSPC I5TOOLKIT/UPROCT54.
# e.g. ./cpy-proct.sh < qproct-54.txt
#
# @pre qproct-54.txt. Hexadecimal content dumped from space object QSYS/QPROCT.
# @pre Create *USRSPC I5TOOLKIT/UPROCT54 via the QUSCRTUS API.
#      e.g.
#      CALL PGM(QUSCRTUS)
#           PARM('UPROCT54  I5TOOLKIT' 'PROCT' X'00008000' X'00' '*USE'
#                'Content of the QPROCT space at VRM 540')  
#

n=0

while read l
do off=$((n*32))
    echo "i5toolkit/chgusrspc i5toolkit/uproct54 $off dta(x'$l')"
    system "i5toolkit/chgusrspc i5toolkit/uproct54 $off dta(x'$l')"
    n=$((n+1))
done
