/*                                                              */
/* @file add.clp                                                */
/*                                                              */
/* Command Processing Program (CPP) of CL command ADD.          */
/*                                                              */
             PGM        PARM(&SUM &ADDENT1 &ADDENT2)
             DCL        VAR(&SUM) TYPE(*DEC) LEN(15 5)
             DCL        VAR(&ADDENT1) TYPE(*DEC) LEN(15 5)
             DCL        VAR(&ADDENT2) TYPE(*DEC) LEN(15 5)
             CHGVAR     VAR(&SUM) VALUE(&ADDENT1 + &ADDENT2)
 END:
             ENDPGM
