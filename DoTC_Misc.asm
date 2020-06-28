;-------------------------------------------------------------------------------
; from DIVERS.ASM
; ---------------------------
; A_Fonctions de manipulation de donnees du jeu
; ---------------------------
; supprime un Lord de la partie.
kill:
; ---------------------------
	push iy
	call getlord
	ld (iy+LORD_TYPE),LORD_TYPE_KILL
	pop iy
	ret
; ---------------------------
; fait pointer IX sur les donnees de la region.
; a  -> numero de la region
; ix <- region data ptr
getregion:
let GETREG=getregion
; ---------------------------
	push af

	add a,a	; x2
	add a,a ; x4
	add a,a ; x8
	add a,a ; x16

	ld ixl,a
	adc a,0
	sub ixl
	ld ixh,a

	ld a,ixl
	add a,REGIONS-REGIONS_LENGTH
	ld ixl,a
	adc a,REGIONS-REGIONS_LENGTH/&100
	sub a,ixl
	add a,ixh
	ld ixh,a

	pop af

	ret
;
; ---------------------------
; fait pointer iy sur les donnees du lord.
; A = lord 0->15
getlord:
; ---------------------------
	push af

	add a,a	; x2
	add a,a ; x4
	add a,a ; x8
	add a,a ; x16

	add a,LORDS-LORDS_LENGTH
	ld iyl,a
	adc a,LORDS-LORDS_LENGTH/&100
	sub a,iyl
	ld iyh,a

	pop af

	ret
; ---------------------------
; renvoie la region domicile du Lord
; iy -> lord data ptr
; a  <- la region domicile du Lord
getlordhome:
; ---------------------------
	ld a,(iy+LORD_CASTLE)
	push hl
	ld hl,chato+1
	call rdtab_4
	ld a,(hl)
	pop hl

	ret
; ---------------------------
; renvoie la region domicile du lord.
lgethome
; ---------------------------
	push iy
	call getlord
	ld a,(iy+LORD_CASTLE)
	push hl
	ld hl,chato+1
	call rdtab_4
	ld a,(hl)
	pop hl
	pop iy
	ret
; ---------------------------
; renvoie la liste des régions préférées d'un lord
lgetpref
; ---------------------------
	push iy
	push af
	call getlord
	ld a,(iy+LORD_CASTLE)
	ld hl,chato+2
	call rdtab_4
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	pop af
	pop iy
	ret
; ---------------------------
; renvoie le type du lord.
lgetype
; ---------------------------
	push iy
	call getlord
	ld a,(iy+LORD_TYPE)
	pop iy
	ret
; ---------------------------
; renvoie la region courante du lord.
lgetreg
; ---------------------------
	push iy
	call getlord
	ld a,(iy+LORD_REGION)
	pop iy
	ret
; ---------------------------
; Renvoie la haine du Lord envers le joueur
lgethate
; ---------------------------
	push iy
	call getlord
	ld a,(iy+LORD_HATE_FOR_YOU)
	pop iy
	ret
; ---------------------------
; Renvoie le nombre de soldats de l'armee du Lord.
lgetsold
; ---------------------------
	push iy
	call getlord
	ld l,(iy+LORD_SOLDATS+0)
	ld h,(iy+LORD_SOLDATS+1)
	pop iy
	ret
; ---------------------------
; Change les soldats de l'armee du Lord
; a  -> numero du lord
; hl -> nombre de soldats
lputsold
; ---------------------------
	push iy
	call getlord
	ld (iy+LORD_SOLDATS+0),l
	ld (iy+LORD_SOLDATS+1),h
	pop iy
	ret
; ---------------------------
; Renvoie le nombre de chevaliers de l'armee du Lord.
; a  -> numero du lord
; hl <- nombre de chevaliers
lgetchev
; ---------------------------
	push iy
	call getlord
	ld l,(iy+LORD_CHEVALIERS+0)
	ld h,(iy+LORD_CHEVALIERS+1)
	pop iy
	ret
; ---------------------------
; Change le nombre de chevaliers de l'armee du Lord.
; a  -> numero du lord
; hl -> nombre de chevaliers
lputchev
; ---------------------------
	push iy
	call getlord
	ld (iy+LORD_CHEVALIERS+0),l
	ld (iy+LORD_CHEVALIERS+1),h
	pop iy
	ret
