;
;
;JOUTE.ASM
;   (c)1989 B.RIVE
;

	read	"LINK.ASM"

	write direct "a:JOUTE.BIN",BUFOVL

         ORG  BUFOVL

         JP   JOUTE
;
;Variables
;
LORD1    DEFS 1
LORD2    DEFS 1
REGION1  DEFS 1
REGION2  DEFS 1
LORDSOUT DEFS 9
NBLORDS  DEFS 1
INDIC    DEFB 0
;
;Constantes
;
YTOOLOW  EQU  39
XBULL    EQU  48
YBULL    EQU  66
XMIN     EQU  30
XMAX     EQU  70
YMIN     EQU  8
YMAX     EQU  85

SELCODE  DEFB #FE,#FF
SELCODE2 DEFB #FE,#F9,#FF
NOPCODE  DEFB #FF

JOUST    DEFB JOUTE_SIDE,"JOUST   .MUS"
TRUMP    DEFB JOUTE_SIDE,"TRUMP   .DEF"
TENTS    DEFB JOUTE_SIDE,"TENTS   .DEF"
GALLERY  DEFB JOUTE_SIDE,"GALLERY .DEF"
JOUSTOP  DEFB JOUTE_SIDE,"JOUSTOP .DEF"
SIDE     DEFB JOUTE_SIDE,"SIDE    .DEF"
GKNIGHT  DEFB JOUTE_SIDE,"GKNIGHT .SPR"
CHARGE   DEFB JOUTE_SIDE,"CHARGE  .SPR"
JTOPSPR  DEFB JOUTE_SIDE,"JTOPSPR .SPR"
SIDEDEAD DEFB JOUTE_SIDE,"SIDEDEAD.SPR"
SIDEWON  DEFB JOUTE_SIDE,"SIDEWON .SPR"
SIDELOST DEFB JOUTE_SIDE,"SIDELOST.SPR"
SONS     DEFB JOUTE_SIDE,"DEFENDER.SON"
;
;JOUTE(A-LORD) -> CARRY=1 si interdit de joute
;
JOUTE
;
;JOUTINIT
;
         LD   (LORD1),A
         LD   HL,LORDSOUT
         ld bc,&0901
JOUTINI0 LD   (HL),c
         INC  HL
         DJNZ JOUTINI0
;
;JOUTRUMP
;
         LD   HL,TRUMP
	call load_decomp_scr
         LD   HL,JOUST
         CALL LOADMUS
         LD   HL,BUFIMA
         CALL SETPAL
         LD   A,5
         CALL WAIT_PAUSE
         LD   A,(LORD1)
         CALL GETLNAME
         PUSH HL
         LD   HL,TOURNOIS
         LD   A,10
         CALL PLACARD
         CALL OFF

         LD   HL,SONS
         LD   DE,MUSBUF
         CALL READFILE

JOUTNEXT
;
;TESTFIN
;
         LD   HL,LORDSOUT
         LD   B,9
TESTBCL  LD   A,(HL)
         INC  HL
         OR   A
         JR  NZ,TESTFIN_END
         DJNZ TESTBCL
         CALL GALLANIM
         LD   HL,JOUTVICT
         LD   A,10
         CALL PLACARD
         XOR  A
         RET    ; FIN JOUTE
TESTFIN_END
         CALL CASENLOR
         CALL NC,SELADV
         CALL SELSTAKE
         CALL RUNJOUTE
         CP   2
         JP   C,KILLEDIT
         JP   Z,WONIT
         LD   A,(REGION2)
         OR   A
         JR   Z,LOSTLEA
         CALL GETREG
         LD   A,(LORD2)
         LD   (IX+07),A
         LD   A,(LORD1)
         CALL GETLORD
         LD   A,(REGION2)
         CP   (IY+07)
         JR   NZ,JOUTEF
         LD   A,(LORD1)
         CALL LGETHOME
         LD   (IY+07),A
         JR   JOUTEF
LOSTLEA
         LD   A,(LORD1)
         CALL GETLORD
         LD   A,(IY+01)
         SUB  3
         JR   C,JOUTEF
         INC  A
         LD   (IY+01),A
JOUTEF
         OR   A
         RET
