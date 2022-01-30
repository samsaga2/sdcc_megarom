#include "test.h"

void putch(char c) {
    __asm
    call 0x00a2
    __endasm;
}

void print(char* c) {
    do {
        putch(*c);
    } while(*c++);
}

void print_hello() __banked {
    print("Hello world");
}
