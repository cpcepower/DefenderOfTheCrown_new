; ------------------------------------------------------------------------------
; from DEFAITE.ASM
; ---------------------------
	read "DoTC_binary_header.asm"

	WRITE_DOTC_BIN_FILE DEFEAT, DOTC_DEFEAT_ADDRESS, DOTC_DEFEAT_LENGTH

; ---------------------------
exedef:
; ---------------------------
	ld   a,2
	call wait_pause

	LOAD_DECOMP_SCR DEFEAT_SCASTLE

	ld   hl,DEFEAT_FIRE
	ld   de,BUFSPRLOAD
	call readfile
	ld   hl,256*72+193
	ld   a,1
	call affspr
	ld   hl,DEFEAT_MUS
	call music_load
	call set_image_pal
	call setflash
	ld   a,4
	call wait_pause
	ld   hl,deftxt0
	ld   a,15
	call placard
	ld   hl,deftxt1
	ld   a,10
	call placard
	ld   a,4
	jp wait_pause
; ---------------------------
	read "DoTC_Text_Defeat.asm"
; ---------------------------
list:DOTC_DEFEAT_LENGTH equ $-DOTC_DEFEAT_ADDRESS:nolist
