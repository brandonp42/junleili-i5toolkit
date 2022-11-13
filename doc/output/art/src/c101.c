/*
 * @file c101.c
 *
 * example of using API QUSCRTUQ.
 *
 * i create a keyed USRQ, key length = 8, message length = 64
 */

# include <stdlib.h>
# include <string.h>

# include <qusec.h>
# include <quscrtuq.h>

# define ECLEN 256

# define QNAME "Q31       LSBIN     " /* q name/library */
# define EXT_ATTR "QQ        "        /* extended attribute, must be a valid *NAME object */
# define QTYPE "K"                    /* q type: keyed */
# define KEY_LEN 8                    /* key length */
# define ENTRY_LEN 64                 /* message text length */
# define INIT_MSGS 1                  /* initial number of messages */
# define EXT_MSGS 3                   /* number of messages per extension */
# define PUBLIC_AUTH "*EXCLUDE  "     /* public authority */
# define TEXT "a keyed USRQ, key length = 8, message length = 64 "
# define REPLACE "*YES      "         /* replace existing USRQ */
# define DOMAIN "*USER     "          /* object domain */
# define POINTERS "*YES      "        /* the queue messages can contain pointer data or not. */
# define NUM_EXTENDS 2                /* maximum number of extensions allowed for the USRQ */
# define AUTO_RECLAIM "0"             /* automaticly reclaim storage when queue is empty */

int main(int argc, char *argv[]) {

  Qus_EC_t *ec = NULL;
  int r = 0;
  int init_msgs = INIT_MSGS;
  int ext_msgs = EXT_MSGS;
  int num_extends = NUM_EXTENDS;

  if(argc == 4) {

    memcpy(&init_msgs, argv[1], sizeof(int));
    memcpy(&ext_msgs, argv[2], sizeof(int));
    memcpy(&num_extends, argv[3], sizeof(int));
  }

  ec = (Qus_EC_t*)malloc(ECLEN);
  memset(ec, 0, ECLEN);
  ec->Bytes_Provided = ECLEN;

  QUSCRTUQ(
           QNAME,
           EXT_ATTR,
           QTYPE,
           KEY_LEN,
           ENTRY_LEN,
           init_msgs,
           ext_msgs,
           PUBLIC_AUTH,
           TEXT,
           REPLACE,
           ec,
           DOMAIN,
           POINTERS,
           num_extends,
           AUTO_RECLAIM
           );
  if(ec->Bytes_Available != 0) {

    printf("QUSCRTUQ() failed, exception ID: %7.7s\x25",
           ec->Exception_Id);
    r = 1;
  }

  free(ec);
  return r;
}

/*
CALL C101
DSPQD Q(Q31) QTYPE(*USRQ)

Current maximum number of          
  messages . . . . . . . . . :   1 
Current number of messages         
  enqueued . . . . . . . . . :   0 
Extension value  . . . . . . :   3 
Key length . . . . . . . . . :   8 
Maximum size of message to be      
  enqueued . . . . . . . . . :   64
Maximum number of extends  . :   2 
Current number of extends  . :   0 
Initial number of messages . :   1 
*/
