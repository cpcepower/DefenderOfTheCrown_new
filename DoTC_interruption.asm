; ------------------------------------------------------------------------------
	jr z80_interruption_1:nop	; INT1
	jr z80_interruption_back:nop	; INT2
	jr z80_interruption_back:nop	; INT3
	jr z80_interruption_back:nop	; INT4
	jr z80_interruption_back:nop	; INT5
	jr z80_interruption_back:nop	; INT6
; ---------------------------
z80_interruption_1:
; ---------------------------
	call fdc_sense_interrupt

; clignotement des couleurs 4 et 5
flash_color_activate equ $+1
	ld a,&00
	or a
	jr z,flash_color_end

	ld hl,flash_color_wait_value
	inc (hl)
flash_color_wait_value equ $+1
	ld a,0
flash_color_wait_value_max equ $+1
	cp &0a
	jr nz,flash_color_end
	xor a
	ld (hl),a

	ld hl,flash_colors
; nb of colors to flash (2 max)
	ld b,&7f

	outi
	inc b
	ld a,(hl)
	outi
	inc b
	outi
	inc b
	ld c,(hl)
	outi
;	inc b

; inverse les deux couleurs
	dec hl
	ld (hl),a
	dec hl
	dec hl
	ld (hl),c

flash_color_end

	call keyboard_scan

	SET_MEMORY_BANK MEMORY_BANK1

current_music_enable_play	equ $+1
	ld a,&00
	or a
	call nz,play_music

;	SET_MEMORY_BANK MEMORY_BANK0

	jr z80_interruption_back
; ---------------------------
;z80_interruption_5:
; ---------------------------
;	jr z80_interruption_back
; ------------------------------------------------------------------------------