; ---------------------------
; Renvoie le nombre de catapultes de l'armee du Lord.
; a  -> numero du lord
; hl <- nombre de catapultes
lgetcata
; ---------------------------
	push iy
	call getlord
	ld l,(iy+LORD_CATAPULTES+0)
	ld h,(iy+LORD_CATAPULTES+1)
	pop iy
	ret
; ---------------------------
; Change le nombre de catapultes de l'armee du Lord.
; a  -> numero du lord
; hl -> nombre de catapultes
lputcata
; ---------------------------
	push iy
	call getlord
	ld (iy+LORD_CATAPULTES+0),l
	ld (iy+LORD_CATAPULTES+1),h
	pop iy
	ret
; ---------------------------
; Renvoie le montant du tresor du Lord.
; a  -> numero du lord
; hl <- nombre de pieces d'or
lgetgold
; ---------------------------
	push iy
	call getlord
	ld l,(iy+LORD_TRESOR+0)
	ld h,(iy+LORD_TRESOR+1)
	pop iy
	ret
; ---------------------------
; change le montant du tresor du lord.
; a  -> numero du lord
; hl -> nombre de pieces d'or
lputgold
; ---------------------------
	push iy
	call getlord
	ld (iy+LORD_TRESOR+0),l
	ld (iy+LORD_TRESOR+1),h
	pop iy
	ret
; ---------------------------
; Renvoie la Lady du Lord.
; a  -> numero du lord
; a <- numero de la lady du lord (Z = celibataire)
lgetwife
; ---------------------------
	push iy
	call getlord
	ld a,(iy+LORD_WIFE)
	rlca
	rlca
	and LADY_MAX
	pop iy
	ret
; ---------------------------
; Renvoie le nombre de soldats dans la region.
; a  -> numero de la region
; hl <- nombre de soldats dans la region
rgetsold
; ---------------------------
	push ix
	call getreg
	ld l,(ix+REGION_SOLDATS+0)
	ld h,(ix+REGION_SOLDATS+1)
	pop ix
	ret
; ---------------------------
; change le nombre de soldats dans la region.
; a  -> numero de la region
; hl -> nombre de soldats
rputsold
; ---------------------------
	push ix
	call getreg
	ld (ix+REGION_SOLDATS+0),l
	ld (ix+REGION_SOLDATS+1),h
	pop ix
	ret
;
;rgetchev([a]region)-> hl-chevaliers
; renvoie le nombre de chevaliers dans la region.
rgetchev
	push ix
	call getreg
	ld l,(ix+03)
	ld h,(ix+04)
	pop ix
	ret
;
;rputchev([a]region,[hl]chevaliers)
; change le nombre de chevaliers dans la region.
rputchev
	push ix
	call getreg
	ld (ix+03),l
	ld (ix+04),h
	pop ix
	ret
;
;rgetcata([a]region)-> hl-catapultes
; renvoie le nombre de catapultes dans la region.
rgetcata
	push ix
	call getreg
	ld l,(ix+05)
	ld h,(ix+06)
	pop ix
	ret
;
;rputcata([a]region,[hl]catapultes)
; change le nombre de catapultes dans la region.
rputcata
	push ix
	call getreg
	ld (ix+05),l
	ld (ix+06),h
	pop ix
	ret
; ---------------------------
; renvoie le proprietaire de la region.
; a  -> numero de la region
; a  <- numero du lord
rgetprop
; ---------------------------
	push ix
	call getreg
	ld a,(ix+REGION_PROPRIO)
	pop ix
	ret
; ---------------------------
; renvoie la construction presente sur la region.
; a  <- la construction presente sur la region
rgetbuil
; ---------------------------
	push ix
	call getreg
	ld a,(ix+REGION_CONSTRUCTION)
	pop ix
	ret
; ---------------------------
; renvoie le revenu global du lord.
; a  <- numero du lord
; hl <- revenu global de toutes les regions du lord
; ---------------------------
lgetinc
	push bc
	push de
	push ix

	ld c,a
	ld b,REGIONS_NB
	ld hl,0
	ld d,0
lgetinc0
	ld a,b
	call getreg
	ld a,c
	cp (ix+REGION_PROPRIO)
	jr nz,lgetinc1
	ld e,(ix+REGION_TAXES)
	add hl,de
lgetinc1
	djnz lgetinc0

	pop ix
	pop de
	pop bc
	ret
;
;LGETARM([A]LORD)-> HL-effectif
; Renvoie l'armee totale du Lord (soldats+chevaliers armee et regions)
; a  <- numero du lord
lgetarm
; à améliorer en récuperant la region une fois !
	push bc
	push de
	push ix
	push iy
	ld c,a
	ld b,REGIONS_NB
	ld hl,0
