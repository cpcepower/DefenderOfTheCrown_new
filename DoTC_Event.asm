; ------------------------------------------------------------------------------
; from EVENT.ASM
; ---------------------------
	read "DoTC_binary_header.asm"

	WRITE_DOTC_BIN_FILE EVENT, DOTC_EVENT_ADDRESS, DOTC_EVENT_LENGTH
; ---------------------------
	jp event
	jp battle
; ---------------------------
;conquete d'un lord (b-lord,c-region)->c si joueur tue
;	 (a-type,hl-soldats necessaires)	ff si passer au lordraid
execonqu:
; ---------------------------
	ld (event_cout),hl
	ld (event_type),a
	ld (event_objectif),bc
	ld a,4
	ld (compte),a
boucle
	ld a,(clord)
	call lgetreg
	ld (creg),a
	call transf
	call force
	jr nc,to_home

kamikaze ld a,(event_objectif)
	call next_reg
	ld a,(event_objectif)
	cp b
	jp z,combat
	jr bouge
to_home
	ld a,(clord)
	call lgethome
	ld b,a
	ld a,(creg)
	cp b
	jp z,event_achat
	ld a,b
	call next_reg
	jr c,bouge
	ld a,1
	ld (kamika+1),a
	jr kamikaze
bouge
	ld a,b
	call step
	ld hl,compte
	dec (hl)
	jr nz,boucle
	xor a
	ret
;
combat
	ld a,(clord)
	ld b,a
	ld a,(event_objectif)
	ld c,a
	jp attaque
;
transf
	ld a,(clord)
	ld b,a
	ld a,(creg)
	ld c,a
	call totale
	ld a,b
	call lgetsold
	ld de,(event_cout)
	inc de
	inc de
	or a
	sbc hl,de
	ret c
	ret z
	push hl
	call moyenne
	pop hl
	or a
	sbc hl,de
	jr nc,transf0
	add hl,de
	ex de,hl
	ld hl,0
transf0 ex de,hl
	ld a,(creg)
	call rputsold
	ld hl,(event_cout)
	inc hl
	inc hl
	add hl,de
	ld a,(clord)
	call lputsold
	ret
;
totale ;b-lord,c-reg
	ld a,c
	call rgetsold
	ex de,hl
	ld a,b
	call lgetsold
	add hl,de
	call lputsold
	ld a,c
	call rgetchev
	ex de,hl
	ld a,b
	call lgetchev
	add hl,de
	call lputchev
	ld a,c
	call rgetcata
	ex de,hl
	ld a,b
	call lgetcata
	add hl,de
	call lputcata
	ld a,c
	ld hl,0
	call rputsold
	call rputchev
	call rputcata
	ret
;
force
	ld a,(event_objectif)
	call rgetbuil
	or a
	jr z,force0
	ld a,(clord)
	call lgetcata
	ld a,h
	or l
	ret z
force0 ld a,(clord)
	call lgetsold
	ex de,hl
	call lgetchev
	ld b,5
	call mult
	add hl,de
	ld de,(event_cout)
	or a
	sbc hl,de
	ccf
	ret
;
next_reg
	ld c,a
	ld a,(creg)
	ld b,a
	ld a,(clord)
	call chemin
	ret
;
step
	ld c,a
	ld a,(clord)
	jp go
;
moyenne
	ld a,(clord)
	ld c,a
	call lgetsold
	push hl
	pop ix
	ld b,18
	ld l,0
moy0  ld a,b
	call rgetprop
	cp c
	jr nz,moy1
	ld a,b
	ex de,hl
	call rgetsold
	ex de,hl
	add ix,de
	inc l
moy1  djnz moy0
	ld b,l
	push ix
	pop hl
	call div
	ex de,hl
	ret
;
event_achat
	ld a,(clord)
	ld hl,15
	call tst_mony
	ld a,#ff
	ret nc
	ld a,(event_objectif)
	call rgetbuil
	or a
	call nz,buy_cata
ach_bcle call buy_sold
	call buy_chev
	call buy_sold
	call buy_chev
	call buy_sold
	call buy_cata
	call buy_sold
	call buy_cast
	jr ach_bcle
;
buy_sold
	ld a,(clord)
	call lgetgold
	ld de,11
	or a
	sbc hl,de
	jr nc,buy_s0
	add hl,de
	ex de,hl
	ld hl,0
buy_s0 call lputgold
	call lgethome
	call rgetsold
	add hl,de
	call rputsold
	jr buy_fin
