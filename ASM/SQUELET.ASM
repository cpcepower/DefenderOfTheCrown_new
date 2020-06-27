;
;
;SQUELET.ASM
;   Squelette du jeu
;*******************************************************************************
;
;Programme principal
;
MAIN
         LD   SP,#C000
         CALL INIT
MAIN0    CALL INIVAR
         CALL EXEINTRO
         CALL SETVAR
         CALL SETMAP
MAIN1    CALL UN_MOIS
         JR   NC,MAIN1
         LD   HL,MENURES
         CALL AIGUILLE
         JR   MAIN0

MENURES  DEFW EXEVICT
         DEFW EXELOST
         DEFW PNT_RET
;*******************************************************************************
;
;SETMAP
;   Affichage de la carte et chargement de EVENT et .SON
;
SETMAP
         PUSH AF
         PUSH HL
         PUSH BC
         PUSH DE
         LD   HL,EVENT
         LD   DE,BUFOVL
         CALL READFILE
         LD   HL,SONS
         LD   DE,MUSBUF
         CALL READFILE
         CALL AFFMAP
         POP  DE
         POP  BC
         POP  HL
         POP  AF
PNT_RET  RET
;
;UN_MOIS
;   Execution d'un tour de jeu
;   Renvoie CARRY en fin de partie
;   et A = 1,2,3 pour Gagne,Perdu,Abandon
;Modifies - AF
;
UN_MOIS
         LD   B,1
UN_MOIS0
         LD   A,B
         CALL ISDEAD
         CALL NZ,EVENMT
         CALL NZ,PLAY
         RET  C
         INC  B
         LD   A,10
         CP   B
         JR   NZ,UN_MOIS0
         CALL ACTVAR
         OR   A
         RET
;
;EXEINTRO
;   Introduction complete ou choix simple du Lord
;Modifies- AF
;
    IF _DEBUG
FL_DEB   DEFB 0
    ELSE
FL_DEB   DEFB 1
    ENDIF
;
EXEINTRO
         LD   A,(FL_DEB)
         OR   A
         JP   Z,CHOOSE
         DEC  A
         LD   (FL_DEB),A
         CALL RUNFILE
         DEFW INTRO
         RET
;
;EXEVICT
;   Lancement OVL VICTOIRE
;
EXEVICT
         CALL RUNFILE
         DEFW VICTOIRE
         RET
;
;EXELOST
;   Lancement OVL DEFAITE
;
EXELOST
         CALL RUNFILE
         DEFW DEFAITE
         RET
;********************************************************************************
;
;
;EVENMT
;   Creation de l'actualite
;
EVENMT
         PUSH AF
         PUSH BC
         LD   A,EVT_PROB
         CALL RND
         DEC  A
         CALL Z,BUFOVL
         POP  BC
         POP  AF
         RET
;
;PLAY
;   Tour de jeu d'un Lord
;   B- Numero du Lord
;   Renvoie CARRY si fin de partie et A- 1->Gagne 2->Perdu
;Modifies - AF
;
PLAY
         PUSH BC
         LD   A,B
         LD   (LORD1),A
         CALL MONEYIN
         LD   A,4
         LD   (DECOMPTE),A
         LD   A,B
         CALL LGETYPE
         LD   HL,PLAYWHO
         CALL AIGUILLE
         POP  BC
         RET
PLAYWHO
         DEFW PLAY_LO
         DEFW PLAY_LO
         DEFW PLAY_JO
;
;ACTVAR
;   Actualisation des variables en fin de mois
;
ACTVAR
         CALL ACTJOUT
         CALL ACTDATE
         jp AFFDATE

ACTDATE
         LD   HL,COUR_MOI
         INC  (HL)
         LD   A,(HL)
         CP   13
         RET  NZ
         LD   A,1
         LD   (HL),A
         INC  HL
         INC  (HL)
         RET

ACTJOUT
         LD   HL,LASTJOUT
         LD   A,(HL)
         OR   A
         RET  Z
         DEC  (HL)
         RET
;
;*******************************************************************************
;
;PLAY_LO
;   Tour de jeu d'un Lord
;   B- Numero du Lord
;   Renvoie CARRY si fin de partie et A- 1->Gagne 2->Perdu 3->Abandon
;
PLAY_LO
         CALL DEFENSIF       ;->DE armee a laisser dans HOME
         RET  NC
         CALL OBJECTIF       ;Recherche le meilleur objectif
         OR   A
         JR   Z,PLO_NOAT
         LD   C,A
         LD   A,(IY+03)
         LD   L,(IY+01)
         LD   H,(IY+02)
         PUSH BC
         CALL BUFOVL+6       ;Execute une attaque->Carry si joueur tue
         POP  BC
         INC  A
         JR   Z,PLO_NOAT
         LD   A,2
         RET
PLO_NOAT CALL TSTJOUTE
         JR   NC,PLO_NOJ
         LD   A,3
         LD   (LASTJOUT),A
         LD   A,B
         CALL RUNFILE
         DEFW JOUTE
         CALL SETMAP
         RET  NC
         LD   A,1
         LD   (OUTJOUT),A
         OR   A
         RET
