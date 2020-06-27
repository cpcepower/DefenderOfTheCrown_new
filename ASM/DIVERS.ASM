;-------------------------------------------------------------------------------
;DIVERS.ASM
;   (c)1988 B.RIVE
;-------------------------------------------------------------------------------
;   Routines du jeu par type-
;        A_Fonctions de manipulation de donnees du jeu
;        B_Fonctions affichant sur la carte
;        C_Tests sur les donnees du jeu
;        D_Fonctions de dialogue
;        E_Fonctions de deroulement du programme
;-------------------------------------------------------------------------------
;A_Fonctions de manipulation de donnees du jeu
;TRANSFER(A-Reg)
;KILL([A]LORD)
;GETREG([A]REGION)-> IX-Buffer de donnees.
;GETLORD([A]LORD)-> IY-Buffer de donnees.
;LGETHOME([A]LORD)-> A-Region.
;LGETPREF(A-Lord)-> HL-Table de preferences
;LGETYPE([A]LORD)-> A-Type (0=out,1=Saxon,2=Normand,3=Joueur)
;LGETREG([A]LORD)-> A-Region.
;LGETHATE([A]LORD)-> A-Hate
;LGETSOLD([A]LORD)-> HL-Soldats
;LPUTSOLD([A]LORD,[HL]SOLDATS)
;LGETCHEV([A]LORD)-> HL-Chevaliers.
;LPUTCHEV([A]LORD,[HL]CHEVALIERS)
;LGETCATA([A]LORD)-> HL-Catapultes.
;LPUTCATA([A]LORD,[HL]CATAPULTES)
;LGETGOLD([A]LORD)-> HL-Pieces d'or.
;LPUTGOLD([A]LORD,[HL]GOLD)
;LGETWIFE(A-Lord)-> Z si celibataire A-Wife
;RGETSOLD([A]REGION)-> HL-soldats.
;RPUTSOLD([A]REGION,[HL]SOLDATS)
;RGETCHEV([A]REGION)-> HL-Chevaliers
;RPUTCHEV([A]REGION,[HL]CHEVALIERS)
;RGETCATA([A]REGION)-> HL-catapultes
;RPUTCATA([A]REGION,[HL]CATAPULTES)
;RGETPROP([A]REGION)-> A-Lord
;RGETBUIL([A]REGION)-> A-Building (0=rien,1=Scastle,2=Ncastle,3=garnison)
;RGETVASS([A]REGION)-> A-Vassaux
;LGETINC([A]LORD)-> HL-Incom
;LGETARM([A]LORD)-> HL-effectif
;ENCAISSE(A-Lord,HL-Montant)
;PAYE(A-Lord,HL-Montant)-> C si bien paye
;TST_MONY(A-Lord,HL-Montant)-> C si assez d'argent
;PAYE_PC(A-Lord,B-Pour_256,HL-Min)-> C si paye et HL-montant paye.
;RETIRE(B-Lord,C-Beneficiaire)
;GOHOME(A-Lord)
;GO(A-Lord,C-Region)
;KADO(B-Lord,C-Region)
;LINCHATE(A-Lord)
;CHEMIN(A-Lord,B-Region1,C-Region2)-> C si accessible, A=distance, B=Next reg
;R_DIST(A-Lord,B-Region1,C-Region2)-> C si accessible, A=distance
;LPOWER(A-Lord)->HL-Army power
;RPOWER(A-Reg)->HL-Reg defensive power
;-------------------------------------------------------------------------------
;B_Fonctions affichant sur la carte
;RAMENE(A-Reg)
;RAPATRIE(A-Lord)
;REG_REG()
;REG_FAC()
;REG_DAT()
;MONEYIN([A]LORD)
;DEPOUIL([C]LORD1,[B]LORD2)
;DONNE([C]REGION,[B]LORD)
;DEPLACE([A]LORD,[C]REGION)
;AFFINC()
;AFFGOLD()
;AFFARM()
;AFFDATE()
;GETLEV([A]VALUE)->HL-String
;AFFFACE([A]LORD)
;AFFWIFE()
;AFFLORD()
;AFFLAND()
;AFFLEA()
;AFFJOU()
;AFFSWO()
;-------------------------------------------------------------------------------
;C_Tests sur les donnees du jeu
;LORDHERE(A-Region)
;LORDNEAR(A-Region)
;ISDEAD(A-Lord)-> Z
;ISNORM(A-Lord)-> Z
;ISJOUEUR(A-Lord)-> Z
;BELONG(B-Lord,C-Region)-> Z
;LANDFREE(A-Lord)-> C A=Region (La preferee du Lord)
;ADJACENT([B]REGION1,[C]REGION2)-> C
;-------------------------------------------------------------------------------
;D_Fonctions de dialogue
;PLACARD([HL]TEXT,[A]DUREE)
;CHOIREG()
;-------------------------------------------------------------------------------
;E_Fonctions de deroulement du programme
;CHOOSE()
;SETVAR()
;AFFMAP()
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;A_Fonctions de manipulation de donnees du jeu
;-------------------------------------------------------------------------------
;
;KILL([A]LORD)
;   Supprime un Lord de la partie.
KILL
         PUSH IY
         CALL GETLORD
         LD   (IY+00),0
         POP  IY
         RET
