.globl        _main

.globl s__INITIALIZER
.globl s__INITIALIZED
.globl l__INITIALIZER

.area _HEADER (ABS)
        ; Reset vector
        .org 0x4000
        .db  0x41
        .db  0x42
        .dw  init
        .dw  0x0000
        .dw  0x0000
        .dw  0x0000
        .dw  0x0000
        .dw  0x0000
        .dw  0x0000

        ; Ordering of segments for the linker.
        ;; Ordering of segments for the linker.
        .area        _HOME
        .area        _CODE
        .area        _INITIALIZER
        .area   _GSINIT
        .area   _GSFINAL

        .area        _DATA
        .area        _INITIALIZED
        .area        _BSEG
        .area   _BSS
        .area   _HEAP

        .area        _CODE

init:
        ld      sp,(0xfc4a) ; Stack at the top of memory.
          call    gsinit ; Initialise global variables
        call    megarom
        call    _main
        call    #0x0000; call CHKRAM

;
; ------------------------------------------
; Special load routine that initiates static writable data

        .area   _GSINIT

gsinit::
        push af
        push bc
        push de
        push hl
        ld      bc, #l__INITIALIZER
        ld      a,b
        or      a,c
        jr      z, gsinit_next
        ld      de, #s__INITIALIZED
        ld      hl, #s__INITIALIZER
        ldir
gsinit_next:
        .area   _GSFINAL
        pop hl
        pop de
        pop bc
        pop af
        ret

megarom::
        ;; locate 32k
	      call #0x00138
	      rrca
	      rrca
	      and #0x003
	      ld c,a
	      ld hl,#0x0fcc1
	      add a,l
	      ld l,a
	      ld a,(hl)
	      and #0x080
	      or c
	      ld c,a
	      inc l
	      inc l
	      inc l
	      inc l
	      ld a,(hl)
	      and #0x00c
	      or c
	      ld h,#0x080
	      call #0x00024

        ;; default slots
        xor a
        ld (#0x5000),a
        inc a
        ld (#0x7000),a
        inc a
        ld (#0x9000),a
        inc a
        ld (#0xb000),a
        ret
