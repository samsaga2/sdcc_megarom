#include "test.h"

void chgmod(char c) {
    __asm
    ld iy,#2
    add iy,sp
    ld a,0(iy)
    call 0x005f
    __endasm;
}

void main() {
    chgmod(0);
    print_hello();
    while(1);
}