WONIT
         LD   A,(REGION1)
         OR   A
         JR   Z,WONLEA
         CALL GETREG
         LD   A,(LORD1)
         LD   (IX+07),A
         LD   A,(LORD2)
         CALL GETLORD
         LD   A,(REGION1)
         CP   (IY+07)
         JP   NZ,JOUTNEXT
         LD   A,(LORD2)
         CALL LGETHOME
         LD   (IY+07),A
         JP   JOUTNEXT
WONLEA
         LD   A,(LORD1)
         CALL GETLORD
         LD   A,(IY+01)
         ADD  A,2
         CP   11
         JR   C,OKNEWLEA
         LD   A,10
OKNEWLEA LD   (IY+01),A
         JP   JOUTNEXT
KILLEDIT
         LD   B,18
KILLBCLE LD   A,B
         CALL RGETPROP
         LD   HL,LORD1
         CP   (HL)
         JR   NZ,KILLSTRA
         LD   A,B
         CALL RGETBUIL
         OR   A
         JR   NZ,KILLSTRA
         LD   A,B
         CALL GETREG
         LD   (IX+07),0
KILLSTRA DJNZ KILLBCLE
         LD   A,(LORD1)
         CALL LGETHOME
         LD   HL,0
         CALL RPUTSOLD
         CALL RPUTCHEV
         CALL RPUTCATA
         LD   B,A
         LD   A,(LORD1)
         CALL GETLORD
         LD   (IY+07),B
         SCF
         RET
;
CASENLOR
         LD   A,(LORD1)
         CALL LGETYPE
         CP   3
         RET  Z

         LD   A,(LORD1)
         LD   (LORD2),A

         LD   HL,LORDSOUT-1
         LD   D,0
         LD   E,A
         ADD  HL,DE
         LD   (HL),d	; d=0

         LD   HL,(LORD)
         LD   A,(HL)
         LD   (LORD1),A
         SCF
         RET
;
SELADV
         CALL GALLANIM
         XOR  A
         LD   (NBLORDS),A
         LD   A,9
SELSCAN  LD   (LORD2),A
         LD   HL,LORDSOUT-1
         LD   E,A
         LD   D,0
         ADD  HL,DE
         LD   A,(HL)
         OR   A
         JR   Z,PAS_LA
         LD   A,(LORD2)
         CALL LGETYPE
         CP   3
         JR   Z,PAS_LA
         OR   A
         JR   Z,PAS_LA
         LD   HL,SELCODE2
         PUSH HL
         LD   A,(LORD2)
         CALL GETLNAME
         PUSH HL
         LD   HL,SELCODE
         PUSH HL
         LD   HL,NBLORDS
         INC  (HL)
         LD   A,(HL)
ECRI_TAB LD   DE,(LORD2)
         LD   D,0
         LD   HL,LORDSOUT-1
         ADD  HL,DE
         LD   (HL),A
         LD   A,(LORD2)
         DEC  A
         JR   NZ,SELSCAN
         JR   SCAN_FIN
PAS_LA   LD   HL,NOPCODE
         PUSH HL
         PUSH HL
         PUSH HL
         XOR  A
         JR   ECRI_TAB

SCAN_FIN LD   HL,JOUTSEL
         CALL MENUTEXT
         CALL MENUREST
         LD   D,A
         LD   A,(NBLORDS)
         CP   D
         JR   NC,SEL_OK
         CALL AFFMAP
JOUTEMAP CALL EXECARTE
         JR   NC,JOUTEMAP
         XOR  A
         LD   (INDIC),A
         JP   SELADV
SEL_OK   LD   HL,LORDSOUT-1
         SUB  D
         INC  A
         LD   D,0
RETRIEVE INC  HL
         INC  D
         CP   (HL)
         JR   NZ,RETRIEVE
         LD   (HL),0
         LD   A,D
         LD   (LORD2),A
         RET
;
SELSTAKE
         XOR  A
         LD   (REGION1),A
         LD   (REGION2),A
         LD   A,(LORD2)
         LD   D,A
         CALL TSTFREE
         JR   NC,NOREG
         LD   DE,(LORD1-1)
         CALL TSTFREE
         JR   C,YESREG
NOREG    LD   A,(LORD2)
         CALL GETLNAME
         PUSH HL
         LD   HL,FORFAME
         LD   A,7
         CALL PLACARD
         RET
