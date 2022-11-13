/**
 * @file 
 *
 * implements native methods of class isqlsvr
 *
 * compile: CRTCMOD MODULE(LSBIN/ISQLSVR) SRCSTMF(isqlsvr.c) INCDIR('.')
 */

# include <isqlsvr.h>

// libc
# include <stdlib.h>
# include <string.h>
# include <except.h>

// libmi
# include <mih/rslvsp.h>
# include <mih/enq.h>
# include <mih/genuuid.h>

// libiconv
# include <iconv.h>

// apis
# include <qusec.h>
# include <qusrjobi.h>

/**
 * deq prefix structure
 */
typedef _Packed struct _deq_prefix {

  char time_enqueued[8];
  char timeout[8];
  int text_len_returned;
  char acc_state_mod[1];
  char key_in[16];
  char key_out[16];
} deq_prefix_t;

// prototype of instruction DEQWAIT
# pragma linkage(_DEQWAIT, builtin)
void _DEQWAIT (
               deq_prefix_t *,
               void*,
               _SYSPTR*
               );

# define REQUEST_Q "ISQL2"
# define REPLY_Q   "ISQLR2"
# define UTF8_CCSID \
  "IBMCCSID012080000000\0\0\0\0\0\0\0\0\0\0\0\0"
# define ECLEN   256
# define TEXTLEN 16
# define KEYLEN  16
# define ENQ_PREFIX_LEN 20
# define DEQ_PREFIX_LEN 53

/** request structure */
typedef _Packed struct _request {

  size_t sql_len;
  char reserved[8];
  char *sql;
} request_t;

static request_t _r;

/** reply structure */
typedef _Packed struct _reply {

  int sqlcod;
  char reserved[12];
} reply_t;

/**
 * generate uuid
 *
 * @param[in/out] uuid, 16 bytes
 */
void gen_uuid(char *uuid);

/**
 * get job ccsid
 *
 * @return job's ccsid
 */
int get_job_ccsid();

/**
 * convert UTF-8 string to EBCDIC
 *
 * @param dest, result EBCDIC string
 */
void
utf8_2_ebcdic (
               const char *source,
               size_t source_length,
               char *dest
               );

/**
 * enq request SQL statement
 *
 * @param reqeust q
 * @param sql
 */
void enq_request(
                 _SYSPTR q,
                 const char *key,
                 const char *sql
                 );

/**
 * deq reply
 *
 * @return sqlcod
 */
int deq_reply(_SYSPTR q, const char* key);

/**
 * resolve request q and reply q
 *
 * @return 0, if okey, -1, if failed
 */
int resolve_queues(
                   _SYSPTR *request_q,
                   _SYSPTR *reply_q
                   );

/*
 * implements isqlsvr.sendRequest()
 *
 * - resolve request q
 * - resolve reply q
 * - enq SQL
 */
JNIEXPORT
jint
JNICALL
Java_isqlsvr_sendRequest (
                          JNIEnv *env,
                          jclass jthis,
                          jstring jsql
                          ) {

  int r = 0;
  int sqlcod = 0;
  jclass class_exception;
  const char *utf8_sql = NULL;
  char *sql = NULL;
  jboolean is_copy = JNI_FALSE;
  size_t len = 0;
  char uuid[16] = {0};

  _SYSPTR request_q = NULL;
  _SYSPTR reply_q = NULL;

  /* resolve qs */
  if(resolve_queues(&request_q, &reply_q) != 0) {

    // raise exception and return
# pragma convert(819)
    class_exception = (*env)->FindClass(env, "java/lang/Exception");
# pragma convert(0)
    if(class_exception != 0)
      (*env)->ThrowNew(env,
                       class_exception,
                       "Failed to resolve user queues"
                       );
    return;
  }

  // convert sql to ebcdic
  utf8_sql = (*env)->GetStringUTFChars(env, jsql, &is_copy);
  len = (*env)->GetStringUTFLength(env, jsql);
  sql = malloc(len * 2 + 1);
  utf8_2_ebcdic(utf8_sql, len, sql);
  (*env)->ReleaseStringUTFChars(env, jsql, utf8_sql);

  // enq request q
  gen_uuid(uuid);
  enq_request(request_q, uuid, sql);

  // deq reply q
  sqlcod = deq_reply(reply_q, uuid);

  free(sql);
  return sqlcod;
}

void gen_uuid(char *uuid) {

  _UUID_Template_T tmpl;

  memset(&tmpl, 0, 32);
  tmpl.bytesProv = 32;
  _GENUUID(&tmpl);

  memcpy(uuid, tmpl.uuid, 16);
}

int get_job_ccsid() {

  int ccsid = 0;
  Qwc_JOBI0400_t jobi;
  Qus_EC_t *ec = NULL;

  ec = (Qus_EC_t*)malloc(ECLEN);
  memset(ec, 0, ECLEN);
  ec->Bytes_Provided = ECLEN;
  jobi.Bytes_Avail = sizeof(Qwc_JOBI0400_t);
  QUSRJOBI(
           &jobi,
           sizeof(Qwc_JOBI0400_t),
           "JOBI0400",
           "*                         ",
           "                ",
           ec
           );
  if(ec->Bytes_Available != 0)
    ccsid = 37; // ascii ccsid
  else
    ccsid = jobi.Coded_Char_Set_ID;

  free(ec);
  return ccsid;
}

void
utf8_2_ebcdic (
               const char *source,
               size_t source_length,
               char *dest
               ) {

  size_t result_length = source_length * 2;
  char host_ccsid[32 + 1] = {0};
  iconv_t cvt;

  sprintf(host_ccsid,
          "IBMCCSID%05d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
          get_job_ccsid());
  cvt = iconv_open(host_ccsid, UTF8_CCSID);

  iconv(cvt,
        &source,
        &source_length,
        &dest,
        &result_length
        );

  iconv_close(cvt);
}

void enq_request(
                 _SYSPTR q,
                 const char *key,
                 char *sql
                 ) {

  _ENQ_Msg_Prefix_T *prefix;
  request_t *request = &_r;
  char text[16] = {0};

  prefix = (_ENQ_Msg_Prefix_T*)malloc(ENQ_PREFIX_LEN);
  memset(prefix, 0, ENQ_PREFIX_LEN);
  prefix->Msg_Len = TEXTLEN;
  memcpy(prefix->Msg, key, KEYLEN);

  request->sql_len = strlen(sql);
  request->sql = sql;
  memcpy(text, &request, 16);

  _ENQ(&q, prefix, text);

  free(prefix);
}

int deq_reply(_SYSPTR q, const char* key) {

  deq_prefix_t prefix;
  reply_t reply;

  prefix.acc_state_mod[0] = 0xF8; // 1111,1000; key realtion=EQ, deq infinitely
  memcpy(prefix.key_in, key, KEYLEN);

  _DEQWAIT(&prefix, &reply, &q);

  return reply.sqlcod;
}

int resolve_queues(
                   _SYSPTR *request_q,
                   _SYSPTR *reply_q
                   ) {

  int resolved = -1;
  volatile int ca = 0;

# pragma exception_handler(end, ca, _C1_OBJECT_NOT_FOUND, \
                           _C2_ALL, _CTLA_HANDLE)
  *request_q = rslvsp(0x0A02, REQUEST_Q, "", 0x0000);
  *reply_q = rslvsp(0x0A02, REPLY_Q, "", 0x0000);
  resolved = 0;

# pragma disable_handler

 end:
  return resolved;
}

/* eof - isqlsvr.c */
