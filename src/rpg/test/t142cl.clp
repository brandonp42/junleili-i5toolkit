             /*************************************************************/
             /* @file t142cl.clp                                          */
             /*************************************************************/
             PGM        PARM(&PRM1 &PRM2)
             DCL        VAR(&PRM1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRM2) TYPE(*CHAR) LEN(8)

             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50) VALUE('You know that')
             DCL        VAR(&MSGPTR) TYPE(*PTR) ADDRESS(&MSG)
             DCL        VAR(&STR) TYPE(*CHAR) STG(*BASED) LEN(8) BASPTR(&MSGPTR)
             CHGVAR     VAR(%OFFSET(&MSGPTR)) VALUE(%OFFSET(&MSGPTR) + 15)
             CHGVAR     VAR(&STR) VALUE(&PRM1)
             CHGVAR     VAR(%OFFSET(&MSGPTR)) VALUE(%OFFSET(&MSGPTR) + 9)
             CHGVAR     VAR(&STR) VALUE(&PRM2)

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG) TOPGMQ(*PRV)
             ENDPGM