lgetarm0 ld a,b
	call rgetprop
	cp c
	jr nz,lgetarm1
	ld a,b
	ex de,hl
	call rgetsold
	add hl,de
	ex de,hl
	call rgetchev
	add hl,de
lgetarm1 djnz lgetarm0
	ld a,c
	ex de,hl
	call lgetsold
	add hl,de
	ex de,hl
	call lgetchev
	add hl,de
	pop iy
	pop ix
	pop de
	pop bc
	ret
;
;encaisse(a-lord,hl-montant)
; encaisse un montant.
encaisse
	push de
	push hl
	ex de,hl
	call lgetgold
	add hl,de
	call lputgold
	pop hl
	pop de
	ret
;
;paye(a-lord,hl-montant)-> c si bien paye
; paye un montant fixe
paye
	push de
	push hl
	ex de,hl
	call lgetgold
	or a
	sbc hl,de
	jr c,paye0
	call lputgold
	or a
paye0 ccf
	pop hl
	pop de
	ret
;
;tst_mony(a-lord,hl-montant)-> c si assez d'argent
; verifie que lord peut payer
tst_mony
	push hl
	push de
	ex de,hl
	call lgetgold
	or a
	sbc hl,de
	ccf
	pop de
	pop hl
	ret
;
;paye_pc(a-lord,b-pour_256,hl-min)-> c si paye et hl-montant paye.
; paye un pourcentage du tresor
paye_pc
	call tst_mony
	ret nc
	push de
	call lgetgold
	push hl
	call diminue
	call lputgold
	pop de
	ex de,hl
	or a
	sbc hl,de
	pop de
	scf
	ret
;
;retire(b-lord,c-beneficiaire)
; le lord donne toutes ses regions au beneficiaire
;
retire
	push af
	push bc
	push de
	ld e,c
	ld d,b
	ld c,REGIONS_NB
retire0 ld b,d
	call belong
	ld b,e
	call z,kado
	dec c
	jr nz,retire0
	pop de
	pop bc
	pop af
	ret
;
;gohome(a-lord)
; renvoie le lord chez lui
gohome
	push af
	push bc
	ld b,a
	call lgethome
	ld c,a
	ld a,b
	call go
	pop bc
	pop af
	ret
;
;go(a-lord,c-region)
; deplace le lord
go
	push iy
	call getlord
	ld (iy+LORD_REGION),c
	pop iy
	ret
;
;KADO(B-Lord,C-Region)
; Donne la region au lord.
KADO
	PUSH AF
	PUSH IX
	PUSH BC
	LD A,C
	CALL RGETPROP
	LD B,A
	CALL LGETREG
	CP C
	LD A,B
	CALL Z,GOHOME
	POP BC
	LD A,C
	CALL GETREG
	LD (IX+07),B
	POP IX
	POP AF
	RET
;
;LINCHATE(A-Lord)
; Incremente le hate for you d'un Lord
LINCHATE
	PUSH IY
	PUSH AF
	CALL GETLORD
	LD A,(IY+04)
	CP 10
	JR Z,NOHINC
	INC (IY+04)
NOHINC POP AF
	POP IY
	RET
;
;CHEMIN(A-Lord,B-Region1,C-Region2)-> C si accessible, B=Next reg
; Cherche un chemin pour deplacer le Lord vers la region.
CHTABLE EQU TAMPON		;NB_REGIONS
DIST  EQU CHTABLE+REGIONS_NB;1
MINDIST EQU DIST+1		;1
FIR_REG DEFS 1
DIR  DEFS 1
;
CHEMIN
	PUSH HL
	PUSH DE
	PUSH BC
	LD E,B
	LD B,REGIONS_NB+1
	LD HL,CHTABLE
CHEMIN0 LD (HL),0
	INC HL
	DJNZ CHEMIN0
	LD (HL),#FF
	CALL RECURS
	POP BC
	LD A,(DIR)
	LD B,A
	LD A,(MINDIST)
	CP #FF
	POP DE
	POP HL
	RET
RECURS
	LD D,0
	LD HL,CHTABLE+REGIONS_NB
	OR A
	SBC HL,DE
	INC (HL)
	LD HL,DIST
	INC (HL)
	LD D,A
	LD B,REGIONS_NB
	LD HL,CHTABLE
RECURS0 LD A,(DIST)
	CP 1
	JR NZ,PASFIR
	LD A,B
	LD (FIR_REG),A