;
;GETREG([A]REGION)-> IX-Buffer de donnees.
;   Fait pointer IX sur les donnees de la region.
GETREG
; 35 (1->13) 1160
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

; 28 -> 172

;         PUSH AF
;         PUSH DE
;         LD   IX,REGIONS-16
;         LD   DE,16
;GETREG0  ADD  IX,DE
;         DEC  A
;         JR   NZ,GETREG0
;         POP  DE
;         POP  AF
         RET
;
;GETLORD([A]LORD)-> IY-Buffer de donnees.
;   Fait pointer IY sur les donnees du Lord.
; 23
GETLORD
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

; 28 -> 92

;         PUSH AF
;         PUSH DE
;         LD   IY,LORDS-16
;         LD   DE,16
;GETLOR0  ADD  IY,DE
;         DEC  A
;         JR   NZ,GETLOR0
;         POP  DE
;         POP  AF
         RET
;
;LGETHOME([A]LORD)-> A-Region.
;   Renvoie la region domicile du Lord.
LGETHOME
         PUSH IY
         CALL GETLORD
         LD   A,(IY+06)
         PUSH HL
         PUSH DE
         LD   DE,4
         LD   HL,CHATO+1
         CALL RDTAB
         LD   A,(HL)
         POP  DE
         POP  HL
         POP  IY
         RET
;
;LGETPREF(A-Lord)-> HL-Table de preferences
;
LGETPREF
         PUSH IY
         PUSH AF
         PUSH DE
         CALL GETLORD
         LD   A,(IY+06)
         LD   DE,4
         LD   HL,CHATO+2
         CALL RDTAB
         LD   A,(HL)
         INC  HL
         LD   H,(HL)
         LD   L,A
         POP  DE
         POP  AF
         POP  IY
         RET
;
;LGETYPE([A]LORD)-> A-Type (0=out,1=Saxon,2=Normand,3=Joueur)
;   Renvoie le type du Lord.
LGETYPE
         PUSH IY
         CALL GETLORD
         LD   A,(IY+00)
         POP  IY
         RET
;
;LGETREG([A]LORD)-> A-Region.
;   Renvoie la region courante du Lord.
LGETREG
         PUSH IY
         CALL GETLORD
         LD   A,(IY+07)
         POP  IY
         RET
;
;LGETHATE([A]LORD)-> A-Hate
;   Renvoie la haine du Lord.
LGETHATE
         PUSH IY
         CALL GETLORD
         LD   A,(IY+04)
         POP  IY
         RET
;
;LGETSOLD([A]LORD)-> HL-Soldats
;   Renvoie le nombre de soldats de l'armee du Lord.
LGETSOLD
         PUSH IY
         CALL GETLORD
         LD   L,(IY+08)
         LD   H,(IY+09)
         POP  IY
         RET
;
;LPUTSOLD([A]LORD,[HL]SOLDATS)
;   Change les soldats de l'armee du Lord.
LPUTSOLD
         PUSH IY
         CALL GETLORD
         LD   (IY+08),L
         LD   (IY+09),H
         POP  IY
         RET
;
;LGETCHEV([A]LORD)-> HL-Chevaliers.
;   Renvoie le nombre de chevaliers de l'armee du Lord.
LGETCHEV
         PUSH IY
         CALL GETLORD
         LD   L,(IY+10)
         LD   H,(IY+11)
         POP  IY
         RET
;
;LPUTCHEV([A]LORD,[HL]CHEVALIERS)
;   Change le nombre de chevaliers de l'armee du Lord.
LPUTCHEV
         PUSH IY
         CALL GETLORD
         LD   (IY+10),L
         LD   (IY+11),H
         POP  IY
         RET
;
;LGETCATA([A]LORD)-> HL-Catapultes.
;   Renvoie le nombre de catapultes de l'armee du Lord.
LGETCATA
         PUSH IY
         CALL GETLORD
         LD   L,(IY+12)
         LD   H,(IY+13)
         POP  IY
         RET
;
;LPUTCATA([A]LORD,[HL]CATAPULTES)
;   Change le nombre de catapultes de l'armee du Lord.
LPUTCATA
         PUSH IY
         CALL GETLORD
         LD   (IY+12),L
         LD   (IY+13),H
         POP  IY
         RET
;
;LGETGOLD([A]LORD)-> HL-Pieces d'or.
;   Renvoie le montant du tresor du Lord.
LGETGOLD
         PUSH IY
         CALL GETLORD
         LD   L,(IY+14)
         LD   H,(IY+15)
         POP  IY
         RET
;
;LPUTGOLD([A]LORD,[HL]GOLD)
;   Change le montant du tresor du Lord.
LPUTGOLD
         PUSH IY
         CALL GETLORD
         LD   (IY+14),L
         LD   (IY+15),H
         POP  IY
         RET
;
;LGETWIFE(A-Lord)-> Z si celibataire A-Wife
;   Renvoie la Lady du Lord.
LGETWIFE
         PUSH IY
         CALL GETLORD
         LD   A,(IY+05)
         RLCA
         RLCA
         AND  #03
         POP  IY
         RET
