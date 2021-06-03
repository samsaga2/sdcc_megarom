#include "bank1.h"

void chput(char c) {
    __asm
    ld iy,#2
    add iy,sp
    ld a,0(iy)
    call 0x00a2
    __endasm;
}

void main() __banked {
    char a = test_func(65, 1);
    chput(a);
    while(1);
}
