Konami5 MEGAROM


Memory Banks:
  - bank 0: fixed code page 0
  - bank 1: fixed coed page 1
  - bank 2: paginated code (pages 50..63)
  - bank 3: paginated resources (pages 2..49)


Call from bank 2 to banks 0/1/2:
  test_function();


Call from bank 0/1 to bank 2 (no arguments, but you can dig on the stack and read the calling func arg):
  #include "test_funcs.h"
  ...
  _asm call ADDR_TEST __endasm;


Dependencies:
  - linux (for scripts)
  - sjasm (for resources.asm)
  - sdcc (for everything else)


Variables:
  All vars must be on the variables.c file.