PASFIR LD A,(HL)
	OR A
	JR NZ,RECURS2
	PUSH BC
	LD C,E
	CALL ADJACENT
	POP BC
	JR NC,RECURS2
	LD A,C
	CP B
	JR NZ,RECURS1
	PUSH HL
	LD HL,MINDIST
	LD A,(DIST)
	CP (HL)
	POP HL
	JR NC,RECURS2
	LD (MINDIST),A
	LD A,(FIR_REG)
	LD (DIR),A
	JR RECURS2
RECURS1 LD A,B
	CALL RGETPROP
	CP D
	JR NZ,RECURS2
	PUSH HL
	PUSH BC
	PUSH DE
	LD A,D
	LD E,B
	CALL RECURS
	POP DE
	POP BC
	POP HL
RECURS2 INC HL
	DJNZ RECURS0
	LD D,0
	LD HL,CHTABLE+REGIONS_NB
	OR A
	SBC HL,DE
	DEC (HL)
	LD HL,DIST
	DEC (HL)
	RET
;
;R_DIST(A-Lord,B-Region1,C-Region2)-> C si accessible, A=distance
; Calcule la distance entre deux region pour un lord.
CH_MASK DEFS 3
CH_COUR DEFS 3
CH_TEMP DEFS 3
CH_DIST DEFS 1
;
R_DIST
	PUSH HL
	PUSH DE
	PUSH BC
	PUSH IX
	PUSH IY
	CALL INITMASK
	LD A,B
	CALL GETLIGNE
	LD A,1
R_DIST0 LD (CH_DIST),A
	CALL TSTFOUND
	JR C,R_DISTR
	CALL ANDLIGNE
	JR Z,R_DISTR
	CALL CALCMASK
	CALL CALCTEMP
	CALL NEWCOUR
	LD A,(CH_DIST)
	INC A
	JR R_DIST0
R_DISTR LD A,(CH_DIST)
	POP IY
	POP IX
	POP BC
	POP DE
	POP HL
	RET
CALCTEMP
	PUSH BC
	LD HL,CH_TEMP
	LD (HL),0
	INC HL
	LD (HL),0
	INC HL
	LD (HL),0
	LD IX,CH_COUR+2
	LD HL,ADJATAB
	LD B,1
	SCF
CALCTEM0 RR (IX+00)
	JR NZ,CALCTEM1
	DEC IX
	SCF
	JR CALCTEM0
CALCTEM1 JR NC,CALCTEM2
	PUSH HL
	LD DE,CH_TEMP
	LD A,(DE)
	OR (HL)
	LD (DE),A
	INC DE
	INC HL
	LD A,(DE)
	OR (HL)
	LD (DE),A
	INC DE
	INC HL
	LD A,(DE)
	OR (HL)
	LD (DE),A
	POP HL
CALCTEM2 LD DE,3
	ADD HL,DE
	INC B
	BIT 4,B
	JR Z,CALCTEM0
	BIT 1,B
	JR Z,CALCTEM0
	POP BC
	RET
NEWCOUR
	PUSH BC
	LD BC,3
	LD HL,CH_TEMP
	LD DE,CH_COUR
	LDIR
	POP BC
	RET
CALCMASK
	PUSH BC
	LD B,3
	LD HL,CH_MASK
	LD DE,CH_COUR
CALCMA0 LD A,(DE)
	CPL
	AND (HL)
	LD (HL),A
	INC HL
	INC DE
	DJNZ CALCMA0
	POP BC
	RET
TSTFOUND
	PUSH BC
	LD HL,CH_COUR
	DEC C
	BIT 4,C
	JR NZ,TSTFOU0
	INC HL
	BIT 3,C
	JR NZ,TSTFOU0
	INC HL
TSTFOU0 LD A,C
	AND #07
	RLA
	RLA
	RLA
	OR #46	 ;BIT 0,(HL)
	LD (TSTFOU1+1),A
TSTFOU1 BIT 0,(HL)
	SCF
	POP BC
	RET NZ
	OR A
	RET
GETLIGNE
	PUSH BC
	LD HL,ADJATAB-3
	LD E,A
	LD D,0
	ADD HL,DE
	ADD HL,DE
	ADD HL,DE
	LD DE,CH_COUR
	LD BC,3
	LDIR
	POP BC
	RET
ANDLIGNE
	PUSH BC
	LD DE,CH_MASK
	LD HL,CH_COUR
	LD BC,#0300
