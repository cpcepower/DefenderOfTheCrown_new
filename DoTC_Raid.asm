; ------------------------------------------------------------------------------
; from RAID.ASM
; ---------------------------
	read "dotc_binary_header.asm"

	WRITE_DOTC_BIN_FILE RAID, DOTC_RAID_ADDRESS, DOTC_RAID_LENGTH
; ---------------------------
;raid(c-raid_region,a-0=tresor.1,2=lady/#10,#20,#30,#40=tuteur)
;  hl->rob_help
raidexe
; ---------------------------
	ld (stake),a
	ld a,(hl)
	and #80
	ld (help),a
	res 7,(hl)
	ld hl,(lord)
	ld a,(hl)
	ld (raid_lord1),a
	ld a,c
;	ld (raid_region),a
	call rgetprop
	ld (raid_lord2),a
	ld hl,RAID_NORMLONG
	cp 5
	jr nc,raidchat
	ld hl,RAID_SAXLONG
raidchat
	call scr_load_decomp ; LOAD_DECOMP_SCR
	call set_image_pal
	ld hl,RAID_RAIDMUS
	call music_load

	ld a,(raid_lord2)
	call getlname
	push hl
	ld a,3
	call wait_pause
	ld hl,text_raid_intro
	ld a,12
	call placard
	call music_off

	LOAD_DECOMP_SCR RAID_COURT
;	ld hl,RAID_SONS
;	ld de,BUFMUS
;	call readfile

	ld hl,RAID_FIGHTERS
	ld de,BUFSPRLOAD
	call readfile
	ld hl,(anibuf)
	ld (hl),e
	inc hl
	ld (hl),d
	call lutinit
	ld a,1	  ;lord
	ld hl,10*256+56
	call lutin
	ld a,7	  ;guard
	ld hl,120*256+56
	call lutin
	ld a,10
	ld (lordx),a
	ld a,120
	ld (guardx),a
	ld a,(raid_lord1)
	call getlord
	ld b,(iy+02)	 ;sword
	ld a,(help)
	or a
	ld a,24
	call z,calcvu
	ld (lordvu),a
	call lvumetre
	ld a,(raid_lord2)
	call getlord
	ld b,(iy+02)
	call calcvu
	ld (guardvu),a
	call rvumetre
	call set_image_pal
	call setflash
	ld a,124
;	call fight
	dec a
	jp z,perdu
	dec a
	jp z,raid_abandon

	LOAD_DECOMP_SCR RAID_INTERIOR

	ld hl,RAID_FIGHTERS
	ld de,BUFSPRLOAD
	call readfile
	ld hl,(anibuf)
	ld (hl),e
	inc hl
	ld (hl),d
	call lutinit
	ld a,1	  ;lord
	ld hl,10*256+56
	call lutin
	ld a,7	  ;guard
	ld hl,50*256+56
	call lutin
	ld a,10
	ld (lordx),a
	ld a,50
	ld (guardx),a
	ld a,(lordvu)
	call lvumetre
	ld a,(raid_lord2)
	call getlord
	ld b,(iy+02)
	call calcvu
	ld (guardvu),a
	call rvumetre
	call set_image_pal
	call setflash
	ld a,52
;	call fight
	dec a
	jp z,perdu
	dec a
	jp z,raid_abandon
gagne
	ld a,(stake)
	or a
	jp nz,lady

	ld a,(raid_lord2)
	call getlname
	push hl
	ld hl,0
	ld b,128
	call paye_pc
	push hl
	ld a,(raid_lord1)
	call encaisse
	ld hl,text_raid_tresor
	ld a,10
	call placard
	or a
	ret
calcvu
	ld a,-6
	ld c,3
calcvu0 add a,c
	djnz calcvu0
	ret

lady
	ld a,(stake)
	srl a
	srl a
	srl a
	srl a
	ld b,a
	call isjoueur
	jp nz,notmine
	ld a,(stake)
	and &03
	add a,9
	call getlname
	push hl
	ld a,(raid_lord2)
	ld c,a
	call getlname
	push hl
	ld hl,text_raid_reunion
	ld a,10
	call placard
	or a
	ret
;
notmine
	ld a,(raid_lord1)
	ld b,a
	call lgetwife
	jp z,celibat
	ld a,(stake)
	and &03
	add a,9
	call getlname
	push hl
	ld a,(raid_lord2)
	ld c,a
	call getlname
	push hl
	ld hl,text_raid_rescue
	ld a,10
	call placard
	ld a,b
	call landfree
	jp nc,noland
	ld a,c
	call getrname
	push hl
	ld a,b
	call getlname
	push hl
	ld a,(stake)
	and #03
	add a,9
	call getlname
	push hl
	ld a,(raid_lord1)
	ld b,a
	call kado
	ld hl,text_raid_wonareg
	ld a,10
	call placard
	or a
	ret
noland
	ld a,(raid_lord1)
	call getlord
	ld a,(iy+01)
	cp 10
	jr nc,pasplus
	inc (iy+01)
pasplus
	ld hl,text_raid_respect
	ld a,10
	call placard
	or a
	ret
;
celibat
	ld a,(stake)
	and #03
	add a,9
	call getlname
	push hl
	ld hl,text_raid_greatest
	ld a,10
	call placard

	ld hl,RAID_PRINCESS
	ld de,BUFMUS
	call readfile
	LOAD_DECOMP_SCR RAID_BEDROOM

	ld hl,RAID_COUPLE1
	ld de,BUFSPRLOAD
	call readfile
	ld a,1
	ld hl,36*256+140
	call affsprb
	ld a,2
	ld hl,90*256+131
	call affsprb
	call set_image_pal
	call setflash
	call music_on
	ld a,10
	call wait_pause
	call music_off
	ld hl,RAID_COUPLE2
	ld de,BUFSPRLOAD
	call readfile
	ld a,1
	ld hl,36*256+140
	call affsprb
	ld a,2
	ld hl,90*256+131
	call affsprb
	ld hl,RAID_COUPLE3
	ld de,BUFSPRLOAD
	call readfile
	ld a,1
	ld hl,36*256+140
	call affsprb
	ld a,2
	ld hl,90*256+131
	call affsprb
	ld hl,RAID_COUPLE4
	ld de,BUFSPRLOAD
	call readfile
	ld a,1
	ld hl,36*256+140
	call affsprb
	ld a,2
	ld hl,90*256+131
	call affsprb
	ld hl,RAID_COUPLE5
	ld de,BUFSPRLOAD
	call readfile
	ld a,1
	ld hl,36*256+140
	call affsprb
	ld a,2
	ld hl,90*256+131
	call affsprb

	LOAD_DECOMP_SCR RAID_ROOMWALL

	ld hl,RAID_BLONDE
	ld a,(stake)
	and #0f
	cp 2
	jr z,leblond
	ld hl,RAID_BRUNE
leblond ld de,BUFSPRLOAD
	call readfile
	ld hl,41*256+183
	ld a,1
	call affspr
	call set_image_pal
	call music_on
	ld a,10
	call wait_pause
	call music_off

	LOAD_DECOMP_SCR RAID_ROOMWALL
	ld hl,RAID_BISOU1
	ld de,BUFSPRLOAD
	call readfile
	ld a,1
	ld hl,42*256+175
	call affsprb
	call set_image_pal
	ld hl,RAID_BISOU2
	ld de,BUFSPRLOAD
	call readfile
	ld a,1
	ld hl,42*256+175
	call affsprb
	ld hl,RAID_BISOU3
	ld de,BUFSPRLOAD
	call readfile
	ld a,1
	ld hl,42*256+175
	call affsprb
	ld hl,RAID_BISOU2
	ld de,BUFSPRLOAD
	call readfile
	ld a,1
	ld hl,42*256+175
	call affsprb
	ld hl,RAID_BISOU3
	ld de,BUFSPRLOAD
	call readfile
	ld a,1
	ld hl,42*256+175
	call affsprb
	ld a,2
	call wait_pause

	ld a,(raid_lord1)
	ld c,a
	ld a,(raid_lord2)
	ld b,a
	call retire
	call kill
	ld a,c
	ld c,b
	call getlord
	ld a,(stake)
	rrca
	rrca
	and #c0
	or (iy+05)
	ld (iy+05),a
	ld a,c
	call getlname
	push hl
	ld a,(stake)
	and &03
	add a,9
	call getlname
	push hl
	ld hl,text_raid_mariage
	ld a,10
	call placard
	call music_off
	or a
	ret
;
perdu
	ld a,3
	call wait_pause
	ld a,(raid_lord1)
	ld b,128
	ld hl,0
	call paye_pc
	ld de,text_raid_pieces
	ld a,h
	or a
	jr nz,pluriel
	ld a,l
	cp 2
	jr nc,pluriel
	ld de,text_raid_piece
pluriel push de
	push hl
	ld a,(raid_lord2)
	call encaisse
	ld a,(raid_lord2)
	call getlname
	push hl
	ld hl,text_raid_captured
	ld a,10
	call placard
	jp iflady
raid_abandon
	ld hl,text_raid_retraite
	ld a,10
	call placard
iflady ld a,(stake)
	or a
	ret z
	rra
	rra
	rra
	rra
	and #0f
	call isjoueur
	jr z,mygirl
	call getlname
	push hl
	ld a,(stake)
	and #0f
	add a,9
	call getlname
	push hl
	ld hl,text_raid_retlad
	ld a,5
	call placard
	or a
	ret
;
mygirl ld a,(raid_lord1)
	ld b,128
	ld hl,0
	call paye_pc
	push hl
	ld a,(raid_lord2)
	call encaisse
	ld a,(raid_lord2)
	call getlname
	push hl
	ld hl,text_raid_rancon
	ld a,10
	call placard
	or a
	ret
;
;fight(a-x max)->a-1=perdu,0=gagne,2=abandon
;
lordx ds 1
guardx ds 1
lordvu ds 1
guardvu ds 1
;
lordm ds 1
lordt ds 1
guardm ds 1
guardt ds 1
lbot  ds 1
gbot  ds 1
raid_xmax  ds 1
;
fspeed equ 3
ltouched equ 2
gtouched equ 3
lmoving equ 4
gmoving equ 5
closdist equ 20
;
;fight
;	ld hl,lordm
;	ld b,6
;f_init ld (hl),0
;	inc hl
;	djnz f_init
;	ld (raid_xmax),a
;	ld a,1
;	call getlut
;	ld a,b
;	ld (raid_larg1),a
;	ld a,c
;	ld (raid_haut),a
;	ld (raid_buff1),de
;	ld (raid_add1),hl
;	ld a,1
;	ld hl,BUFSPR
;	call getspr
;	ld (raid_sprite1),hl
;	ld a,2
;	call getlut
;	ld a,b
;	ld (raid_larg2),a
;	ld (raid_buff2),de
;	ld (raid_add2),hl
;	ld a,(ix+00)
;	ld hl,BUFSPR
;	call getspr
;	ld (raid_sprite2),hl
;	jp f_start
;f_bcle
;	call raid_multido
;
;f_start ld a,fspeed
;	call milpause
;
;	ld a,(lordt)
;	or a
;	jr z,f_nltouc
;	dec a
;	ld (lordt),a
;	ld a,(lordx)
;	cp 0
;	jp z,f_aband
;	dec a
;	dec a
;	ld (lordx),a
;	ld hl,#fe00
;	ld b,3
;	call raid_multset1
;	jp f_guard
;f_nltouc
;	ld a,(lordm)
;	or a
;	jr z,f_nlmove
;	cp lmoving/2
;	dec a
;	ld (lordm),a
;	jp nc,f_lnop
;	ld hl,#0000
;	ld b,1
;	call raid_multset1
;	jp f_guard
;f_nlmove
;	call getjoy
;	jr nc,f_nlclic
;	ld a,lmoving
;	ld (lordm),a
;	xor a
;	ld (lbot),a
;	ld hl,#0000
;	ld b,4
;	call raid_multset1
;	call tstclose
;	jr c,lclose
;	jp f_guard
;lclose ld a,(guardm)
;	cp gmoving/2
;	jr c,hitg
;;	ld a,8
;;	call bruit
;	jp f_guard
;hitg
;;	ld a,9
;;	call bruit
;	xor a
;	ld (gbot),a
;	ld a,gtouched
;	ld (guardt),a
;	ld a,(guardvu)
;	dec a
;	ld (guardvu),a
;	push af
;	call rvumetre
;	pop af
;	jp z,f_gagne
;	jp f_guard
;f_nlclic
;	bit 2,a
;	jr z,f_nlleft
;	ld a,(lordx)
;	cp 0
;	jp z,f_aband
;	dec a
;	dec a
;	ld (lordx),a
;	ld a,(lbot)
;	inc a
;	ld b,a
;	cp 4
;	jr nz,f_lbotl0
;	ld b,2
;	xor a
;f_lbotl0 ld (lbot),a
;	ld hl,#fe00
;	call raid_multset1
;	jp f_guard
;f_nlleft
;	bit 3,a
;	jr z,f_nlrigh
;	call tstclose
;	jp c,f_lnop
;	ld hl,lordx
;	inc (hl)
;	inc (hl)
;	ld a,(lbot)
;	inc a
;	ld b,a
;	cp 4
;	jr nz,f_lbotr0
;	ld b,2
;	xor a
;f_lbotr0 ld (lbot),a
;	ld hl,#0200
;	call raid_multset1
;	jp f_guard
;f_nlrigh
;	and #03
;	jr z,f_lnop
;	ld a,lmoving
;	ld (lordm),a
;	xor a
;	ld (lbot),a
;	ld hl,#0000
;	ld b,5
;	call raid_multset1
;	jp f_guard
;f_lnop
;	ld hl,(raid_add1)
;	ld (raid_oldadd1),hl
;
;f_guard
;	ld a,(guardt)
;	or a
;	jr z,f_ngtouc
;	dec a
;	ld (guardt),a
;	ld a,(guardx)
;	ld hl,raid_xmax
;	cp (hl)
;	jp z,f_gnop
;	inc a
;	inc a
;	ld (guardx),a
;	ld hl,#0200
;	ld b,9
;	call raid_multset2
;	jp f_bcle
;f_ngtouc
;	ld a,(guardm)
;	or a
;	jr z,f_ngmove
;	cp gmoving/2
;	dec a
;	ld (guardm),a
;	jp nc,f_gnop
;	ld b,7
;	ld hl,#0000
;	call raid_multset2
;	jp f_bcle
;f_ngmove
;	call tstclose
;	jp nc,f_ngtry
;	ld a,4
;	call random
;	cp 3
;	jr nz,f_ngrigh
;	ld a,(guardx)
;	ld hl,raid_xmax
;	cp (hl)
;	jp z,f_gnop
;	inc a
;	inc a
;	ld (guardx),a
;	ld a,(gbot)
;	inc a
;	ld b,a
;	cp 4
;	jr nz,f_gbotr0
;	ld b,2
;	xor a
;f_gbotr0 ld (gbot),a
;	ld a,6
;	add a,b
;	ld b,a
;	ld hl,#0200
;	call raid_multset2
;	jp f_bcle
;f_ngrigh
;	cp 2
;	jr z,f_ngclic
;	ld a,gmoving
;	ld (guardm),a
;	xor a
;	ld (gbot),a
;	ld b,10
;	ld hl,#0000
;	call raid_multset2
;	ld a,(lordm)
;	cp lmoving/2
;	jr c,hitl
;;	ld a,8
;;	call bruit
;	jp f_bcle
;hitl
;;	ld a,9
;;	call bruit
;	xor a
;	ld (lbot),a
;	ld a,ltouched
;	ld (lordt),a
;	ld a,(lordvu)
;	dec a
;	ld (lordvu),a
;	push af
;	call lvumetre
;	pop af
;	jp z,f_perdu
;	jp f_bcle
;f_ngclic
;	ld a,gmoving
;	ld (guardm),a
;	xor a
;	ld (gbot),a
;	ld hl,#0000
;	ld b,11
;	call raid_multset2
;	jp f_bcle
;f_ngtry
;	ld hl,guardx
;	ld a,4
;	call random
;	cp 4
;	jr nc,frecul0
;	ld de,#fe00
;	dec (hl)
;	dec (hl)
;	jr frecul1
;frecul0 ld a,(raid_xmax)
;	cp (hl)
;	jr z,f_gnop
;	ld de,#0200
;	inc (hl)
;	inc (hl)
;frecul1
;	ld a,(gbot)
;	inc a
;	ld b,a
;	cp 4
;	jr nz,f_gbotl0
;	ld b,2
;	xor a
;f_gbotl0 ld (gbot),a
;	ld a,6
;	add a,b
;	ld b,a
;	ex de,hl
;	call raid_multset2
;	jp f_bcle
;f_gnop
;	ld hl,(raid_add2)
;	ld (raid_oldadd2),hl
;	jp f_bcle
;;
;f_aband
;	ld a,2
;	ret
;;
;f_gagne
;	ld hl,(raid_add2)
;	ld (raid_oldadd2),hl
;	call raid_multido
;	ld a,2
;	call lutoff
;	ld a,1
;	call luton
;	ld a,2
;	call lutsave
;	call luton
;	ld hl,guardead
;	call animate
;	ld a,1
;	call lutoff
;	ld a,2
;	call luton
;	ld a,1
;	call lutsave
;	call luton
;	ld a,1
;	push ix
;	call getlut
;	ld h,(ix+01)
;	ld l,(ix+02)
;	pop ix
;	ld a,1
;	ld b,1
;	call lutmodv
;f_gagne0 ld a,(lordx)
;	inc a
;	inc a
;	ld (lordx),a
;	ld hl,raid_xmax
;	cp (hl)
;	jr nc,f_gagne2
;	ld hl,#0200
;	ld a,(lbot)
;	inc a
;	ld b,a
;	cp 4
;	jr nz,f_lbotw0
;	ld b,2
;	xor a
;f_lbotw0 ld (lbot),a
;	call sprmove
;	ld a,6
;	call milpause
;	jr f_gagne0
;f_gagne2 ld a,0
;	ret
;guardead
;	defb 2
;	defb #ba,13,-7,0,30
;	defb #ba,14,-27,0,30
;
;f_perdu
;	call raid_multido
;	ld a,1
;	ret
;
;tstclose
;	push bc
;	ld bc,(lordx)
;	ld a,b
;	sub c
;	cp closdist
;	pop bc
;	ret
;
;raid_multset1
;	push bc
;	push hl
;	ld a,1
;	call getlut
;	ld a,b
;	ld (raid_larg1),a
;	ld a,c
;	ld (raid_haut),a
;	ld (raid_oldadd1),hl
;	ld (raid_buff1),de
;	pop hl
;	ld a,(ix+01)
;	add a,h
;	ld (ix+01),a
;	ld h,a
;	ld a,(ix+02)
;	add a,l
;	ld (ix+02),a
;	ld l,a
;	call scradd
;	ld (raid_add1),hl
;	pop bc
;	ld (ix+00),b
;	ld a,b
;	ld hl,BUFSPR
;	call getspr
;	ld (raid_sprite1),hl
;	ret
;raid_multset2
;	push bc
;	push hl
;	ld a,2
;	call getlut
;	ld a,b
;	ld (raid_larg2),a
;	ld a,c
;	ld (raid_haut),a
;	ld (raid_oldadd2),hl
;	ld (raid_buff2),de
;	pop hl
;	ld a,(ix+01)
;	add a,h
;	ld (ix+01),a
;	ld h,a
;	ld a,(ix+02)
;	add a,l
;	ld (ix+02),a
;	ld l,a
;	call scradd
;	ld (raid_add2),hl
;	pop bc
;	ld (ix+00),b
;	ld a,b
;	ld hl,BUFSPR
;	call getspr
;	ld (raid_sprite2),hl
;	ret
;;
;raid_multido
;	ld hl,(raid_oldadd2)
;	ld de,(raid_oldadd1)
;	ld bc,(raid_larg1)
;	call raid_subst
;	ld (raid_offset1+1),hl
;	ld hl,(raid_add1)
;	ld de,(raid_oldadd2)
;	ld bc,(raid_larg2)
;	call raid_subst
;	ld (raid_offset2+1),hl
;	ld hl,(raid_add2)
;	ld de,(raid_add1)
;	ld bc,(raid_larg1)
;	call raid_subst
;	ld (raid_offset3+1),hl
;	ld (raid_offset5+1),hl
;	ld hl,(raid_add1)
;	ld de,(raid_add2)
;	ld bc,(raid_larg2)
;	call raid_subst
;	ld (raid_offset4+1),hl
;	ld hl,(raid_buff1)
;	ld (raid_bf1+1),hl
;	ld hl,(raid_buff2)
;	ld (raid_bf2+1),hl
;	ld hl,(raid_sprite1)
;	ld (raid_spr1+1),hl
;	ld hl,(raid_sprite2)
;	ld (raid_spr2+1),hl
;	ld a,(raid_larg1)
;	ld (raid_la10+1),a
;	ld (raid_la11+1),a
;	ld (raid_la12+1),a
;	ld a,(raid_larg2)
;	ld (raid_la20+1),a
;	ld (raid_la21+1),a
;	ld (raid_la22+1),a
;	ld a,(raid_larg1)
;	ld c,a
;	ld a,(raid_larg2)
;	add a,c
;	add a,3
;	ld c,a
;	ld b,0
;	ld hl,312
;	ld de,(raid_haut)
;	ld d,0
;	or a
;	sbc hl,de
;	ld d,-1
;raid_calcbcl sbc hl,bc
;	inc d
;	jr nc,raid_calcbcl
;	ld a,d
;	ld (raid_nlig+1),a
;	ld a,(raid_haut)
;	ld b,a
;	ld de,(raid_oldadd1)
;	call raid_tillbot
;
;raid_multbcl
;	push bc
;
;raid_bf1 ld hl,0
;raid_la10 ld bc,0
;	push de
;	ldir
;
;raid_offset1 ld hl,0
;	add hl,de
;	ex de,hl
;raid_bf2 ld hl,0
;raid_la20 ld bc,0
;	ldir
;
;raid_offset2 ld hl,0
;	add hl,de
;	ld de,(raid_bf1+1)
;raid_la11 ld bc,0
;	ldir
;	ld (raid_bf1+1),de
;
;raid_offset3 ld de,0
;	add hl,de
;	ld de,(raid_bf2+1)
;raid_la21 ld bc,0
;	ldir
;	ld (raid_bf2+1),de
;
;raid_offset4 ld de,0
;	add hl,de
;raid_spr1 ld de,0
;raid_la12 ld b,0
;	call raid_merge
;	ld (raid_spr1+1),de
;
;raid_offset5 ld de,0
;	add hl,de
;raid_spr2 ld de,0
;raid_la22 ld b,0
;	call raid_merge
;	ld (raid_spr2+1),de
;
;	pop de
;	ld hl,#800
;	add hl,de
;	jr nc,raid_nocarr
;	ld de,-#3fb0
;	jr raid_yecarr
;raid_nocarr ld de,#0000
;	add a,(hl)
;raid_yecarr add hl,de
;	ex de,hl
;
;	pop bc
;	dec c
;	call z,raid_tillbot
;	dec b
;	jp nz,raid_multbcl
;
;	ei
;	ret
;
;sprmove
;	call raid_multset1
;	ld hl,(raid_add1)
;	ld de,(raid_oldadd1)
;	ld bc,(raid_larg1)
;	call raid_subst
;	ld (sprmoff+1),hl
;	ld hl,(raid_buff1)
;	ld (sprmbuf+1),hl
;	ld hl,(raid_sprite1)
;	ld (sprmspr+1),hl
;	ld a,(raid_larg1)
;	ld (sprmla1+1),a
;	ld (sprmla2+1),a
;	ld (sprmla3+1),a
;
;	ld a,(raid_haut)
;	ld b,a
;	ld de,(raid_oldadd1)
;	call raid_tillbot
;
;sprmbcl
;	push bc
;
;sprmbuf ld hl,0
;sprmla1 ld bc,0
;	push de
;	ldir
;
;sprmoff ld hl,0
;	add hl,de
;	push hl
;
;	ld de,(sprmbuf+1)
;sprmla2 ld bc,0
;	ldir
;	ld (sprmbuf+1),de
;
;	pop hl
;sprmspr ld de,0
;sprmla3 ld b,0
;	call raid_merge
;	ld (sprmspr+1),de
;
;	pop de
;	ld hl,#800
;	add hl,de
;	jr nc,sprmcal
;	ld de,-#3fb0
;	add hl,de
;sprmcal ex de,hl
;
;	pop bc
;	djnz sprmbcl
;	ei
;	ret
;;
;raid_merge
;raid_merge10 ld a,(de)
;	and #55
;	jr nz,raid_merge11
;	ld a,(hl)
;	and #55
;	jr raid_merge12
;raid_merge11 push hl
;	pop hl
;raid_merge12 ld c,a
;	ld a,(de)
;	and #aa
;	jr nz,raid_merge13
;	ld a,(hl)
;	and #aa
;	jr raid_merge14
;raid_merge13 push hl
;	pop hl
;raid_merge14 or c
;	ld (hl),a
;	inc hl
;	inc de
;	bit 0,(hl)
;	bit 0,(ix+00)
;	djnz raid_merge10
;	ret
;;
;raid_subst
;	ld b,0
;	or a
;	sbc hl,bc
;	or a
;	sbc hl,de
;	ret
;;
;raid_tillbot
;	push bc
;	call vbl_wait
;	pop bc
;raid_nlig ld c,0
;	ret
;	read "../include/vbl_wait.asm"
;
;raid_haut ds 1
;raid_larg1 ds 1
;raid_larg2 ds 1
;
;raid_buff1 ds 2
;raid_oldadd1 ds 2
;raid_add1 ds 2
;raid_sprite1 ds 2
;
;raid_buff2 ds 2
;raid_oldadd2 ds 2
;raid_add2 ds 2
;raid_sprite2 ds 2
;
;
;lvumetre(a-intensite)
;
lvumetre
	push bc
	push hl

	ld c,#c3	 ;green
	ld hl,16*256+3	;left vu
	jr vumetre
; ---------------------------
; a -> intensite
rvumetre
; ---------------------------
	push bc
	push hl

	ld c,#c0	 ;red
	ld hl,96*256+3	;right vu
;
vumetre call scradd
	ld b,3
vumetr0
;vufill
	push hl
	push bc
	push af

	ld b,24
vufill0 or a
	jr nz,vufill1
	ld c,#0f	 ;black
vufill1 ld (hl),c
	inc hl
	dec a
	djnz vufill0

	pop af
	pop bc
	pop hl
	call nextline
	djnz vumetr0

	pop hl
	pop bc
	ret
; ---------------------------
;variables
; ---------------------------
raid_lord1
	ds 1		;lord attaquant
raid_lord2
	ds 1		;lord attaque
;raid_region
;	ds 1		;region attaquee
stake
	ds 1		;0=tresor,1=lady
help
	ds 1		;aide de robin
; ---------------------------
	read "DoTC_Text_Raid.asm"
; ---------------------------
list:DOTC_RAID_LENGTH equ $-DOTC_RAID_ADDRESS:nolist