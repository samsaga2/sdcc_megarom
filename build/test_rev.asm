;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.14 #12899 (MINGW32)
;--------------------------------------------------------
	.module test_rev
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _print_rev
	.globl _putch_rev
	.globl b_print_hello_rev
	.globl _print_hello_rev
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
	.area _BANK4
;..\src\test_rev.c:3: void putch_rev(char c) __naked {
;	---------------------------------
; Function putch_rev
; ---------------------------------
_putch_rev::
;..\src\test_rev.c:7: __endasm;
	jp	0x00a2
;..\src\test_rev.c:8: }
;..\src\test_rev.c:10: void print_rev(char* c) {
;	---------------------------------
; Function print_rev
; ---------------------------------
_print_rev::
;..\src\test_rev.c:11: do {
00101$:
;..\src\test_rev.c:12: putch_rev(*c);
	ld	c, (hl)
	push	hl
	ld	a, c
	call	_putch_rev
	pop	hl
;..\src\test_rev.c:13: } while(*c++);
	ld	a, (hl)
	inc	hl
	or	a, a
	jr	NZ, 00101$
;..\src\test_rev.c:14: }
	ret
;..\src\test_rev.c:16: void print_hello_rev() __banked  {
;	---------------------------------
; Function print_hello_rev
; ---------------------------------
	b_print_hello_rev	= 4
_print_hello_rev::
;..\src\test_rev.c:17: print_rev("Hello world from bank4-5  \r\n");
	ld	hl, #___str_0
;..\src\test_rev.c:18: }
	jp	_print_rev
___str_0:
	.ascii "Hello world from bank4-5  "
	.db 0x0d
	.db 0x0a
	.db 0x00
	.area _BANK4
	.area _INITIALIZER
	.area _CABS (ABS)
