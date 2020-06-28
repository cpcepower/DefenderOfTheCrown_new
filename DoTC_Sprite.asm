; ------------------------------------------------------------------------------
; from SPRITE.ASM
; ---------------------------
; a  -> lutin number
; hl <- sprite ptr
getlut:
; ---------------------------
	push af

	dec a
	add a,a
	add a,sprite_table
	ld l,a
	adc a,sprite_table/&100
	sub l
	ld h,a

	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a		; hl -> sprite ptr

	pop af
	ret
; ---------------------------
;  Initialisation du sprite manager
lutinit:
; @todo Calcul et install de l'adresse du buffer ?
; ---------------------------
	push hl

	ld hl,lutin_current_idx
	ld (hl),&00

	pop hl
	ret
; ---------------------------
; Declaration d'un lutin au sprite manager
; Table des sprites en BUFSPR
; Buffer de sauvegarde en (ANIBUF)
; l -> ligne
; h -> colonne
; a <- numéro du lutin
; c <- declaration ok
; nc<- plus de place dans le buffer de sauvegarde ecran
lutin
; @todo Calcul et install de l'adresse du buffer ?
; ---------------------------
	push bc
	push de
	push hl

	ld (lutin_sprite_nb),a	; sprite number

lutin_current_idx	equ $+1
	ld a,0
	inc a
	ld (lutin_idx),a
	cp LUTIN_NB+1
	jr nz,lutin_idx_ok
	dec a
	ld (lutin_idx),a
	jr lutin_end
lutin_idx_ok
	ld (lutin_current_idx),a

	ld b,h
	ld c,l		; bc -> Y, X

	call scradd
	push hl

	call getlut

	ld (hl),c
	inc hl
	ld (hl),b
	inc hl

	pop bc		; bc = screen address

	ld (hl),c
	inc hl
	ld (hl),b
	inc hl

	ex de,hl

lutin_sprite_nb equ $+1
	ld a,0		; sprite number

	ld hl,BUFSPR
lutin_getspr_loop
	ld  c,(hl)
	inc hl
	ld  b,(hl)
	inc hl
	dec a
	jr  z,lutin_getspr_ok
	add hl,bc
	jr  lutin_getspr_loop
lutin_getspr_ok
	ex de,hl
; de -> data sprite address
	ld (hl),e
	inc hl
	ld (hl),d
;	inc hl
lutin_end
	pop hl
	pop de
	pop bc
lutin_idx equ $+1
	ld a,0
	ret
; ---------------------------
; affichage d'un lutin
; a  -> lutin number
luton
; ---------------------------
	push af
	push bc
	push de
	push hl

	call getlut

	inc hl
	inc hl		; skip x,y
	ld e,(hl)
	inc hl
	ld d,(hl)	; de = actual screen address
	inc hl
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a		; hl = sprite address
	ld c,(hl)
	inc hl
	ld b,(hl)	; bc = sprite width, height
	inc hl
	ex de,hl
	call putspr

	pop hl
	pop de
	pop bc
	pop af
	ret

; ---------------------------
; effacement d'un lutin
; a  -> lutin number
lutoff:
; ---------------------------
	push af
	push bc
	push de
	push hl

	call getlut

	inc hl
	inc hl		; skip x,y
	ld e,(hl)
	inc hl
	ld d,(hl)	; de = actual screen address
	inc hl
	ld c,(hl)
	inc hl
	ld h,(hl)
	ld l,c		; hl = sprite address
	ld b,(hl)
	inc hl
	ld c,(hl)	; bc = sprite height,width
	inc hl
;	ex de,hl
	call lutmscr

	pop hl
	pop de
	pop bc
	pop af
	ret

; ---------------------------
; sauvegarde de l'ecran sous un lutin
; a  -> lutin number
lutsave
; ---------------------------
	push af
	push bc
	push de
	push hl

	call getlut

	inc hl
	inc hl		; skip x,y
	ld e,(hl)
	inc hl
	ld d,(hl)	; de = actual screen address
	inc hl
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a		; hl = sprite address
	ld b,(hl)
	inc hl
	ld c,(hl)	; bc = sprite height,width
	inc hl
	ex de,hl

	call lutscrm

	pop hl
	pop de
	pop bc
	pop af
	ret

; ---------------------------
; inversion d'une region a l'ecran
; hl-> adresse ecran
; de-> sprite
; b -> nombre d'octets par ligne
; c -> nombre de lignes
;modifies- aucun
xorreg:
; ---------------------------
	push af
	push bc
	push de
	push hl
	
xorreg0
	push bc
	push hl
