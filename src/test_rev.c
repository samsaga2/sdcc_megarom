#include "test.h"

void putch_rev(char c) __naked {
	c;
    __asm
    jp 0x00a2
    __endasm;
}

void print_rev(char* c) {
    do {
        putch_rev(*c);
    } while(*c++);
}

void print_hello_rev() __banked  {
    print_rev("Hello world from bank4-5  \r\n");
}