;
;RGETSOLD([A]REGION)-> HL-soldats.
;   Renvoie le nombre de soldats dans la region.
RGETSOLD
         PUSH IX
         CALL GETREG
         LD   L,(IX+01)
         LD   H,(IX+02)
         POP  IX
         RET
;
;RPUTSOLD([A]REGION,[HL]SOLDATS)
;   Change le nombre de soldats dans la region.
RPUTSOLD
         PUSH IX
         CALL GETREG
         LD   (IX+01),L
         LD   (IX+02),H
         POP  IX
         RET
;
;RGETCHEV([A]REGION)-> HL-Chevaliers
;   Renvoie le nombre de chevaliers dans la region.
RGETCHEV
         PUSH IX
         CALL GETREG
         LD   L,(IX+03)
         LD   H,(IX+04)
         POP  IX
         RET
;
;RPUTCHEV([A]REGION,[HL]CHEVALIERS)
;   Change le nombre de chevaliers dans la region.
RPUTCHEV
         PUSH IX
         CALL GETREG
         LD   (IX+03),L
         LD   (IX+04),H
         POP  IX
         RET
;
;RGETCATA([A]REGION)-> HL-catapultes
;   Renvoie le nombre de catapultes dans la region.
RGETCATA
         PUSH IX
         CALL GETREG
         LD   L,(IX+05)
         LD   H,(IX+06)
         POP  IX
         RET
;
;RPUTCATA([A]REGION,[HL]CATAPULTES)
;   Change le nombre de catapultes dans la region.
RPUTCATA
         PUSH IX
         CALL GETREG
         LD   (IX+05),L
         LD   (IX+06),H
         POP  IX
         RET
;
;RGETPROP([A]REGION)-> A-Lord
;   Renvoie le proprietaire de la region.
RGETPROP
         PUSH IX
         CALL GETREG
         LD   A,(IX+07)
         POP  IX
         RET
;
;RGETBUIL([A]REGION)-> A-Building (0=rien,1=Scastle,2=Ncastle,3=garnison)
;   Renvoie la construction presente sur la region.
RGETBUIL
         PUSH IX
         CALL GETREG
         LD   A,(IX+00)
         POP  IX
         RET
;
;LGETINC([A]LORD)-> HL-Incom
;   Renvoie le revenu global du Lord.
LGETINC
         PUSH BC
         PUSH DE
         PUSH IX
         LD   C,A
         LD   B,NB_REGIONS
         LD   HL,0
         LD   D,h
LGETINC0 LD   A,B
         CALL GETREG
         LD   A,C
         CP   (IX+07)
         JR   NZ,LGETINC1
         LD   E,(IX+08)
         ADD  HL,DE
LGETINC1 DJNZ LGETINC0
         POP  IX
         POP  DE
         POP  BC
         RET
;
;LGETARM([A]LORD)-> HL-effectif
;   Renvoie l'armee totale du Lord (soldats+chevaliers armee et regions)
LGETARM
         PUSH BC
         PUSH DE
         PUSH IX
         PUSH IY
         LD   C,A
         LD   B,NB_REGIONS
         LD   HL,0
LGETARM0 LD   A,B
         CALL RGETPROP
         CP   C
         JR   NZ,LGETARM1
         LD   A,B
         EX   DE,HL
         CALL RGETSOLD
         ADD  HL,DE
         EX   DE,HL
         CALL RGETCHEV
         ADD  HL,DE
LGETARM1 DJNZ LGETARM0
         LD   A,C
         EX   DE,HL
         CALL LGETSOLD
         ADD  HL,DE
         EX   DE,HL
         CALL LGETCHEV
         ADD  HL,DE
         POP  IY
         POP  IX
         POP  DE
         POP  BC
         RET
;
;ENCAISSE(A-Lord,HL-Montant)
;   Encaisse un montant.
ENCAISSE
         PUSH DE
         PUSH HL
         EX   DE,HL
         CALL LGETGOLD
         ADD  HL,DE
         CALL LPUTGOLD
         POP  HL
         POP  DE
         RET
;
;PAYE(A-Lord,HL-Montant)-> C si bien paye
;   Paye un montant fixe
PAYE
         PUSH DE
         PUSH HL
         EX   DE,HL
         CALL LGETGOLD
         OR   A
         SBC  HL,DE
         JR   C,PAYE0
         CALL LPUTGOLD
         OR   A
PAYE0    CCF
         POP  HL
         POP  DE
         RET
;
;TST_MONY(A-Lord,HL-Montant)-> C si assez d'argent
;   Verifie que Lord peut payer
TST_MONY
         PUSH HL
         PUSH DE
         EX   DE,HL
         CALL LGETGOLD
         OR   A
         SBC  HL,DE
         CCF
         POP  DE
         POP  HL
         RET
;
;PAYE_PC(A-Lord,B-Pour_256,HL-Min)-> C si paye et HL-montant paye.
;   Paye un pourcentage du tresor
PAYE_PC
         CALL TST_MONY
         RET  NC
         PUSH DE
         CALL LGETGOLD
         PUSH HL
         CALL DIMINUE
         CALL LPUTGOLD
         POP  DE
         EX   DE,HL
         OR   A
         SBC  HL,DE
         POP  DE
         SCF
         RET
