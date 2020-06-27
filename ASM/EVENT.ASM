;
;EVENT.ASM    (c)1989 B.RIVE
;

	read	"LINK.ASM"

	write direct "a:EVENT.BIN",BUFOVL

         ORG  BUFOVL
;
         JP   EVENT
         JP   BATTLE
;
;CONQUETE D'UN LORD (B-Lord,C-Region)->C si joueur tue
;           (A-Type,HL-Soldats necessaires)         FF Si passer au LORDRAID
EXECONQU
         LD   (COUT),HL
         LD   (TYPE),A
         LD   (OBJECTIF),BC
         LD   A,4
         LD   (COMPTE),A
BOUCLE
         LD   A,(CLORD)
         CALL LGETREG
         LD   (CREG),A
         CALL TRANSF
         CALL FORCE
         JR   NC,TO_HOME

KAMIKAZE LD   A,(OBJECTIF)
         CALL NEXT_REG
         LD   A,(OBJECTIF)
         CP   B
         JP   Z,COMBAT
         JR   BOUGE
TO_HOME
         LD   A,(CLORD)
         CALL LGETHOME
         LD   B,A
         LD   A,(CREG)
         CP   B
         JP   Z,ACHAT
         LD   A,B
         CALL NEXT_REG
         JR   C,BOUGE
         LD   A,1
         LD   (KAMIKA+1),A
         JR   KAMIKAZE
BOUGE
         LD   A,B
         CALL STEP
         LD   HL,COMPTE
         DEC  (HL)
         JR   NZ,BOUCLE
         XOR  A
         RET
;
COMBAT
         LD   A,(CLORD)
         LD   B,A
         LD   A,(OBJECTIF)
         LD   C,A
         JP   ATTAQUE
;
TRANSF
         LD   A,(CLORD)
         LD   B,A
         LD   A,(CREG)
         LD   C,A
         CALL TOTALE
         LD   A,B
         CALL LGETSOLD
         LD   DE,(COUT)
         INC  DE
         INC  DE
         OR   A
         SBC  HL,DE
         RET  C
         RET  Z
         PUSH HL
         CALL MOYENNE
         POP  HL
         OR   A
         SBC  HL,DE
         JR   NC,TRANSF0
         ADD  HL,DE
         EX   DE,HL
         LD   HL,0
TRANSF0  EX   DE,HL
         LD   A,(CREG)
         CALL RPUTSOLD
         LD   HL,(COUT)
         INC  HL
         INC  HL
         ADD  HL,DE
         LD   A,(CLORD)
         CALL LPUTSOLD
         RET
;
TOTALE   ;B-Lord,C-Reg
         LD   A,C
         CALL RGETSOLD
         EX   DE,HL
         LD   A,B
         CALL LGETSOLD
         ADD  HL,DE
         CALL LPUTSOLD
         LD   A,C
         CALL RGETCHEV
         EX   DE,HL
         LD   A,B
         CALL LGETCHEV
         ADD  HL,DE
         CALL LPUTCHEV
         LD   A,C
         CALL RGETCATA
         EX   DE,HL
         LD   A,B
         CALL LGETCATA
         ADD  HL,DE
         CALL LPUTCATA
         LD   A,C
         LD   HL,0
         CALL RPUTSOLD
         CALL RPUTCHEV
         CALL RPUTCATA
         RET
;
FORCE
         LD   A,(OBJECTIF)
         CALL RGETBUIL
         OR   A
         JR   Z,FORCE0
         LD   A,(CLORD)
         CALL LGETCATA
         LD   A,H
         OR   L
         RET  Z
FORCE0   LD   A,(CLORD)
         CALL LGETSOLD
         EX   DE,HL
         CALL LGETCHEV
         LD   B,5
         CALL MULT
         ADD  HL,DE
         LD   DE,(COUT)
         OR   A
         SBC  HL,DE
         CCF
         RET
;
NEXT_REG
         LD   C,A
         LD   A,(CREG)
         LD   B,A
         LD   A,(CLORD)
         CALL CHEMIN
         RET
;
STEP
         LD   C,A
         LD   A,(CLORD)
         jp GO
;
MOYENNE
         LD   A,(CLORD)
         LD   C,A
         CALL LGETSOLD
         PUSH HL
         POP  IX
         LD   B,18
         LD   L,0
MOY0     LD   A,B
         CALL RGETPROP
         CP   C
         JR   NZ,MOY1
         LD   A,B
         EX   DE,HL
         CALL RGETSOLD
         EX   DE,HL
         ADD  IX,DE
         INC  L
MOY1     DJNZ MOY0
         LD   B,L
         PUSH IX
         POP  HL
         CALL DIV
         EX   DE,HL
         RET
;
ACHAT
         LD   A,(CLORD)
         LD   HL,15
         CALL TST_MONY
         LD   A,#FF
         RET  NC
         LD   A,(OBJECTIF)
         CALL RGETBUIL
         OR   A
         CALL NZ,BUY_CATA
ACH_BCLE CALL BUY_SOLD
         CALL BUY_CHEV
         CALL BUY_SOLD
         CALL BUY_CHEV
         CALL BUY_SOLD
         CALL BUY_CATA
         CALL BUY_SOLD
         CALL BUY_CAST
         JR   ACH_BCLE
