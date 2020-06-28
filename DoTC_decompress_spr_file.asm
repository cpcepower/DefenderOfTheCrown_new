; load un fichier de sprite et éclate le
; puis sauvegarde les sprites en &c000

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

	xor a
	ld (decomp_all_width_screen),a
	ld (decomp_all_width_screen_already_add),a
	ld (decomp_save_height),a

	ld bc,0
	ld (decomp_save_bc),bc
	
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

	ld hl,&4000
	ld de,&4001
	ld (hl),&00
	ld bc,&3fff
	ldir

	ld hl,scr_filename
	ld de,&4000
	call system_load_file

	ld hl,palette
	call setpal
	ld hl,&4000
	ld de,&c000
decomp_all
	ld c,(hl)
	inc hl
	ld b,(hl)	; spr length
	inc hl
	ld a,b
	or c
	jr z,decomp_all_end
	call decomp

	ex de,hl

decomp_save_bc equ $+1
	ld bc,0
	ld a,c
	ld c,b
	ld b,0
	add hl,bc

	ld b,a

decomp_save_height equ $+1
	ld a,0
	cp b
	jr nc,decomp_save_height_done
	ld a,b
	ld (decomp_save_height),a
decomp_save_height_done

decomp_all_width_screen	equ $+1
	ld a,0
	add c
	ld (decomp_all_width_screen),a
	cp &50
	jr c,decomp_all_no_width_screen_end

	ld a,(decomp_save_height)
	cp b
	jr c,decomp_all_save_height_max_add_done
	ld b,a
decomp_all_save_height_max_add_done

	sra b
	sra b
	sra b	; / 8
	ld a,b
	ld bc,&0050
decomp_all_width_screen_add
	add hl,bc
	dec a
	jr nz,decomp_all_width_screen_add
	ld (decomp_all_width_screen),a
	
	push hl

decomp_all_width_screen_add_1
	ld a,l
decomp_all_width_screen_add_2
	sub &50
	jr nc,decomp_all_width_screen_add_2
	ld l,a
	ld a,h
	dec h
	and &07
	jr nz,decomp_all_width_screen_add_1
	ld a,l
	add &50
	ld (decomp_all_width_screen_add_value),a

	pop hl

	ld a,l
decomp_all_width_screen_add_value equ $ +1
	sub 0
	ld l,a
	jr nc,decomp_all_no_width_screen_end
	dec h

decomp_all_no_width_screen_end

	ld a,(decomp_save_bc+1)
	ld c,a

decomp_all_width_screen_already_add equ $+1
	ld a,0
	or a
	jr z,decomp_all_width_screen_already_add_end
	xor a
	ld (decomp_all_width_screen_already_add),a
	ld a,l
	add c
	ld l,a
	ld a,(decomp_all_width_screen)
	add c
	ld (decomp_all_width_screen),a
decomp_all_width_screen_already_add_end

	ex de,hl
	call &bd19
	jr decomp_all

decomp_all_end

	call &bd19

	call &bb06

	ld hl,scr_filename
	ld de,scr_decomp_filename
	ld bc,8
	ldir

	ld hl,scr_decomp_filename
	ld de,&4000
	ld bc,&c000
	ld a,2	; 2=binary; &16=ASCII

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
	db "DoTC .spr image decompressor by Megachur",10,13
	db "----------------------------------------",10,13,10,13
	db "Press any key after loading for writing...",10,13,10,13
	db "Loading file : ",0

filename_table
	db "END     "	; side 0
	db "FIRE    "

	db "BISOU1  "	; side 1
	db "BISOU2  "
	db "BISOU3  "
	db "BLONDE  "
	db "BRUNE   "
	db "COUPLE1 "
	db "COUPLE2 "
	db "COUPLE3 "
	db "COUPLE4 "
	db "COUPLE5 "
	db "FIGHTERS"

	db "BATSPR  "	; side 2
	db "CATANIM "
	db "CATSPR  "
	db "FACES   "
	db "MCATSPR "
	db "SPRSIEGE"
	db "TACTSPR "

	db "CHARGE  "	; side 3 - warning 2 screens for this one !
	db "GKNIGHT "
	db "JTOPSPR "
	db "SIDEDEAD"
	db "SIDELOST"
	db "SIDEWON "

	db 0

scr_filename
	db "XXXXXXXX",".SPR"

scr_decomp_filename
	db "XXXXXXXX",".SCR"

	read "../include/system_load_file.asm"
	read "../include/system_write_file.asm"

scr_file_ga_palette
	ds 16,0

palette ; TACTMAP.DEF
	db &08,&0E,&19,&06,&05,&04,&01,&11,&07,&09,&00,&14,&03,&10,&0F,&0D
;
setpal
	ld  b,16
	ld  a,0
chink
	push af
	push bc
	push de
	push hl

	ld c,(hl)

; system_set_color
	ld b,c

	call #bc32

	pop hl
	pop de
	pop bc
	pop af

	inc hl
	inc a
	djnz chink
	ret

; ---------------------------
decomp:
; hl -> address spr to decompress
; ---------------------------
	push de
	push bc
	push af

	ld c,(hl)		; height
	inc hl
	ld b,(hl)		; width
	inc hl

	ld a,(decomp_all_width_screen)
	add b
	cp &50
	jr c,decomp_no_width_screen_add
	ld a,1
	ld (decomp_all_width_screen_already_add),a

	push bc

	ld a,(decomp_save_height)
	cp c
	jr c,decomp_save_height_max_add_done
	ld c,a
decomp_save_height_max_add_done

	sra c
	sra c
	sra c	; / 8
	ld a,c
	inc a
	ld bc,&0050
	ex de,hl
decomp_width_screen_add
	add hl,bc
	dec a
	jr nz,decomp_width_screen_add

	ex de,hl
	push de

decomp_width_screen_add_1
	ld a,e
decomp_width_screen_add_2
	sub &50
	jr nc,decomp_width_screen_add_2
	ld e,a
	ld a,d
	dec d
	and &07
	jr nz,decomp_width_screen_add_1
	ld a,e
	add &50
	ld (decomp_width_screen_add_value),a

	pop de

	ld a,e
decomp_width_screen_add_value equ $ +1
	sub 0
	ld e,a
	jr nc,decomp_no_width_screen_end
	dec d

decomp_no_width_screen_end
	pop bc

decomp_no_width_screen_add
	ld (decomp_save_bc),bc

decomp_loop_y
	push de
	push bc
decomp_loop_x
	inc c
	ldi
	djnz decomp_loop_x

	pop bc
;	call &bd19
	pop de
	ex de,hl
	call &bc26
	ex de,hl
	dec c
	jr nz,decomp_loop_y

	pop af
	pop bc
	pop de
	ret