YESREG   LD   HL,STAKES
         CALL MENUTEXT
         CALL MENUREST
         CP   1
         JR   Z,YESLEA
         CALL AFFMAP
SELREG   CALL CHOIXREG
         LD   (REGION1),A
         CALL RGETPROP
         LD   DE,(LORD2)
         CP   E
         JR   Z,YESHIS
         LD   HL,NOTHIS
         LD   A,5
         CALL PLACARD
         JR   SELREG
YESHIS   LD   A,(REGION1)
         CALL RGETBUIL
         OR   A
         JR   Z,YESEMPTY
         LD   HL,NOTEMPTY
         LD   A,5
         CALL PLACARD
         JR   SELREG
YESEMPTY CALL LORDCHOO
         LD   (REGION2),A
         CALL GETRNAME
         PUSH HL
         LD   A,(LORD2)
         CALL GETLNAME
         PUSH HL
         LD   HL,FORREG
         LD   A,7
         CALL PLACARD
         RET
YESLEA   LD   A,(LORD2)
         CALL GETLNAME
         PUSH HL
         LD   HL,FORLEAD
         LD   A,7
         CALL PLACARD
         RET
;
TSTFREE
         LD   B,18
TSTFR1   LD   A,B
         CALL RGETPROP
         CP   D
         JR   NZ,TSTFR2
         LD   A,B
         CALL RGETBUIL
         OR   A
         SCF
         RET  Z
TSTFR2   DJNZ TSTFR1
         OR   A
         RET
;
LORDCHOO
         PUSH BC
         PUSH HL
         LD   A,(LORD2)
         CALL LGETPREF
         LD   A,(LORD1)
         LD   C,A
LORDCHO0 LD   A,(HL)
         CALL RGETPROP
         CP   C
         JR   NZ,LORDCHO1
         LD   A,(HL)
         CALL RGETBUIL
         OR   A
         JR   Z,LORDCHO2
LORDCHO1 INC  HL
         LD   A,(HL)
         OR   A
         JR   NZ,LORDCHO0
LORDCHO2 LD   A,(HL)
         POP  HL
         POP  BC
         RET
;
;
;LANCE()
;
LANCE
         PUSH AF
         PUSH BC
         PUSH DE
         PUSH HL
         LD   HL,SPRNO
         INC  (HL)
         CALL GETJOY
         LD   C,A
         BIT  0,C
         JR   Z,LANC0
         LD   A,1
         LD   (DYL),A
LANC0    BIT  1,C
         JR   Z,LANC1
         LD   A,-1
         LD   (DYL),A
LANC1    BIT  2,C
         JR   Z,LANC2
         LD   A,-1
         LD   (DXL),A
LANC2    BIT  3,C
         JR   Z,LANC3
         LD   A,1
         LD   (DXL),A
LANC3
         LD   A,(DXL)
         LD   D,A
         LD   A,(DYL)
         LD   E,A
         CALL #BD19
         CALL EFFLANCE
         LD   A,(XLANCE)
         ADD  A,D
         ADD  A,D
         CP   XMIN
         JR   C,NOXMOV
         CP   XMAX
         JR   NC,NOXMOV
         LD   (XLANCE),A
NOXMOV   LD   A,(YLANCE)
         ADD  A,E
         ADD  A,E
         ADD  A,E
         ADD  A,E
         CP   YMIN
         JR   C,NOYMOV
         CP   YMAX
         JR   NC,NOYMOV
         LD   (YLANCE),A
NOYMOV   CALL AFFLANCE
         CALL LANCSPR

         LD   A,(SOUNDIND)
         INC  A
         CP   4
         JR   NZ,LANCE0
         XOR  A
LANCE0   LD   (SOUNDIND),A
         OR   A
         LD   A,5
         CALL Z,BRUIT
         POP  HL
         POP  DE
         POP  BC
         POP  AF
         RET
