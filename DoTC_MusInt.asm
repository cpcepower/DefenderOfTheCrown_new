; ------------------------------------------------------------------------------
; player ayc
; ---------------------------
	read "DoTC_binary_header.asm"

;	WRITE_DOTC_BIN_FILE PLAYER, DOTC_MUSICINT_ADDRESS, DOTC_MUSICINT_LENGTH

	write ".\BIN\PLAYER.BIN"

	list:org DOTC_MUSICINT_ADDRESS:nolist

	read "../include/play_ay_v1_1a.asm"
; ---------------------------
DOTC_MUSICINT_LENGTH equ $-DOTC_MUSICINT_ADDRESS
; ------------------------------------------------------------------------------