xorreg1
	ld a,(de)
	xor (hl)
	ld (hl),a
	inc hl
	inc de
	djnz xorreg1

	pop hl
	call nextline

	pop bc
	dec c
	jr nz,xorreg0

	pop hl
	pop de
	pop bc
	pop af
	ret
; ---------------------------
; descend d'une ligne
; hl -> old address
; hl <- next address
nextline:
; @todo - voir si besoin du push/pop af ?
; ---------------------------
	push af

	read "../include/screen_next_line_hl.asm"

	pop af
	ret
; ---------------------------
; calcul d'une adresse ecran
; hl -> h = Colonne (0 -> 159), l -> Ligne (199 -> 0)
; hl <- screen address
scradd:
; ---------------------------
	push af
	push bc
	push de

	ld e,h
	ld h,0
	ld d,h
	sla e
	rl d
	call SCR_DOT_POSITION	; #bc1d

	pop de
	pop bc
	pop af
	ret
; ---------------------------
; a  <- le code d'un octet ecran de la couleur dans a
encode:
; ---------------------------
	push bc

	ld c,a
	xor a
	bit 3,c
	jr z,encod0
	or #03
encod0
	bit 2,c
	jr z,encod1
	or #30
encod1
	bit 1,c
	jr z,encod2
	or #0c
encod2
	bit 0,c
	jr z,encod3
	or #c0
encod3
	pop bc
	ret

TEST equ 1
	IF TEST
; 2960


; ---------------------------
lutscrm
; ---------------------------
	push bc
	push hl

lutsave0
	push bc
	push hl

	ld b,0
	ldir

	pop hl
	inline_bc26_hl

	pop bc
	djnz lutsave0

	pop hl
	pop bc
	ret
; ---------------------------
; affichage d'un sprite sans transparence
; hl -> buffer data
; de -> screen address
; b  -> nombre d'octets par ligne
; c  -> nombre de lignes
; ---------------------------
putsprb:
	ld a,b
	ld b,c
	ld c,a
; ---------------------------
; hl -> buffer data
; de -> screen address
; b  -> nombre d'octets par ligne
; c  -> nombre de lignes
lutmscr:
; ---------------------------
lutrest0
	push bc
	push de

	ld b,0
	ldir

	ex de,hl
	pop hl
	inline_bc26_hl
	ex de,hl

	pop bc
	djnz lutrest0

	ret
; ---------------------------
; recherche et affichage d'un sprite
; Table des sprites en BUFSPR
; a -> no du sprite
; l -> ligne
; h -> colonne
; modifies- aucun
affspr
; ---------------------------
	push bc
	push de
	push hl

	call scradd
	ex de,hl
	ld hl,BUFSPR
	call getspr
	ex de,hl
	call putspr

	pop hl
	pop de
	pop bc
	ret
; ---------------------------
; recherche et affichage d'un sprite sans transparence
; Table des sprites en BUFSPR
; a -> no du sprite
; l -> ligne
; h -> colonne
; modifies- aucun
affsprb
; ---------------------------
	push bc
	push de
	push hl

	call scradd
	ex de,hl
	ld hl,BUFSPR
	call getspr

	call putsprb

	pop hl
	pop de
	pop bc
	ret
; ---------------------------
; recherche et affichage d'un sprite avec effacement en couleur b
; Table des sprites en BUFSPR
; a -> no du sprite
; l -> ligne
; h -> colonne
; modifies- aucun
affsprc
; ---------------------------
	push bc
	push de
	push hl

	call scradd
	ex de,hl
	ld hl,BUFSPR

	push af
	ld a,b
	call encode
	ld (fond),a
	pop af

	call getspr
	ex de,hl
	call clean
	call putspr

	pop hl
	pop de
	pop bc
	ret
; ---------------------------
; affichage d'un sprite
; hl-> adresse ecran
; de-> sprite
; b -> nombre d'octets par ligne
; c -> nombre de lignes
putspr:
; ---------------------------
	push af
	push de
putspr0
	push bc
	push hl
putspr1
	ld a,(de)
	and #aa
	jr nz,putspr2
	ld a,(hl)
	and #aa
putspr2
	ld c,a
	ld a,(de)
	and #55
	jr nz,putspr3
	ld a,(hl)
	and #55
putspr3
	or c
	ld (hl),a
	inc de
	inc hl
	djnz putspr1

	pop hl

	INLINE_BC26_HL

	pop bc
	dec c
	jr nz,putspr0

	pop de
	pop af
	ret
; ---------------------------
; effacement sous un sprite
clean
; ---------------------------
	push hl
	push de
	push bc
	ld e,b
	ld b,c
	ld c,e
	dec c

clean0
	push bc
	push hl

	ld b,0

	ld d,h
	ld e,l
	inc de
