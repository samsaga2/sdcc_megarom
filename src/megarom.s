.globl b_main
.globl _main
.globl l__DATA
.globl s__DATA
.globl l__INITIALIZER
.globl s__INITIALIZED
.globl s__INITIALIZER

.area _HEADER (ABS)

;; megarom header
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

init:
        ld      sp,(0xfc4a) ; Stack at the top of memory.
        call    gsinit ; Initialise global variables
        call    megarom

        ld e,#b_main
        ld hl,#_main
        call ___sdcc_bcall_ehl

        call    #0x0000; call CHKRAM

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

;;set_bank::
	;;ld (#0x7000),a
	;;ld (#_curr_bank),a
        ;;ret

;;get_bank::
	;;ld a,(#_curr_bank)
	;;ret

gsinit::

        ; Default-initialized global variables.
        ld      bc, #l__DATA
        ld      a, b
        or      a, c
        jr      Z, zeroed_data
        ld      hl, #s__DATA
        ld      (hl), #0x00
        dec     bc
        ld      a, b
        or      a, c
        jr      Z, zeroed_data
        ld      e, l
        ld      d, h
        inc     de
        ldir
zeroed_data:

        ; Explicitly initialized global variables.
        ld      bc, #l__INITIALIZER
        ld      a, b
        or      a, c
        jr      Z, gsinit_next
        ld      de, #s__INITIALIZED
        ld      hl, #s__INITIALIZER
        ldir

gsinit_next:

        ret


;
; trampoline to call banked functions
; used when legacy banking is enabled only
; Usage:
;   call ___sdcc_bcall
;   .dw  <function>
;   .dw  <function_bank>
;
___sdcc_bcall::
        ex      (sp), hl
        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        inc     hl
        ld      a, (hl)
        inc     hl
        inc     hl
        ex      (sp), hl
;
; trampoline to call banked functions with __z88dk_fastcall calling convention
; Usage:
;  ld   a, #<function_bank>
;  ld   bc, #<function>
;  call ___sdcc_bcall_abc
;
___sdcc_bcall_abc::
        push    hl
        ld      l, a
        ;;call    get_bank        ;must return A as current bank number, other registers expected to be unchanged
	ld a,(#_curr_bank)
        ld      h, a
        ld      a, l
        ex      (sp), hl
        inc     sp
        call    ___sdcc_bjump_abc
        dec     sp
        pop     af
        ;;jp      set_bank
	ld (#0x7000),a
	ld (#_curr_bank),a
	ret

;
___sdcc_bjump_abc:
        ;;call    set_bank        ;set current bank to A, other registers expected to be unchanged
	ld (#0x7000),a
	ld (#_curr_bank),a
        push    bc
        ret
;
; default trampoline to call banked functions
; Usage:
;  ld   e, #<function_bank>
;  ld   hl, #<function>
;  call ___sdcc_bcall_ehl
;
___sdcc_bcall_ehl::
        ;;call    get_bank
	ld a,(#_curr_bank)
        push    af
        inc     sp
        call    ___sdcc_bjump_ehl
        dec     sp
        pop     af
        ;;jp      set_bank
	ld (#0x7000),a
	ld (#_curr_bank),a
	ret

;
___sdcc_bjump_ehl:
        ld      a, e
        ;;call    set_bank
	ld (#0x7000),a
	ld (#_curr_bank),a
        jp      (hl)
        

        .area _DATA
_curr_bank::
        .ds 2

