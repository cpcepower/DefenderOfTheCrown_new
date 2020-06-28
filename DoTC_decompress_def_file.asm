; load une image et decompresse la
; puis sauvegarde le screen en &c000

	org &3000

	nolist

	ld hl,filename_table

convert_all_loop
	ld a,(hl)
	or a
	ret z

	ld de,scr_filename
	ld bc,8
	ldir

	push hl

	ld a,2
	call &bc0e

	ld hl,text_loading
	ld de,scr_filename
	call print_text

	call &bb06

	ld a,0
	call &bc0e

	call &bd19

	ld hl,&c000
	ld de,&c001
	ld (hl),&00
	ld bc,&3fff
	ldir

	ld hl,scr_filename
	ld de,&4000
	call system_load_file

	ld hl,&4000
	ld de,scr_file_ga_palette
	call setpal_and_convert
;	ld hl,&4000+16
	call decomp

	call &bd19

	call &bb06

	ld hl,scr_filename
	ld de,scr_decomp_filename
	ld bc,8
	ldir

	ld hl,scr_filename
	ld de,scr_decomp_filename_pal
	ld bc,8
	ldir

	ld hl,scr_decomp_filename
	ld de,&4000
	ld bc,&c000
	ld a,2	; 2=binary; &16=ASCII

	call system_write_file

	ld hl,scr_decomp_filename_pal
	ld de,16
	ld bc,scr_file_ga_palette
	ld a,2

	call system_write_file

	pop hl
	jp convert_all_loop

print_text
print_text_loop
	ld a,(hl)
	or a
	jr z,print_text_end
	inc hl
	call &bb5a
	jr print_text_loop
print_text_end
	ex de,hl
	ld b,12
print_filename_loop
	ld a,(hl)
	inc hl
	call &bb5a
	djnz print_filename_loop
	ret

text_loading
	db "DoTC .def image decompressor by Megachur",10,13
	db "----------------------------------------",10,13,10,13
	db "Press any key after loading for writing...",10,13,10,13
	db "Warning 16 colors saved before screen data",10,13,10,13
	db "Loading file : ",0

filename_table
	db "CROWNING"   ; side 0
	db "NAMES   "
	db "NORMLONG"
	db "SAXLONG "
	db "SCASTLE "
	db "TITLE   "
	db "BEDROOM "   ; side 1
	db "COURT   "
	db "INTERIOR"
;	db "NORMLONG"
	db "ROOMWALL"
;	db "SAXLONG "
	db "BATBACK "   ; side 2
	db "NCASTLE "
;	db "NORMLONG"
	db "PLOTTERS"
;	db "SAXLONG "
;	db "SCASTLE "
	db "TACTMAP "
	db "GALLERY "	; side 3
	db "JOUSTOP "
	db "SIDE    "
	db "TENTS   "
	db "TRUMP   "
	db 0
scr_filename
	db "XXXXXXXX",".DEF"

scr_decomp_filename
	db "XXXXXXXX",".SCR"

scr_decomp_filename_pal
	db "XXXXXXXX",".PAL"

	read "../include/system_load_file.asm"
	read "../include/system_write_file.asm"

scr_file_ga_palette
	ds 16,0

palette0
	defb #00,#00,#00,#00
	defb #00,#00,#00,#00
	defb #00,#00,#00,#14
	defb #03,#10,#0f,#0d
palfix
	defb #14,#03,#10,#0f,#0d
;
blackout
	ld  hl,palette0

setpal_and_convert
	ld  b,16
	ld  a,0
chink
	push af
	push bc
	push de
	push hl

	ld b,a

	ld a,(hl)
	ld c,a

; convert_color
	add a,table_Basic_color_to_Gate_Array
	ld l,a
	adc a,table_Basic_color_to_Gate_Array/&100
	sub l
	ld h,a
	ld a,(hl)
	and &1f
	or &40
	ld (de),a

; system_set_color
	ld a,b
	ld  b,c

	call #bc32

	pop hl
	pop de
	pop bc
	pop af

	inc hl
	inc de
	inc a
	djnz chink
	ret

; ---------------------------
decomp:
; hl -> address screen to decompress
; ---------------------------
	push hl
	push de
	push bc
	push af

	ld de,&c000
decomp0
	bit 6,d
	jr z,decomp1
	ld b,1
	ld a,(hl)
	inc hl
	cp 01
	jr nz,decomp2
	ld b,(hl)
	inc hl
	ld a,(hl)
	inc hl
decomp2
	ld (de),a
	inc de
	djnz decomp2
	jr decomp0
decomp1
	pop af
	pop bc
	pop de
	pop hl
	ret
;
; table to convert from software colour number to hardware colour number
;
table_Basic_color_to_Gate_Array
	db &14,&04,&15,&1c,&18,&1d,&0c,&05,&0d,&16,&06,&17,&1e,&00,&1f,&0e,&07,&0f
	db &12,&02,&13,&1a,&19,&1b,&0a,&03,&0b,&01,&08,&09,&10,&11