PLO_NOJ  CALL LORDRAID
         OR   A
         RET
;
;
;PLAY_JO
;   Tour de jeu du joueur
;   Renvois CARRY si fin de partie et A- 1->Gagne 2->Perdu 3->Abandon
;Modifies - AF
;
PLAY_JO
         LD   A,0
         CALL BRUIT
PLAY_JO0
         LD   HL,MENU
         CALL MENUTEXT
         CALL MENUREST
         LD   HL,TMENU1
         JP   AIGUILLE
;
TMENU1   DEFW EXEJOUTE
         DEFW CONQUETE
         DEFW EXERAID
         DEFW ACHAT
         DEFW ABANDON
         DEFW SUITE
;
;-------------------------------------------------------------------------------
;
;DEFENSIF(B-Lord) -> Carry si achat effectue, DE=armee a laisser dans home
;
DEFENSIF
         PUSH BC
         LD   A,(LORD)
         CALL LGETREG
         LD   C,A
         LD   A,(LORD)
         CALL LGETCATA
         EX   DE,HL
         LD   A,C
         CALL RGETCATA
         ADD  HL,DE
         LD   A,H
         OR   L
         JR   Z,DEFENSIR
         PUSH BC
         LD   A,B
         CALL LGETHOME
         LD   B,A
         LD   A,(LORD)
         CALL R_DIST
         POP  BC
         JR   NC,DEFENSIR
         CP   5
         JR   NC,DEFENSIR
         LD   A,(LORD)
         CALL LPOWER
         EX   DE,HL
         LD   A,B
         CALL LGETHOME
         CALL RPOWER
         OR   A
         SBC  HL,DE
         JR   NC,DEFENSIR
         LD   A,B
         CALL LGETGOLD
         EX   DE,HL
         LD   HL,0
         CALL LPUTGOLD
         CALL LGETHOME
         CALL RGETSOLD
         ADD  HL,DE
         CALL RPUTSOLD
         SCF
DEFENSIR
         POP  BC
         CCF
         RET
;
;OBJECTIF(B-Lord) -> A=Region choisie
;   Calcule la table des objectifs
;
OBJECTIF
         PUSH DE
         LD   IX,OBJETAB
         LD   C,18
OBJECTI0
         CALL OBJTYPE
         LD   (IX+03),D
         INC  D
         JR   Z,OBJECTNO
         PUSH BC
         LD   A,B
         CALL LGETREG
         LD   E,A
         LD   A,B
         LD   B,E
         CALL R_DIST
         POP  BC
         JR   C,OBJECTI1
         LD   A,#FF
OBJECTI1 LD   (IX+00),A
         JR   NC,OBJECTNO
         PUSH BC
         CALL OBJCOUT
         POP  BC
         LD   (IX+01),L
         LD   (IX+02),H
         CALL OBJVALUE
         LD   (IX+04),A
OBJECTNO LD   DE,OBJESZ
         ADD  IX,DE
         DEC  C
         JR   NZ,OBJECTI0
         CALL OBJCHOIX
         POP  DE
         RET
OBJCOUT
         LD   A,C
         CALL RGETSOLD
         PUSH HL
         CALL RGETCHEV
         LD   B,5
         CALL MULT
         POP  DE
         ADD  HL,DE
         PUSH HL
         CALL RGETCATA
         LD   B,10
         CALL MULT
         POP  DE
         ADD  HL,DE
         CALL RGETPROP
         OR   A
         RET  Z
         LD   D,A
         CALL LGETREG
         CP   C
         JR   Z,OBJCLORD
         LD   A,C
         CALL RGETBUIL
         OR   A
         RET  Z
         PUSH BC
         LD   A,D
         CALL LGETREG
         LD   B,A
         CALL ADJACENT
         POP  BC
         RET  NC
OBJCLORD LD   A,D
         PUSH HL
         CALL LGETSOLD
         POP  DE
         ADD  HL,DE
         PUSH HL
         CALL LGETCHEV
         LD   B,5
         CALL MULT
         POP  DE
         ADD  HL,DE
         PUSH HL
         CALL LGETCATA
         LD   B,10
         CALL MULT
         POP  DE
         ADD  HL,DE
         RET
OBJTYPE
         LD   D,1
         LD   A,C
         CALL RGETPROP
         LD   E,A
         OR   A
         RET  Z
         INC  D
         LD   A,C
         CALL RGETBUIL
         OR   A
         JR   Z,OBJBUIL
         INC  D
         INC  D
OBJBUIL  LD   A,B
         CALL ISNORM
         LD   A,E
         JR   Z,NOTSAX
         CALL LGETYPE	; is saxon ?
         CP   1
         JR   NOTNOR
NOTSAX   CALL ISNORM
NOTNOR   JR   NZ,OBJNOTA
         LD   D,#FF
         RET
OBJNOTA  LD   A,E
         CALL ISJOUEUR
         RET  NZ
         INC  D
         RET
