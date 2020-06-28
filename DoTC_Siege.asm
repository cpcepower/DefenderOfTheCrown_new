; ------------------------------------------------------------------------------
; from SIEGE.ASM
; ---------------------------
	read "DoTC_binary_header.asm"

	WRITE_DOTC_BIN_FILE SIEGE, DOTC_SIEGE_ADDRESS, DOTC_SIEGE_LENGTH
; ---------------------------
; (a-siege_lord1,b-siege_lord2,c-siege_region) -> a-castresi
exesiege
; ---------------------------
	ld (siege_lord1),a
	ld a,b
	ld (siege_lord2),a
	ld a,c
	ld (siege_region),a

	ld hl,siegval
	ld de,days
	ld bc,5
	ldir
	ld a,(siege_lord2)
	call lgetype
	ld hl,SIEGE_SAXLONG
	dec a
	push af
	jr z,essaxon
	ld hl,SIEGE_NORMLONG
essaxon
	call scr_load_decomp ; LOAD_DECOMP_SCR
	ld hl,SIEGE_SPRSIEGE
	ld de,BUFSPRLOAD
	call readfile
	pop af
	push af
	ld a,2
	ld hl,28*256+85
	jr nz,essaxon3
	ld a,1
	ld hl,36*256+92
essaxon3
	call affspr
	ld hl,SIEGE_MUS
	call music_load
	call set_image_pal
	ld a,8
	call wait_pause
	ld hl,SIEGE_SCASTLE
	pop af
	jr z,essaxon2
	ld hl,SIEGE_NCASTLE
essaxon2
	ld (siegcast),hl
	call music_off
	ld a,2
	ld (lordcol+1),a
	call affsiege
	call music_on
	ld a,4
	call wait_pause
	ld a,(siege_lord2)
	call getlname
	push hl
	ld hl,siegtxt
	ld a,14
	call placard
	call music_off
esmenu
	ld hl,SIEGE_MCATSPR
	ld de,BUFSPRLOAD
	call readfile
	ld (savebuf),de         ; menusave called in menutext scratch at this memory address !!!
	ld hl,(days)
	ld h,0
	push hl
	ld a,(castle)
	ld de,10
	ld hl,0
	ld b,a
escascal add hl,de
	djnz escascal
	push hl
	ld a,(siege_region)
	call rgetcata
	push hl
	ld a,(siege_lord1)
	call lgetcata
	push hl
	ld a,(siege_region)
	call rgetchev
	push hl
	ld a,(siege_lord1)
	call lgetchev
	push hl
	ld a,(siege_region)
	call rgetsold
	push hl
	ld a,(siege_lord1)
	call lgetsold
	push hl
	ld a,1
	ld hl,(retsiege)
	ld (hl),a
	ld hl,siegmenu
	call menutext
	xor a
	ld hl,(retsiege)
	ld (hl),a
	call maffproj
eschoose call menutex1
	cp 4
	jp z,renvoie

	ld hl,boulders-1
	ld e,a
	ld d,0
	add hl,de
	ld c,(hl)
	dec c
	jp m,eschoose
	dec (hl)
	push af
	call menurest
	ld hl,SIEGE_CATANIM
	ld de,BUFSPRLOAD
	call readfile
	pop af

	call exethrow  ;a-type de projectile
;	call bufmus+3
	ld hl,days
	dec (hl)
	ld a,(hl)
	or a
	jp z,renvoie
	ld a,1
	call milpause
	jp esmenu
renvoie
	ld a,(castle)
	ret

affsiege
	call scr_load_decomp ; LOAD_DECOMP_SCR
	ld hl,SIEGE_CATSPR
	ld de,BUFSPRLOAD
	call readfile
	ld a,2	 ;catapulte
	ld hl,256*64+57
	call affspr
	ld a,3	 ;soldats
	ld hl,256*8+68
	call affspr
	ld a,4	 ;chevalier
	ld hl,256*128+98
	call affspr
	ld hl,SIEGE_CATANIM
	ld de,BUFSPRLOAD
	call readfile
	ld hl,(anibuf)
	ld (hl),e
	inc hl
	ld (hl),d
	call lutinit
	ld a,7
	ld hl,256*80+58
	call lutin	 ;panier
	ld b,1
	ld hl,256*80+58
	call lutmodv
	ld a,48
	ld hl,256*82+123
	call lutin	 ;mur
	ld b,42
	ld hl,256*82+123
	call lutmodv
	call lutoff
	ld hl,256*82+102
	ld a,9
	call lutin	 ;projectile
	call lutoff
	call set_image_pal
	call setflash
lordcol
	SET_GA_COLOR &09,&55	; SCR SET BORDER
	ret
;
maffproj
	ld a,(boulders)
	or a
	jr z,maffgree
	ld b,a
	ld a,1
	ld hl,256*60+100
	call maffpro0
maffgree ld a,(greeks)
	or a
	jr z,maffdis
	ld b,a
	ld a,2
	ld hl,256*60+84
	call maffpro0
maffdis ld a,(disease)
	or a
	ret z
	ld b,a
	ld a,3
	ld hl,256*60+68
maffpro0
	call affspr
	push af
	ld a,h
	add a,&08
	ld h,a
	pop af
	djnz maffpro0
	ret
