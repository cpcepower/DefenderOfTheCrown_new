; ------------------------------------------------------------------------------
; hl -> sp_save_regs
; ---------------------------
packfire_decrunch_partial:
; ---------------------------
	ld (packfire_save_registers_sp1),hl
	push af
	push bc
	push de
	push hl
	push ix
	push iy
	exx
	ex af,af'
	push af
	push bc
	push de
	push hl
	push ix
	push iy

	di

	ld (packfire_save_sp_restore_regs),sp
packfire_save_registers_sp1 equ $+1
	ld sp,packfire_save_registers

	pop iy
	pop ix
	pop hl
	pop de
	pop bc
	pop af
	exx
	ex af,af'
	pop iy
	pop ix
	pop hl
	pop de
	pop bc

packfire_ldir_max_buffer equ $+1
	ld a,0
	or a
	jr z,packfire_ldir_no_max_buffer

	dec a
	ld (packfire_ldir_max_buffer),a

	pop af
	ld (packfire_save_registers_sp2),sp

	ld sp,(packfire_save_sp_restore_regs)

	push af
	push hl

	ld bc,&0100
packfire_continue_ldir  equ $+1
	ld hl,0
	ldir
	jr packfire_continue_ldir_done

packfire_ldir_no_max_buffer
	pop af

	ld (packfire_save_registers_sp2),sp

packfire_save_sp_restore_regs equ $+1
	ld sp,0

	ei

packfire_partial_decrunch_call equ $+1
	call packfire_decrunch

	push af
;
; check if bc > max max buffer length = &0100 ?!
;
	ld a,(sm_len+2)
	cp &01
	jr c,packfire_bc_inf_max_buffer
	ld (packfire_ldir_max_buffer),a

	xor a				; max buffer length
	ld (sm_len+2),a

packfire_bc_inf_max_buffer
	push hl
	ld h,d
	ld l,e				; a3 = a1
	ld b,iyh
	ld c,iyl			; bc = d3
	or a				; clear carry
	sbc hl,bc

sm_len
	ld bc,&0000			; can be > 255
	ldir
	ld (packfire_continue_ldir),hl

packfire_continue_ldir_done
	pop hl
	pop af

	di

	ld (packfire_save_sp),sp
packfire_save_registers_sp2 equ $+1
	ld sp,packfire_save_registers

	push af
	push bc
	push de
	push hl
	push ix
	push iy
	exx
	ex af,af'
	push af
	push bc
	push de
	push hl
	push ix
	push iy

packfire_save_sp equ $+1
	ld sp,0

	ei

	pop iy
	pop ix
	pop hl
	pop de
	pop bc
	pop af
	exx
	ex af,af'
	pop iy
	pop ix
	pop hl
	pop de
	pop bc
	pop af

	ret

packfire_save_registers

; ------------------------------------------------------------------------------
; Packfire tiny decruncher for Z80 by Syx 2011
; Original MC68000 code by Franck "hitchhikr" Charlet
; ------------------------------------------------------------------------------

	MACRO GET_BIT

	add a,a
	jr nz,$+5
	ld a,(hl)
	inc hl
	adc a,a

	ENDM
; ------------------------------------------------------------------------------
; packfire_decrunch - HL = Source / DE = Destination
; ------------------------------------------------------------------------------
packfire_decrunch:
	push hl
	pop ix				 ; ix = table of frequency
	ld bc,26
	add hl,bc			; hl = crunch data
	ld a,(hl)			; initiliaze bit counter (a)
	inc hl
literal_copy
	ldi
main_loop
	GET_BIT				; call get_bit

	jr c,literal_copy
	ld iyl,&ff
get_index
	inc iyl
	GET_BIT				; call get_bit
	jr nc,get_index

	ex af,af'
	ld a,iyl
	cp &10
	ret z				; decrunch finish
	ex af,af'

	call get_pair			; before the call iy < 256 always, after return can be iy > 255
	ld (sm_len + 1),iy		; bytes to copy *** iy > 255 ***

	ex af,af'

	ld a,iyl
	cp 3
	jr nc,es_mayor_2
	dec a
	jr z,es_1
	dec a
	jr nz,es_0
es_2
	ld a,&04			; table_len[2]
	ld bc,&0020			; table_dist[2]
	jr fin_cmp
es_1
	ld a,&02			; table_len[1]
	ld bc,&0030			; table_dist[1]
	jr fin_cmp
es_0
es_mayor_2
	ld a,&04			; table_len[0]
	ld bc,&0010			; table_dist[0]
fin_cmp
	ld (sm_d0 + 1),bc
	ld b,a
	ex af,af'

	call get_bits
	jp get_pair     ; call get_pair

;	push hl
;	ld h,d
;	ld l,e				; a3 = a1
;	ld b,iyh
;	ld c,iyl			; bc = d3
;	or a				; clear carry
;	sbc hl,bc
;sm_len
;	ld bc,&0000			; can be > 255
;	ldir
;	pop hl
;	jr main_loop
; ------------------------------------------------------------------------------
; used registers a (d7), de (a1), hl (a2), ix (a0)
; free register bc, a', bc', de', hl'
get_pair
	ex af,af'
	exx
	inc iyl				; here iy < 256 always
	ld c,0				; a6 = 0.l

calc_len_dist
	ld a,c				; d0 = a6.w
	and &0f				; d0 &= &0f
	jr nz,node			; if d0 == &x0 then d5 = 1.w
	ld hl,1				; d5 = 1.w

