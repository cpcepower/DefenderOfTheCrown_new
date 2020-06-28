; ------------------------------------------------------------------------------
	read "DoTC_binary_header.asm"

	write ".\BIN\-DEFEND."

	org BUFOVL

	ld a,2
	call &bc0e

; 128 ko ?

	ld hl,&4000
	xor a
	ld (hl),a

	ld bc,&7fc7
	out (c),c

	dec a
	ld (hl),a

	ld bc,&7fc0
	out (c),c

	ld a,(hl)
	or a
	jr nz,no_128ko

	call #bca7

	ld c,#07
	ld a,(#a700)
	push af
	ld hl,#aeff
	ld de,#0040
	call #bcce	; KL INIT BACK
	pop af
	ld (AMSDOS_current_drive),a

	ld bc,&0000	; set all colors to black
	call &bc38	; SCR SET BORDER

	ld a,16
set_pen_color
	push af
	ld bc,&0000
	call #bc32	; SCR SET INK
	pop af
	dec a
	jp pe,set_pen_color

	call #bd19

	ld hl,no_128ko_end
	ld (hl),&c9
        ld hl,text_loading
	call no_128ko_loop

	ld hl,main_filename
	ld de,DOTC_MAIN_START
	call system_load_file

	di

	ld hl,crtc_regs_value
	call set_crtc_regs

	ex de,hl
	jp (hl)
no_128ko
	ld hl,text_no_128ko
no_128ko_loop
	ld a,(hl)
	inc hl
	cp &ff
	jr z,no_128ko_end
	call &bb5a
	jr no_128ko_loop
no_128ko_end
	call &bb06
	rst 0
text_loading
	db "- Defender of The Crown - Orginal game coding (c) 1989 by B.RIVE",10,13,10,13
	db "(c) 2012 version and code optimization by Megachur",10,13,10,13
	db "Design and fantastic graphics by TotO !",10,13,10,13
	db "Loading main program in progress...",10,13,10,13
	db &ff
text_no_128ko
	db "Sorry, no 128kb detected !",10,13
	db "Press any key to reset..."
	db &ff


	read "../include/system_load_file.asm"
main_filename
	db "DOTC    .BIN"
; ---------------------------
	read "../include/crtc_set_regs.asm"
	read "../include/data_crtc_basic_value.asm"
; ---------------------------
	ret
; ------------------------------------------------------------------------------