#include "megarom.h"

extern unsigned char test_var;

void chput(char c) {
  __asm
  ld hl,#2
  add hl,sp
  ld a,(hl)
  call 0x00a2
  __endasm;
}

void test() {
  char *str = (char*)0xa000;
  PAGE3(2);
  chput(test_var);
  do {
    chput(*str);
  } while(*str++);
}