node
	ld d,a				; save for the bit
	ld a,c				; d4 = a6.w (a6 <= 52 .b)
	rra				; d4 >> 1
	ld (sm_ix + 2),a
sm_ix
	ld a,(ix + 0)			; d1 = a0[d4].b (a0 => ix | d4 <= 26)

	bit 0,d				; d4 = 1 | d0 &=d4 =>d0 &= 1 (because d0 is changed next)
	jr z,nibble			; use low nibble
	rra
	rra
	rra
	rra				; d1 >> 4 use high nibble (nibble alternating)
nibble
	and &0f				; d1 &= &0f
	ld b,a				; d1 must go in register b for get_bits

	ld (sm_d0 + 1),hl		; d0 = d5.w (in the last pass has the value for sm_d0)

	; 1 << d1 (d1 = &0 - &f)
	ld de,&0000
	cp 8
	jr c,ponlo_en_e
ponlo_en_d
	sub 8
	or %01011000
	jr sigue_generando_el_set
ponlo_en_e
	or %01111000
sigue_generando_el_set
	rlca
	rlca
	rlca
	ld (sm_set + 1),a
sm_set
	set 0,a				; transform in set x,d or set x,e

	add hl,de			; d5 += d4.l
	inc c				; a6++
	dec iyl				; d3--
	jr nz,calc_len_dist

	ld a,b
	exx
	ld b,a
	ex af,af'

get_bits
	ld iy,0
	inc b

getting_bits
	djnz cont_get_bits

sm_d0
	ld bc,&0000
	add iy,bc
	ret

cont_get_bits
	GET_BIT				; call get_bit
	jr nc,solo_duplica_iy		; simulate adc iy,iy
	add iy,iy
	inc iy				; it looks that inc iyl works fine
	jr getting_bits
solo_duplica_iy
	add iy,iy
	jr getting_bits

; ---------------------------------------------------------------------------
;       |  SIZE|MegaLZ|BITBUS|HRUS21|PCD6.2|RIP.01|CHEESE|CPCT31| CROWN| APLIB|  EXO |PFIREt| PFIRE|   ZIP|    7Z
;-------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------
;code-1 | 27932| 12654| 12827| 12865| 12904| 12118| 15771| 14262| 16558| 12222| 12207| 12215| 10833| 12680| 11155
;code-2 | 14807|  7767|  8119|  8012|  8090|  7689| 10094|  9510| 11935|  7802|  7597|  7597|  7149|  7904|  7367
;code-3 | 35840|  8406|  8181|  8291|  8373|  7891| 10785| 10179| 10772|  7964|  7810|   (1)|  6302|  8667|  6542
;-------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------
;scrv-1 |  6912|  4672|  4757|  4705|  4764|  4551|  5219|  5104|  5250|  4692|  4568|  4568|  4430|  4687|  4455
;scrv-2 |  6912|  4074|  4170|  4144|  4173|  4030|  4691|  4802|  5317|  4116|  3971|  3970|  3901|  4228|  3980
;scrv-3 |  6912|  3604|  3717|  3722|  3753|  3544|  4174|  4273|  4854|  3677|  3517|  3516|  3370|  3679|  3448
;scrv-4 |  6912|  2211|  2270|  2359|  2366|  2165|  2783|  2696|  3697|  2228|  2063|  2063|  2008|  2301|  2121
;scrv-5 |  6912|  4399|  4470|  4486|  4524|  4298|  5050|  5048|  5558|  4421|  4249|  4249|  4158|  4476|  4173
;scrv-6 |  6912|  4233|  4300|  4345|  4364|  4129|  4873|  5084|  5634|  4291|  4093|  4093|  4053|  4297|  4086
;scrv-7 |  6912|  3788|  3902|  3921|  3942|  3721|  4534|  4512|  5468|  3800|  3625|  3625|  3506|  3878|  3624
;scrv-8 |  6912|  5275|  5345|  5308|  5373|  5139|  5928|  5888|  6480|  5305|  5080|  5088|  4994|  5015|  5344
;scrv-9 |  6912|  4958|  5081|  5048|  5095|  4844|  5677|  5732|  6285|  5031|  4818|  4818|  4673|  5035|  4752
;-------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------
;text-1 |  6859|  3858|  4077|  4004|  4029|  3726|  5084|  4963|  6133|  3946|  3794|  3794|  3595|  3857|  3751
;text-2 | 21746|  7341|  7766|  7549|  7470|  6525| 12202|  8178| 11223|  6878|  6584|  6584|  6047|  6642|  6175
;text-3 | 28352| 10252| 11156| 10360| 10246|  8847| 17537| 11304| 15258|  9383|  8990|  8990|  8241|  8955|  8365
;text-4 | 39159| 20406| 22246| 20892| 20752| 17334|   (2)| 23343| 30728| 19247| 17830|   (1)| 16451| 17534| 16584
;text-5 | 25149| 10443| 11225| 10618| 10515|  9088| 15998| 11754| 16359|  9712|  9293|  9292|  8554|  9236|  8627
;
;(1) Original file is bigger 32KBs, PackFire tiny doesn't compress
;(2) Original file is bigger 38KBs, Cheese Cruncher doesn't compress
;
;NOTES:
;.- The CPC native crunchers are "Cheese Cruncher v2.2", "CPCT v3.1" and "Crown Cruncher v1.4".
;.- All the files sizes are without Amsdos headers.
;.- PFIREt is PackFire tiny mode and PFIRE is PackFire normal mode.
;.- There is not CPC decruncher for ZIP, 7Z and PackFire normal mode.