;
buy_chev
	ld a,(clord)
	ld hl,8
	call paye
	ret nc
	call lgethome
	call rgetchev
	inc hl
	call rputchev
buy_fin ld a,(clord)
	call lgetgold
	ld a,h
	or l
	ret nz
	pop hl
	xor a
	ret
;
buy_cata
	ld a,(clord)
	ld hl,15
	call paye
	ret nc
	call lgethome
	call rgetcata
	inc hl
	call rputcata
	jr buy_fin
;
buy_cast
	ld a,(clord)
	call landfree
	ret nc
	ld c,a
	ld a,(clord)
	ld hl,20
	call paye
	ret nc
	ld a,c
	ld de,10
	call rgetsold
	add hl,de
	call rputsold
	call getreg
	ld (ix+00),3
;	ld a,7
;	call bruit
	ld a,c
	call affreg
	jr buy_fin
;
event_cout  ds 2
event_type  ds 1
event_objectif ds 1
clord ds 1
compte ds 1
creg  ds 1
;
event_castresi ds 1
menuon ds 1
tactdef ds 1
tactatt ds 1
leadatt ds 1
leaddef ds 1
attkill ds 2
defkill ds 2
attsold ds 2
attknig ds 2
attkret ds 1
defsold ds 2
defknig ds 2
defkret ds 1
numcoord ds 2
; ---------------------------
; iy -> lord
; ix -> region
; hl -> castresi, rob_help ,kamika set	 z-defaite nz-retraite
;  f <- carry si victoire
battle:
; ---------------------------
	xor a
	ld (menuon),a
	ld a,(hl)
	ld (event_castresi),a
	inc hl
	call identif
	call calclea
	call affbat
battle0
	call choidef
	ld (tactdef),a
	call choiatt
	ld (tactatt),a
	call calcule
	call actarm
	jr nz,battle0
	sub 2
	push af
	call interact
	jr nc,battle1
	ld a,2
	call wait_pause
	call affmap
battle1
	pop af
	ld hl,kamika+1
	ld (hl),0
	ret
;
;
;
actarm
	push ix
	push iy
	pop ix
	ld de,8
	add ix,de
	ld hl,17*256+5
	call reverse
	jr nc,actarm0
	ld h,34
actarm0 ld (numcoord),hl
	ld hl,(defkill)
	push iy
	ld iy,attsold
	call fossoy
	pop iy
	pop ix
	ld a,2
	ret z
	ld a,(tactatt)
	cp 6
	jr nz,actarm10
	ld a,3
	ret
actarm10 inc ix
	ld hl,17*256+5
	call reverse
	jr c,actarm1
	ld h,34
actarm1 ld (numcoord),hl
	ld hl,(attkill)
	push iy
	ld iy,defsold
	call fossoy
	pop iy
	dec ix
	ld a,1
	ret
;
fossoy
	ld e,(ix+00)
	ld d,(ix+01)
	ex de,hl
	or a
	sbc hl,de
	push hl
	jr nc,foss0
	ld hl,0
foss0 ld (ix+00),l
	ld (ix+01),h
	call interact
	jr nc,fossni0
	call affresu
	ld bc,79*256+10
	call howmany
	ld a,e
	ld e,(iy+00)
	ld d,(iy+01)
	call compare
	ld (iy+00),e
	ld (iy+01),d
	ld hl,(numcoord)
	inc l
	ld (numcoord),hl
fossni0 pop de
	ld hl,0
	or a
	sbc hl,de
	bit 7,h
	ret nz
	ld e,(ix+02)
	ld d,(ix+03)
	ld a,d
	or e
	jr nz,foss10
foss11 ld (ix+04),0
	ld (ix+05),0
	ret
foss10 ld bc,8
	xor a
foss1 sbc hl,bc
	jr c,foss2
	inc a
	jr foss1
foss2 add hl,bc
	ld c,a
	ld a,(iy+04)
	add a,l
	cp 8
	jr c,foss3
	inc c
	sub 8
foss3 ld (iy+04),a
	ld l,c
	ld h,0
	ex de,hl
	or a
	sbc hl,de
	jr nc,foss4
	ld hl,0
foss4 ld (ix+02),l
	ld (ix+03),h
	call interact
	jr nc,fossni1
	call affresu
	push hl
	ld bc,39*256+5
	call howmany
	ld a,e
	ld e,(iy+02)
	ld d,(iy+03)
	call compare
	ld (iy+02),e
	ld (iy+03),d
	pop hl
fossni1 ld a,h
	or l
	jr z,foss11
	ret