;
BUY_SOLD
         LD   A,(CLORD)
         CALL LGETGOLD
         LD   DE,11
         OR   A
         SBC  HL,DE
         JR   NC,BUY_S0
         ADD  HL,DE
         EX   DE,HL
         LD   HL,0
BUY_S0   CALL LPUTGOLD
         CALL LGETHOME
         CALL RGETSOLD
         ADD  HL,DE
         CALL RPUTSOLD
         JR   BUY_FIN
;
BUY_CHEV
         LD   A,(CLORD)
         LD   HL,8
         CALL PAYE
         RET  NC
         CALL LGETHOME
         CALL RGETCHEV
         INC  HL
         CALL RPUTCHEV
BUY_FIN  LD   A,(CLORD)
         CALL LGETGOLD
         LD   A,H
         OR   L
         RET  NZ
         POP  HL
         XOR  A
         RET
;
BUY_CATA
         LD   A,(CLORD)
         LD   HL,15
         CALL PAYE
         RET  NC
         CALL LGETHOME
         CALL RGETCATA
         INC  HL
         CALL RPUTCATA
         JR   BUY_FIN
;
BUY_CAST
         LD   A,(CLORD)
         CALL LANDFREE
         RET  NC
         LD   C,A
         LD   A,(CLORD)
         LD   HL,20
         CALL PAYE
         RET  NC
         LD   A,C
         LD   DE,10
         CALL RGETSOLD
         ADD  HL,DE
         CALL RPUTSOLD
         CALL GETREG
         LD   (IX+00),3
         LD   A,7
         CALL BRUIT
         LD   A,C
         CALL AFFREG
         JR   BUY_FIN
;
COUT     DEFS 2
TYPE     DEFS 1
OBJECTIF DEFS 1
CLORD    DEFS 1
COMPTE   DEFS 1
CREG     DEFS 1
;
CASTRESI DEFS 1
MENUON   DEFS 1
TACTDEF  DEFS 1
TACTATT  DEFS 1
LEADATT  DEFS 1
LEADDEF  DEFS 1
ATTKILL  DEFS 2
DEFKILL  DEFS 2
ATTSOLD  DEFS 2
ATTKNIG  DEFS 2
ATTKRET  DEFS 1
DEFSOLD  DEFS 2
DEFKNIG  DEFS 2
DEFKRET  DEFS 1
NUMCOORD DEFS 2
;
;BATTLE(IY->Lord,IX->Region,HL->Castresi)->Carry si victoire
;        HL+1->ROB_HELP,KAMIKA set           Z-DEFAITE  NZ-RETRAITE
BATTLE
         XOR  A
         LD   (MENUON),A
         LD   A,(HL)
         LD   (CASTRESI),A
         INC  HL
         CALL IDENTIF
         CALL CALCLEA
         CALL AFFBAT
BATTLE0
         CALL CHOIDEF
         LD   (TACTDEF),A
         CALL CHOIATT
         LD   (TACTATT),A
         CALL CALCULE
         CALL ACTARM
         JR   NZ,BATTLE0
         SUB  2
         PUSH AF
         CALL INTERACT
         JR   NC,BATTLE1
         LD   A,2
         CALL WAIT_PAUSE
         CALL AFFMAP
BATTLE1  POP  AF
         LD   HL,KAMIKA+1
         LD   (HL),0
         RET
;
;
;
ACTARM
         PUSH IX
         PUSH IY
         POP  IX
         LD   DE,8
         ADD  IX,DE
         LD   HL,17*256+5
         CALL REVERSE
         JR   NC,ACTARM0
         LD   H,34
ACTARM0  LD   (NUMCOORD),HL
         LD   HL,(DEFKILL)
         PUSH IY
         LD   IY,ATTSOLD
         CALL FOSSOY
         POP  IY
         POP  IX
         LD   A,2
         RET  Z
         LD   A,(TACTATT)
         CP   6
         JR   NZ,ACTARM10
         LD   A,3
         RET
ACTARM10 INC  IX
         LD   HL,17*256+5
         CALL REVERSE
         JR   C,ACTARM1
         LD   H,34
ACTARM1  LD   (NUMCOORD),HL
         LD   HL,(ATTKILL)
         PUSH IY
         LD   IY,DEFSOLD
         CALL FOSSOY
         POP  IY
         DEC  IX
         LD   A,1
         RET
;
FOSSOY
         LD   E,(IX+00)
         LD   D,(IX+01)
         EX   DE,HL
         OR   A
         SBC  HL,DE
         PUSH HL
         JR   NC,FOSS0
         LD   HL,0
FOSS0    LD   (IX+00),L
         LD   (IX+01),H
         CALL INTERACT
         JR   NC,FOSSNI0
         CALL AFFRESU
         LD   BC,79*256+10
         CALL HOWMANY
         LD   A,E
         LD   E,(IY+00)
         LD   D,(IY+01)
         CALL COMPARE
         LD   (IY+00),E
         LD   (IY+01),D
         LD   HL,(NUMCOORD)
         INC  L
         LD   (NUMCOORD),HL
FOSSNI0  POP  DE
         LD   HL,0
         OR   A
         SBC  HL,DE
         BIT  7,H
         RET  NZ
         LD   E,(IX+02)
         LD   D,(IX+03)
         LD   A,D
         OR   E
         JR   NZ,FOSS10