;
SOUNDIND DEFB 0
YLANCE   DEFB 0
XLANCE   DEFB 0
DXL      DEFS 1
DYL      DEFS 1
;
LANCSPR
         PUSH IX
         PUSH BC
         PUSH DE
         PUSH HL
         PUSH AF
         LD   A,(SPRNO)
         LD   HL,SPRBUF
         CALL GETSPR
         LD   IX,YLA
         LD   (IX+04),C
         LD   (IX+05),B
         LD   BC,(YLANCE)
         LD   (IX+00),C
         LD   (IX+01),B
         LD   (SPRADD),HL
         LD   HL,ANICHARG+3
         LD   DE,5
         LD   A,(SPRNO)
         CALL RDTAB
         LD   A,(HL)
         LD   (IX+02),A
         INC  HL
         LD   A,(HL)
         LD   (IX+03),A
         LD   B,11
         LD   DE,SCRBUF
LANCSPR0 CALL TEST
         INC  DE
         INC  (IX+01)
         INC  (IX+01)
         BIT  2,B
         JR   NZ,LANCSPR1
         CALL TEST
         INC  DE
LANCSPR1 INC  (IX+01)
         INC  (IX+01)
         CALL TEST
         INC  DE
         DEC  (IX+01)
         DEC  (IX+01)
         DEC  (IX+01)
         DEC  (IX+01)
         DEC  (IX+00)
         DEC  B
         JP   P,LANCSPR0
         POP  AF
         POP  HL
         POP  DE
         POP  BC
         POP  IX
         RET
;
TEST
         LD   A,(IX+03)
         CP   (IX+01)
         JR   C,TEST0
         RET  NZ
TEST0    ADD  A,(IX+05)
         ADD  A,(IX+05)
         CP   (IX+01)
         RET  C
         RET  Z
         LD   A,(IX+02)
         CP   (IX+00)
         RET  C
         SUB  (IX+04)
         INC  A
         CP   (IX+00)
         JR   C,TEST1
         RET  NZ
TEST1    LD   HL,(SPRADD)
         PUSH DE
         LD   A,(IX+01)
         SUB  (IX+03)
         SRL  A
         LD   E,A
         LD   D,0
         ADD  HL,DE
         LD   E,(IX+05)
         LD   A,(IX+02)
         SUB  (IX+00)
TEST2    OR   A
         JR   Z,TEST3
         ADD  HL,DE
         DEC  A
         JR   TEST2
TEST3    LD   A,(HL)
         LD   (HL),ROUGE
         POP  DE
         LD   (DE),A
         RET
;
YLA      DEFS 1
XLA      DEFS 1
YS       DEFS 1
XS       DEFS 1
DYS      DEFS 1
DXS      DEFS 1
SPRADD   DEFS 2
ROUGE    EQU  #C0
SPRNO    DEFS 1
;
LANCINIT
         LD   A,9
         CALL RND
         DEC  A
         SLA  A
         ADD  A,XBULL-8
         LD   (XLANCE),A
         LD   A,9
         CALL RND
         DEC  A
         SLA  A
         SLA  A
         ADD  A,YBULL-16
         LD   (YLANCE),A
         CALL AFFLANCE
         LD   A,1
         LD   (SPRNO),A
         LD   (DXL),A
         LD   (DYL),A
	jp LANCSPR
;
SCRBUF   DEFS 32
;
AFFLANCE
         PUSH HL
         PUSH DE
         PUSH BC
         PUSH AF
         LD   DE,SCRBUF
         LD   HL,(YLANCE)
         CALL SCRADD
         LD   B,11
AFFL0    PUSH HL
         LD   A,(HL)
         LD   (DE),A
         INC  DE
         LD   (HL),ROUGE
         INC  HL
         BIT  2,B
         JR   NZ,AFFL1
         LD   A,(HL)
         LD   (DE),A
         INC  DE
         LD   (HL),ROUGE
AFFL1    INC  HL
         LD   A,(HL)
         LD   (DE),A
         INC  DE
         LD   (HL),ROUGE
         POP  HL
         CALL NEXTLINE
         DEC  B
         JP   P,AFFL0
         POP  AF
         POP  BC
         POP  DE
         POP  HL
         RET
;
EFFLANCE
         PUSH HL
         PUSH DE
         PUSH BC
         PUSH AF
         LD   DE,SCRBUF
         LD   HL,(YLANCE)
         CALL SCRADD
         LD   B,11
EFFL0    PUSH HL
         LD   A,(DE)
         LD   (HL),A
         INC  DE
         INC  HL
         BIT  2,B
         JR   NZ,EFFL1
         LD   A,(DE)
         LD   (HL),A
         INC  DE
