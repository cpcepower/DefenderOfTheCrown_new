; ------------------------------------------------------------------------------
; from INTRO.ASM
; ---------------------------
	read "DoTC_binary_header.asm"

	WRITE_DOTC_BIN_FILE INTRO, DOTC_INTRO_ADDRESS, DOTC_INTRO_LENGTH
; ---------------------------
intro:
; ---------------------------
	ld hl,intro0
	call menutex0
	ld a,5
	call wait_pause

	LOAD_DECOMP_SCR filename_title

	ld hl,filename_saxlong
	ld de,MEMORY_BANK2_ADR+16+2
; 	ld de,BUFIMA+16+2    ; +2 = skip file length
	call scr_load

	ld hl,theme
	call music_load

	call set_image_pal

	ld a,12
	call wait_pause

	call blackout

;	ld hl,BUFIMA+32+4; +2 = skip file length
	ld hl,MEMORY_BANK2_ADR+32+4; +2 = skip file length
	call decomp

;	ld hl,BUFIMA+16+4; +2 = skip file length
	ld hl,MEMORY_BANK2_ADR+16+4; +2 = skip file length
	call set_image_pal+3	; sauv_image_pal

	ld hl,intro1
	ld a,7
	call placard

	ld hl,intro2
	ld a,7
	call placard

	ld hl,intro3
	ld a,7
	call placard

	ld hl,intro4
	ld a,7
	call placard

	ld hl,intro5
	ld a,7
	call placard

	ld hl,intro6
	ld a,7
	call placard

	ld hl,intro7
	ld a,3
	call placard

	call choose

	ld hl,intro8
	ld a,12
	call placard

	LOAD_DECOMP_SCR filename_normlong
	call set_image_pal

	ld hl,intro_robin_mus
	call music_load

	ld hl,intro9
	ld a,15
	call placard

	ld hl,intro10
	ld a,15
	call placard

	jp music_off
; ---------------------------
	read "DoTC_Text_Intro.asm"
; ---------------------------
list:DOTC_INTRO_LENGTH equ $-DOTC_INTRO_ADDRESS:nolist