FOSS11   LD   (IX+04),0
         LD   (IX+05),0
         RET
FOSS10   LD   BC,8
         XOR  A
FOSS1    SBC  HL,BC
         JR   C,FOSS2
         INC  A
         JR   FOSS1
FOSS2    ADD  HL,BC
         LD   C,A
         LD   A,(IY+04)
         ADD  A,L
         CP   8
         JR   C,FOSS3
         INC  C
         SUB  8
FOSS3    LD   (IY+04),A
         LD   L,C
         LD   H,0
         EX   DE,HL
         OR   A
         SBC  HL,DE
         JR   NC,FOSS4
         LD   HL,0
FOSS4    LD   (IX+02),L
         LD   (IX+03),H
         CALL INTERACT
         JR   NC,FOSSNI1
         CALL AFFRESU
         PUSH HL
         LD   BC,39*256+5
         CALL HOWMANY
         LD   A,E
         LD   E,(IY+02)
         LD   D,(IY+03)
         CALL COMPARE
         LD   (IY+02),E
         LD   (IY+03),D
         POP  HL
FOSSNI1  LD   A,H
         OR   L
         JR   Z,FOSS11
         RET
;
AFFRESU
         CALL INTERACT
         RET  NC
         PUSH HL
         LD   HL,(NUMCOORD)
         CALL TXT_SET_CURSOR
         POP  HL
         CALL AFFD16
         RET
AFFD16
         PUSH HL
         PUSH AF
         PUSH DE
         LD   A," "
         LD   (DECHAR+1),A
         LD   DE,10000
         CALL AFFD160
         LD   DE,1000
         CALL AFFD160
         LD   DE,100
         CALL AFFD160
         LD   DE,10
         CALL AFFD160
         LD   DE,1
         LD   A,"0"
         LD   (DECHAR+1),A
         CALL AFFD160
         POP  DE
         POP  AF
         POP  HL
         RET
AFFD160  LD   A,#FF
         OR   A
AFFD161  SBC  HL,DE
         INC  A
         JR   NC,AFFD161
         ADD  HL,DE
DECHAR   ADD  A," "
         CP   " "
         JP   Z,TXT_OUTPUT
         CP   " "+10
         JP   NC,TXT_OUTPUT
         ADD  A,"0"-" "
         CALL TXT_OUTPUT
         LD   A,"0"
         LD   (DECHAR+1),A
         RET
;
HOWMANY
         EX   DE,HL
         LD   A,B
         LD   H,0
         LD   L,B
         LD   (HMMAX+1),A
         LD   B,0
         OR   A
         SBC  HL,DE
         JR   NC,HM1
HMMAX    LD   DE,0
HM1      EX   DE,HL
         ADD  HL,BC
         DEC  HL
         LD   E,0
HM0      OR   A
         SBC  HL,BC
         RET  C
         INC  E
         JR   HM0
;
COMPARE
         CP   E
         RET  Z
         PUSH AF
         LD   A,D
         CALL LUTOFF
         DEC  D
         DEC  E
         POP  AF
         JR   COMPARE
;
;
;
CALCULE
         LD   A,(LEADATT)
         LD   B,A
         LD   A,(TACTATT)
         PUSH IX
         PUSH IY
         POP  IX
         LD   DE,8
         ADD  IX,DE
         LD   HL,CALCTAB
         CALL AIGUILLE
         POP  IX
         PUSH HL
         INC  IX
         LD   A,(LEADDEF)
         LD   B,A
         LD   A,(TACTDEF)
         LD   HL,CALCTAB
         CALL AIGUILLE
         DEC  IX
         POP  DE
         EX   DE,HL
         LD   A,(TACTDEF)
         CP   5
         JR   NZ,CALCUL0
         LD   A,(CASTRESI)
         LD   B,A
         CALL DIMINUE
CALCUL0
         PUSH DE
         LD   B,240
         CALL DIMINUE
         LD   A,H
         OR   L
         JR   NZ,CALPASN0
         INC  HL
CALPASN0 EX   DE,HL
         LD   HL,40
         OR   A
         SBC  HL,DE
         JR   NC,CALCOK0
         LD   DE,40
CALCOK0  LD   (ATTKILL),DE
         POP  HL
         LD   B,240
         CALL DIMINUE
         LD   A,H
         OR   L
         JR   NZ,CALPASN1
         INC  HL
CALPASN1 EX   DE,HL
         LD   HL,40
         OR   A
         SBC  HL,DE
         JR   NC,CALCOK1
         LD   DE,40
CALCOK1  LD   (DEFKILL),DE
         RET
CALCTAB
         DEFW CALC1
         DEFW CALC2
         DEFW CALC3
         DEFW CALC4
         DEFW CALC5
         DEFW CALC6
CALC1
         PUSH BC
         LD   E,(IX+00)
         LD   D,(IX+01)
         LD   L,(IX+02)
         LD   H,(IX+03)
         LD   B,5
         CALL MULT
         ADD  HL,DE
         EX   DE,HL
         LD   L,(IX+04)
         LD   H,(IX+05)
         LD   B,10
         CALL MULT
         ADD  HL,DE
         POP  BC
         SLA  B
         JP   COMM0