;
;RETIRE(B-Lord,C-Beneficiaire)
;   Le Lord donne toutes ses regions au beneficiaire
;
RETIRE
         PUSH AF
         PUSH BC
         PUSH DE
         LD   E,C
         LD   D,B
         LD   C,NB_REGIONS
RETIRE0  LD   B,D
         CALL BELONG
         LD   B,E
         CALL Z,KADO
         DEC  C
         JR   NZ,RETIRE0
         POP  DE
         POP  BC
         POP  AF
         RET
;
;GOHOME(A-Lord)
;   Renvoie le lord chez lui
GOHOME
         PUSH AF
         PUSH BC
         LD   B,A
         CALL LGETHOME
         LD   C,A
         LD   A,B
         CALL GO
         POP  BC
         POP  AF
         RET
;
;GO(A-Lord,C-Region)
;   Deplace le Lord
GO
         PUSH IY
         CALL GETLORD
         LD   (IY+07),C
         POP  IY
         RET
;
;KADO(B-Lord,C-Region)
;   Donne la region au lord.
KADO
         PUSH AF
         PUSH IX
         PUSH BC
         LD   A,C
         CALL RGETPROP
         LD   B,A
         CALL LGETREG
         CP   C
         LD   A,B
         CALL Z,GOHOME
         POP  BC
         LD   A,C
         CALL GETREG
         LD   (IX+07),B
         POP  IX
         POP  AF
         RET
;
;LINCHATE(A-Lord)
;   Incremente le hate for you d'un Lord
LINCHATE
         PUSH IY
         PUSH AF
         CALL GETLORD
         LD   A,(IY+04)
         CP   10
         JR   Z,NOHINC
         INC  (IY+04)
NOHINC   POP  AF
         POP  IY
         RET
;
;CHEMIN(A-Lord,B-Region1,C-Region2)-> C si accessible, B=Next reg
;   Cherche un chemin pour deplacer le Lord vers la region.
CHTABLE  EQU  TAMPON		;NB_REGIONS
DIST     EQU  CHTABLE+NB_REGIONS;1
MINDIST  EQU  DIST+1		;1
FIR_REG  DEFS 1
DIR      DEFS 1
;
CHEMIN
         PUSH HL
         PUSH DE
         PUSH BC
         LD   E,B
         LD   B,NB_REGIONS+1
         LD   HL,CHTABLE
CHEMIN0  LD   (HL),0
         INC  HL
         DJNZ CHEMIN0
         LD   (HL),#FF
         CALL RECURS
         POP  BC
         LD   A,(DIR)
         LD   B,A
         LD   A,(MINDIST)
         CP   #FF
         POP  DE
         POP  HL
         RET
RECURS
         LD   D,0
         LD   HL,CHTABLE+NB_REGIONS
         OR   A
         SBC  HL,DE
         INC  (HL)
         LD   HL,DIST
         INC  (HL)
         LD   D,A
         LD   B,NB_REGIONS
         LD   HL,CHTABLE
RECURS0  LD   A,(DIST)
         CP   1
         JR   NZ,PASFIR
         LD   A,B
         LD   (FIR_REG),A
PASFIR   LD   A,(HL)
         OR   A
         JR   NZ,RECURS2
         PUSH BC
         LD   C,E
         CALL ADJACENT
         POP  BC
         JR   NC,RECURS2
         LD   A,C
         CP   B
         JR   NZ,RECURS1
         PUSH HL
         LD   HL,MINDIST
         LD   A,(DIST)
         CP   (HL)
         POP  HL
         JR   NC,RECURS2
         LD   (MINDIST),A
         LD   A,(FIR_REG)
         LD   (DIR),A
         JR   RECURS2
RECURS1  LD   A,B
         CALL RGETPROP
         CP   D
         JR   NZ,RECURS2
         PUSH HL
         PUSH BC
         PUSH DE
         LD   A,D
         LD   E,B
         CALL RECURS
         POP  DE
         POP  BC
         POP  HL
RECURS2  INC  HL
         DJNZ RECURS0
         LD   D,0
         LD   HL,CHTABLE+NB_REGIONS
         OR   A
         SBC  HL,DE
         DEC  (HL)
         LD   HL,DIST
         DEC  (HL)
         RET
;
;R_DIST(A-Lord,B-Region1,C-Region2)-> C si accessible, A=distance
;   Calcule la distance entre deux region pour un lord.
CH_MASK  DEFS 3
CH_COUR  DEFS 3
CH_TEMP  DEFS 3
CH_DIST  DEFS 1
;
R_DIST
         PUSH HL
         PUSH DE
         PUSH BC
         PUSH IX
         PUSH IY
         CALL INITMASK
         LD   A,B
         CALL GETLIGNE
         LD   A,1