EFFL1    INC  HL
         LD   A,(DE)
         LD   (HL),A
         INC  DE
         POP  HL
         CALL NEXTLINE
         DEC  B
         JP   P,EFFL0
         POP  AF
         POP  BC
         POP  DE
         POP  HL
         RET
;
;
;GALLANIM()
;
GALLANIM
         LD   HL,GALLERY
	call load_decomp_scr
         LD   HL,GKNIGHT
         LD   DE,SPRBUF
         CALL READFILE

         LD   HL,(ANIBUF)
         LD   (HL),E
         INC  HL
         LD   (HL),D
         CALL LUTINIT
         LD   HL,256*0+174
         LD   A,1
         CALL AFFSPR
         LD   HL,256*34+97
         LD   A,2
         CALL LUTIN
         CALL LUTON
         LD   HL,256*36+60
         LD   A,4
         CALL LUTIN
         CALL LUTON
         LD   HL,BUFIMA
         CALL SETPAL
         LD   A,7
         LD   HL,256*126+71
         CALL LUTIN
         LD   A,9
         LD   HL,256*116+107
         CALL LUTIN
         LD   HL,ANIGAL
         LD   DE,RETADD
         CALL ANIMATEB
         LD   HL,INDIC
         LD   A,(HL)
         LD   (HL),1
         OR   A
         RET  Z
         LD   A,(LORD2)
         CALL GETLNAME
         PUSH HL
         LD   HL,TXTVICT
         LD   A,3
         CALL PLACARD
RETADD   RET
;
;RUNJOUTE
;
RUNJOUTE
RUNAGAIN LD   HL,JOUSTOP
	call load_decomp_scr
         LD   HL,JTOPSPR
         LD   DE,SPRBUF
         CALL READFILE

         LD   HL,(ANIBUF)
         LD   (HL),E
         INC  HL
         LD   (HL),D
         CALL LUTINIT
         LD   A,15
         CALL LUTIN
         LD   A,30
         CALL LUTIN
         LD   HL,BUFIMA
         CALL SETPAL
         LD   HL,TOPMOVE1
         CALL ANIMATE
         LD   B,2
         LD   HL,TOPMOVE2
RUNJOUT2 CALL ANIMATE
         DJNZ RUNJOUT2
         LD   HL,TOPMOVE3
         CALL ANIMATE
RUNJTST  LD   HL,TENTS
	call load_decomp_scr
         LD   HL,CHARGE
         LD   DE,SPRBUF
         CALL READFILE
         LD   HL,(ANIBUF)
         LD   (HL),E
         INC  HL
         LD   (HL),D
         CALL LUTINIT
         LD   A,19
         CALL LUTIN
         LD   HL,BUFIMA
         CALL SETPAL
         CALL LANCINIT
         LD   A,5
         CALL BRUIT
         LD   HL,ANICHARG
         LD   DE,LANCE
         CALL ANIMATEB
         LD   A,6
         CALL BRUIT
         LD   A,4
         CALL WAIT_PAUSE

         LD   A,(YLANCE)
         CP   YTOOLOW
         LD   A,1
         JR   C,VIEWJOUT

         LD   A,(LORD1)
         CALL GETLORD
         LD   A,(IY+03)
         INC  A
         SRL  A
         DEC  A
         DEC  A
         LD   B,A
         LD   A,(XLANCE)
         SUB  XBULL
         JR   NC,DXPOS
         NEG
DXPOS    SRL  A
         CP   B
         JR   NC,LRATE
         LD   A,(YLANCE)
         SUB  YBULL
         JR   NC,DYPOS
         NEG
DYPOS    SRL  A
         SRL  A
         CP   B
         JR   NC,LRATE
         LD   A,2
         JR   VIEWJOUT

LRATE
         LD   A,(LORD2)
         CALL GETLORD
         LD   B,(IY+03)
         LD   A,10
         CALL RND
         CP   B
         JR   NC,NRATE
         LD   A,3
         JR   VIEWJOUT

NRATE
         LD   A,4

VIEWJOUT
         PUSH AF
         LD   HL,SIDE
	call load_decomp_scr
         POP  AF

         PUSH AF
         LD   HL,SIDEDEAD
         CP   2
         JR   C,SIDEFILE
         LD   HL,SIDEWON
         JR   Z,SIDEFILE
         LD   HL,SIDELOST