CALC2
         PUSH BC
         LD   L,(IX+00)
         LD   H,(IX+01)
         ADD  HL,HL
         PUSH HL
         LD   L,(IX+02)
         LD   H,(IX+03)
         LD   B,5
         CALL MULT
         POP  DE
         ADD  HL,DE
         EX   DE,HL
         LD   L,(IX+04)
         LD   H,(IX+05)
         LD   B,10
COMM1    CALL MULT
         ADD  HL,DE
         POP  BC
COMM0    PUSH HL
         CALL DIMINUE
         EX   DE,HL
         LD   HL,0
         OR   A
         SBC  HL,DE
         POP  DE
         ADD  HL,DE
         ADD  HL,DE
         RET
CALC3
         PUSH BC
         LD   E,(IX+00)
         LD   D,(IX+01)
         LD   L,(IX+02)
         LD   H,(IX+03)
         LD   B,8
         CALL MULT
         ADD  HL,DE
         EX   DE,HL
         LD   L,(IX+04)
         LD   H,(IX+05)
         LD   B,10
         JP   COMM1
CALC4
         PUSH BC
         LD   E,(IX+00)
         LD   D,(IX+01)
         LD   L,(IX+02)
         LD   H,(IX+03)
         LD   B,5
         CALL MULT
         ADD  HL,DE
         EX   DE,HL
         LD   L,(IX+04)
         LD   H,(IX+05)
         LD   B,15
         JP   COMM1
CALC5
         PUSH BC
         LD   E,(IX+00)
         LD   D,(IX+01)
         LD   L,(IX+02)
         LD   H,(IX+03)
         LD   B,5
         CALL MULT
         ADD  HL,DE
         EX   DE,HL
         LD   L,(IX+04)
         LD   H,(IX+05)
         LD   B,10
         JP   COMM1
CALC6
         LD   HL,0
         RET
;
;
;
CHOIDEF
         CALL INTERACT
         JP   NC,ENNEMID
         CALL REVERSE
         JP   NC,ENNEMID
         JP   PLAYER
;
CHOIATT
         CALL INTERACT
         JP   NC,ENNEMIA
         CALL REVERSE
         JP   C,ENNEMIA
         JP   PLAYER
;
CALCLEA
         XOR  A
         LD   (ATTKRET),A
         LD   (DEFKRET),A
         LD   A,(CASTRESI)
         CALL CASTCONV
         LD   (CASTRESI),A
         LD   A,(IY+01)
         CALL CONVLEA
         LD   (LEADATT),A
         LD   A,(IX+07)
         OR   A
         JR   NZ,CALCLEA0
CALCLEA1 XOR  A
         CALL CONVLEA
         LD   (LEADDEF),A
         RET
CALCLEA0 CALL LGETREG
         PUSH IX
         POP  DE
         CALL GETREG
         PUSH IX
         POP  HL
         OR   A
         SBC  HL,DE
         PUSH DE
         POP  IX
         JR   NZ,CALCLEA1
         LD   A,(IX+07)
         PUSH IY
         CALL GETLORD
         LD   A,(IY+01)
         POP  IY
         CALL CONVLEA
         LD   (LEADDEF),A
         RET
CONVLEA
         LD   HL,LEATAB
CONVGEN  LD   E,A
         LD   D,0
         ADD  HL,DE
         LD   A,(HL)
         RET
LEATAB
         DEFB 0,10,20,30,43,53,64,76
         DEFB 87,97,110
CASTCONV
         LD   HL,CASTAB
         JR   CONVGEN
CASTAB
         DEFB 0,0,0,0,30,64,94,128
         DEFB 161,192,225
;
IDENTIF
         LD   A,#B7          ;OR A
         LD   (INTERACT),A
         LD   A,(IY+00)
         CP   3
         JP   NZ,IDENT0
         LD   A,(IX+07)
         OR   A
         JP   Z,IDENT0
         LD   A,#37          ;SCF
         LD   (INTERACT),A
         LD   A,#B7          ;OR A
         LD   (REVERSE),A
         LD   A,(HL)         ;ROB_HELP
         AND  #80
         RES  7,(HL)
         INC  HL
         RET  Z
         LD   L,(IX+01)
         LD   H,(IX+02)
         LD   E,(IY+08)
         LD   D,(IY+09)
         OR   A
         SBC  HL,DE
         LD   E,(IX+03)
         LD   D,(IX+04)
         ADD  HL,DE
         LD   E,(IY+10)
         LD   D,(IY+11)
         OR   A
         SBC  HL,DE
         BIT  7,H
         JR   Z,OKPOSN
         LD   HL,2
OKPOSN   PUSH HL
         LD   E,(IY+08)
         LD   D,(IY+09)
         ADD  HL,DE
         LD   (IY+08),L
         LD   (IY+09),H
         LD   HL,ROBGIVE
         LD   A,5
         CALL PLACARD
         RET

IDENT0   LD   A,(IX+07)
         LD   HL,(LORD)
         CP   (HL)
         RET  NZ
         LD   A,(HL)
         CALL LGETREG
         LD   C,A
         LD   A,(HL)
         CALL LGETHOME
         CALL EQUREG
         JR   Z,YESINT
         LD   A,C
         CALL EQUREG
         RET  NZ
YESINT   LD   A,#37          ;SCF
         LD   (INTERACT),A
         LD   (REVERSE),A
         RET
EQUREG
         PUSH IX
         POP  DE
         CALL GETREG
         PUSH IX
         POP  HL
         OR   A
         SBC  HL,DE
         PUSH DE
         POP  IX
         RET
