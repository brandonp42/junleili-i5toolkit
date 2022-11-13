/* @FILE ISQL.CMD */

             CMD        PROMPT('Run SQL statement')
             PARM       KWD(SQL) TYPE(*CHAR) LEN(256) MIN(1) +
                          INLPMTLEN(50) PROMPT('SQL statement')
/* EOF */
