#include "test.h"


void putch(char c) __naked {
	c;
    __asm
    jp 0x00a2
    __endasm;
}

void print(char* c) {
    do {
        putch(*c);
    } while(*c++);
}

void print_hello() __banked  {
    print("Hello world from bank2-3 \r\n");
}