;
exethrow
;	push af
;	ld hl,SIEGE_SONS
;	ld de,BUFMUS
;	call readfile
;	pop af
	ld (project),a
	ld b,a
	add a,4
	ld c,a	 ;c=load2 correspondant au projectile
	inc b	  ;b=load1 correspondant au projectile
	ld c,b
	ld a,1
	ld hl,256*80+58
	call lutmodv
exethro0 call getjoy
	jr nc,exethro0
	ld b,16
	ld hl,256*80+56
exethro1 push bc
	ld a,1
	dec l
	ld b,c
	call lutmodv
;	ld a,2
;	call bruit
	ld a,15
	call milpause
	call getjoy
	pop bc
	jr c,exethcli
	djnz exethro1
exethcli ld a,55
	sub l
	srl a
	add a,4	 ;a = 4 -> 11
	ld (power),a
	ld a,1
	ld b,c
	ld l,76
	call lutmodv
;	ld a,3
;	call bruit
	ld a,20
	call milpause
	ld a,1
	ld b,8
	ld hl,256*82+84
	call lutmodv

	ld a,(power)
	ld hl,monttab-12
	ld e,a
	ld d,0
	add hl,de
	add hl,de
	add hl,de
	ld ix,mont+8
	ld b,3
	ld de,5
setpent ld a,(hl)
	ld (ix+00),a
	inc hl
	add ix,de
	djnz setpent

	ld a,(project)
	dec a
;	jp z,isbould
	dec a
	jp z,isgreek
isdiseas
	ld a,20
	call setmont
	ld hl,mont
	call animate
	ld a,(power)
	ld bc,(castle)
	sub c
	jr z,disreb
	jr c,disreb
	cp 1
	ld a,28
	jp nz,isover
	ld de,(days)
	ld d,0
	ld hl,distab-1
	add hl,de
	ld b,(hl)
	ld a,(siege_region)
	call rgetsold
	call diminue
	call rputsold
;	ld a,9
;	call bruit
	ld a,28
	jp isover
disreb ld a,28
	jp islow
isgreek
	ld a,31
	call setmont
	ld hl,mont
	call animate
	ld a,(power)
	ld bc,(castle)
	sub c
	jr z,grereb
	jr c,grereb
	cp 1
	ld a,39
	jp nz,isover
	ld b,25
	ld a,(siege_region)
	call rgetsold
	call diminue
	call rputsold
;	ld a,9
;	call bruit
	ld a,39
	jp isover
grereb ld a,39
	jp islow

;isbould
;	ld a,9
;	call setmont
;	ld hl,mont
;	call animate
;	ld a,(power)
;	ld bc,(castle)
;	sub c
;	ld a,17
;	jp c,islow
;	jp nz,isover
;	ld a,3
;	call lutoff
;;	ld a,4
;;	call bruit
;	ld hl,castle
;	ld a,52
;	sub (hl)
;	dec (hl)
;	cp 48
;	push af
;	push af
;	ld a,2
;	push ix
;	call getlut
;	ld h,(ix+01)
;	ld l,(ix+02)
;	pop ix
;	pop bc
;	ld a,2
;	call lutmodv
;	ld a,1
;	push ix
;	call getlut
;	ld h,(ix+01)
;	ld l,(ix+02)
;	pop ix
;	pop af
;	ld a,1
;	ld b,8
;	call z,luton
;	ld a,3
;	call lutsave
;	jp exethrf2

islow ld hl,low+2
	ld (hl),a
	ld de,(power)
	ld d,0
	ld hl,lowtab-4
	add hl,de
	ld b,(hl)
lowbcle ld hl,low
	call animate
	djnz lowbcle
	jp exethrf

isover call setover
	ld hl,over
	call animate
exethrf
	ld a,3
	call lutoff
exethrf2 ld a,10
	jp wait_pause
;
setmont
	push hl
	push bc
	push de
	ld hl,mont+2
	ld b,8
	ld de,5
setmont0 ld (hl),a
	add hl,de
	inc a
	djnz setmont0
	pop de
	pop bc
	pop hl
	ret
;
setover
	push hl
	push bc
	push de
	ld hl,over+2
	ld b,3
	ld de,5
setover0 ld (hl),a
	add hl,de
	inc a
	djnz setover0
	pop de
	pop bc
	pop hl
	ret
; ---------------------------
days  ds 1
castle ds 1
boulders ds 1
greeks ds 1
disease ds 1
siegval db 7,10,8,3,1
siegcast ds 2
siege_lord1 ds 1
siege_lord2 ds 1
siege_region ds 1
project ds 1
power ds 1
distab db 0,25,51,76,102,128
lowtab db 1,10,17,22,26,29,32
;
monttab
	db 1,-3,-3
	db 4,0,0
	db 7,2,2
	db 9,4,4
	db 10,5,5
	db 11,6,6
	db 12,7,7
	db 13,8,8

mont
	db 8
	db #3b,0,107,82,8
	db #bb,1,0,0,8
	db #bb,2,0,0,8
	db #bb,3,0,0,8
	db #bb,4,0,0,8
	db #bb,5,0,0,8
	db #bb,6,-4,2,8
	db #bb,7,-3,0,8
low
	db 1
	db #bb,0,-1,0,3
over
	db 3
	db #bb,0,-1,0,8
	db #bb,1,-1,2,8
	db #bb,2,-1,0,8
; ---------------------------
	read "DoTC_Text_Siege.asm"
; ---------------------------
list:DOTC_SIEGE_LENGTH equ $-DOTC_SIEGE_ADDRESS:nolist