R_DIST0  LD   (CH_DIST),A
         CALL TSTFOUND
         JR   C,R_DISTR
         CALL ANDLIGNE
         JR   Z,R_DISTR
         CALL CALCMASK
         CALL CALCTEMP
         CALL NEWCOUR
         LD   A,(CH_DIST)
         INC  A
         JR   R_DIST0
R_DISTR  LD   A,(CH_DIST)
         POP  IY
         POP  IX
         POP  BC
         POP  DE
         POP  HL
         RET
CALCTEMP
         PUSH BC
         LD   HL,CH_TEMP
         LD   (HL),0
         INC  HL
         LD   (HL),0
         INC  HL
         LD   (HL),0
         LD   IX,CH_COUR+2
         LD   HL,ADJATAB
         LD   B,1
         SCF
CALCTEM0 RR   (IX+00)
         JR   NZ,CALCTEM1
         DEC  IX
         SCF
         JR   CALCTEM0
CALCTEM1 JR   NC,CALCTEM2
         PUSH HL
         LD   DE,CH_TEMP
         LD   A,(DE)
         OR   (HL)
         LD   (DE),A
         INC  DE
         INC  HL
         LD   A,(DE)
         OR   (HL)
         LD   (DE),A
         INC  DE
         INC  HL
         LD   A,(DE)
         OR   (HL)
         LD   (DE),A
         POP  HL
CALCTEM2 LD   DE,3
         ADD  HL,DE
         INC  B
         BIT  4,B
         JR   Z,CALCTEM0
         BIT  1,B
         JR   Z,CALCTEM0
         POP  BC
         RET
NEWCOUR
         PUSH BC
         LD   BC,3
         LD   HL,CH_TEMP
         LD   DE,CH_COUR
         LDIR
         POP  BC
         RET
CALCMASK
         PUSH BC
         LD   B,3
         LD   HL,CH_MASK
         LD   DE,CH_COUR
CALCMA0  LD   A,(DE)
         CPL
         AND  (HL)
         LD   (HL),A
         INC  HL
         INC  DE
         DJNZ CALCMA0
         POP  BC
         RET
TSTFOUND
         PUSH BC
         LD   HL,CH_COUR
         DEC  C
         BIT  4,C
         JR   NZ,TSTFOU0
         INC  HL
         BIT  3,C
         JR   NZ,TSTFOU0
         INC  HL
TSTFOU0  LD   A,C
         AND  #07
         RLA
         RLA
         RLA
         OR   #46            ;BIT 0,(HL)
         LD   (TSTFOU1+1),A
TSTFOU1  BIT  0,(HL)
         SCF
         POP  BC
         RET  NZ
         OR   A
         RET
GETLIGNE
         PUSH BC
         LD   HL,ADJATAB-3
         LD   E,A
         LD   D,0
         ADD  HL,DE
         ADD  HL,DE
         ADD  HL,DE
         LD   DE,CH_COUR
         LD   BC,3
         LDIR
         POP  BC
         RET
ANDLIGNE
         PUSH BC
         LD   DE,CH_MASK
         LD   HL,CH_COUR
         LD   BC,#0300
ANDLIG0  LD   A,(DE)
         AND  (HL)
         LD   (HL),A
         OR   C
         LD   C,A
         INC  HL
         INC  DE
         DJNZ ANDLIG0
         POP  BC
         RET
INITMASK
         PUSH BC
         LD   IX,CH_MASK+2
         LD   HL,REGIONS+7
         LD   DE,16
         LD   B,1
         LD   C,#80
INITMAS0 CP   (HL)
         SCF
         JR   Z,INITMAS1
         CCF
INITMAS1 RR   C
         JR   NC,INITMAS2
         LD   (IX+00),C
         LD   C,#80
         DEC  IX
INITMAS2 ADD  HL,DE
         INC  B
         BIT  4,B
         JR   Z,INITMAS0
         BIT  1,B
         JR   Z,INITMAS0
         LD   (IX+00),C
         POP  BC
         RET
;
;TRANSFER(A-Reg)
;   Transfere l'armee du proprietaire dans la garnison
TRANSFER
         PUSH BC
         PUSH HL
         PUSH DE
         LD   C,A
         CALL RGETPROP
         LD   B,A
         CALL LGETSOLD
         EX   DE,HL
         LD   A,C
         CALL RGETSOLD
         ADD  HL,DE
         CALL RPUTSOLD
         LD   A,B
         CALL LGETCHEV
         EX   DE,HL
         LD   A,C
         CALL RGETCHEV
         ADD  HL,DE
         CALL RPUTCHEV
         LD   A,B
         CALL LGETCATA
         EX   DE,HL
         LD   A,C
         CALL RGETCATA
         ADD  HL,DE
         CALL RPUTCATA
         LD   A,B
         LD   HL,0
         CALL LPUTSOLD
         CALL LPUTCHEV
         CALL LPUTCATA
         POP  DE
         POP  HL
         POP  BC
         RET
;
;LPOWER(A-Lord)->HL-Army power
;
LPOWER
         PUSH BC
         PUSH DE
         CALL LGETSOLD
         EX   DE,HL
         CALL LGETCHEV
         LD   B,5
         CALL MULT
         ADD  HL,DE
         POP  DE
         POP  BC
         RET
