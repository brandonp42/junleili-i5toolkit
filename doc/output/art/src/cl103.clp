             /* @FILE CL103.CLP */
PGM
             DCL        VAR(&SQLCOD) TYPE(*CHAR) LEN(4)
 RUN_SQL:    RUNSQL     SQL('delete from pf16') SQLCOD(&SQLCOD) /* +
                          clear PF16 */
             RUNSQL     SQL('insert into PF16 values(''A'', ''B'', +
                          ''C'')') SQLCOD(&SQLCOD) /* insert new +
                          records */
             IF         COND(%BIN(&SQLCOD) *LT 0) THEN(DO)
             SNDPGMMSG  MSG('SQL operations failed.') +
                          TOMSGQ(*TOPGMQ) MSGTYPE(*INFO)
             RUNSQL     SQL('rollback') SQLCOD(&SQLCOD) /* rollbak +
                          when insert operation failed */
             GOTO       CMDLBL(END)
             ENDDO

             RUNSQL     SQL('commit') SQLCOD(&SQLCOD) /* commit */

 END:        ENDPGM
/* EOF - CL103.CLP */