;
;Valeur = 2*classment+hate
;
OBJVALUE
         LD   A,B
         CALL LGETPREF
         LD   D,19
OBJVALU0 LD   A,(HL)
         INC  HL
         DEC  D
         CP   C
         JR   NZ,OBJVALU0
         LD   A,D
         ADD  A,D
         LD   D,A
         LD   A,C
         CALL RGETPROP
         CALL ISJOUEUR
         LD   A,D
         RET  Z
         LD   A,B
         CALL LGETHATE
         ADD  A,D
         RET

BESTREG  DEFS 1
OBJCHOIX
         XOR  A
         LD   (BESTREG),A
         LD   IX,OBJETAB
         LD   C,18
OBJCH0
         LD   A,(IX+03)
         INC  A
         JR   Z,OBJCH01
         LD   A,(IX+00)
         INC  A
         JR   Z,OBJCH01
         LD   A,(BESTREG)
         OR   A
         JR   Z,OBJCH02
         LD   A,(IY+03)
         CP   (IX+03)
         JR   C,OBJCH01
         JR   NZ,OBJCH02
         LD   A,(IY+04)
         CP   (IX+04)
         JR   C,OBJCH02
         JR   NZ,OBJCH01
         LD   L,(IY+01)
         LD   H,(IY+02)
         LD   E,(IX+01)
         LD   D,(IX+02)
         OR   A
         SBC  HL,DE
         JR   C,OBJCH01
         JR   NZ,OBJCH02
         LD   A,(IX+00)
         CP   (IY+00)
         JR   NC,OBJCH01
OBJCH02  LD   A,C
         LD   (BESTREG),A
         PUSH IX
         POP  IY
OBJCH01  LD   DE,OBJESZ
         ADD  IX,DE
         DEC  C
         JR   NZ,OBJCH0
         LD   A,(BESTREG)
         RET
;
;
TSTJOUTE
         LD   A,(LORD)
         CALL LANDFREE
         RET  NC
         LD   A,B
         CALL LANDFREE
         RET  NC
         LD   A,(OUTJOUT)
         OR   A
         RET  NZ
         LD   A,(LASTJOUT)
         OR   A
         RET  NZ
         LD   A,B
         LD   HL,5
	jp PAYE
;
LORDRAID
         LD   A,B
         CALL ISNORM
         RET  NZ
         LD   A,4
         CALL RND
         LD   C,A
         CALL ISDEAD
         RET  Z
         LD   A,C
         LD   HL,11
         CALL TST_MONY
         RET  NC
         CALL RAID_WON
         RET  NC
         LD   A,C
         CALL LGETWIFE
         JP   NZ,LORDRLAD
         PUSH BC
         LD   A,C
         LD   B,85
         LD   HL,11
         CALL PAYE_PC
         POP  BC
         RET  NC
         PUSH HL
         LD   A,B
         CALL ENCAISSE
         LD   A,C
         CALL ISJOUEUR
         JP   Z,STEALME
         LD   A,C
         CALL GETLNAME
         PUSH HL
         LD   A,B
         CALL GETLNAME
         PUSH HL
         LD   HL,STEAL
         LD   A,5
         CALL PLACARD
         RET
RAID_WON
         PUSH IY
         PUSH BC
         LD   A,B
         CALL GETLORD
         LD   B,(IY+02)
         LD   A,C
         CALL GETLORD
         LD   A,21
         CALL RND
         DEC  A
         LD   C,A
         LD   A,(IY+02)
         SUB  B
         ADD  A,10
         CP   C
         POP  BC
         POP  IY
         RET
STEALME
         LD   A,B
         CALL GETLNAME
         PUSH HL
         LD   HL,STELMET
         LD   A,5
         CALL PLACARD
         RET
LORDRLAD
;         LD   A,3
;         CALL RND
;         CP   1
;         RET  NZ
         LD   A,B
         CALL LGETHOME
         CALL GETRNAME
         PUSH HL
         LD   A,C
         CALL LGETWIFE
         ADD  A,9
         CALL GETLNAME
         PUSH HL
         LD   HL,KIDNAP
         CALL MENUTEXT
         CALL MENUREST
         LD   HL,CHOIRAID
         JP   AIGUILLE
CHOIRAID
         DEFW RAIDIGNO
         DEFW RAIDRESC
         DEFW RAIDROBI

RAIDROBI LD   A,1
         LD   HL,ROB_HELP
         CALL RUNFILE
         DEFW ROBIN
         JP   RAIDRESC

RAIDIGNO
         LD   A,C
         CALL ISJOUEUR
         JR   Z,RAIDPAY
         CALL GETLNAME
         PUSH HL
         LD   A,C
         CALL LGETWIFE
         ADD  A,9
         CALL GETLNAME
         PUSH HL
         LD   HL,RETWIF
         LD   A,5
         CALL PLACARD
         RET

