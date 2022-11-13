/*
This file is part of i5/OS Programmer's Toolkit.

Copyright (C) 2010, 2011  Junlei Li (李君磊).

i5/OS Programmer's Toolkit is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

i5/OS Programmer's Toolkit is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with i5/OS Programmer's Toolkit.  If not, see <http://www.gnu.org/licenses/>.
*/
/**
 * @file os400-mock.h
 *
 * mock OS/400 prototypes and structures.
 */

# ifndef __os400_mock_h__
# define __os400_mock_h__

inline
void QPRCRTPG (void *,          /* Intermediate representation of */
               /* program                        */
               int,             /* Length of intermediate         */
               /* representation of program      */
               void *,          /* Qulaified program name         */
               void *,          /* Program text                   */
               void *,          /* Qualified source file name     */
               char *,          /* Source file member information */
               void *,          /* Source file last changed date  */
               /* and time information           */
               void *,          /* Qualified printer file name    */
               int,             /* Starting page number           */
               char *,          /* Public authority               */
               void *,          /* Option template                */
               int,             /* Number of option template      */
               /* entries                        */
               ...)             /* Optional Parameter:
                                   Error code                  */
{
}

typedef struct Qus_EC
{
  int  Bytes_Provided;
  int  Bytes_Available;
  char Exception_Id[7];
  char Reserved;
  /*char Exception_Data[];*/           /* Varying length        */
} Qus_EC_t;

inline
void QMHRTVM (void *,           /* Message information            */
              int,              /* Length of message information  */
              const char *,           /* Format name                    */
              char *,           /* Message identifier             */
              const char *,           /* Qualified message file name    */
              void *,           /* Message data                   */
              int,              /* Length of message data         */
              const char *,           /* Replace substitution values    */
              const char *,           /* Return format control          */
              void *            /* Error Code                     */
              ) {}

typedef struct Qmh_Rtvm_RTVM0100
{
  int  Bytes_Return;
  int  Bytes_Available;
  int  Length_Message_Returned;
  int  Length_Message_Available;
  int  Length_Help_Returned;
  int  Length_Help_Available;
  /*char Message[];*/         /* Varying length                 */
  /*char Message_Help[];*/    /* Varying length                 */
} Qmh_Rtvm_RTVM0100_t;

inline
void QMHSNDPM (char *,           /* Message identifier             */
               const char *,           /* Qualified message file name    */
               void *,           /* Message data or text           */
               int,              /* Length of message data or text */
               char *,           /* Message type                   */
               const char *,           /* Call stack entry               */
               int,              /* Call stack counter             */
               void *,           /* Message key                    */
               void *,           /* Error code                     */
               ...) {}

void QUSRJOBI(void *,            /* Receiver variable              */
              int,               /* Length of receiver variable    */
              const char *,            /* Format name                    */
              const char *,            /* Qualified job name             */
              const char *,            /* Internal job identifier        */
              ...) {}
typedef struct tag_Qwc_JOBI0400 {

  int Bytes_Avail;
  int Coded_Char_Set_ID;
} Qwc_JOBI0400_t;

inline
void QUSRTVUI(void *,           /* Receiver variable              */
              int,              /* Length of receiver variable    */
              void *,           /* Entry lengths and offsets      */
              int,              /* Len entry lengths and offsets  */
              int *,            /* Number entries returned        */
              char *,           /* Returned library name          */
              char *,           /* Qualified user index name      */
              char *,           /* Format                         */
              int,              /* Maximum number of entries      */
              int,              /* Search type                    */
              void *,           /* Search criteria                */
              int,              /* Length search criteria         */
              int,              /* Search criteria offset         */
              void *)           /* Error code                     */
{}

#   define O_TEXTDATA 0
#   define O_CCSID    0

# endif