;
affresu
	call interact
	ret nc
	push hl
	ld hl,(numcoord)
	call txt_set_cursor
	pop hl
	jp affd16
;
howmany
	ex de,hl
	ld a,b
	ld h,0
	ld l,b
	ld (hmmax+1),a
	ld b,0
	or a
	sbc hl,de
	jr nc,hm1
hmmax ld de,0
hm1  ex de,hl
	add hl,bc
	dec hl
	ld e,0
hm0  or a
	sbc hl,bc
	ret c
	inc e
	jr hm0
;
compare
	cp e
	ret z
	push af
	ld a,d
	call lutoff
	dec d
	dec e
	pop af
	jr compare
;
;
;
calcule
	ld a,(leadatt)
	ld b,a
	ld a,(tactatt)
	push ix
	push iy
	pop ix
	ld de,8
	add ix,de
	ld hl,calctab
	call aiguille
	pop ix
	push hl
	inc ix
	ld a,(leaddef)
	ld b,a
	ld a,(tactdef)
	ld hl,calctab
	call aiguille
	dec ix
	pop de
	ex de,hl
	ld a,(tactdef)
	cp 5
	jr nz,calcul0
	ld a,(event_castresi)
	ld b,a
	call diminue
calcul0
	push de
	ld b,240
	call diminue
	ld a,h
	or l
	jr nz,calpasn0
	inc hl
calpasn0 ex de,hl
	ld hl,40
	or a
	sbc hl,de
	jr nc,calcok0
	ld de,40
calcok0 ld (attkill),de
	pop hl
	ld b,240
	call diminue
	ld a,h
	or l
	jr nz,calpasn1
	inc hl
calpasn1 ex de,hl
	ld hl,40
	or a
	sbc hl,de
	jr nc,calcok1
	ld de,40
calcok1 ld (defkill),de
	ret
calctab
	dw calc1
	dw calc2
	dw calc3
	dw calc4
	dw calc5
	dw calc6
calc1
	push bc
	ld e,(ix+00)
	ld d,(ix+01)
	ld l,(ix+02)
	ld h,(ix+03)
	ld b,5
	call mult
	add hl,de
	ex de,hl
	ld l,(ix+04)
	ld h,(ix+05)
	ld b,10
	call mult
	add hl,de
	pop bc
	sla b
	jp comm0
calc2
	push bc
	ld l,(ix+00)
	ld h,(ix+01)
	add hl,hl
	push hl
	ld l,(ix+02)
	ld h,(ix+03)
	ld b,5
	call mult
	pop de
	add hl,de
	ex de,hl
	ld l,(ix+04)
	ld h,(ix+05)
	ld b,10
comm1 call mult
	add hl,de
	pop bc
comm0 push hl
	call diminue
	ex de,hl
	ld hl,0
	or a
	sbc hl,de
	pop de
	add hl,de
	add hl,de
	ret
calc3
	push bc
	ld e,(ix+00)
	ld d,(ix+01)
	ld l,(ix+02)
	ld h,(ix+03)
	ld b,8
	call mult
	add hl,de
	ex de,hl
	ld l,(ix+04)
	ld h,(ix+05)
	ld b,10
	jp comm1
calc4
	push bc
	ld e,(ix+00)
	ld d,(ix+01)
	ld l,(ix+02)
	ld h,(ix+03)
	ld b,5
	call mult
	add hl,de
	ex de,hl
	ld l,(ix+04)
	ld h,(ix+05)
	ld b,15
	jp comm1
calc5
	push bc
	ld e,(ix+00)
	ld d,(ix+01)
	ld l,(ix+02)
	ld h,(ix+03)
	ld b,5
	call mult
	add hl,de
	ex de,hl
	ld l,(ix+04)
	ld h,(ix+05)
	ld b,10
	jp comm1
calc6
	ld hl,0
	ret
;
;
;
choidef
	call interact
	jp nc,ennemid
	call reverse
	jp nc,ennemid
	jp player
;
choiatt
	call interact
	jp nc,ennemia
	call reverse
	jp c,ennemia
	jp player
; ---------------------------
calclea
; ---------------------------
	xor a
	ld (attkret),a
	ld (defkret),a
	ld a,(event_castresi)
;	ld hl,castab
;	call convgen
	add a,castab
	ld l,a
	adc a,castab/&100
	sub a,l
	ld h,a
	ld a,(hl)
	ld (event_castresi),a

	ld a,(iy+LORD_LEADERSHIP)
	call convlea
	ld (leadatt),a

	ld a,(ix+REGION_PROPRIO)
	or a
	jr nz,calclea0