ANDLIG0 LD A,(DE)
	AND (HL)
	LD (HL),A
	OR C
	LD C,A
	INC HL
	INC DE
	DJNZ ANDLIG0
	POP BC
	RET
INITMASK
	PUSH BC
	LD IX,CH_MASK+2
	LD HL,REGIONS+7
	LD DE,16
	LD B,1
	LD C,#80
INITMAS0 CP (HL)
	SCF
	JR Z,INITMAS1
	CCF
INITMAS1 RR C
	JR NC,INITMAS2
	LD (IX+00),C
	LD C,#80
	DEC IX
INITMAS2 ADD HL,DE
	INC B
	BIT 4,B
	JR Z,INITMAS0
	BIT 1,B
	JR Z,INITMAS0
	LD (IX+00),C
	POP BC
	RET
;
;TRANSFER(A-Reg)
; Transfere l'armee du proprietaire dans la garnison
TRANSFER
	PUSH BC
	PUSH HL
	PUSH DE
	LD C,A
	CALL RGETPROP
	LD B,A
	CALL LGETSOLD
	EX DE,HL
	LD A,C
	CALL RGETSOLD
	ADD HL,DE
	CALL RPUTSOLD
	LD A,B
	CALL LGETCHEV
	EX DE,HL
	LD A,C
	CALL RGETCHEV
	ADD HL,DE
	CALL RPUTCHEV
	LD A,B
	CALL LGETCATA
	EX DE,HL
	LD A,C
	CALL RGETCATA
	ADD HL,DE
	CALL RPUTCATA
	LD A,B
	LD HL,0
	CALL LPUTSOLD
	CALL LPUTCHEV
	CALL LPUTCATA
	POP DE
	POP HL
	POP BC
	RET
;
;LPOWER(A-Lord)->HL-Army power
;
LPOWER
	PUSH BC
	PUSH DE
	CALL LGETSOLD
	EX DE,HL
	CALL LGETCHEV
	LD B,5
	CALL MULT
	ADD HL,DE
	POP DE
	POP BC
	RET
;
;RPOWER(A-Region)->HL-defensive power
;
RPOWER
	PUSH BC
	PUSH DE
	PUSH AF
	LD C,A
	CALL RGETSOLD
	EX DE,HL
	CALL RGETCHEV
	LD B,5
	CALL MULT
	ADD HL,DE
	LD A,C
	CALL RGETBUIL
	OR A
	JR Z,RPOWER0
	LD A,C
	CALL LORDNEAR
	JR NC,RPOWER0
	LD A,C
	EX DE,HL
	CALL RGETPROP
	CALL LPOWER
	ADD HL,DE
RPOWER0 INC HL
	INC HL
	POP AF
	POP DE
	POP BC
	RET


;-------------------------------------------------------------------------------
;B_Fonctions affichant sur la carte
;-------------------------------------------------------------------------------
;
;DEPLACE([A]LORD,[C]REGION)
; Le Lord va dans la region.
DEPLACE
	PUSH BC
	PUSH AF
	CALL LGETREG
	LD B,A
	POP AF
	CALL GO
	CALL ISJOUEUR
	JR NZ,DEPLACE0
	LD A,B
	CALL AFFREG
	LD A,C
	CALL AFFREG
	CALL AFFLAND
DEPLACE0 POP BC
	RET
;
;DONNE([C]REGION,[B]LORD)
; Le Lord recoit la region.
DONNE
	CALL KADO
	LD A,C
	CALL AFFREG
	LD A,B
	CALL ISJOUEUR
	RET NZ
	CALL AFFINC
	JP AFFARM
;
;RAMENE(A-Reg)
; Ramene le proprietaire dans la region
RAMENE
	PUSH BC
	LD C,A
	CALL RGETPROP
	CALL DEPLACE
	POP BC
	RET
;
;RAPATRIE(A-Lord)
; Effectue un GOHOME avec rafraichissement de la carte
RAPATRIE
	CALL LGETHOME
	JP RAMENE
;
;DEPOUIL(B-Lord,C-Beneficiaire)
; Toutes les regions du Lord1 vont au Lord2.
DEPOUIL
	PUSH AF
	PUSH BC
	PUSH DE
	LD E,C
	LD D,B
	LD C,REGIONS_NB
DEPOUIL0 LD B,D
	CALL BELONG
	LD B,E
	CALL Z,DONNE
	DEC C
	JR NZ,DEPOUIL0
	POP DE
	POP BC
	POP AF
	RET
