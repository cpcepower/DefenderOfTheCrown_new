	read	"LINK.ASM"

	MACRO EXE_FONCTION1 FONCTION, arg1

	dw FONCTION
	dw arg1

	ENDM

	MACRO EXE_FONCTION2 FONCTION, arg1, arg2

	dw FONCTION
	dw arg1
	dw arg2

	ENDM

	MACRO GET_ARG_DE

	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	push de

	ENDM
;
;
SCENE_EXECUTE
; input - hl - ptr on scene tab
;
	push af
	push de
	push hl

	GET_ARG_DE
	GET_ARG_DE
	ex de,hl



	pop hl
	pop de
	pop af
	ret

TAB_DEFAITE
	EXE_FONCTION1 WAIT_PAUSE, 2
	EXE_FONCTION2 READFILE, SCASTLE, BUFIMA
	EXE_FONCTION1 BLACKOUT, DECOMP