calclea1
	xor a
	call convlea    ; @todo - delete this !
	ld (leaddef),a
	ret
calclea0
	call lgetreg
	push ix
	pop de
	call getreg
	push ix
	pop hl
	or a
	sbc hl,de
	push de
	pop ix
	jr nz,calclea1
	ld a,(ix+REGION_PROPRIO)
	push iy
	call getlord
	ld a,(iy+LORD_LEADERSHIP)
	pop iy
	call convlea
	ld (leaddef),a
	ret
convlea
	ld hl,leatab
convgen ld e,a
	ld d,0
	add hl,de
	ld a,(hl)
	ret
leatab
	db 0,10,20,30,43,53,64,76
	db 87,97,110
castab
	db 0,0,0,0,30,64,94,128
	db 161,192,225
; ---------------------------
identif
; ---------------------------
	ld a,#b7	 ;or a
	ld (interact),a
	ld a,(iy+LORD_TYPE)
	cp LORD_TYPE_PLAYER
	jp nz,ident0
	ld a,(ix+REGION_PROPRIO)
	or a
	jp z,ident0
	ld a,#37	 ;scf
	ld (interact),a
	ld a,#b7	 ;or a
	ld (reverse),a

	ld a,(hl)	;rob_help
	and #80
	res 7,(hl)
	inc hl
	ret z

	ld l,(ix+REGION_SOLDATS+0)
	ld h,(ix+REGION_SOLDATS+1)
	ld e,(iy+LORD_SOLDATS+0)
	ld d,(iy+LORD_SOLDATS+1)
	or a
	sbc hl,de
	ld e,(ix+REGION_CHEVALIERS+0)
	ld d,(ix+REGION_CHEVALIERS+1)
	add hl,de
	ld e,(iy+LORD_CHEVALIERS+0)
	ld d,(iy+LORD_CHEVALIERS+1)
	or a
	sbc hl,de
	bit 7,h
	jr z,okposn
	ld hl,2
okposn
	push hl
	ld e,(iy+LORD_SOLDATS+0)
	ld d,(iy+LORD_SOLDATS+1)
	add hl,de
	ld (iy+LORD_SOLDATS+0),l
	ld (iy+LORD_SOLDATS+1),h
	ld hl,robgive
	ld a,5
	call placard
	ret

ident0
	ld a,(ix+REGION_PROPRIO)
	ld hl,(lord)
	cp (hl)
	ret nz
	ld a,(hl)
	call lgetreg
	ld c,a
	ld a,(hl)
	call lgethome
	call equreg
	jr z,yesint
	ld a,c
	call equreg
	ret nz
yesint
	ld a,#37	 ;scf
	ld (interact),a
	ld (reverse),a
	ret
equreg
	push ix
	pop de
	call getreg
	push ix
	pop hl
	or a
	sbc hl,de
	push de
	pop ix
	ret
interact
	or a
	ret
reverse
	or a
	ret
; ---------------------------
affbat
; ---------------------------
	call interact
	ret nc

; load de l'image du fond
	LOAD_DECOMP_SCR batback
; load sprites
	ld hl,batspr
	ld de,BUFSPRLOAD
	call readfile
	ld hl,(anibuf)
	ld (hl),e
	inc hl
	ld (hl),d
	call lutinit
; affichage première vague pour player et l'ennemi
; paquet de 10 chevaliers, 10 soldats, (10 archers), 3 catapultes

	ld e,(iy+LORD_CATAPULTES+0)
	ld d,(iy+LORD_CATAPULTES+1)
	ld l,(ix+REGION_CATAPULTES+0)
	ld h,(ix+REGION_CATAPULTES+1)
	call reverse
	jr nc,affbat0
	ex de,hl
affbat0
	push hl
	push de

	ld l,(iy+LORD_CHEVALIERS+0)
	ld h,(iy+LORD_CHEVALIERS+1)
	ld e,(ix+REGION_CHEVALIERS+0)
	ld d,(ix+REGION_CHEVALIERS+1)
	call reverse
	jr nc,affbat1
	ex de,hl
affbat1
	push de
	push hl
	call affchev

; rajouter un groupe de 3 unités pour les catapultes
; lorsqu'un groupe pour chevaliers, soldats, (archers) ou catapultes est décimé
; rajoute groupe si reste des unités