RAIDPAY  PUSH BC
         LD   A,C
         LD   B,128
         LD   HL,2
         CALL PAYE_PC
         POP  BC
         PUSH HL
         LD   A,B
         CALL ENCAISSE
         LD   A,B
         CALL GETLNAME
         PUSH HL
         LD   HL,MYRANCON
         LD   A,5
         CALL PLACARD
         OR   A
         RET

RAIDRESC LD   A,C
         RLA
         RLA
         RLA
         RLA
         AND  #F0
         LD   E,A
         LD   A,C
         CALL LGETWIFE
         OR   E
         LD   E,A
         LD   A,B
         CALL LGETHOME
         LD   C,A
         LD   A,E
         LD   HL,ROB_HELP
         CALL RUNFILE
         DEFW RAID
         CALL SETMAP
         RET
;
;ABANDON
;   Option RESTART GAME
;Modifies - AF,HL
;
ABANDON
         LD   HL,MENU5
         CALL MENUTEXT
         CALL MENUREST
         CP   1
         JP   NZ,PLAY_JO0
         LD   A,3
         SCF
         RET
;
;
;SUITE
;   Option END TURN
;Modifies - AF
;
SUITE
         OR   A
         RET
;
;
;EXEJOUTE B=JOUEUR
;   Option HOLD JOUST
;Modifies - AF,HL
;
EXEJOUTE
         LD   A,(OUTJOUT)
         OR   A
         JR   Z,EXEJOUT1
         LD   HL,INTJOUT          ;Joueur interdit de joute
         LD   A,5
         CALL PLACARD
         JP   PLAY_JO0
EXEJOUT1 LD   A,(LASTJOUT)
         OR   A
         JR   Z,EXEJOUT0
         LD   HL,TOOEARLY         ;Derniere joute trop recente
         LD   A,5
         CALL PLACARD
         JP   PLAY_JO0
EXEJOUT0 LD   A,B
         LD   HL,5
         CALL PAYE
         JR   C,EXEJOUT2
         LD   HL,POORJOUT         ;Pas assez d'argent
         LD   A,5
         CALL PLACARD
         JP   PLAY_JO0
EXEJOUT2 LD   A,2
         LD   (LASTJOUT),A
         LD   A,B
         CALL RUNFILE
         DEFW JOUTE
         CALL SETMAP
         RET  NC
         LD   A,1
         LD   (OUTJOUT),A
         OR   A
         RET
;
;
;CONQUETE B=JOUEUR
;   Option SEEK CONQUEST
;
CONQUETE
         LD   A,1
         LD   (OKNULL),A
         LD   C,0
         LD   HL,MENU2
         CALL MENUTEXT
CONQUET2 OR   A
         JR   NZ,CONQUET0
         CALL WHATREG
         OR   A
         JR   NZ,CONQUET1
         CALL AFLECHE
         CALL MENUSEL
         CALL EFLECHE
         JR   CONQUET2
CONQUET1 LD   C,A
         LD   A,1
CONQUET0 CALL MENUREST
         LD   HL,OKNULL
         LD   (HL),0
         LD   HL,TMENU2
         JP   AIGUILLE
;
TMENU2   DEFW MOVE
         DEFW TRANSFERT
         DEFW CARTE
         DEFW CONQUROB
         DEFW CONTINUE
;
;
;RAID
;   Option GO RAIDING
;
EXERAID
         CALL CHOIXREG
         LD   C,A
         OR   A
         JR   NZ,RAID2
         LD   HL,RAIDABB          ;Abandon du raid
         LD   A,5
         CALL PLACARD
         JP   PLAY_JO0
RAID2    CP   19
         JR   NZ,RAID3
         LD   A,1
         LD   HL,ROB_HELP
         CALL RUNFILE             ;Voir ROBIN
         DEFW ROBIN
         CALL SETMAP
         JP   EXERAID
RAID3    CALL RGETBUIL
         CP   0
         JR   Z,RAID4
         CP   3
         JR   NZ,RAID5
RAID4    LD   HL,RAIDNOCA         ;raid sans chateau
         LD   A,5
         CALL PLACARD
         JP   EXERAID
RAID5    CALL BELONG
         JR   NZ,RAID7
         LD   A,B
         CALL GETLNAME
         PUSH HL
         LD   HL,RAIDYOU
         LD   A,5
         CALL PLACARD
         JP   EXERAID
RAID7    XOR  A
         LD   HL,ROB_HELP
         CALL RUNFILE
         DEFW RAID
         LD   A,C
         CALL RGETPROP
         CALL LINCHATE
         CALL SETMAP
         OR   A
         RET
;
;
;ACHAT  B=JOUEUR
;   Option BUY ARMY
;
ACHAT
         CALL REPONOFF
         LD   A,0
         LD   (SENS),A
ACHAT0   CALL AFFARM
         CALL AFFGOLD
         LD   A,(LORD)
         CALL LGETHOME
         CALL RGETCATA
         PUSH HL
         CALL RGETCHEV
         PUSH HL
         CALL RGETSOLD
         PUSH HL
         LD   A,(SENS)
         INC  A
         LD   HL,ACHSENS
         CALL GETSTR
         PUSH HL
         LD   HL,MENUACH
         CALL MENUTEXT
         LD   HL,MENUACH1
         JP   AIGUILLE