;
;RPOWER(A-Region)->HL-defensive power
;
RPOWER
         PUSH BC
         PUSH DE
         PUSH AF
         LD   C,A
         CALL RGETSOLD
         EX   DE,HL
         CALL RGETCHEV
         LD   B,5
         CALL MULT
         ADD  HL,DE
         LD   A,C
         CALL RGETBUIL
         OR   A
         JR   Z,RPOWER0
         LD   A,C
         CALL LORDNEAR
         JR   NC,RPOWER0
         LD   A,C
         EX   DE,HL
         CALL RGETPROP
         CALL LPOWER
         ADD  HL,DE
RPOWER0  INC  HL
         INC  HL
         POP  AF
         POP  DE
         POP  BC
         RET


;-------------------------------------------------------------------------------
;B_Fonctions affichant sur la carte
;-------------------------------------------------------------------------------
;
;DEPLACE([A]LORD,[C]REGION)
;   Le Lord va dans la region.
DEPLACE
         PUSH BC
         PUSH AF
         CALL LGETREG
         LD   B,A
         POP  AF
         CALL GO
         CALL ISJOUEUR
         JR   NZ,DEPLACE0
         LD   A,B
         CALL AFFREG
         LD   A,C
         CALL AFFREG
         CALL AFFLAND
DEPLACE0 POP  BC
         RET
;
;DONNE([C]REGION,[B]LORD)
;   Le Lord recoit la region.
DONNE
         CALL KADO
         LD   A,C
         CALL AFFREG
         LD   A,B
         CALL ISJOUEUR
         RET  NZ
         CALL AFFINC
         JP   AFFARM
;
;RAMENE(A-Reg)
;   Ramene le proprietaire dans la region
RAMENE
         PUSH BC
         LD   C,A
         CALL RGETPROP
         CALL DEPLACE
         POP  BC
         RET
;
;RAPATRIE(A-Lord)
;   Effectue un GOHOME avec rafraichissement de la carte
RAPATRIE
         CALL LGETHOME
         JP   RAMENE
;
;DEPOUIL(B-Lord,C-Beneficiaire)
;   Toutes les regions du Lord1 vont au Lord2.
DEPOUIL
         PUSH AF
         PUSH BC
         PUSH DE
         LD   E,C
         LD   D,B
         LD   C,NB_REGIONS
DEPOUIL0 LD   B,D
         CALL BELONG
         LD   B,E
         CALL Z,DONNE
         DEC  C
         JR   NZ,DEPOUIL0
         POP  DE
         POP  BC
         POP  AF
         RET
;
;MONEYIN([A]LORD)
;   Le Lord recoit ses revenus mensuels
MONEYIN
         PUSH HL
         CALL LGETINC
         CALL ENCAISSE
         POP  HL
         JP   AFFGOLD
;
;AFFINC()
;   Affiche les revenus du joueur (MAP ON)
AFFINC
	TXT_LOCATE 05,12
         LD   A,(LORD)
         CALL LGETINC
         CALL AFFD16
         RET
;
;AFFGOLD()
;   Affiche le tresor du joueur (MAP ON)
AFFGOLD
	TXT_LOCATE 05,14
         LD   A,(LORD)
         CALL GETLORD
         LD   L,(IY+14)
         LD   H,(IY+15)
         CALL AFFD16
         RET
;
;AFFARM()
;   Affiche l'armee du joueur (MAP ON)
AFFARM
	TXT_LOCATE 05,16
         LD   A,(LORD)
         CALL LGETARM
         CALL AFFD16
         RET
;
;AFFDATE()
;   Affiche la date courante (MAP ON)
AFFDATE
	TXT_LOCATE 30,23
         LD   A,(COUR_MOI)
         LD   HL,MOIS
         CALL GETSTR
         CALL AFFMEBIS
         LD   HL,(COUR_AN)
         CALL AFFD16
         LD   A," "
         JP TXT_OUTPUT

;
;AFFFACE([A]LORD)
;   Affichage du visage du Lord (MAP ON)
AFFFACE
         ADD  A,24
         LD   H,52
         LD   L,191
         LD   B,13
	jp AFFSPRC
;
;AFFWIFE()
;   Affichage du visage de la Lady du joueur(MAP ON)
AFFWIFE
         LD   A,(LORD)
         CALL GETLORD
         LD   A,(IY+5)
         RLCA
         RLCA
         AND  #03
         RET  Z
         ADD  A,33
         LD   H,132
         LD   L,191
	jp AFFSPR
;
;AFFLORD()
;   Affichage du nom du joueur(MAP ON)
AFFLORD
	TXT_LOCATE 03,02
         LD   HL,PRENOMS
         LD   A,(LORD)
         CALL GETSTR
	jp AFFMEBIS
;
;AFFLAND()
;   Affichage de la region ou est le joueur(MAP ON)
AFFLAND
	TXT_LOCATE 01, 04
	ld hl,AFFLAND_CLEAR_TEXT
	CALL AFFMEBIS
	TXT_LOCATE 01, 04
         LD   A,(LORD)
         CALL GETLORD
         LD   A,(IY+07)
         PUSH AF
	call GETRNAME
         LD   A,12
         CALL CENTRE
         CALL AFFMEBIS
	TXT_LOCATE 08, 03
         POP  AF
         LD   HL,LANDS_PREPOSI_IDX-2
         CALL GETSTRIDX
	jp AFFMEBIS