INTERACT
         OR   A
         RET
REVERSE
         OR   A
         RET
;
;
;
AFFBAT
         CALL INTERACT
         RET  NC
         LD   HL,BATBACK
	call load_decomp_scr
         LD   HL,BATSPR
         LD   DE,SPRBUF
         CALL READFILE
         LD   HL,(ANIBUF)
         LD   (HL),E
         INC  HL
         LD   (HL),D
         CALL LUTINIT

         LD   E,(IY+12)
         LD   D,(IY+13)
         LD   L,(IX+05)
         LD   H,(IX+06)
         CALL REVERSE
         JR   NC,AFFBAT0
         EX   DE,HL
AFFBAT0  PUSH HL
         PUSH DE

         LD   E,(IY+10)
         LD   D,(IY+11)
         LD   L,(IX+03)
         LD   H,(IX+04)
         CALL REVERSE
         JR   NC,AFFBAT1
         EX   DE,HL
AFFBAT1  PUSH HL
         PUSH DE
         CALL AFFCHEV

         LD   E,(IY+08)
         LD   D,(IY+09)
         LD   L,(IX+01)
         LD   H,(IX+02)
         CALL REVERSE
         JR   NC,AFFBAT2
         EX   DE,HL
AFFBAT2  PUSH HL
         PUSH DE
         CALL AFFSOLD

         LD   HL,BUFIMA
         CALL SETPAL
         LD   BC,#0303
         CALL #BC38
         LD   HL,EFFECTIF
         CALL MENUTEX0
         RET

AFFCHEV            ;DE-Chevaliers lord, HL-Chevaliers ennemi
         PUSH HL
         LD   BC,39*256+5
         LD   A,3
         LD   HL,256*30+137
         CALL PLACESPR
         POP  HL
         PUSH DE
         LD   BC,39*256+5
         EX   DE,HL
         LD   A,4
         LD   HL,256*105+137
         CALL PLACESPR
         POP  HL
         CALL REVERSE
         JR   NC,AFFCHEV0
         EX   DE,HL
AFFCHEV0 LD   (ATTKNIG),HL
         LD   (DEFKNIG),DE
         RET
AFFSOLD            ;DE-Soldats lord, HL-Soldats ennemi
         PUSH HL
         LD   BC,79*256+10
         LD   A,1
         LD   HL,256*55+135
         CALL PLACESPR
         POP  HL
         PUSH DE
         LD   BC,79*256+10
         EX   DE,HL
         LD   A,2
         LD   HL,256*80+135
         CALL PLACESPR
         POP  HL
         CALL REVERSE
         JR   NC,AFFSOLD0
         EX   DE,HL
AFFSOLD0 LD   (ATTSOLD),HL
         LD   (DEFSOLD),DE
         RET
PLACESPR
         LD   (SPRNO+1),A
         LD   (SPRCOO+1),HL
         LD   A,B
         LD   H,0
         LD   L,B
         LD   (PLMAX+1),A
         LD   B,0
         OR   A
         SBC  HL,DE
         JR   NC,PLA1
PLMAX    LD   DE,0
PLA1     EX   DE,HL
         ADD  HL,BC
         DEC  HL
         LD   DE,0
PLA0     OR   A
         SBC  HL,BC
         RET  C
         INC  E
         PUSH HL
         PUSH BC
SPRNO    LD   A,0
SPRCOO   LD   HL,0
         CALL LUTIN
         LD   D,A
         CALL LUTON
         LD   A,(SPRCOO+1)
         SUB  10
         LD   (SPRCOO+1),A
         LD   A,(SPRCOO+2)
         ADD  A,2
         LD   (SPRCOO+2),A
         POP  BC
         POP  HL
         JR   PLA0
;
;
;
ENNEMIA
         LD   E,(IX+01)
         LD   D,(IX+02)
         LD   L,(IX+03)
         LD   H,(IX+04)
         LD   B,5
         CALL MULT
         ADD  HL,DE
         SRL  H
         RR   L
         PUSH HL
         LD   E,(IY+08)
         LD   D,(IY+09)
         LD   L,(IY+10)
         LD   H,(IY+11)
         LD   B,5
         CALL MULT
         ADD  HL,DE
         POP  DE
         OR   A
         SBC  HL,DE
         JR   NC,NOWILD
KAMIKA   LD   A,0
         OR   A
         JR   NZ,NOWILD
         LD   A,(IY+0)       ;Si Joueur, pas de retraite
         CP   3
         JR   Z,NOWILD
         LD   A,6
         RET
NOWILD
         PUSH IX
         PUSH IY
         POP  IX
         LD   DE,8
         ADD  IX,DE
         CALL VIRT
         POP  IX
         RET

ENNEMID
         LD   A,(IX+00)
         OR   A
         JR   Z,NODEF
         LD   A,(CASTRESI)
         OR   A
         JR   Z,NODEF
         LD   A,5
         RET
NODEF
         INC  IX
         CALL VIRT
         DEC  IX
         RET

VIRT
         LD   A,2
         CALL CALCV2
         LD   (NMAX),HL
         CALL CALCV3
         PUSH HL
         LD   DE,(NMAX)
         OR   A
         SBC  HL,DE
         POP  HL
         JR   C,VIRT0
         LD   (NMAX),HL
         LD   A,3
