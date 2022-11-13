             /************************************************/
             /* @FILE CL101.CLP                              */
             /* DEQUEUE FIFO DTAQ Q21                        */
             /************************************************/
             PGM
             DCL        VAR(&QNAM) TYPE(*CHAR) LEN(10) VALUE('Q21')
             DCL        VAR(&QLIB) TYPE(*CHAR) LEN(10) VALUE('LSBIN')
             DCL        VAR(&ENTLEN) TYPE(*DEC) LEN(5 0) /* length +
                          of dequeued data */
             DCL        VAR(&ENTRY) TYPE(*CHAR) LEN(64)
             DCL        VAR(&TIMEOUT) TYPE(*DEC) LEN(5 0) VALUE(-1) +
                          /* dequeue infinittely */
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(32) VALUE('entry +
                          dequeued:')

             CALL       PGM(QRCVDTAQ) PARM(&QNAM &QLIB &ENTLEN +
                          &ENTRY &TIMEOUT)
             CHGVAR     VAR(%SST(&MSG 17 16)) VALUE(&ENTRY)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG)

             ENDPGM
             /* EOF - CL101.CLP */
