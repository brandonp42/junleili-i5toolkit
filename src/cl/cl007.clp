             PGM
             DCL        VAR(&OPT) TYPE(*CHAR) LEN(10) +
                          VALUE('*HEXTOSYM')
             DCL        VAR(&EXTYP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MITYP) TYPE(*UINT) LEN(2) VALUE(X'1900')
             DCL        VAR(&EC) TYPE(*CHAR) LEN(16)
             DCL        VAR(&ECLEN) TYPE(*UINT) STG(*DEFINED) LEN(4) +
                          DEFVAR(&EC)
             DCL        VAR(&ECRTN) TYPE(*UINT) STG(*DEFINED) LEN(4) +
                          DEFVAR(&EC 5)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(16)
             DCL        VAR(&NIBLEN) TYPE(*UINT) LEN(4) VALUE(4)

             CHGVAR     VAR(&ECLEN) VALUE(16)
 LOOP:       CHGVAR     VAR(&MITYP) VALUE(&MITYP + 1)
             IF         COND(&MITYP *GT 6655) THEN(GOTO +
                          CMDLBL(SEEYOU)) /* when &MITYP > x'19FF' */
             CALL       PGM(QLICVTTP) PARM(&OPT &EXTYP &MITYP &EC) +
                          /* Convert MI object type code to +
                          external object type name */
             IF         COND(&ECRTN *NE 0) THEN(GOTO CMDLBL(LOOP))
             CALL       PGM(CVTHC) PARM(&MSG &MITYP &NIBLEN)
             CHGVAR     VAR(%SST(&MSG 7 10)) VALUE(&EXTYP)
             SNDPGMMSG  MSG(&MSG)
             GOTO       CMDLBL(LOOP)

 SEEYOU:     ENDPGM