VIRT0    CALL CALCV4
         LD   DE,(NMAX)
         OR   A
         SBC  HL,DE
         RET  C
         LD   A,4
         RET
NMAX     DEFS 2

CALCV2
         PUSH AF
         LD   L,(IX+00)
         LD   H,(IX+01)
         LD   B,2
         CALL MULT
         EX   DE,HL
         LD   L,(IX+02)
         LD   H,(IX+03)
         LD   B,10
         CALL MULT
         ADD  HL,DE
         EX   DE,HL
         LD   L,(IX+04)
         LD   H,(IX+05)
         LD   B,25
         CALL MULT
         ADD  HL,DE
         POP  AF
         RET
CALCV3
         PUSH AF
         LD   E,(IX+00)
         LD   D,(IX+01)
         LD   L,(IX+02)
         LD   H,(IX+03)
         LD   B,20
         CALL MULT
         ADD  HL,DE
         EX   DE,HL
         LD   L,(IX+04)
         LD   H,(IX+05)
         LD   B,25
         CALL MULT
         ADD  HL,DE
         POP  AF
         RET
CALCV4
         PUSH AF
         LD   E,(IX+00)
         LD   D,(IX+01)
         LD   L,(IX+02)
         LD   H,(IX+03)
         LD   B,10
         CALL MULT
         ADD  HL,DE
         EX   DE,HL
         LD   L,(IX+04)
         LD   H,(IX+05)
         LD   B,50
         CALL MULT
         ADD  HL,DE
         POP  AF
         RET
;
;
;
PLAYER
         LD   HL,MENUON
         LD   A,(HL)
         OR   A
         JP   NZ,NOMENU
         INC  (HL)
         LD   HL,AVAL+1
         LD   DE,AVAL+2
         PUSH HL
         LD   BC,4
         LD   (HL),0
         LDIR
         POP  DE
         LD   HL,NOOP
         CALL REVERSE
         JR   C,CH0
         LD   A,6
         LD   (DE),A
         INC  DE
         LD   HL,WILD
CH0      PUSH HL
         LD   HL,NOOP
         CALL REVERSE
         JR   NC,CH1
         LD   A,(IX+0)
         OR   A
         JR   Z,CH1
         LD   A,5
         LD   (DE),A
         INC  DE
         LD   HL,DEFENSIV
CH1      PUSH HL
         LD   HL,NOOP
         CALL REVERSE
         JR   C,DEF0
         LD   A,(IY+12)
         OR   (IY+13)
         JR   CH11
DEF0     LD   A,(IX+05)
         OR   (IX+06)
CH11     JR   Z,CH2
         LD   HL,CATAPULT
         LD   A,4
         LD   (DE),A
         INC  DE
CH2      PUSH HL
         LD   HL,NOOP
         CALL REVERSE
         JR   C,DEF1
         LD   A,(IY+10)
         OR   (IY+11)
         JR   CH21
DEF1     LD   A,(IX+03)
         OR   (IX+04)
CH21     JR   Z,CH3
         LD   HL,KNIGHT
         LD   A,3
         LD   (DE),A
         INC  DE
CH3      PUSH HL
         LD   HL,NOOP
         CALL REVERSE
         JR   C,DEF2
         LD   A,(IY+08)
         OR   (IY+09)
         JR   CH31
DEF2     LD   A,(IX+01)
         OR   (IX+02)
CH31     JR   Z,CH4
         LD   HL,STAND
         LD   A,2
         LD   (DE),A
         INC  DE
CH4      PUSH HL

         LD   HL,AVAL
TRI0     LD   A,(HL)
         OR   A
         JR   Z,TRIF
         LD   D,H
         LD   E,L
TRI1     INC  DE
         LD   A,(DE)
         OR   A
         JR   Z,TRI2
         CP   (HL)
         JR   NC,TRI1
         LD   B,(HL)
         LD   (HL),A
         LD   A,B
         LD   (DE),A
         JR   TRI1
TRI2     INC  HL
         JR   TRI0
TRIF
         LD   HL,OPTIONS
         CALL MENUTEX0
         JR   YESMENU
NOMENU
         CALL AFLECHE
         CALL MENUSEL
         CALL EFLECHE
YESMENU
         LD   HL,AVAL-1
         LD   D,0
         LD   E,A
         ADD  HL,DE
         LD   A,(HL)
         RET
NOOP     DEFB #FF
STAND    DEFB #F9,#FE,"Corps corps",#FE,#FF
KNIGHT   DEFB #F9,#FE,"Charge       ",#FE,#FF
CATAPULT DEFB #F9,#FE,"Catapultes   ",#FE,#FF
DEFENSIV DEFB #F9,#FE,"D[fensive    ",#FE,#FF
WILD     DEFB #F9,#FE,"Retraite     ",#FE,#FF
AVAL     DEFB 1,2,3,4,5,0
;
;EVENT(B-Indice Lord courant)
;
EVENT
         PUSH AF
         PUSH BC
         PUSH DE
         PUSH HL
         LD   A,B
         CALL LGETYPE
         LD   C,A
         LD   A,NB_EVENT
         CALL RND
         LD   HL,EVT_LIST
         CALL AIGUILLE
         CALL AFFINC
         CALL AFFARM
         POP  HL
         POP  DE
         POP  BC
         POP  AF
         RET