; hl -> 
; rajoute un groupe sur le champ de bataille de n paquet
; ajoute les b sprites du groupe dans la limite de n
; animation d'arrivee à prevoir pour le groupe de sprites
; puis animation detente si pas d'action
; -> on supprime l'animation detente si action et si inaction on la remets du début


	ld e,(iy+LORD_SOLDATS+0)
	ld d,(iy+LORD_SOLDATS+1)
	ld l,(ix+REGION_SOLDATS+0)
	ld h,(ix+REGION_SOLDATS+1)
	call reverse
	jr nc,affbat2
	ex de,hl
affbat2
	push hl
	push de
;	call affsold

	call set_image_pal
	
	SET_GA_COLOR &10,&5c	; SCR SET BORDER

	ld hl,effectif
	call menutex0
	ret
; ---------------------------
create_unit
; ---------------------------

	ret
; ---------------------------
calculate_unit_catapult:
; ---------------------------
	ld c,3
	jr calculate_unit
; ---------------------------
calculate_unit_knights:
calculate_unit_soldiers:
; ---------------------------
	ld c,10
;	jp calculate_unit
; @todo + stocke sa force = nombre d'unites !
; @todo voir si on s'arrête pas au nombre d'unit nécessaire pour un groupe !
; ---------------------------
; c  -> number of units to regroup
; hl -> total number of units
; b  <- number of units grouped
calculate_unit:
; ---------------------------
	ld b,0
calculate_unit_nb equ $ +1
	ld a,l
calculate_unit_loop
	inc b
	sub a,c
	jr nc,calculate_unit_loop
	dec h
	jr nc,calculate_unit_loop
	jr z,calculate_unit_loop
;	add a,c	; force de la dernière unité
	ret
; ---------------------------
;de-chevaliers lord, hl-chevaliers ennemi
affchev
; ---------------------------
; rajoute un groupe de 10 paquets max de 10 unites pour chevaliers, soldats, (archers)
; for the lord
;	call calculate_unit_knight
;	call create_unit_knight

	ajoute à la liste des sprites les 10 sprites knight
	pour chaque knight, place le premier -> faire une liste de placement qui constitue les 2 rangés de 5.

	ld hl,list_knight_position
	ld de,(knight_screen_position_init)
	

knight_screen_position_init
	dw SCREEN_WIDTH*10+SCREEN_ADDRESS
knight_screen_position
	dw 0

list_knight_position
	db +00,+00
	db +05,-05
	db +05,-05
	db +05,-05
	db +05,-05
	db +05,-05
	db +05,-05
	db +05,-05
	db +05,-05
	db +05,-05
	db &ff,&ff

	créer une unité de knight ainsi constitué
	sa force est le nombre de knight dans l'unité
boucle : on sort si knight utilisé <= 0 
voir combien d'unité on place sur le terrain de jeu ?

; for the opponent
;	call calculate_unit_knight

;	push hl
;	ld bc,39*256+5
;	ld a,3
;	ld hl,256*30+137
;	call placespr
;	pop hl
;	push de
;	ld bc,39*256+5
;	ex de,hl
;	ld a,4
;	ld hl,256*105+137
;	call placespr
;	pop hl
	call reverse
	jr nc,affchev0
	ex de,hl
affchev0
	ld (attknig),hl
	ld (defknig),de
	ret
; ---------------------------
; de-soldats lord, hl-soldats ennemi
affsold
; ---------------------------
;	push hl
;	ld bc,79*256+10
;	ld a,1
;	ld hl,256*55+135
;	call placespr
;	pop hl
;	push de
;	ld bc,79*256+10
;	ex de,hl
;	ld a,2
;	ld hl,256*80+135
;	call placespr
;	pop hl
	call reverse
	jr nc,affsold0
	ex de,hl
affsold0
	ld (attsold),hl
	ld (defsold),de
	ret
; ---------------------------
;placespr
; ---------------------------
;	ld (sprno+1),a
;	ld (sprcoo+1),hl
;	ld a,b
;	ld h,0
;	ld l,b
;	ld (plmax+1),a
;	ld b,0
;	or a
;	sbc hl,de
;	jr nc,pla1
;plmax ld de,0
;pla1  ex de,hl
;	add hl,bc
;	dec hl
;	ld de,0
;pla0  or a
;	sbc hl,bc
;	ret c
;	inc e
;	push hl
;	push bc
;sprno ld a,0
;sprcoo ld hl,0
;	call lutin
;	ld d,a
;	call luton
;	ld a,(sprcoo+1)
;	sub 10
;	ld (sprcoo+1),a
;	ld a,(sprcoo+2)
;	add a,2
;	ld (sprcoo+2),a
;	pop bc
;	pop hl
;	jr pla0
;
;
;
ennemia
	ld e,(ix+01)
	ld d,(ix+02)
	ld l,(ix+03)
	ld h,(ix+04)
	ld b,5
	call mult
	add hl,de
	srl h
	rr l
	push hl
	ld e,(iy+08)
	ld d,(iy+09)
	ld l,(iy+10)
	ld h,(iy+11)
	ld b,5
	call mult
	add hl,de
	pop de
	or a
	sbc hl,de
	jr nc,nowild