SIDEFILE LD   DE,SPRBUF
         CALL READFILE

         LD   HL,(ANIBUF)
         LD   (HL),E
         INC  HL
         LD   (HL),D
         CALL LUTINIT
         LD   A,3
         LD   HL,256*110+76
         CALL LUTIN
         LD   A,1
         LD   HL,76
         CALL LUTIN
         LD   HL,BUFIMA
         CALL SETPAL
         LD   B,11
SIDEBCL
         PUSH BC
         LD   B,4
         LD   HL,#FE00
         CALL MULTSET1
         LD   B,2
         LD   HL,#0200
         CALL MULTSET2
         CALL MULTIDO
         LD   B,3
         LD   HL,#FE00
         CALL MULTSET1
         LD   B,1
         LD   HL,#0200
         CALL MULTSET2
         CALL MULTIDO
         POP  BC
         DJNZ SIDEBCL

	POP  AF
	PUSH AF

         LD   IX,ANIMKILL
         LD   B,8
         DEC  A
         JR   Z,SIDEOPT
         LD   IX,ANIMWON
         LD   B,8
         DEC  A
         JR   Z,SIDEOPT
         LD   B,6
         LD   IX,ANIMLOST
         DEC  A
         JR   Z,SIDEOPT
         LD   B,6
         LD   IX,ANIMNUL
SIDEOPT
         PUSH BC
         LD   B,(IX+00)
         INC  IX
         LD   H,(IX+00)
         INC  IX
         LD   L,0
         PUSH IX
         CALL MULTSET1
         POP  IX
         LD   B,(IX+00)
         INC  IX
         LD   H,(IX+00)
         INC  IX
         LD   L,0
         PUSH IX
         CALL MULTSET2
         CALL MULTIDO
         POP  IX
         POP  BC
         DJNZ SIDEOPT

         POP  AF
         PUSH AF
         LD   HL,TXTKILL
         DEC  A
         JR   Z,SIDEOPT2
         LD   HL,TXTWON
         DEC  A
         JR   Z,SIDEOPT2
         LD   HL,TXTLOST
         DEC  A
         JR   Z,SIDEOPT2
         LD   HL,TXTNUL
SIDEOPT2 LD   A,10
         CALL PLACARD
         POP  AF
         CP   4
         JP   Z,RUNAGAIN
         RET
;
MULTSET1
         PUSH BC
         PUSH HL
         LD   A,1
         CALL GETLUT
         LD   A,B
         LD   (LARG1),A
         LD   A,C
         LD   (HAUT),A
         LD   (OLDADD1),HL
         LD   (BUFF1),DE
         POP  HL
         LD   A,(IX+01)
         ADD  A,H
         LD   (IX+01),A
         LD   H,A
         LD   A,(IX+02)
         ADD  A,L
         LD   (IX+02),A
         LD   L,A
         CALL SCRADD
         LD   (ADD1),HL
         POP  BC
         LD   (IX+00),B
         LD   A,B
         LD   HL,SPRBUF
         CALL GETSPR
         LD   (SPRITE1),HL
         RET
MULTSET2
         PUSH BC
         PUSH HL
         LD   A,2
         CALL GETLUT
         LD   A,B
         LD   (LARG2),A
         LD   A,C
         LD   (HAUT),A
         LD   (OLDADD2),HL
         LD   (BUFF2),DE
         POP  HL
         LD   A,(IX+01)
         ADD  A,H
         LD   (IX+01),A
         LD   H,A
         LD   A,(IX+02)
         ADD  A,L
         LD   (IX+02),A
         LD   L,A
         CALL SCRADD
         LD   (ADD2),HL
         POP  BC
         LD   (IX+00),B
         LD   A,B
         LD   HL,SPRBUF
         CALL GETSPR
         LD   (SPRITE2),HL
         RET
