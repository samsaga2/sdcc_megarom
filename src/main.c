#include "test.h"

void chgmod(char c) {
    __asm
    call 0x005f
    __endasm;
}

void main() {
    chgmod(0);
    print_hello();
    while(1);
}