kamika
	ld a,0
	or a
	jr nz,nowild
	ld a,(iy+LORD_TYPE)  ;si joueur, pas de retraite
	cp LORD_TYPE_PLAYER
	jr z,nowild
	ld a,6
	ret
nowild
	push ix
	push iy
	pop ix
	ld de,8
	add ix,de
	call virt
	pop ix
	ret

ennemid
	ld a,(ix+REGION_CONSTRUCTION)
	or a
	jr z,nodef
	ld a,(event_castresi)
	or a
	jr z,nodef
	ld a,5
	ret
nodef
	inc ix
	call virt
	dec ix
	ret

virt
	ld a,2
	call calcv2
	ld (nmax),hl
	call calcv3
	push hl
	ld de,(nmax)
	or a
	sbc hl,de
	pop hl
	jr c,virt0
	ld (nmax),hl
	ld a,3
virt0 call calcv4
	ld de,(nmax)
	or a
	sbc hl,de
	ret c
	ld a,4
	ret
nmax  ds 2

calcv2
	push af
	ld l,(ix+00)
	ld h,(ix+01)
	ld b,2
	call mult
	ex de,hl
	ld l,(ix+02)
	ld h,(ix+03)
	ld b,10
	call mult
	add hl,de
	ex de,hl
	ld l,(ix+04)
	ld h,(ix+05)
	ld b,25
	call mult
	add hl,de
	pop af
	ret
calcv3
	push af
	ld e,(ix+00)
	ld d,(ix+01)
	ld l,(ix+02)
	ld h,(ix+03)
	ld b,20
	call mult
	add hl,de
	ex de,hl
	ld l,(ix+04)
	ld h,(ix+05)
	ld b,25
	call mult
	add hl,de
	pop af
	ret
calcv4
	push af
	ld e,(ix+00)
	ld d,(ix+01)
	ld l,(ix+02)
	ld h,(ix+03)
	ld b,10
	call mult
	add hl,de
	ex de,hl
	ld l,(ix+04)
	ld h,(ix+05)
	ld b,50
	call mult
	add hl,de
	pop af
	ret
;
;
;
player
	ld hl,menuon
	ld a,(hl)
	or a
	jp nz,nomenu
	inc (hl)
	ld hl,aval+1
	ld de,aval+2
	push hl
	ld bc,4
	ld (hl),0
	ldir
	pop de
	ld hl,noop
	call reverse
	jr c,ch0
	ld a,6
	ld (de),a
	inc de
	ld hl,wild
ch0  push hl
	ld hl,noop
	call reverse
	jr nc,ch1
	ld a,(ix+0)
	or a
	jr z,ch1
	ld a,5
	ld (de),a
	inc de
	ld hl,defensiv
ch1  push hl
	ld hl,noop
	call reverse
	jr c,def0
	ld a,(iy+12)
	or (iy+13)
	jr ch11
def0  ld a,(ix+05)
	or (ix+06)
ch11  jr z,ch2
	ld hl,catapult
	ld a,4
	ld (de),a
	inc de
ch2  push hl
	ld hl,noop
	call reverse
	jr c,def1
	ld a,(iy+10)
	or (iy+11)
	jr ch21
def1  ld a,(ix+03)
	or (ix+04)
ch21  jr z,ch3
	ld hl,knight
	ld a,3
	ld (de),a
	inc de
ch3  push hl
	ld hl,noop
	call reverse
	jr c,def2
	ld a,(iy+08)
	or (iy+09)
	jr ch31
def2  ld a,(ix+01)
	or (ix+02)
ch31  jr z,ch4
	ld hl,stand
	ld a,2
	ld (de),a
	inc de
ch4  push hl

	ld hl,aval
tri0  ld a,(hl)
	or a
	jr z,trif
	ld d,h
	ld e,l
tri1  inc de
	ld a,(de)
	or a
	jr z,tri2
	cp (hl)
	jr nc,tri1
	ld b,(hl)
	ld (hl),a
	ld a,b
	ld (de),a
	jr tri1
tri2  inc hl
	jr tri0
trif
	ld hl,options
	call menutex0
	jr yesmenu
nomenu
	call afleche
	call menusel
	call efleche