ACHAT1   CALL AFFARM
         CALL AFFGOLD
         CALL AFLECHE
         CALL MENUSEL
         CALL EFLECHE
         LD   HL,MENUACH1
         JP   AIGUILLE
;
MENUACH1
         DEFW ACHSWIC
         DEFW ACHSOLD
         DEFW ACHCHEV
         DEFW ACHCATA
         DEFW ACHCHAT
         DEFW ACHCONT
;
ACHSENS  DEFB "Achat",#FF
         DEFB "Vente",#FF
;
;-------------------------------------------------------------------------------
;
ACHSWIC
         LD   HL,SENS
         LD   A,(HL)
         XOR  1
         LD   (HL),A
         CALL MENUREST
         JP   ACHAT0
;
ACHSOLD

         LD   HL,256*18+19
         LD   DE,1
         LD   IX,RGETSOLD
         LD   IY,RPUTSOLD
         JR   ACHANY
ACHCHEV
         LD   HL,256*18+20
         LD   DE,8
         LD   IX,RGETCHEV
         LD   IY,RPUTCHEV
         JR   ACHANY
ACHCATA
         LD   HL,256*18+21
         LD   DE,15
         LD   IX,RGETCATA
         LD   IY,RPUTCATA

ACHANY
         LD   (ACHAGET0+1),IX
         LD   (ACHAGET1+1),IX
         LD   (ACHAGET2+1),IX
         LD   (ACHAPUT0+1),IY
         LD   (ACHAPUT1+1),IY
         LD   A,(LASTJOY)
         AND  #20
         LD   B,1
         JR   Z,ACHAGAIN
         LD   B,5
ACHAGAIN
         PUSH HL
         LD   A,(SENS)
         OR   A
         LD   A,(LORD)
         JR   NZ,ACHANY0
         CALL LGETGOLD
         PUSH BC
         OR   A
ACHPRIX  SBC  HL,DE
         JR   NC,ACHOK
         POP  BC
         POP  HL
         DEC  B
         JP   Z,ACHAT1
         JR   ACHAGAIN
ACHOK    DJNZ ACHPRIX
         POP  BC
         POP  DE
         LD   A,(LORD)
         CALL LPUTGOLD
         CALL LGETHOME
ACHAGET0 CALL RGETSOLD
ACHGET   INC  HL
         DJNZ ACHGET
ACHAPUT0 CALL RPUTSOLD
         EX   DE,HL
ACHANY1  CALL TXT_SET_CURSOR
         LD   A,(LORD)
         CALL LGETHOME
ACHAGET1 CALL RGETSOLD
         CALL AFFD16
         JP   ACHAT1
ACHANY0
         CALL LGETHOME
ACHAGET2 CALL RGETSOLD
         PUSH DE
         PUSH BC
         LD   DE,1
         OR   A
ACHCOMB  SBC  HL,DE
         JR   NC,RETOK
         POP  BC
         POP  DE
         POP  HL
         DEC  B
         JP   Z,ACHAT1
         JR   ACHAGAIN
RETOK    DJNZ ACHCOMB
         POP  BC
         POP  DE
         LD   A,(LORD)
         LD   C,A
         CALL LGETHOME
ACHAPUT1 CALL RPUTSOLD
         LD   A,C
         CALL LGETGOLD
RETMONT  ADD  HL,DE
         DJNZ RETMONT
         CALL LPUTGOLD
         POP  HL
         JP   ACHANY1
;
ACHCHAT
         LD   A,(LORD)
         LD   B,A
         LD   HL,20
         CALL PAYE
         JP   NC,ACHAT1
         CALL MENUREST
         CALL REPONOFF
         CALL CHOIXREG
         OR   A
         LD   C,A
         JR   NZ,ACHCHAT0
         LD   HL,CONSABB
         LD   A,5
         JR   ACHCHAT3
ACHCHAT0 CALL BELONG
         JR   Z,ACHCHAT1
         LD   HL,CONSNOT
         LD   A,5
         JR   ACHCHAT3
ACHCHAT1 LD   A,C
         CALL RGETBUIL
         OR   A
         JR   Z,ACHCHAT2
         LD   HL,CONSDEJ
         LD   A,5
         JR   ACHCHAT3
ACHCHAT2 LD   A,C
         CALL GETREG
         LD   A,3
         LD   (IX+00),A
         LD   A,(IX+08)
         ADD  A,2
         LD   (IX+08),A
         LD   L,(IX+01)
         LD   H,(IX+02)
         LD   DE,10
         ADD  HL,DE
         LD   (IX+01),L
         LD   (IX+02),H
         LD   A,7
         CALL BRUIT
         LD   A,C
         CALL AFFREG
         CALL AFFINC
         JR   ACHCHAT4
ACHCHAT3 CALL PLACARD
         LD   A,(LORD)
         LD   HL,20
         CALL ENCAISSE
ACHCHAT4 CALL REPONOFF
         JP   ACHAT0
