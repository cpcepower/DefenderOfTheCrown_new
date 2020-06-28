; ------------------------------------------------------------------------------
	read "../include/macro_SET_ACTIVE_MEMORY_BANK.asm"
	read "../include/macro_SET_MEMORY_BANK.asm"
	read "../include/macro_SET_VAL_hl.asm"
	read "../include/macro_SET_GA_COLOR.asm"

	MACRO WRITE_DOTC_BIN_FILE DOTC_BIN_FILENAME, DOTC_BIN_ADDRESS, DOTC_BIN_LENGTH

	write ".\BIN\DOTC_BIN_FILENAME.BIN"

	list:org DOTC_BIN_ADDRESS:nolist

	dw DOTC_BIN_LENGTH

	ENDM

	MACRO LOAD_DECOMP_SCR SCREEN_NAME

	ld hl,SCREEN_NAME
	call scr_load_decomp

	ENDM

	MACRO INLINE_BC26 high,low

	ld a,high
	add a,&08
	ld high,a
	jr nc,$+12

	ld a,low
	add a,SCREEN_WIDTH
	ld low,a
	ld a,high
	adc a,-#40
	res 3,a
	ld high,a

	ENDM

	MACRO INLINE_BC26_BC

	INLINE_BC26 b,c

	ENDM

	MACRO INLINE_BC26_HL

	INLINE_BC26 h,l

	ENDM

	MACRO INLINE_BC26_DE

	INLINE_BC26 d,e

	ENDM

	MACRO TXT_LOCATE X,Y	; &BB5A - ASC 31-&1f Locate the text cursor

	ld hl,X*&100+Y
	call TXT_SET_CURSOR

	ENDM
; ------------------------------------------------------------------------------
