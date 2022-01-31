;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.14 #12899 (MINGW32)
;--------------------------------------------------------
	.module test
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _print
	.globl _putch
	.globl b_print_hello
	.globl _print_hello
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _BANK2
;..\src\test.c:4: void putch(char c) __naked {
;	---------------------------------
; Function putch
; ---------------------------------
_putch::
;..\src\test.c:8: __endasm;
	jp	0x00a2
;..\src\test.c:9: }
;..\src\test.c:11: void print(char* c) {
;	---------------------------------
; Function print
; ---------------------------------
_print::
;..\src\test.c:12: do {
00101$:
;..\src\test.c:13: putch(*c);
	ld	c, (hl)
	push	hl
	ld	a, c
	call	_putch
	pop	hl
;..\src\test.c:14: } while(*c++);
	ld	a, (hl)
	inc	hl
	or	a, a
	jr	NZ, 00101$
;..\src\test.c:15: }
	ret
;..\src\test.c:17: void print_hello() __banked  {
;	---------------------------------
; Function print_hello
; ---------------------------------
	b_print_hello	= 2
_print_hello::
;..\src\test.c:18: print("Hello world from bank2-3 \r\n");
	ld	hl, #___str_0
;..\src\test.c:19: }
	jp	_print
___str_0:
	.ascii "Hello world from bank2-3 "
	.db 0x0d
	.db 0x0a
	.db 0x00
	.area _BANK2
	.area _INITIALIZER
	.area _CABS (ABS)