;
ACHCONT
         CALL MENUREST
         CALL REPONOFF
         OR   A
         RET
;
TRANSFERT
         LD   A,(LORD)            ;Test region bien au lord
         LD   B,A
         CALL LGETREG
         LD   C,A
         CALL BELONG
         JR   Z,TRANSFE2
         LD   HL,NOTYOURS
         LD   A,6
         CALL PLACARD
         JP   CONQUETE
TRANSFE2 CALL REPONOFF
         LD   A,0
         LD   (SENS),A
TRANSFE0 LD   A,(SENS)
         INC  A
         LD   HL,TRANSENS
         CALL GETSTR
         EX   DE,HL
         LD   A,B
         CALL LGETCATA
         PUSH HL
         PUSH DE
         LD   A,C
         CALL RGETCATA
         PUSH HL
         LD   A,B
         CALL LGETCHEV
         PUSH HL
         PUSH DE
         LD   A,C
         CALL RGETCHEV
         PUSH HL
         LD   A,B
         CALL LGETSOLD
         PUSH HL
         PUSH DE
         LD   A,C
         CALL RGETSOLD
         PUSH HL
         PUSH DE
         LD   HL,MENUTRAN
         CALL MENUTEXT
         LD   HL,MENUTRA1
         JP   AIGUILLE
TRANSFE1 CALL AFFARM
         CALL AFLECHE
         CALL MENUSEL
         CALL EFLECHE
         LD   HL,MENUTRA1
         JP   AIGUILLE
;
MENUTRA1
         DEFW TRASWIC
         DEFW TRASOLD
         DEFW TRACHEV
         DEFW TRACATA
         DEFW TRACONT
;
TRANSENS DEFB "->",#FF
         DEFB "<-",#FF
;
CONQUROB
         LD   A,2
         LD   HL,ROB_HELP
         CALL RUNFILE
         DEFW ROBIN
         CALL SETMAP
         JP   CONQUETE
;
CONTINUE
         JP   PLAY_JO0
;
;
MOVE
         LD   A,C
         OR   A
         CALL Z,CHOIXREG

         OR   A                   ;Test region valide
         JR   Z,MOVE0
         CP   19
         JR   NZ,MOVE1
MOVE0    LD   HL,ATTABORT
         LD   A,3
         CALL PLACARD
         JP   CONQUETE

MOVE1    LD   (REGION2),A         ;Mise en place variables
         LD   C,A
         CALL RGETPROP
         LD   (LORD2),A
         LD   A,(LORD)
         LD   (LORD1),A
         LD   B,A
         CALL LGETREG
         LD   (REGION1),A
         CP   C
         JP   Z,CONQUETE

         PUSH BC
         LD   BC,(REGION1)        ;Test region adjacente
         CALL ADJACENT
         POP  BC
         JR   C,MVOKADJA
         LD   HL,ATTADJA
         LD   A,3
         CALL PLACARD
         JP   CONQUETE

MVOKADJA
         CALL BELONG
         JR   NZ,MVNOTMY

MOVEOK
         LD   A,1
         CALL BRUIT
         LD   A,B
         CALL DEPLACE
         LD   HL,DECOMPTE
         DEC  (HL)
         JP   NZ,CONQUETE
         OR   A
         RET

MVNOTMY
         LD   A,(LORD2)           ;Test lord ami
         OR   A
         JR   Z,MVNOTAMI
         CALL LGETHATE
         CP   5
         JR   NC,MVNOTAMI
         LD   A,(LORD2)
         CALL GETLNAME
         PUSH HL
         LD   HL,PASSAGE
         CALL MENUTEXT
         CALL MENUREST
         CP   1
         JP   Z,MOVEOK

MVNOTAMI
         LD   A,B                 ;Test armee vide
         CALL LGETSOLD
         LD   A,H
         OR   L
         JR   NZ,LTESTAR0
         LD   A,B
         CALL LGETCHEV
         LD   A,H
         OR   L
LTESTAR0 JR   NZ,MVYARM
         LD   A,B
         CALL GETLNAME
         PUSH HL
         LD   HL,NOARMY
         LD   A,5
         CALL PLACARD
         JP   CONQUETE

MVYARM
         LD   A,C                 ;Test chateau
         CALL RGETBUIL
         OR   A
         JR   Z,MVNCAST

         LD   A,B                 ;Test catapultes
         CALL LGETCATA
         LD   A,H
         OR   L
         JR   NZ,MVNCAST
         LD   HL,ATTNCATA
         LD   A,5
         CALL PLACARD
         JP   CONQUETE

MVNCAST
         LD   A,1
         CALL BRUIT

         LD   A,(LORD1)
         LD   B,A
         LD   A,(REGION2)
         LD   C,A
         CALL ATTAQUE
         RET
;
;-------------------------------------------------------------------------------
;
TRASWIC
         LD   HL,SENS
         LD   A,(HL)
         XOR  1
         LD   (HL),A
         CALL MENUREST
         JP   TRANSFE0
