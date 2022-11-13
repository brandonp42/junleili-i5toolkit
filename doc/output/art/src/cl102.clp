             /************************************************/
             /* @FILE CL102.CLP                              */
             /* DEQUEUE KEYED DTAQ Q23                       */
             /************************************************/
             PGM
             DCL        VAR(&QNAM) TYPE(*CHAR) LEN(10) VALUE('Q23')
             DCL        VAR(&QLIB) TYPE(*CHAR) LEN(10) VALUE('LSBIN')
             DCL        VAR(&ENTLEN) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ENTRY) TYPE(*CHAR) LEN(64)
             DCL        VAR(&TIMEOUT) TYPE(*DEC) LEN(5 0) VALUE(-1) +
                          /* dequeue infinittely */
             DCL        VAR(&KEYORDER) TYPE(*CHAR) LEN(2) +
                          VALUE('GT') /* dequeue queue entries +
                          whose key value aregreater than variable +
                          &KEY */
             DCL        VAR(&KEYLEN) TYPE(*DEC) LEN(3 0) VALUE(8)
             DCL        VAR(&KEY) TYPE(*CHAR) LEN(8) VALUE('00000001')
             DCL        VAR(&SNDINFOLEN) TYPE(*DEC) LEN(3 0) +
                          VALUE(0) /* no sender info */
             DCL        VAR(&SNDINFO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(96) +
                          VALUE('key:         ; message text: ')

             CALL       PGM(QRCVDTAQ) PARM(&QNAM &QLIB &ENTLEN +
                          &ENTRY &TIMEOUT &KEYORDER &KEYLEN &KEY +
                          &SNDINFOLEN &SNDINFO)
             CHGVAR     VAR(%SST(&MSG 6 8)) VALUE(&KEY)
             CHGVAR     VAR(%SST(&MSG 30 64)) VALUE(&ENTRY)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG)

             ENDPGM
             /* EOF - CL102.CLP */
