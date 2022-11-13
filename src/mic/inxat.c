/// inxat.c

# include <stdlib.h>
# include <stdio.h>
# include <string.h>

# ifdef __OS400__
#   include <qusruiat.h>
#   include <qusec.h>
# endif

int main() {

# ifdef __OS400__
  Qus_IDXA0100_t info;
  char eb[256] = {0};
  Qus_EC_t *ec = (Qus_EC_t*)eb;
  ec->Bytes_Provided = 256;

  QUSRUIAT(
           &info,
           sizeof info,
           "IDXA0100",
           "EMIBUILTINLSBIN     ",
           ec
           );
  if(ec->Bytes_Available != 0) {

    printf("QUSRUIAT() failed, %7.7s\x25", ec->Exception_Id);
    return 1;
  }

# endif
  return 0;
}
