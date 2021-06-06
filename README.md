How to compile?
===============

Dependencies:
- Linux
- gcc
- sdcc 4.1

Compile command:
`make`

Megarom
=======

Konami with SCC 512kb.

Pages 0&1 are fixed, never changes.
Pages 2&3 always change together.

How to add source file
======================

Add compile line to Makefile:
`cd build && sdcc $(CCFLAGS) --codeseg BANK2 --code-size $(BANKn_SIZE) -c ../src/module.c`

To assign the module to a different page change BANK2 to the desired megarom page.

The pages go in pairs. So each module can have up to 0x4000 bytes. Except the first page that can have up to 0x3f00 (it contains the megarom header).

Banked methods
==============

Mark as __banked the functions that are callable from another pages. Call bankable functions has a small performance impact.

Non-banked functions are only callable inside the same module. It doesn't has any performance impact.
