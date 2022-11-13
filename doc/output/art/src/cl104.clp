             /* @FILE CL104.CLP */
PGM
             DCL        VAR(&SQLCOD) TYPE(*CHAR) LEN(4)
 RUN_SQL:    RUNSQL2    SQL('delete from pf16') SQLCOD(&SQLCOD) /* +
                          clear PF16 */
             RUNSQL2    SQL('insert into PF16 values(''A'', ''B'', +
                          ''C'')') SQLCOD(&SQLCOD) /* insert new +
                          records */
             IF         COND(%BIN(&SQLCOD) *LT 0) THEN(DO)
             SNDPGMMSG  MSG('SQL operations failed.') +
                          TOMSGQ(*TOPGMQ) MSGTYPE(*INFO)
             RUNSQL2    SQL('rollback') SQLCOD(&SQLCOD) /* rollbak +
                          when insert operation failed */
             GOTO       CMDLBL(END)
             ENDDO

             RUNSQL2    SQL('commit') SQLCOD(&SQLCOD) /* commit */

 END:        ENDPGM
/* EOF - CL104.CLP */