;
;MONEYIN([A]LORD)
; Le Lord recoit ses revenus mensuels
MONEYIN
	PUSH HL
	CALL LGETINC
	CALL ENCAISSE
	POP HL
	JP AFFGOLD
;
;AFFINC()
; Affiche les revenus du joueur (MAP ON)
AFFINC
	TXT_LOCATE 05,12
	LD A,(LORD)
	CALL LGETINC
	CALL AFFD16
	RET
;
;AFFGOLD()
; Affiche le tresor du joueur (MAP ON)
AFFGOLD
	TXT_LOCATE 05,14
	LD A,(LORD)
	CALL GETLORD
	LD L,(IY+14)
	LD H,(IY+15)
	CALL AFFD16
	RET
;
;AFFARM()
; Affiche l'armee du joueur (MAP ON)
AFFARM
	TXT_LOCATE 05,16
	LD A,(LORD)
	CALL LGETARM
	CALL AFFD16
	RET
; ---------------------------
; Affiche la date courante (MAP ON)
affdate:
; ---------------------------
	TXT_LOCATE 30,23
	ld a,(cour_moi)
	ld hl,mois
	call getstr
	call affmebis
	ld hl,(cour_an)
	call affd16
	ld a," "
	jp txt_output

;
;AFFFACE([A]LORD)
; Affichage du visage du Lord (MAP ON)
AFFFACE
	ADD A,24
	LD H,52
	LD L,191
	LD B,13
	jp AFFSPRC
;
;AFFWIFE()
; Affichage du visage de la Lady du joueur(MAP ON)
AFFWIFE
	LD A,(LORD)
	CALL GETLORD
	LD A,(IY+5)
	RLCA
	RLCA
	AND #03
	RET Z
	ADD A,33
	LD H,132
	LD L,191
	jp AFFSPR
;
;AFFLORD()
; Affichage du nom du joueur(MAP ON)
AFFLORD
	TXT_LOCATE 03,02
	LD HL,PRENOMS
	LD A,(LORD)
	CALL GETSTR
	jp AFFMEBIS
; ---------------------------
; Affichage de la region ou est le joueur(MAP ON)
AFFLAND
; ---------------------------
	TXT_LOCATE 01, 04
	ld hl,affland_clear_text
	call affmebis
	TXT_LOCATE 01, 04

;	ld a,(lord)
;	call getlord
	ld iy,(player1_lord)

	ld a,(iy+LORD_REGION)
	push af
	call getrname
	ld a,12
	call centre
	call affmebis
	TXT_LOCATE 08, 03
	pop af
	ld hl,LANDS_PREPOSI_IDX-2
	call getstridx
	jp affmebis

AFFLAND_CLEAR_TEXT DEFB "            ",&ff

;
;AFFLEA()
; Affichage du leadership du joueur (MAP ON)
AFFLEA
	TXT_LOCATE 04, 06
	LD A,(LORD)
	CALL GETLORD
	LD A,(IY+01)
	CALL GETLEV
	jp AFFMEBIS
;
;AFFJOU()
; Affichage du jousting du joueur (MAP ON)
AFFJOU
	TXT_LOCATE 04, 08
	LD A,(LORD)
	CALL GETLORD
	LD A,(IY+03)
	CALL GETLEV
	jp AFFMEBIS
;
;AFFSWO()
; Affichage du sword du joueur (MAP ON)
AFFSWO
  TXT_LOCATE 04, 10
	LD A,(LORD)
	CALL GETLORD
	LD A,(IY+02)
	CALL GETLEV
	jp AFFMEBIS
;-------------------------------------------------------------------------------
;C_Tests sur les donnees du jeu
;-------------------------------------------------------------------------------
;
;LORDHERE(A-Region)
; Renvoie Z si proprietaire present
LORDHERE
	PUSH BC
	LD C,A
	CALL RGETPROP
	CALL LGETREG
	CP C
	POP BC
	RET
;
;LORDNEAR(A-Region)
; Renvoie C si proprietaire a cote
LORDNEAR
	PUSH BC
	LD C,A
	CALL RGETPROP
	CALL LGETREG
	LD B,A
	CALL ADJACENT
	POP BC
	RET
; ---------------------------
; renvoie z si lord dead.
isdead
; ---------------------------
	call lgetype
	or a
	ret
; ---------------------------
;ISNORM(A-Lord)-> Z
; Renvoie Z si Lord normand.
ISNORM
	CALL LGETYPE
	CP 2
	RET