fond equ $+1
	ld (hl),0
	ldir

	pop hl
	call nextline

	pop bc
	djnz clean0

	pop bc
	pop de
	pop hl
	ret
; ---------------------------
getspr
	push de
	push af
getspr0
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	dec a
	jr z,getspr1
	add hl,de
	jr getspr0
getspr1
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl
	pop af
	pop de
	ret
; recherche d'un sprite
; a  -> sprite number
; hl -> sprite data table ptr
; hl <- sprite ptr
; b  <- nombre d'octets par ligne
; c  <- nombre de lignes
;getspr:
; ---------------------------
;	push af

;	dec a
;	add a,a
;	add a,l
;	ld l,a
;	adc a,h
;	sub l
;	ld h,a

;	ld a,(hl)
;	inc hl
;	ld h,(hl)
;	ld l,a		; hl <- sprite ptr

;	ld c,(hl)
;	inc hl
;	ld b,(hl)
;	inc hl		; bc <- width, height

;	pop af
;	ret
; ---------------------------
; identification de la region pointee par la fleche
; carry -> region trouvee
; a -> numero de la region pointee par la fleche
;modifies- af
whatreg
; ---------------------------
	push bc
	push de
	push hl
	push ix

	call tfleche
	ld c,a
	ld b,REGIONS_NB
whatreg0
	push bc
	ld a,b
	ld hl,BUFSPR
	call getspr
	ex de,hl
	call getreg
	ld l,(ix+REGION_LIGNE)
	ld h,(ix+REGION_COLONNE)
; insquare
	ld a,(flrow)
	cp l
	jr z,insq1
	jr nc,insquare_end
insq1
	add a,c
	cp l
	jr z,insquare_end
	jr c,insq2
	ld a,(flcol)
	cp h
	jr c,insq2
	sla b
	sub b
	srl b
	cp h
	jr insquare_end
insq2
	ccf
insquare_end
	jr c,whatreg4
	pop bc
	jr whatreg3
whatreg4
	call scradd
	push bc
	call vbl_wait		; #bd19
	pop bc
;	di
	call xorreg
	call tfleche
	call xorreg
;	ei
	pop bc
	cp c
	jr nz,whatreg1
whatreg3
	djnz whatreg0
	xor a
	jr whatreg2
whatreg1
	ld a,b
	scf
whatreg2
	pop ix
	pop hl
	pop de
	pop bc
	ret

; ---------------------------
; affichage d'une region
; a -> numero de la region
affreg
; ---------------------------
	push af
	push bc
	push de
	push hl
	push ix
	push iy

	ld (cour_reg+1),a
	ld (cour_re2+1),a
	ld hl,BUFSPR
	call getspr

	ex de,hl
	call getreg

	ld a,(ix+REGION_PROPRIO)
	or a
	jr nz,affre0
	ld a,13
	jr affre1
affre0
	call getlord
	ld a,(iy+LORD_CASTLE)
	ld hl,chato
	call rdtab_4
	ld a,(hl)
affre1
	call encode
	ld (affreg2+1),a

	ld l,(ix+REGION_LIGNE)
	ld h,(ix+REGION_COLONNE)
	call scradd

affreg0
	push bc
	push hl

affreg1
	ld a,(de)
	cpl
	and (hl)
	ld c,a
	ld a,(de)
affreg2
	and 0
	or c
	ld (hl),a
	inc de
	inc hl
	djnz affreg1

	pop hl
	call nextline

	pop bc
	dec c
	jr nz,affreg0

;	ld a,(lord)
;	call getlord
	ld iy,(player1_lord)

	ld a,(ix+REGION_CONSTRUCTION)
	or a
	jr z,affregnc
	add a,19	; castle sprite (20,21,22)
	ld l,(ix+REGION_Y_CHATEAU)
	ld h,(ix+REGION_X_CHATEAU)
	call affspr

	ld a,(iy+LORD_CASTLE)
	ld hl,chato+1
	call rdtab_4
cour_reg
	ld a,0
	cp (hl)
	jr nz,affregnc
	ld a,(ix+REGION_Y_CHATEAU)
	add a,6
	ld l,a
	ld a,(ix+REGION_X_CHATEAU)
	add a,4
	ld h,a
	ld a,24	; flag
	call affspr
affregnc
cour_re2
	ld a,0
	cp (iy+LORD_REGION)
	jr nz,affregnh
	ld a,23	; horse+knight
	ld l,(ix+REGION_Y_LORD)
	ld h,(ix+REGION_X_LORD)
	call affspr
affregnh
	pop iy
	pop ix
	pop hl
	pop de
	pop bc
	pop af
	ret
;
animate
animateb
LUTMODV
	ret

	ELSE
