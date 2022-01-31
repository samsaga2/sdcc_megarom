;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.14 #12899 (MINGW32)
;--------------------------------------------------------
	.module main
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl b_print_hello_rev
	.globl _print_hello_rev
	.globl b_print_hello
	.globl _print_hello
	.globl _chgmod
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
	.area _BANK0
;..\src\main.c:3: void chgmod(char c) __naked {
;	---------------------------------
; Function chgmod
; ---------------------------------
_chgmod::
;..\src\main.c:7: __endasm;
	jp	0x005f
;..\src\main.c:8: }
;..\src\main.c:10: void main() {
;	---------------------------------
; Function main
; ---------------------------------
_main::
;..\src\main.c:11: chgmod(0);
	xor	a, a
	call	_chgmod
;..\src\main.c:12: print_hello();
	ld	e, #b_print_hello
	ld	hl, #_print_hello
	call	___sdcc_bcall_ehl
;..\src\main.c:13: print_hello_rev();
	ld	e, #b_print_hello_rev
	ld	hl, #_print_hello_rev
	call	___sdcc_bcall_ehl
;..\src\main.c:14: while(1);
00102$:
;..\src\main.c:15: }
	jp	00102$
	.area _BANK0
	.area _INITIALIZER
	.area _CABS (ABS)