;
TRASOLD
         LD   HL,RGETSOLD
         LD   (TRA_RGET+1),HL
         LD   HL,RPUTSOLD
         LD   (TRA_RPUT+1),HL
         LD   HL,LGETSOLD
         LD   (TRA_LGET+1),HL
         LD   HL,LPUTSOLD
         LD   (TRA_LPUT+1),HL
         LD   HL,#1503
         LD   (TRANSCO0+1),HL
         LD   H,#0E
         LD   (TRANSCO1+1),HL
         JP   TRANSALL
TRACHEV
         LD   HL,RGETCHEV
         LD   (TRA_RGET+1),HL
         LD   HL,RPUTCHEV
         LD   (TRA_RPUT+1),HL
         LD   HL,LGETCHEV
         LD   (TRA_LGET+1),HL
         LD   HL,LPUTCHEV
         LD   (TRA_LPUT+1),HL
         LD   HL,#1504
         LD   (TRANSCO0+1),HL
         LD   H,#0E
         LD   (TRANSCO1+1),HL
         JP   TRANSALL
TRACATA
         LD   HL,RGETCATA
         LD   (TRA_RGET+1),HL
         LD   HL,RPUTCATA
         LD   (TRA_RPUT+1),HL
         LD   HL,LGETCATA
         LD   (TRA_LGET+1),HL
         LD   HL,LPUTCATA
         LD   (TRA_LPUT+1),HL
         LD   HL,#1505
         LD   (TRANSCO0+1),HL
         LD   H,#0E
         LD   (TRANSCO1+1),HL
         JP   TRANSALL
TRA_RGET JP   0
TRA_RPUT JP   0
TRA_LGET JP   0
TRA_LPUT JP   0

TRANSALL
         LD   A,(LASTJOY)
         AND  #20
         LD   DE,-1
         JR   Z,TRANSNB
         LD   DE,-5
TRANSNB  LD   A,(SENS)
         OR   A
         JR   NZ,TRANS0
TRANAGA1 LD   A,C
         CALL TRA_RGET
         ADD  HL,DE
         JR   C,TRANSOK1
         INC  DE
         LD   A,D
         OR   E
         JP   Z,TRANSFE1
         JR   TRANAGA1
TRANSOK1 CALL TRA_RPUT
         LD   A,B
         CALL TRA_LGET
         OR   A
         SBC  HL,DE
         CALL TRA_LPUT
TRANSCO1 LD   HL,0
         PUSH HL
         CALL TXT_SET_CURSOR
         LD   A,C
         CALL TRA_RGET
         CALL AFFD16
         POP  HL
TRANSCO0 LD   HL,0
         CALL TXT_SET_CURSOR
         LD   A,B
         CALL TRA_LGET
         CALL AFFD16
         JP   TRANSFE1
TRANS0
TRANAGA2 LD   A,B
         CALL TRA_LGET
         ADD  HL,DE
         JR   C,TRANSOK2
         INC  DE
         LD   A,D
         OR   E
         JP   Z,TRANSFE1
         JR   TRANAGA2
TRANSOK2 CALL TRA_LPUT
         LD   A,C
         CALL TRA_RGET
         OR   A
         SBC  HL,DE
         CALL TRA_RPUT
         JR   TRANSCO1
;
TRACONT
         CALL MENUREST
         CALL REPONOFF
         JP   CONQUETE
;
CARTE
         CALL EXECARTE
         JP   C,CONQUETE
         JP   CARTE
;
EXECARTE
         LD   A,1
         LD   (OKNULL),A
         LD   C,0
         LD   HL,MENU23
         CALL MENUTEXT
EXECART2 OR   A
         JR   NZ,EXECART0
         CALL WHATREG
         OR   A
         JR   NZ,EXECART1
         CALL AFLECHE
         CALL MENUSEL
         CALL EFLECHE
         JR   EXECART2
EXECART1 LD   C,A
         LD   A,1
EXECART0 CALL MENUREST
         LD   HL,OKNULL
         LD   (HL),0
         LD   HL,TMENU23
         JP   AIGUILLE
;
TMENU23
         DEFW SEETERR
         DEFW SENDSPY
         DEFW SEELORD
         DEFW MAPCONT
;
SEETERR
         LD   A,C
         OR   A
         JR   NZ,SEETER1
         CALL CHOIXREG
         OR   A
         RET  Z
         CP   19
         RET  Z
         LD   C,A
SEETER1  CALL GETREG
         LD   L,(IX+09)      ;Vasseaux
         LD   H,0
         PUSH HL
         LD   L,(IX+08)      ;Taxes
         PUSH HL
         LD   HL,NOPROP
         LD   DE,NOPROP2
         LD   A,(IX+07)
         OR   A
         JR   Z,SEETER0
         LD   DE,YESPROP
	call GETLNAME
SEETER0  PUSH HL
         PUSH DE
         LD   A,C
	call GETRNAME
         PUSH HL
         LD   HL,STMESS
         LD   A,7
         CALL PLACARD
         OR   A
         RET
