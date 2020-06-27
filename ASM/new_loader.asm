
	read "constant.asm"

	write direct "a:-DEFEND.",&170

	org &170

	ld c,#07
	ld a,(#a700)
	push af
	ld hl,#aeff
	ld de,#0040
	call #bcce	; KL INIT BACK
	pop af
	ld (AMSDOS_current_drive),a

	ld a,#ff
	ld (#be78),a	; disc error message flag = &ff = off

	call LOAD_FILE
	jp START

LOAD_FILE
; ---------------------------
; HL = FILENAME PTR
; DE = BUFFER ADDRESS
; ---------------------------
	ld hl,main_filename
	ld de,START
	ld b,12
	push de
	call &bc77
	pop de
	jr nc,load_error
	ex de,hl
	call &bc83
	jr nc,load_error
	call &bc7a
	ret c
load_error
	call &bc7d
	jr LOAD_FILE
main_filename
	db "MAIN    .BIN"