;
MULTIDO
         LD   HL,(OLDADD2)
         LD   DE,(OLDADD1)
         LD   BC,(LARG1)
         CALL SUBST
         LD   (OFFSET1+1),HL
         LD   HL,(ADD1)
         LD   DE,(OLDADD2)
         LD   BC,(LARG2)
         CALL SUBST
         LD   (OFFSET2+1),HL
         LD   HL,(ADD2)
         LD   DE,(ADD1)
         LD   BC,(LARG1)
         CALL SUBST
         LD   (OFFSET3+1),HL
         LD   (OFFSET5+1),HL
         LD   HL,(ADD1)
         LD   DE,(ADD2)
         LD   BC,(LARG2)
         CALL SUBST
         LD   (OFFSET4+1),HL
         LD   HL,(BUFF1)
         LD   (BF1+1),HL
         LD   HL,(BUFF2)
         LD   (BF2+1),HL
         LD   HL,(SPRITE1)
         LD   (SPR1+1),HL
         LD   HL,(SPRITE2)
         LD   (SPR2+1),HL
         LD   A,(LARG1)
         LD   (LA10+1),A
         LD   (LA11+1),A
         LD   (LA12+1),A
         LD   A,(LARG2)
         LD   (LA20+1),A
         LD   (LA21+1),A
         LD   (LA22+1),A
         LD   A,(LARG1)
         LD   C,A
         LD   A,(LARG2)
         ADD  A,C
         ADD  A,10
         LD   C,A
         LD   B,0
         LD   HL,312
         LD   DE,(HAUT)
         LD   D,0
         OR   A
         SBC  HL,DE
         LD   D,-1
CALCBCL  SBC  HL,BC
         INC  D
         JR   NC,CALCBCL
         LD   A,D
         LD   (NLIG+1),A
         LD   A,(HAUT)
         LD   B,A
         LD   DE,(OLDADD1)
         CALL TILLBOT

MULTBCL
         PUSH BC

BF1      LD   HL,0
LA10     LD   BC,0
         PUSH DE
         LDIR

OFFSET1  LD   HL,0
         ADD  HL,DE
         EX   DE,HL
BF2      LD   HL,0
LA20     LD   BC,0
         LDIR

OFFSET2  LD   HL,0
         ADD  HL,DE
         LD   DE,(BF1+1)
LA11     LD   BC,0
         LDIR
         LD   (BF1+1),DE

OFFSET3  LD   DE,0
         ADD  HL,DE
         LD   DE,(BF2+1)
LA21     LD   BC,0
         LDIR
         LD   (BF2+1),DE

OFFSET4  LD   DE,0
         ADD  HL,DE
SPR1     LD   DE,0
LA12     LD   B,0
         CALL MERGE
         LD   (SPR1+1),DE

OFFSET5  LD   DE,0
         ADD  HL,DE
SPR2     LD   DE,0
LA22     LD   B,0
         CALL MERGE
         LD   (SPR2+1),DE

         POP  DE
         LD   HL,#800
         ADD  HL,DE
         JR   NC,NOCARR
         LD   DE,-#3FB0
         JR   YECARR
NOCARR   LD   DE,#0000
         ADD  A,(HL)
YECARR   ADD  HL,DE
         EX   DE,HL

         POP  BC
         DEC  C
         CALL Z,TILLBOT
         DEC  B
         JP   NZ,MULTBCL

         EI
         RET
;
MERGE
MERGE10  LD   A,(DE)
         AND  #55
         JR   NZ,MERGE11
         LD   A,(HL)
         AND  #55
         JR   MERGE12
MERGE11  PUSH HL
         POP  HL
MERGE12  LD   C,A
         LD   A,(DE)
         AND  #AA
         JR   NZ,MERGE13
         LD   A,(HL)
         AND  #AA
         JR   MERGE14
MERGE13  PUSH HL
         POP  HL
MERGE14  OR   C
         LD   (HL),A
         INC  HL
         INC  DE
         BIT  0,(HL)
         BIT  0,(IX+00)
         DJNZ MERGE10
         RET
;
SUBST
         LD   B,0
         OR   A
         SBC  HL,BC
         OR   A
         SBC  HL,DE
         RET
;
TILLBOT
         PUSH BC
         LD   B,#F5
TBWAIT   EI
         DI
         IN   A,(C)
         RRA
         JR   NC,TBWAIT
         POP  BC
NLIG     LD   C,0
         RET
