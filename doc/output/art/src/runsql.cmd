/* @FILE RUNSQL.CMD */

             CMD        PROMPT('Run SQL statement')
             PARM       KWD(SQL) TYPE(*CHAR) LEN(256) MIN(1) +
                          INLPMTLEN(50) PROMPT('SQL statement')
             PARM       KWD(SQLCOD) TYPE(*CHAR) LEN(4) RTNVAL(*YES) +
                          MIN(1) PROMPT('SQLCOD returned')
/* EOF */
