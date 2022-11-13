/* This file is part of i5/OS Programmer's Toolkit. */
/*  */
/* Copyright (C) 2010, 2011  Junlei Li (李君磊). */
/*  */
/* i5/OS Programmer's Toolkit is free software: you can redistribute it and/or modify */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or */
/* (at your option) any later version. */
/*  */
/* i5/OS Programmer's Toolkit is distributed in the hope that it will be useful, */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the */
/* GNU General Public License for more details. */
/*  */
/* You should have received a copy of the GNU General Public License */
/* along with i5/OS Programmer's Toolkit.  If not, see <http://www.gnu.org/licenses/>. */

/**********************************************************/
/*                                                        */
/* @file mic.cmd                                          */
/*                                                        */
/* cl command interface of my mi compiler :)              */
/*                                                        */
/* project name: mic                                      */
/*                                                        */
/* author: Junlei Li                                      */
/*                                                        */
/**********************************************************/

             CMD        PROMPT('Create MI Program (MIC)')

/* program name */
             PARM       KWD(PGM) TYPE(Q_NAME) MIN(1) KEYPARM(*YES) +
                          PROMPT('Program')

/* srcstmf */
             PARM       KWD(SRCPATH) TYPE(*PNAME) LEN(512) MIN(1) +   
                          VARY(*YES *INT2) CASE(*MIXED) +              
                          INLPMTLEN(50) PROMPT('Source path name') 

/* description test of the generated PGM object */
             PARM       KWD(TEXT) TYPE(*CHAR) LEN(50) CASE(*MIXED) +
                          PROMPT('Text description')

/* compilation output */
             PARM       KWD(OUTPUT) TYPE(Q_OUTPUT) PROMPT('Output +
                          printer file')

/* public authority */
             PARM       KWD(AUT) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          DFT(*ALL) VALUES(*CHANGE *ALL *USE +
                          *EXCLUDE) SPCVAL((*CHANGE '*CHANGE') +
                          (*ALL '*ALL') (*USE '*USE') (*EXCLUDE +
                          '*EXCLUDE')) PROMPT('Public authority')

/* include directories */
             PARM       KWD(INCDIR) TYPE(*PNAME) LEN(512) MAX(15) +    
                          VARY(*YES *INT2) CASE(*MIXED) +              
                          LISTDSPL(*INT2) PROMPT('Include directories')

/* compiler options */
             PARM       KWD(OPTION) TYPE(*CHAR) LEN(11) RSTD(*YES) +
                          VALUES(*GEN *NOGEN *NOREPLACE *REPLACE +
                          *NOLIST *LIST *NOXREF *XREF *NOATR *ATR +
                          *USER *ADOPT *OWNER *ADPAUT *NOADPAUT +
                          *SUBSCR *NOSUBSCR *UNCON *SUBSTR +
                          *NOSUBSTR *CLRPSSA *NOCLRPSSA *CLRPASA +
                          *NOCLRPASA *NOIGNDEC *IGNDEC *NOIGNBIN +
                          *IGNBIN *NOOVERLAP *OVERLAP *NODUP *DUP +
                          *OPT *NOOPT *CURRENT *PRV V5R1M0 V5R2M0 +
                          V5R3M0 V5R4M0) MAX(38) PROMPT('Compiler +
                          options')

/* qualifiers */
 Q_NAME:     QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*CURLIB) +
                          SPCVAL((*CURLIB)) PROMPT('Library')

 Q_OUTPUT:   QUAL       TYPE(*NAME) LEN(10) DFT(*PRINT) +
                          SPCVAL((*PRINT QSYSPRT)) MIN(0)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*CURLIB '*CURLIB') (*LIBL +
                          '*LIBL')) MIN(0) PROMPT('Library')