;
;ISJOUEUR(A-Lord)-> Z
; Renvoie Z si Lord joueur.
ISJOUEUR
	CALL LGETYPE
	CP 3
	RET
;
;BELONG(B-Lord,C-Region)-> Z
; Teste si la region appartient au lord.
BELONG
	LD A,C
	CALL RGETPROP
	CP B
	RET
;
;LANDFREE(A-Lord)-> C A=Region (La preferee du Lord)
; Renvoie C si Lord possede un terrain negociable.
LANDFREE
	PUSH BC
	PUSH HL
	LD B,A
	CALL LGETPREF
LANDFR0 LD C,(HL)
	CALL BELONG
	JR NZ,LANDFR1
	LD A,C
	CALL RGETBUIL
	OR A
	JR NZ,LANDFR1
	LD A,C
	SCF
	JR LANDFR2
LANDFR1 INC HL
	LD A,(HL)
	OR A
	JR NZ,LANDFR0
LANDFR2 POP HL
	POP BC
	RET
;
;ADJACENT([B]REGION1,[C]REGION2)-> C
; Renvoit Carry si les deux regions sont adjacentes.
ADJACENT
	PUSH HL
	PUSH BC
	LD HL,ADJATAB-1
	LD A,B
	LD B,0
	ADD HL,BC
	ADD HL,BC
	ADD HL,BC
	DEC A
	LD B,A
	AND #07
	RLA
	RLA
	RLA
	OR #46	 ;BIT 0,(HL)
	LD (ADJABIT+1),A
	BIT 4,B
	JR Z,ADJA0
	DEC HL
	DEC HL
	JR ADJABIT
ADJA0 BIT 3,B
	JR Z,ADJABIT
	DEC HL
ADJABIT BIT 0,(HL)
	POP BC
	POP HL
	SCF
	RET NZ
	OR A
	RET
;-------------------------------------------------------------------------------
;D_Fonctions de dialogue
;-------------------------------------------------------------------------------
; Affiche le texte HL(cf. TXT.ASM pour les codes de controle) et le laisse
; pendant A secondes (cf. PAUSE()).
; ***ATTENTION*** ne peut etre entree par JP que si pas de parametres.
; hl -> Text ptr
; a  -> Duree
PLACARD
; ---------------------------
	LD (PLACBUF_DE),DE
	LD (PLACBUF_A),A
	POP DE
	LD (PLACBUF_SAVEDE),DE
	CALL MENUTEXT
PLACBUF_SAVEDE equ $ +1
	LD DE,0
	PUSH DE
PLACBUF_DE equ $ +1
	LD DE,0
PLACBUF_A equ $ +1
	LD A,0
	CALL WAIT_PAUSE
	CALL MENUREST
	LD A,1
	jp WAIT_PAUSE
;
;CHOIREG()
; Choix d'une region.
CHOIXREG
	PUSH HL
	CALL EFLECHE
	LD HL,SELECTR
	CALL MENUTEXT
	CALL AFLECHE
CHOIXRE0 CALL MFLECHE
	JR NC,CHOIXRE0
	CALL EFLECHE
	CALL WHATREG
	CALL MENUREST
	POP HL
	RET
;
;GETLEV([A]VALUE)->HL-String
; Renvoie le niveau (Faible,Moyen,Bon,Fort) d'une apitude.
GETLEV
	DEC A
	SRL A
	JR NZ,GETLEV0
	INC A
GETLEV0 LD HL,LEVEL
	JP GETSTR
;
;GETLNAME(A-Personne)-> HL-string
; Renvoie le nom d'un personnage
GETLNAME
	ld hl,CHARACTERS_NAMES_IDX-2
; 21
GETSTRIDX
	push af

	add a,a	; x2
	add a,l
	ld l,a
	adc a,h
	sub l
	ld h,a
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a

	pop af
	ret
;
;GETRNAME(A-Region)-> HL-string
; Renvoie le nom d'une region
GETRNAME
	ld hl,LANDS_IDX-2
	jr GETSTRIDX
;-------------------------------------------------------------------------------
;E_Fonctions de deroulement du programme
;-------------------------------------------------------------------------------
; Selection du personnage en debut de partie
choose:
; ---------------------------
	call music_off

;	ld hl,crtc_regs_value+1
;	ld (hl),SCREEN_WIDTH+16/2
;	inc hl
;	ld (hl),SCREEN_WIDTH+16/2+2
;	call set_crtc_regs

	LOAD_DECOMP_SCR filename_names

	call set_image_pal

	call afleche
	scf
