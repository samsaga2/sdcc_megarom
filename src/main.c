#include "test.h"

void chgmod(char c) __naked {
	c;
    __asm
    jp 0x005f
    __endasm;
}

void main() {
    chgmod(0);
    print_hello();
    print_hello_rev();
    while(1);
}