PUTSPR
GETSPR
WHATREG
affspr
AFFSPRB
AFFSPRC
LUTMSCR
lutscrm
	ret
; ---------------------------
; execution d'une animation
; hl -> adresse de l'animation
animateb
; ---------------------------
	push af
	push hl

	ld a,#c9
	ld (qlutoff),a
	ld (qlutsav),a
	ld hl,putsprb
	ld (qlonmod+1),hl
	ld a,#cd
	ld (animint),a
	ld (animint+1),de
	pop hl
	pop af
	call animate
	push hl
	push af
	ld hl,putspr
	ld (qlonmod+1),hl
	ld a,#01
	ld (qlutoff),a
	ld (qlutsav),a
	ld hl,animint
	dec a
	ld (hl),a
	inc hl
	ld (hl),a
	inc hl
	ld (hl),a

	pop af
	pop hl
	ret
animate
	push hl
	push bc
	push de
	push af
	push ix

	ld b,(hl)
	inc hl
animbcl push bc
	ld a,(hl)
	inc hl
	ld c,a
	and #07
	push af
	push hl
	ld hl,luttab+7
	ld de,7
	call rdtab
	push hl
	pop ix
	pop hl
	bit 5,c
	ld b,(ix+00)
	jr z,animat1
	ld b,(hl)
	inc hl
animat1 ld d,(ix+01)
	ld e,(ix+02)
	bit 4,c
	jr z,animat2
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
animat2 bit 7,c
	jr z,animat3
	push hl
	ld h,(ix+01)
	ld l,(ix+02)
	ld a,h
	add a,d
	ld d,a
	ld a,l
	add a,e
	ld e,a
	pop hl
animat3 pop af
	ex de,hl
	call lutmodv
	ex de,hl
	bit 3,c
	jp z,animsui0
	ld a,(hl)
	inc hl
	call milpause
animint nop
	nop
	nop
animsui0 pop bc
	djnz animbcl

	pop ix
	pop af
	pop de
	pop bc
	pop hl
	ret


; ---------------------------
; deplacement d'un lutin avec changement
; h  -> colonne
; l  -> ligne
; b  -> numero sprite
; a  -> lutin number
lutmodv
; ---------------------------
	push af
	push bc
	push de
	push hl
	push ix
	push iy

	push bc
	push hl
	call getlut
	ld (qlofsz+1),bc
	ld (qlofbf+1),de
	ld (qlofad+1),hl
	ld (qlsvbf+1),de
	pop hl
	ld (ix+01),h
	ld (ix+02),l
	call scradd
	ld (qlsvad+1),hl
	ld (qlonad+1),hl
	pop af
	ld (ix+00),a
	ld hl,BUFSPR
	call getspr
	ld (qlsvsz+1),bc
	ld (qlonsz+1),bc
	ld (qlonsp+1),hl

	call vbl_wait		; #bd19
	di
	call qlutoff
	call qlutsav
	call qluton
	ei

	pop iy
	pop ix
	pop hl
	pop de
	pop bc
	pop af
	ret
;
qluton
qlonsz ld bc,0
qlonsp ld de,0
qlonad ld hl,0
qlonmod jr putspr
;
qlutoff
qlofsz ld bc,0
qlofbf ld de,0
qlofad ld hl,0
	jr lutmscr
;
qlutsav
qlsvsz ld bc,0
qlsvbf ld de,0
qlsvad ld hl,0
	jp lutscrm

; 2128
; ---------------------------
; de -> sprite_data
; bc -> background_data
;putspr:
; ---------------------------
	push af
;	push bc
;	push de
;	push hl
	push ix
	push iy

	ld ixh,c		; 2
	ld a,b
	ld (putspr_loop_sprite_width),a

	ld b,h
	ld c,l

	ld iyl,c

	ld hl,sprite_mask_table

putspr_loop_height
putspr_loop_sprite_width equ $ +2
	ld ixl,&00

putspr_loop_width
	ld a,(de)		; get one byte of sprite data
	inc de			; next
	ld l,a			; l = sprite_data=sprite_mask_index
	ld a,(bc)		; get background_data
	and (hl)		; sprite_mask and background_data
	or l			; (sprite_mask and background_data) or sprite_data
	ld (bc),a		; put on the background
	inc bc			; next background_data
	dec ixl
	jr nz,putspr_loop_width	; 3/2

	ld c,iyl

	INLINE_BC26_BC

	dec ixh
	jr nz,putspr_loop_height; 3/2

	pop iy
	pop ix
;	pop hl
;	pop de
;	pop bc
	pop af
	ret

;	org &1200

;;	read "H:\work\CS_new\CS_Data_Sprite_Mask_Table_v1_0.asm";
	ENDIF