;
HAUT     DEFS 1
LARG1    DEFS 1
LARG2    DEFS 1
;
BUFF1    DEFS 2
OLDADD1  DEFS 2
ADD1     DEFS 2
SPRITE1  DEFS 2
;
BUFF2    DEFS 2
OLDADD2  DEFS 2
ADD2     DEFS 2
SPRITE2  DEFS 2
;
ANIMKILL
         DEFB 4,-2
         DEFB 5,2
         DEFB 3,-2
         DEFB 6,2
         DEFB 4,-2
         DEFB 7,4
         DEFB 3,-2
         DEFB 8,4
         DEFB 4,-2
         DEFB 9,6
         DEFB 3,-2
         DEFB 10,6
         DEFB 4,-2
         DEFB 11,6
         DEFB 3,-2
         DEFB 12,0
;
ANIMWON
         DEFB 4,-2
         DEFB 5,2
         DEFB 3,-2
         DEFB 6,1
         DEFB 4,-2
         DEFB 7,0
         DEFB 3,-2
         DEFB 8,1
         DEFB 4,-2
         DEFB 9,0
         DEFB 3,-2
         DEFB 10,1
         DEFB 4,-2
         DEFB 11,4
         DEFB 3,-2
         DEFB 12,7
;
ANIMLOST
         DEFB 5,-1
         DEFB 2,2
         DEFB 6,1
         DEFB 1,2
         DEFB 7,-1
         DEFB 2,2
         DEFB 8,0
         DEFB 1,2
         DEFB 9,-1
         DEFB 2,2
         DEFB 10,-2
         DEFB 1,2
;
ANIMNUL
         DEFB 4,-2
         DEFB 2,2
         DEFB 3,-2
         DEFB 1,2
         DEFB 4,-2
         DEFB 2,2
         DEFB 3,-2
         DEFB 1,2
         DEFB 4,-2
         DEFB 2,2
         DEFB 3,-2
         DEFB 1,2
;
ANIGAL
         DEFB 10
         DEFB #2C,10,40
         DEFB #2A,5,20
         DEFB #2A,6,20
         DEFB #29,3,20
         DEFB #2B,8,100
         DEFB #2C,9,40
         DEFB #29,2,20
         DEFB #2A,5,20
         DEFB #2A,4,20
         DEFB #23,7
;
ANICHARG
         DEFB 19
         DEFB #39,1,96,62,20
         DEFB #39,2,96,62,20
         DEFB #39,3,94,60,20
         DEFB #39,4,93,58,20
         DEFB #39,5,93,58,20
         DEFB #39,6,92,56,20
         DEFB #39,7,91,56,20
         DEFB #39,8,90,52,20
         DEFB #39,9,91,52,20
         DEFB #39,10,91,50,20
         DEFB #39,11,91,50,20
         DEFB #39,12,90,48,20
         DEFB #39,13,88,48,20
         DEFB #39,14,86,46,20
         DEFB #39,15,85,42,20
         DEFB #39,16,86,40,20
         DEFB #39,17,86,40,20
         DEFB #39,18,87,36,20
         DEFB #39,19,87,36,20
;
TOPMOVE1
         DEFB 16
         DEFB #31,1,120,36
         DEFB #3A,16,120,116,20
         DEFB #31,2,118,34
         DEFB #3A,17,118,120,20
         DEFB #31,3,113,32
         DEFB #3A,18,114,124,20
         DEFB #31,4,113,34
         DEFB #3A,19,114,126,20
         DEFB #31,5,110,34
         DEFB #3A,20,114,126,20
         DEFB #31,6,103,32
         DEFB #3A,21,108,122,20
         DEFB #31,7,101,36
         DEFB #3A,22,108,116,20
         DEFB #31,8,102,36
         DEFB #3A,23,109,110,20
TOPMOVE2
         DEFB 8
         DEFB #B1,9,0,1
         DEFB #BA,24,0,255,6
         DEFB #B1,10,0,3
         DEFB #BA,25,0,255,6
         DEFB #B1,11,0,1
         DEFB #BA,26,0,255,6
         DEFB #B1,8,0,1
         DEFB #BA,23,0,253,6
TOPMOVE3
         DEFB 8
         DEFB #B1,12,0,2
         DEFB #BA,27,0,254,9
         DEFB #B1,13,0,2
         DEFB #BA,28,0,254,9
         DEFB #B1,14,0,3
         DEFB #BA,29,0,253,9
         DEFB #B1,15,0,4
         DEFB #BA,30,0,252,9
;
	read "TEXTE_JOUTE.ASM"
