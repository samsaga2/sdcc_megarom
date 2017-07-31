#include "test_funcs.h"
#include "megarom.h"

void main() {
  PAGE2(50);
  __asm
  call ADDR_TEST
  __endasm;
  while(1);
}