;
NOPROP   DEFB "Sans d[fenseur",#FF
NOPROP2  DEFB #FF
YESPROP  DEFB "Lord : ",#FF
;
SENDSPY
         LD   A,(LORD)
         LD   HL,5
         CALL PAYE
         JR   C,SPYGOLD
         LD   HL,SPYPOOR
         LD   A,5
         CALL PLACARD
         OR   A
         RET
SPYGOLD  CALL CHOIXREG
         OR   A
         JR   Z,SPYABB
         CP   19
         JR   NZ,SPYOK
SPYABB   LD   A,(LORD)
         LD   HL,5
         CALL ENCAISSE
         RET
SPYOK    LD   (REGION1),A
         CALL AFFGOLD
         LD   A,(REGION1)
         CALL GETREG
         CALL RGETPROP
         OR   A
         JR   NZ,SPYLORD

         LD   H,0                 ;Region sans Lord
         LD   L,(IX+09)
         PUSH HL
         LD   L,(IX+08)
         PUSH HL
         LD   A,(REGION1)
	call GETRNAME
         PUSH HL
         LD   A,7
         LD   HL,SPYTXT1
         CALL PLACARD
         LD   A,(REGION1)
         CALL RGETCATA
         PUSH HL
         CALL RGETCHEV
         PUSH HL
         CALL RGETSOLD
         PUSH HL
	call GETRNAME
         PUSH HL
         LD   A,7
         LD   HL,SPYTXT2
         CALL PLACARD
         OR   A
         RET

SPYLORD  LD   (LORD1),A
         LD   HL,FACES
         LD   DE,(SAVEBUF)
         PUSH DE
         CALL READFILE
         POP  DE
         LD   (SAVEBUF),DE
         LD   A,(LORD1)
         ADD  A,24
         LD   H,52
         LD   L,191
         LD   B,13
         CALL AFFSPRC

         LD   A,(LORD1)
         CALL LGETREG
         LD   (REGION2),A
;         LD   HL,LANDS
;         CALL GETSTR
	call GETRNAME
         PUSH HL
         LD   A,(LORD1)
         CALL LGETGOLD
         PUSH HL
	call GETLNAME
         PUSH HL
         LD   A,(REGION1)
	call GETRNAME
         PUSH HL
         LD   A,7
         LD   HL,SPYTXT3
         CALL PLACARD

         LD   A,(REGION1)
         CALL RGETCATA
         PUSH HL
         CALL RGETCHEV
         PUSH HL
         CALL RGETSOLD
         PUSH HL
	call GETRNAME
         PUSH HL
         LD   A,7
         LD   HL,SPYTXT4
         CALL PLACARD

         LD   A,(LORD1)
         CALL LGETCATA
         PUSH HL
         LD   A,(REGION2)
         CALL RGETCATA
         PUSH HL
         LD   A,(LORD1)
         CALL LGETCHEV
         PUSH HL
         LD   A,(REGION2)
         CALL RGETCHEV
         PUSH HL
         LD   A,(LORD1)
         CALL LGETSOLD
         PUSH HL
         LD   A,(REGION2)
         CALL RGETSOLD
         PUSH HL
	call GETRNAME
         PUSH HL
         LD   A,7
         LD   HL,SPYTXT5
         CALL PLACARD

         LD   HL,FACES
         LD   DE,(SAVEBUF)
         PUSH DE
         CALL READFILE
         POP  DE
         LD   (SAVEBUF),DE
         LD   A,(LORD)
         ADD  A,24
         LD   H,52
         LD   L,191
         LD   B,13
         CALL AFFSPRC
         OR   A
         RET

;
SEELORD
         CALL CHOIXREG
         OR   A
         RET  Z
         CP   19
         RET  Z
         CALL RGETPROP
         LD   (LORD1),A
         OR   A
         RET  Z
         LD   HL,FACES
         LD   DE,(SAVEBUF)
         PUSH DE
         CALL READFILE
         POP  DE
         LD   (SAVEBUF),DE
         LD   A,(LORD1)
         ADD  A,24
         LD   H,52
         LD   L,191
         LD   B,13
         CALL AFFSPRC
         LD   A,(LORD1)
         CALL GETLORD
         LD   H,0
         LD   L,(IY+04)
         PUSH HL
         LD   L,(IY+03)
         PUSH HL
         LD   L,(IY+02)
         PUSH HL
         LD   L,(IY+01)
         PUSH HL
         CALL LGETINC
         PUSH HL
         LD   A,(IY+07)
	call GETRNAME
         PUSH HL
         LD   A,(LORD1)
	call GETLNAME
         PUSH HL
         LD   A,8
         LD   HL,SLORDTXT
         CALL PLACARD
         LD   HL,FACES
         LD   DE,(SAVEBUF)
         PUSH DE
         CALL READFILE
         POP  DE
         LD   (SAVEBUF),DE
         LD   A,(LORD)
         ADD  A,24
         LD   H,52
         LD   L,191
         LD   B,13
         CALL AFFSPRC
         OR   A
         RET
MAPCONT
         SCF
         RET
;
;*******************************************************************************





