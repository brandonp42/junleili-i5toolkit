/* @FILE RUNSQL2.CMD */

             CMD        PROMPT('Run SQL statement')
             PARM       KWD(SQL) TYPE(*CHAR) LEN(5000) MIN(1) +
                          VARY(*YES *INT4) INLPMTLEN(50) +
                          PROMPT('SQL statement')
             PARM       KWD(SQLCOD) TYPE(*CHAR) LEN(4) RTNVAL(*YES) +
                          MIN(1) PROMPT('SQLCOD returned')
/* EOF */