;
;EVENEMENTS(B-Lord,C-Type->1=player,2=saxon,3=normand)
;
EVT_LIST
         DEFW HALFINC
         DEFW CATAP
         DEFW REVOLTE
         DEFW DESERT
         DEFW VIKINGS
         DEFW DANES
         DEFW CHANGE
         DEFW NOINCOM
         DEFW KNIGHTS
         DEFW MONEY
;
;HALFINC
;
HALFINC
         LD   A,B
         CALL LGETINC
         SRL  H
         RR   L
         LD   A,H
         OR   A
         JR   NZ,OKHALF
         LD   A,L
         CP   4
         RET  C
OKHALF   PUSH HL
         LD   A,B
         CALL PAYE
         LD   A,C
         CP   3
         JR   Z,HALFLORD
         LD   A,B
         CALL GETLNAME
         PUSH HL
HALFLORD LD   A,C
         LD   HL,HALFTXT-2
         CALL RDTAB16
         LD   A,10
         CALL PLACARD
         RET
;
;CATAP
;
CATAP
         LD   A,B
         CALL LGETHOME
         CALL RGETCATA
         PUSH HL
         LD   HL,0
         CALL RPUTCATA
         LD   A,B
         CALL LGETCATA
         PUSH HL
         LD   HL,0
         CALL LPUTCATA
         POP  HL
         POP  DE
         LD   A,H
         OR   L
         JR   NZ,YESCATA
         LD   A,D
         OR   E
         RET  Z
YESCATA  LD   A,C
         CP   3
         JR   Z,CATALORD
         LD   A,B
         CALL GETLNAME
         PUSH HL
         LD   A,C
CATALORD LD   HL,CATATXT-2
         CALL RDTAB16
         LD   A,10
         CALL PLACARD
         RET
;
;REVOLTE
;
REVOLTE
         PUSH BC
         LD   A,B
         LD   HL,10
         LD   B,64
         CALL SOLD_PC
         POP  BC
         RET  NC
         PUSH HL
         LD   A,C
         CP   3
         JR   Z,REVOLORD
         LD   A,B
         CALL GETLNAME
         PUSH HL
REVOLORD LD   A,C
         CP   3
         CALL Z,YESPLOT
         LD   HL,REVOTXT-2
         CALL RDTAB16
         LD   A,10
         CALL PLACARD
         LD   A,C
         CP   3
         RET  NZ
         JP   AFFMAP
;
;
NBDESERT DEFS 2

DESERT
         PUSH BC
         LD   A,B
         LD   HL,10
         LD   B,64
         CALL SOLD_PC
         POP  BC
         RET  NC
         LD   (NBDESERT),HL
         EX   DE,HL
         LD   A,C
         CALL ENNEMI
         CALL LGETSOLD
         ADD  HL,DE
         CALL LPUTSOLD
         LD   E,A
         CALL ISJOUEUR
         JR   Z,DESLORD1
         LD   A,E
         CALL GETLNAME
         PUSH HL
DESLORD1 LD   A,C
         CP   3
         JR   Z,DESELORD
         LD   A,B
         CALL GETLNAME
         PUSH HL
DESELORD LD   HL,(NBDESERT)
         PUSH HL
         LD   HL,DESETXT0
         LD   A,C
         CP   3
         JR   Z,DESEAFF
         LD   HL,DESETXT1
         LD   A,E
         CALL ISJOUEUR
         JR   Z,DESEAFF
         LD   HL,DESETXT2
DESEAFF  LD   A,10
         CALL PLACARD
         RET

;
VIKINGS
         PUSH BC
         LD   A,B
         LD   HL,10
         LD   B,64
         CALL SOLD_PC
         POP  BC
         RET  NC
         PUSH HL
         LD   A,C
         CP   3
         JR   Z,VIKILORD
         LD   A,B
         CALL GETLNAME
         PUSH HL
VIKILORD LD   A,C
         LD   HL,VIKITXT-2
         CALL RDTAB16
         LD   A,10
         CALL PLACARD
         RET
;
DANES
         LD   A,B
         CALL TERRAIN
         OR   A
         RET  Z
         LD   D,A
         PUSH IX
         CALL GETREG
         LD   (IX+07),0
         POP  IX
         LD   A,C
         CP   3
         JR   Z,DANELORD
         LD   A,B
         CALL GETLNAME
         PUSH HL
DANELORD LD   A,D
         CALL GETRNAME
         PUSH HL
         LD   A,C
         LD   HL,DANETXT-2
         CALL RDTAB16
         LD   A,10
         CALL PLACARD
         LD   A,D
         CALL AFFREG
         RET
;
CHANGE
         LD   A,B
         CALL TERRAIN
         OR   A
         RET  Z
         LD   D,A
         LD   A,C
         CALL ENNEMI
         LD   E,A
         CALL ISJOUEUR
         JR   Z,CHANGE0
         LD   A,E
         CALL GETLNAME
         PUSH HL
CHANGE0  LD   A,C
         CP   2
         JR   NZ,CHANGE1
         LD   A,B
         CALL GETLNAME
         PUSH HL
         JR   CHANGE2
CHANGE1  CP   3
         CALL Z,YESPLOT