choose0 call mfleche
	jr nc,choose0
	call efleche
	call gflech1
	ld c,1
	ld a,h
	cp 80
	jr c,choose1
	inc c
choose1 ld a,l
	cp 100
	jr nc,choose2
	inc c
	inc c
choose2 ld a,c
	ld (player1_lord_id),a
	call getlord
	ld (player1_lord),iy

	call getlname
	push hl

;	ld hl,SCREEN_ADDRESS
;	ld de,SCREEN_ADDRESS+1
;	ld (hl),&00
;	ld bc,&3fff
;	ldir

;	ld hl,crtc_regs_value+1
;	ld (hl),SCREEN_WIDTH/2
;	inc hl
;	ld (hl),SCREEN_WIDTH/2+6
;	call set_crtc_regs

	ld hl,text_welcome
	ld a,4
	call placard
	ret
; ---------------------------
; initialisation des donnees du jeu.
setvar:
; ---------------------------
	ld iy,(player1_lord)
	ld (iy+LORD_TYPE),LORD_TYPE_PLAYER
	ld (iy+LORD_WIFE),&00
	ld a,3
	call random
	ld (iy+LORD_CASTLE),a
	ld d,a
	call getlordhome
	ld (iy+LORD_REGION),a
	call getregion
	ld a,(player1_lord_id)
	ld (ix+REGION_PROPRIO),a
	ld (ix+REGION_CONSTRUCTION),CONSTRUCTION_ACASTLE
	ld a,(ix+REGION_TAXES)
	ld (ix+REGION_SOLDATS),a
; Initialise les données des lords amis
; d = player1_lord_castle
	ld e,0
	ld b,LORDS_NB_AMI
setvar1 inc e
	ld a,e
	cp d
	jr z,setvar1
setvar2 ld a,4
	call random
	ld c,a
	call getlord
	ld a,(iy+LORD_CASTLE)
	or a
	jr nz,setvar2
	ld (iy+LORD_TYPE),LORD_TYPE_AMI
	ld (iy+LORD_WIFE),b
	rrc (iy+LORD_WIFE)
	rrc (iy+LORD_WIFE)
	ld (iy+LORD_CASTLE),e
	call getlordhome
	ld (iy+LORD_REGION),a
	call getregion
	ld (ix+REGION_PROPRIO),c
	ld (ix+REGION_CONSTRUCTION),CONSTRUCTION_ACASTLE
	ld a,(ix+REGION_TAXES)
	ld (ix+REGION_SOLDATS),a
	djnz setvar1
; Initialise les données des lords ennemis
	ld b,LORDS_NB_ENNEMI
setvar3 ld a,5
	call random
	add a,4
	ld c,a
	call getlord
	ld a,(iy+LORD_CASTLE)
	or a
	jr nz,setvar3
	ld (iy+LORD_TYPE),LORD_TYPE_ENNEMI
	ld a,b
	add a,3
	ld (iy+LORD_CASTLE),a
	call getlordhome
	ld (iy+LORD_REGION),a
	call getregion
	ld (ix+REGION_PROPRIO),c
	ld (ix+REGION_CONSTRUCTION),CONSTRUCTION_ECASTLE
	ld a,(ix+REGION_TAXES)
	ld (ix+REGION_SOLDATS),a
	djnz setvar3

	ld b,REGIONS_NB
setvar4 ld a,b
	call getregion
	ld a,(ix+REGION_VASSEAUX)
	add a,(ix+REGION_SOLDATS)
	ld (ix+REGION_SOLDATS),a
	djnz setvar4

	ret
; ---------------------------
; Affichage complet de la carte.
affmap
; ---------------------------
	push af
	push hl

	LOAD_DECOMP_SCR filename_tactmap

	ld hl,filename_province
	ld de,BUFSPRLOAD
	call readfile

	push de
	ld hl,faces
	call readfile
	pop de			; don't skip file length because FACES don't have !
	ld (savebuf),de

	push bc	; reaffiche les regions

	ld b,REGIONS_NB
regen0
	ld a,b
	call affreg
	djnz regen0

	pop bc

	ld a,(lord)	; reaffiche les visages
	call affface
	call affwife

	call afflord	; reaffiche toutes les donnees
	call affland
	call afflea
	call affjou
	call affswo
	call affinc
	call affgold
	call affarm
	call affdate

	call set_image_pal

	pop hl
	pop af
	ret