AFFLAND_CLEAR_TEXT DEFB "            ",&ff

;
;AFFLEA()
;   Affichage du leadership du joueur (MAP ON)
AFFLEA
	TXT_LOCATE 04, 06
         LD   A,(LORD)
         CALL GETLORD
         LD   A,(IY+01)
         CALL GETLEV
	jp AFFMEBIS
;
;AFFJOU()
;   Affichage du jousting du joueur (MAP ON)
AFFJOU
	TXT_LOCATE 04, 08
         LD   A,(LORD)
         CALL GETLORD
         LD   A,(IY+03)
         CALL GETLEV
	jp AFFMEBIS
;
;AFFSWO()
;   Affichage du sword du joueur (MAP ON)
AFFSWO
        TXT_LOCATE 04, 10
         LD   A,(LORD)
         CALL GETLORD
         LD   A,(IY+02)
         CALL GETLEV
	jp AFFMEBIS
;-------------------------------------------------------------------------------
;C_Tests sur les donnees du jeu
;-------------------------------------------------------------------------------
;
;LORDHERE(A-Region)
;   Renvoie Z si proprietaire present
LORDHERE
         PUSH BC
         LD   C,A
         CALL RGETPROP
         CALL LGETREG
         CP   C
         POP  BC
         RET
;
;LORDNEAR(A-Region)
;   Renvoie C si proprietaire a cote
LORDNEAR
         PUSH BC
         LD   C,A
         CALL RGETPROP
         CALL LGETREG
         LD   B,A
         CALL ADJACENT
         POP  BC
         RET
;
;ISDEAD(A-Lord)-> Z
;   Renvoie Z si lord dead.
ISDEAD
         CALL LGETYPE
         OR   A
         RET
;
;ISNORM(A-Lord)-> Z
;   Renvoie Z si Lord normand.
ISNORM
         CALL LGETYPE
         CP   2
         RET
;
;ISJOUEUR(A-Lord)-> Z
;   Renvoie Z si Lord joueur.
ISJOUEUR
         CALL LGETYPE
         CP   3
         RET
;
;BELONG(B-Lord,C-Region)-> Z
;   Teste si la region appartient au lord.
BELONG
         LD   A,C
         CALL RGETPROP
         CP   B
         RET
;
;LANDFREE(A-Lord)-> C A=Region (La preferee du Lord)
;   Renvoie C si Lord possede un terrain negociable.
LANDFREE
         PUSH BC
         PUSH HL
         LD   B,A
         CALL LGETPREF
LANDFR0  LD   C,(HL)
         CALL BELONG
         JR   NZ,LANDFR1
         LD   A,C
         CALL RGETBUIL
         OR   A
         JR   NZ,LANDFR1
         LD   A,C
         SCF
         JR   LANDFR2
LANDFR1  INC  HL
         LD   A,(HL)
         OR   A
         JR   NZ,LANDFR0
LANDFR2  POP  HL
         POP  BC
         RET
;
;ADJACENT([B]REGION1,[C]REGION2)-> C
;   Renvoit Carry si les deux regions sont adjacentes.
ADJACENT
         PUSH HL
         PUSH BC
         LD   HL,ADJATAB-1
         LD   A,B
         LD   B,0
         ADD  HL,BC
         ADD  HL,BC
         ADD  HL,BC
         DEC  A
         LD   B,A
         AND  #07
         RLA
         RLA
         RLA
         OR   #46            ;BIT 0,(HL)
         LD   (ADJABIT+1),A
         BIT  4,B
         JR   Z,ADJA0
         DEC  HL
         DEC  HL
         JR   ADJABIT
ADJA0    BIT  3,B
         JR   Z,ADJABIT
         DEC  HL
ADJABIT  BIT  0,(HL)
         POP  BC
         POP  HL
         SCF
         RET  NZ
         OR   A
         RET
;-------------------------------------------------------------------------------
;D_Fonctions de dialogue
;-------------------------------------------------------------------------------
;
;PLACARD([HL]TEXT,[A]DUREE)
;   Affiche le texte HL(cf. TXT.ASM pour les codes de controle) et le laisse
;   pendant A secondes (cf. PAUSE()).
;   ***ATTENTION*** ne peut etre entree par JP que si pas de parametres.
PLACARD
         LD   (PLACBUF_DE),DE
         LD   (PLACBUF_A),A
         POP  DE
         LD   (PLACBUF_SAVEDE),DE
         CALL MENUTEXT
PLACBUF_SAVEDE equ $ +1
         LD   DE,0
         PUSH DE
PLACBUF_DE equ $ +1
         LD   DE,0
PLACBUF_A equ $ +1
         LD   A,0
         CALL WAIT_PAUSE
         CALL MENUREST
         LD   A,1
	jp WAIT_PAUSE