yesmenu
	ld hl,aval-1
	ld d,0
	ld e,a
	add hl,de
	ld a,(hl)
	ret
noop  db #ff
stand db #f9,#fe,"corps corps",#fe,#ff
knight db #f9,#fe,"charge  ",#fe,#ff
catapult db #f9,#fe,"catapultes ",#fe,#ff
defensiv db #f9,#fe,"d[fensive ",#fe,#ff
wild  db #f9,#fe,"retraite  ",#fe,#ff
aval  db 1,2,3,4,5,0
; ---------------------------
; b -> indice lord courant
event
; ---------------------------
	push af
	push bc
	push de
	push hl
	ld a,b
	call lgetype
	ld c,a
	ld a,EVENT_NB
	call random
	ld hl,evt_list
	call aiguille
	call affinc
	call affarm
	pop hl
	pop de
	pop bc
	pop af
	ret
; ---------------------------
;evenements
; b -> lord
; c -> LORD_TYPE
;
evt_list
	dw halfinc
	dw catap
	dw revolte
	dw desert
	dw vikings
	dw danes
	dw change
	dw noincom
	dw knights
	dw money
; ---------------------------
halfinc
; ---------------------------
	ld a,b
	call lgetinc
	srl h
	rr l
	ld a,h
	or a
	jr nz,okhalf
	ld a,l
	cp 4
	ret c
okhalf push hl
	ld a,b
	call paye
	ld a,c
	cp 3
	jr z,halflord
	ld a,b
	call getlname
	push hl
halflord ld a,c
	ld hl,halftxt-2
	call rdtab16
	ld a,10
	call placard
	ret
; ---------------------------
catap
; ---------------------------
	ld a,b
	call lgethome
	call rgetcata
	push hl
	ld hl,0
	call rputcata
	ld a,b
	call lgetcata
	push hl
	ld hl,0
	call lputcata
	pop hl
	pop de
	ld a,h
	or l
	jr nz,yescata
	ld a,d
	or e
	ret z
yescata ld a,c
	cp 3
	jr z,catalord
	ld a,b
	call getlname
	push hl
	ld a,c
catalord ld hl,catatxt-2
	call rdtab16
	ld a,10
	call placard
	ret
; ---------------------------
revolte
; ---------------------------
	push bc
	ld a,b
	ld hl,10
	ld b,64
	call sold_pc
	pop bc
	ret nc
	push hl
	ld a,c
	cp 3
	jr z,revolord
	ld a,b
	call getlname
	push hl
revolord ld a,c
	cp 3
	call z,yesplot
	ld hl,revotxt-2
	call rdtab16
	ld a,10
	call placard
	ld a,c
	cp 3
	ret nz
	jp affmap
;
;
nbdesert ds 2

desert
	push bc
	ld a,b
	ld hl,10
	ld b,64
	call sold_pc
	pop bc
	ret nc
	ld (nbdesert),hl
	ex de,hl
	ld a,c
	call ennemi
	call lgetsold
	add hl,de
	call lputsold
	ld e,a
	call isjoueur
	jr z,deslord1
	ld a,e
	call getlname
	push hl
deslord1 ld a,c
	cp 3
	jr z,deselord
	ld a,b
	call getlname
	push hl
deselord ld hl,(nbdesert)
	push hl
	ld hl,desetxt0
	ld a,c
	cp 3
	jr z,deseaff
	ld hl,desetxt1
	ld a,e
	call isjoueur
	jr z,deseaff
	ld hl,desetxt2
deseaff ld a,10
	call placard
	ret
; ---------------------------
vikings
; ---------------------------
	push bc
	ld a,b
	ld hl,10
	ld b,64
	call sold_pc
	pop bc
	ret nc
	push hl
	ld a,c
	cp 3
	jr z,vikilord
	ld a,b
	call getlname
	push hl
vikilord ld a,c
	ld hl,vikitxt-2
	call rdtab16
	ld a,10
	call placard
	ret
; ---------------------------
danes
; ---------------------------
	ld a,b
	call terrain
	or a
	ret z
	ld d,a
	push ix
	call getreg
	ld (ix+07),0
	pop ix
	ld a,c
	cp 3
	jr z,danelord
	ld a,b
	call getlname
	push hl
danelord ld a,d
	call getrname
	push hl
	ld a,c
	ld hl,danetxt-2
	call rdtab16
	ld a,10
	call placard
	ld a,d
	call affreg
	ret
