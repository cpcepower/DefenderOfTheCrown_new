; ------------------------------------------------------------------------------; from ROBIN.ASM; ---------------------------	read "DoTC_binary_header.asm"	WRITE_DOTC_BIN_FILE ROBIN, DOTC_ROBIN_ADDRESS, DOTC_ROBIN_LENGTH; ---------------------------; hl -> (rob_help); a  -> 1 raid or 2 conquestrobinexe:; ---------------------------	push bc	bit 7,(hl)	jr nz,dejafait	push bc	ld c,a	ld a,(hl)	and #03	ld a,c	pop bc	jr z,toomuch	set 7,(hl)	dec a	jr z,pourraid	ld hl,okconq	jr affitpourraid	ld hl,okraid	jr affitdejafait	ld hl,deja	jr affittoomuch	ld hl,tropaffit	push hl	LOAD_DECOMP_SCR ROBIN_normlong	call set_image_pal	ld hl,ROBIN_music	call music_load	pop hl	ld a,10	call placard	call music_off	pop bc	ret; ---------------------------	read "DoTC_Text_Robin.asm"; ---------------------------list:DOTC_ROBIN_LENGTH equ $-DOTC_ROBIN_ADDRESS:nolist