;
;CHOIREG()
;   Choix d'une region.
CHOIXREG
         PUSH HL
         CALL EFLECHE
         LD   HL,SELECTR
         CALL MENUTEXT
         CALL AFLECHE
CHOIXRE0 CALL MFLECHE
         JR   NC,CHOIXRE0
         CALL EFLECHE
         CALL WHATREG
         CALL MENUREST
         POP  HL
         RET
;
;GETLEV([A]VALUE)->HL-String
;   Renvoie le niveau (Faible,Moyen,Bon,Fort) d'une apitude.
GETLEV
         DEC  A
         SRL  A
         JR   NZ,GETLEV0
         INC  A
GETLEV0  LD   HL,LEVEL
         JP   GETSTR
;
;GETLNAME(A-Personne)-> HL-string
;   Renvoie le nom d'un personnage
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
;   Renvoie le nom d'une region
GETRNAME
	ld hl,LANDS_IDX-2
	jr GETSTRIDX
;-------------------------------------------------------------------------------
;E_Fonctions de deroulement du programme
;-------------------------------------------------------------------------------
;
;CHOOSE()
;   Selection du personnage en debut de partie
CHOOSE
         CALL OFF
         LD   HL,NAMES
	call load_decomp_scr
	call SETPAL
         CALL AFLECHE
         SCF
CHOOSE0  CALL MFLECHE
         JR   NC,CHOOSE0
         CALL EFLECHE
         CALL GFLECH1
         LD   C,1
         LD   A,H
         CP   80
         JR   C,CHOOSE1
         INC  C
CHOOSE1  LD   A,L
         CP   100
         JR   NC,CHOOSE2
         INC  C
         INC  C
CHOOSE2  LD   A,C
         LD   (LORD),A
	call GETLNAME
         PUSH HL
         LD   HL,WELCOME
         LD   A,4
         CALL PLACARD
         RET
;
;SETVAR()
;   Initialisation des donnees du jeu.
SETVAR
         PUSH IX
         PUSH IY
         PUSH BC
         PUSH DE
         LD   A,(LORD)
         LD   C,A
         CALL GETLORD
         LD   (IY+00),3
         LD   (IY+05),#00
         LD   A,3
         CALL RND
         LD   (IY+06),A
         LD   D,A
         LD   A,C
         CALL LGETHOME
         LD   (IY+07),A
         CALL GETREG
         LD   (IX+07),C
         LD   (IX+00),1
         LD   A,(IX+08)
         LD   (IX+01),A
         LD   E,0
         LD   B,2
SETVAR1  INC  E
         LD   A,E
         CP   D
         JR   Z,SETVAR1
SETVAR2  LD   A,4
         CALL RND
         LD   C,A
         CALL GETLORD
         LD   A,(IY+06)
         OR   A
         JR   NZ,SETVAR2
         LD   (IY+05),B
         RRC  (IY+05)
         RRC  (IY+05)
         LD   (IY+06),E
         LD   (IY+00),1
         LD   A,C
         CALL LGETHOME
         LD   (IY+07),A
         CALL GETREG
         LD   (IX+07),C
         LD   (IX+00),1
         LD   A,(IX+08)
         LD   (IX+01),A
         DJNZ SETVAR1
         LD   B,3
SETVAR3  LD   A,5
         CALL RND
         ADD  A,4
         LD   C,A
         CALL GETLORD
         LD   A,(IY+06)
         OR   A
         JR   NZ,SETVAR3
         LD   (IY+00),2
         LD   A,B
         ADD  A,3
         LD   (IY+06),A
         LD   A,C
         CALL LGETHOME
         LD   (IY+07),A
         CALL GETREG
         LD   (IX+07),C
         LD   (IX+00),2
         LD   A,(IX+08)
         LD   (IX+01),A
         DJNZ SETVAR3
         LD   B,NB_REGIONS
SETVAR4  LD   A,B
         CALL GETREG
         LD   A,(IX+09)
         ADD  A,(IX+01)
         LD   (IX+01),A
         DJNZ SETVAR4
         POP  DE
         POP  BC
         POP  IY
         POP  IX
         RET
;
;AFFMAP()
;   Affichage complet de la carte.
;
AFFMAP
         PUSH AF
         PUSH HL
         LD   HL,TACTMAP
	call load_decomp_scr
         LD   HL,PROVINCE
         LD   DE,SPRBUF
         CALL READFILE
         PUSH DE
         LD   HL,FACES
         CALL READFILE
         POP  DE
         LD   (SAVEBUF),DE

         PUSH BC	; reaffiche les regions
         LD   B,NB_REGIONS
REGEN0   LD   A,B
         CALL AFFREG
         DJNZ REGEN0
         POP  BC

         LD   A,(LORD)	; reaffiche les visages
         CALL AFFFACE
         CALL AFFWIFE

         CALL AFFLORD	; reaffiche toutes les donnees
         CALL AFFLAND
         CALL AFFLEA
         CALL AFFJOU
         CALL AFFSWO
         CALL AFFINC
         CALL AFFGOLD
         CALL AFFARM
         CALL AFFDATE

         LD   HL,BUFIMA
         CALL SETPAL
         POP  HL
         POP  AF
         RET