;
change
	ld a,b
	call terrain
	or a
	ret z
	ld d,a
	ld a,c
	call ennemi
	ld e,a
	call isjoueur
	jr z,change0
	ld a,e
	call getlname
	push hl
change0 ld a,c
	cp 2
	jr nz,change1
	ld a,b
	call getlname
	push hl
	jr change2
change1 cp 3
	call z,yesplot
change2 ld a,d
	call getrname
	push hl
	ld hl,chantxt0
	ld a,c
	cp 2
	jr nz,change3
	ld hl,chantxt1
	ld a,e
	call lgetype
	cp 1
	jr z,change3
	ld hl,chantxt2
change3 ld a,10
	call placard
	push de
	ld a,c
	cp 3
	call z,affmap
	pop de
	ld a,d
	call getreg
	ld (ix+07),e
	ld a,d
	call affreg
	ret
;
noincom
	ld a,b
	call terrain
	or a
	ret z
	call getrname
	push hl
	push ix
	call getreg
	ld a,(ix+REGION_TAXES)	; renvoie le revenu apporte par la region.
	pop ix
	ld l,a
	ld h,0
	ld a,b
	call paye
	ld a,c
	cp 3
	call z,yesplot
	jr z,noinlord
	ld a,b
	call getlname
	push hl
noinlord ld hl,nointxt-2
	ld a,c
	call rdtab16
	ld a,10
	call placard
	ld a,c
	cp 3
	ret nz
	jp affmap
;
knights
	ld a,c
	cp 3
	ld a,b
	jr z,kniglord
	call getlname
	push hl
kniglord call lgetchev
	inc hl
	inc hl
	inc hl
	call lputchev
	ld a,c
	ld hl,knigtxt-2
	call rdtab16
	ld a,10
	call placard
	ret
;
money
	ld a,c
	cp 3
	ld a,b
	jr z,monelord
	call getlname
	push hl
monelord ld hl,20
	call encaisse
	ld a,c
	ld hl,monetxt-2
	call rdtab16
	ld a,10
	call placard
	ret
;
;yesplot
;
yesplot
	push af
	push hl
	push de
	push bc
	LOAD_DECOMP_SCR plotters
	call set_image_pal
	call setflash
	ld a,3
	call wait_pause
	pop bc
	pop de
	pop hl
	pop af
	ret
;
;ennemi
; <-a-type du lord dont on cherche un ennemi(3,1->saxon 2->normand)
; ->a-numero du lord ennemi
ennemi
	push bc
	cp 2
	jr nz,ennemi1
	ld a,4
	call random
ennemi2 ld b,a
	call isdead
	jr nz,ennemok
	ld a,b
	inc a
	cp 5
	jr nz,ennemi2
	ld a,1
	jr ennemi2
ennemi1 ld a,5
	call random
	add a,4
ennemi3 ld b,a
	call isdead
	jr nz,ennemok
	ld a,b
	inc a
	cp 10
	jr nz,ennemi3
	ld a,5
	jr ennemi3
ennemok ld a,b
	pop bc
	ret
;
;terrain
; <-a-lord dont on cherche une region libre
; ->a-numero de la region libre (0 si aucune)
;
terrain
	push bc
	push ix
	ld c,a
	ld a,18
	call random
	ld (terrsta+1),a
terrain0 ld b,a
	call getreg
	ld a,(ix+07)
	cp c
	jr nz,terrain2
	ld a,(ix+00)
	or a
	jr nz,terrain2
	ld a,c
	call lgetreg
	cp b
	jr nz,terrain1
terrain2 ld a,b
	inc a
	cp 19
	jr nz,terrain0
	ld a,1
terrain3 ld b,a
	call getreg
	ld a,(ix+07)
	cp c
	jr nz,terrain4
	ld a,(ix+00)
	or a
	jr nz,terrain4
	ld a,c
	call lgetreg
	cp b
	jr nz,terrain1
terrain4 ld a,b
	inc a
terrsta cp 0
	jr nz,terrain3
	ld b,0
terrain1 ld a,b
	pop ix
	pop bc
	ret
;
tst_sold
	push de
	ex de,hl
	call lgetsold
	or a
	sbc hl,de
	ccf
	ex de,hl
	pop de
	ret

sold_pc
	call tst_sold
	ret nc
	push de
	call lgetsold
	push hl
	call diminue
	call lputsold
	pop de
	ex de,hl
	or a
	sbc hl,de
	pop de
	scf
	ret
; ---------------------------
	read "DoTC_Text_Event.asm"
; ---------------------------
list:DOTC_EVENT_LENGTH equ $-DOTC_EVENT_ADDRESS:nolist