CHANGE2  LD   A,D
         CALL GETRNAME
         PUSH HL
         LD   HL,CHANTXT0
         LD   A,C
         CP   2
         JR   NZ,CHANGE3
         LD   HL,CHANTXT1
         LD   A,E
         CALL LGETYPE
         CP   1
         JR   Z,CHANGE3
         LD   HL,CHANTXT2
CHANGE3  LD   A,10
         CALL PLACARD
         PUSH DE
         LD   A,C
         CP   3
         CALL Z,AFFMAP
         POP  DE
         LD   A,D
         CALL GETREG
         LD   (IX+07),E
         LD   A,D
         CALL AFFREG
         RET
;
NOINCOM
         LD   A,B
         CALL TERRAIN
         OR   A
         RET  Z
         CALL GETRNAME
         PUSH HL
         PUSH IX
         CALL GETREG
         LD   A,(IX+08)	;   Renvoie le revenu apporte par la region.
         POP  IX
         LD   L,A
         LD   H,0
         LD   A,B
         CALL PAYE
         LD   A,C
         CP   3
         CALL Z,YESPLOT
         JR   Z,NOINLORD
         LD   A,B
         CALL GETLNAME
         PUSH HL
NOINLORD LD   HL,NOINTXT-2
         LD   A,C
         CALL RDTAB16
         LD   A,10
         CALL PLACARD
         LD   A,C
         CP   3
         RET  NZ
         JP   AFFMAP
;
KNIGHTS
         LD   A,C
         CP   3
         LD   A,B
         JR   Z,KNIGLORD
         CALL GETLNAME
         PUSH HL
KNIGLORD CALL LGETCHEV
         INC  HL
         INC  HL
         INC  HL
         CALL LPUTCHEV
         LD   A,C
         LD   HL,KNIGTXT-2
         CALL RDTAB16
         LD   A,10
         CALL PLACARD
         RET
;
MONEY
         LD   A,C
         CP   3
         LD   A,B
         JR   Z,MONELORD
         CALL GETLNAME
         PUSH HL
MONELORD LD   HL,20
         CALL ENCAISSE
         LD   A,C
         LD   HL,MONETXT-2
         CALL RDTAB16
         LD   A,10
         CALL PLACARD
         RET
;
;YESPLOT
;
YESPLOT
         PUSH AF
         PUSH HL
         PUSH DE
         PUSH BC
         LD   HL,PLOTTERS
	call load_decomp_scr
	call SETPAL
         CALL SETFLASH
         LD   A,3
         CALL WAIT_PAUSE
         POP  BC
         POP  DE
         POP  HL
         POP  AF
         RET
;
;ENNEMI
; <-A-Type du lord dont on cherche un ennemi(3,1->saxon 2->normand)
; ->A-Numero du lord ennemi
ENNEMI
         PUSH BC
         CP   2
         JR   NZ,ENNEMI1
         LD   A,4
         CALL RND
ENNEMI2  LD   B,A
         CALL ISDEAD
         JR   NZ,ENNEMOK
         LD   A,B
         INC  A
         CP   5
         JR   NZ,ENNEMI2
         LD   A,1
         JR   ENNEMI2
ENNEMI1  LD   A,5
         CALL RND
         ADD  A,4
ENNEMI3  LD   B,A
         CALL ISDEAD
         JR   NZ,ENNEMOK
         LD   A,B
         INC  A
         CP   10
         JR   NZ,ENNEMI3
         LD   A,5
         JR   ENNEMI3
ENNEMOK  LD   A,B
         POP  BC
         RET
;
;TERRAIN
; <-A-Lord dont on cherche une region libre
; ->A-Numero de la region libre (0 si aucune)
;
TERRAIN
         PUSH BC
         PUSH IX
         LD   C,A
         LD   A,18
         CALL RND
         LD   (TERRSTA+1),A
TERRAIN0 LD   B,A
         CALL GETREG
         LD   A,(IX+07)
         CP   C
         JR   NZ,TERRAIN2
         LD   A,(IX+00)
         OR   A
         JR   NZ,TERRAIN2
         LD   A,C
         CALL LGETREG
         CP   B
         JR   NZ,TERRAIN1
TERRAIN2 LD   A,B
         INC  A
         CP   19
         JR   NZ,TERRAIN0
         LD   A,1
TERRAIN3 LD   B,A
         CALL GETREG
         LD   A,(IX+07)
         CP   C
         JR   NZ,TERRAIN4
         LD   A,(IX+00)
         OR   A
         JR   NZ,TERRAIN4
         LD   A,C
         CALL LGETREG
         CP   B
         JR   NZ,TERRAIN1
TERRAIN4 LD   A,B
         INC  A
TERRSTA  CP   0
         JR   NZ,TERRAIN3
         LD   B,0
TERRAIN1 LD   A,B
         POP  IX
         POP  BC
         RET
;
TST_SOLD
         PUSH DE
         EX   DE,HL
         CALL LGETSOLD
         OR   A
         SBC  HL,DE
         CCF
         EX   DE,HL
         POP  DE
         RET

SOLD_PC
         CALL TST_SOLD
         RET  NC
         PUSH DE
         CALL LGETSOLD
         PUSH HL
         CALL DIMINUE
         CALL LPUTSOLD
         POP  DE
         EX   DE,HL
         OR   A
         SBC  HL,DE
         POP  DE
         SCF
         RET
;
	read "TEXTE_EVENT.ASM"
