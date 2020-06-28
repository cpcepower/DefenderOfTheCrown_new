; ------------------------------------------------------------------------------
; for compiling and writing an asm Binary file
; ---------------------------
	IF DOTC_CONSTANTS_I

	read "DoTC_Constants.asm"
	let DOTC_CONSTANTS_I = 0

	ENDIF

	IF DOTC_MACROS_I

	read "DoTC_Macros.asm"
	LET DOTC_MACROS_I = 0

	ENDIF

;	IF LINK_I

;	read "LINK.ASM"
;	LET LINK_I = 0

;	ENDIF
