;
;RAID.ASM     (c)1989 B.RIVE
;

	read	"LINK.ASM"

	write direct "a:RAID.BIN",BUFOVL

         ORG  BUFOVL
;
         JP   RAID
;
;Variables
;
LORD1    DEFS 1         ;Lord attaquant
LORD2    DEFS 1         ;Lord attaque
REGION   DEFS 1         ;Region attaquee
STAKE    DEFS 1         ;0=Tresor,1=Lady
HELP     DEFS 1         ;Aide de robin
;
;RAID(C-Region,A-0=tresor.1,2=Lady/#10,#20,#30,#40=Tuteur)
;      HL->ROB_HELP
RAID
         LD   (STAKE),A
         LD   A,(HL)
         AND  #80
         LD   (HELP),A
         RES  7,(HL)
         LD   HL,(LORD)
         LD   A,(HL)
         LD   (LORD1),A
         LD   A,C
         LD   (REGION),A
         CALL RGETPROP
         LD   (LORD2),A
         LD   HL,NORMLONG
         CP   5
         JR   NC,RAIDCHAT
         LD   HL,SAXLONG
RAIDCHAT
	call load_decomp_scr
	call SETPAL
         LD   HL,RAIDMUS
         CALL LOADMUS
         LD   A,(LORD2)
         CALL GETLNAME
         PUSH HL
         LD   A,3
         CALL WAIT_PAUSE
         LD   HL,RAIDMESS
         LD   A,12
         CALL PLACARD
         CALL OFF

         LD   HL,COURT
	call load_decomp_scr
         LD   HL,SONS
         LD   DE,MUSBUF
         CALL READFILE

         LD   HL,FIGHTERS
         LD   DE,SPRBUF
         CALL READFILE
         LD   HL,(ANIBUF)
         LD   (HL),E
         INC  HL
         LD   (HL),D
         CALL LUTINIT
         LD   A,1                 ;LORD
         LD   HL,10*256+56
         CALL LUTIN
         LD   A,7                 ;GUARD
         LD   HL,120*256+56
         CALL LUTIN
         LD   A,10
         LD   (LORDX),A
         LD   A,120
         LD   (GUARDX),A
         LD   A,(LORD1)
         CALL GETLORD
         LD   B,(IY+02)           ;SWORD
         LD   A,(HELP)
         OR   A
         LD   A,24
         CALL Z,CALCVU
         LD   (LORDVU),A
         CALL LVUMETRE
         LD   A,(LORD2)
         CALL GETLORD
         LD   B,(IY+02)
         CALL CALCVU
         LD   (GUARDVU),A
         CALL RVUMETRE
         LD   HL,BUFIMA
         CALL SETPAL
         CALL SETFLASH
         LD   A,124
         CALL FIGHT
         DEC  A
         JP   Z,PERDU
         DEC  A
         JP   Z,ABANDON

         LD   HL,INTERIOR
         LD   DE,BUFIMA
         CALL READFILE
         CALL BLACKOUT
         LD   HL,BUFIMA
         CALL DECOMP

         LD   HL,FIGHTERS
         LD   DE,SPRBUF
         CALL READFILE
         LD   HL,(ANIBUF)
         LD   (HL),E
         INC  HL
         LD   (HL),D
         CALL LUTINIT
         LD   A,1                 ;LORD
         LD   HL,10*256+56
         CALL LUTIN
         LD   A,7                 ;GUARD
         LD   HL,50*256+56
         CALL LUTIN
         LD   A,10
         LD   (LORDX),A
         LD   A,50
         LD   (GUARDX),A
         LD   A,(LORDVU)
         CALL LVUMETRE
         LD   A,(LORD2)
         CALL GETLORD
         LD   B,(IY+02)
         CALL CALCVU
         LD   (GUARDVU),A
         CALL RVUMETRE
         LD   HL,BUFIMA
         CALL SETPAL
         CALL SETFLASH
         LD   A,52
         CALL FIGHT
         DEC  A
         JP   Z,PERDU
         DEC  A
         JP   Z,ABANDON
GAGNE
         LD   A,(STAKE)
         OR   A
         JP   NZ,LADY

         LD   A,(LORD2)
         CALL GETLNAME
         PUSH HL
         LD   HL,0
         LD   B,128
         CALL PAYE_PC
         PUSH HL
         LD   A,(LORD1)
         CALL ENCAISSE
         LD   HL,TRESOR
         LD   A,10
         CALL PLACARD
         OR   A
         RET
CALCVU
         LD   A,-6
         LD   C,3
CALCVU0  ADD  A,C
         DJNZ CALCVU0
         RET

LADY
         LD   A,(STAKE)
         SRL  A
         SRL  A
         SRL  A
         SRL  A
         LD   B,A
         CALL ISJOUEUR
         JP   NZ,NOTMINE
         LD   A,(STAKE)
	and &03
         ADD  A,9
         CALL GETLNAME
         PUSH HL
         LD   A,(LORD2)
	ld c,a
         CALL GETLNAME
         PUSH HL
         LD   HL,REUNION
         LD   A,10
         CALL PLACARD
         OR   A
         RET
;
NOTMINE
         LD   A,(LORD1)
	ld b,a
         CALL LGETWIFE
         JP   Z,CELIBAT
         LD   A,(STAKE)
	and &03
         ADD  A,9
         CALL GETLNAME
         PUSH HL
         LD   A,(LORD2)
	ld c,a
         CALL GETLNAME
         PUSH HL
         LD   HL,RESCUE
         LD   A,10
         CALL PLACARD
         LD   A,B
         CALL LANDFREE
         JP   NC,NOLAND
         LD   A,C
         CALL GETRNAME
         PUSH HL
         LD   A,B
         CALL GETLNAME
         PUSH HL
         LD   A,(STAKE)
         AND  #03
         ADD  A,9
         CALL GETLNAME
         PUSH HL
         LD   A,(LORD1)
         LD   B,A
         CALL KADO
         LD   HL,WONAREG
         LD   A,10
         CALL PLACARD
         OR   A
         RET
NOLAND
         LD   A,(LORD1)
         CALL GETLORD
         LD   A,(IY+01)
         CP   10
         JR   NC,PASPLUS
         INC  (IY+01)
PASPLUS  LD   HL,RESPECT
         LD   A,10
         CALL PLACARD
         OR   A
         RET
;
CELIBAT
         LD   A,(STAKE)
         AND  #03
         ADD  A,9
         CALL GETLNAME
         PUSH HL
         LD   HL,GREATEST
         LD   A,10
         CALL PLACARD

         LD   HL,PRINCESS
         LD   DE,MUSBUF
         CALL READFILE
         LD   HL,BEDROOM
         LD   DE,BUFIMA
         CALL READFILE
         CALL BLACKOUT
         LD   HL,BUFIMA
         CALL DECOMP
         LD   HL,COUPLE1
         LD   DE,SPRBUF
         CALL READFILE
         LD   A,1
         LD   HL,36*256+140
         CALL AFFSPRB
         LD   A,2
         LD   HL,90*256+131
         CALL AFFSPRB
         LD   HL,BUFIMA
         CALL SETPAL
         CALL SETFLASH
         LD   HL,MUSBUF
         CALL ON
         LD   A,10
         CALL WAIT_PAUSE
         CALL ONOFF
         LD   HL,COUPLE2
         LD   DE,SPRBUF
         CALL READFILE
         LD   A,1
         LD   HL,36*256+140
         CALL AFFSPRB
         LD   A,2
         LD   HL,90*256+131
         CALL AFFSPRB
         LD   HL,COUPLE3
         LD   DE,SPRBUF
         CALL READFILE
         LD   A,1
         LD   HL,36*256+140
         CALL AFFSPRB
         LD   A,2
         LD   HL,90*256+131
         CALL AFFSPRB
         LD   HL,COUPLE4
         LD   DE,SPRBUF
         CALL READFILE
         LD   A,1
         LD   HL,36*256+140
         CALL AFFSPRB
         LD   A,2
         LD   HL,90*256+131
         CALL AFFSPRB
         LD   HL,COUPLE5
         LD   DE,SPRBUF
         CALL READFILE
         LD   A,1
         LD   HL,36*256+140
         CALL AFFSPRB
         LD   A,2
         LD   HL,90*256+131
         CALL AFFSPRB

         LD   HL,ROOMWALL
         LD   DE,BUFIMA
         CALL READFILE
         CALL BLACKOUT
         LD   HL,BUFIMA
         CALL DECOMP
         LD   HL,BLONDE
         LD   A,(STAKE)
         AND  #0F
         CP   2
         JR   Z,LEBLOND
         LD   HL,BRUNE
LEBLOND  LD   DE,SPRBUF
         CALL READFILE
         LD   HL,41*256+183
         LD   A,1
         CALL AFFSPR
         LD   HL,BUFIMA
         CALL SETPAL
         CALL ONOFF
         LD   A,10
         CALL WAIT_PAUSE
         CALL ONOFF

         LD   HL,ROOMWALL
         LD   DE,BUFIMA
         CALL READFILE
         CALL BLACKOUT
         LD   HL,BUFIMA
         CALL DECOMP
         LD   HL,BISOU1
         LD   DE,SPRBUF
         CALL READFILE
         LD   A,1
         LD   HL,42*256+175
         CALL AFFSPRB
         LD   HL,BUFIMA
         CALL SETPAL
         LD   HL,BISOU2
         LD   DE,SPRBUF
         CALL READFILE
         LD   A,1
         LD   HL,42*256+175
         CALL AFFSPRB
         LD   HL,BISOU3
         LD   DE,SPRBUF
         CALL READFILE
         LD   A,1
         LD   HL,42*256+175
         CALL AFFSPRB
         LD   HL,BISOU2
         LD   DE,SPRBUF
         CALL READFILE
         LD   A,1
         LD   HL,42*256+175
         CALL AFFSPRB
         LD   HL,BISOU3
         LD   DE,SPRBUF
         CALL READFILE
         LD   A,1
         LD   HL,42*256+175
         CALL AFFSPRB
         LD   A,2
         CALL WAIT_PAUSE

         LD   A,(LORD1)
	ld c,a
	ld a,(lord2)
	ld b,a
         call retire
         CALL KILL
	ld a,c
	ld c,b
         CALL GETLORD
         LD   A,(STAKE)
         RRCA
         RRCA
         AND  #C0
         OR   (IY+05)
         LD   (IY+05),A
         LD   A,C
         CALL GETLNAME
         PUSH HL
         LD   A,(STAKE)
	and &03
         ADD  A,9
         CALL GETLNAME
         PUSH HL
         LD   HL,MARIAGE
         LD   A,10
         CALL PLACARD
         CALL OFF
         OR   A
         RET
;
PERDU
         LD   A,3
         CALL WAIT_PAUSE
         LD   A,(LORD1)
         LD   B,128
         LD   HL,0
         CALL PAYE_PC
         LD   DE,PIECES
         LD   A,H
         OR   A
         JR   NZ,PLURIEL
         LD   A,L
         CP   2
         JR   NC,PLURIEL
         LD   DE,PIECE
PLURIEL  PUSH DE
         PUSH HL
         LD   A,(LORD2)
         CALL ENCAISSE
         LD   A,(LORD2)
         CALL GETLNAME
         PUSH HL
         LD   HL,CAPTURED
         LD   A,10
         CALL PLACARD
         JP   IFLADY
PIECES   DEFB "s"
PIECE    DEFB #FF
ABANDON
         LD   HL,RETRAITE
         LD   A,10
         CALL PLACARD
IFLADY   LD   A,(STAKE)
         OR   A
         RET  Z
         RRA
         RRA
         RRA
         RRA
         AND  #0F
         CALL ISJOUEUR
         JR   Z,MYGIRL
         CALL GETLNAME
         PUSH HL
         LD   A,(STAKE)
         AND  #0F
         ADD  A,9
         CALL GETLNAME
         PUSH HL
         LD   HL,RETLAD
         LD   A,5
         CALL PLACARD
         OR   A
         RET
;
MYGIRL   LD   A,(LORD1)
         LD   B,128
         LD   HL,0
         CALL PAYE_PC
         PUSH HL
         LD   A,(LORD2)
         CALL ENCAISSE
         LD   A,(LORD2)
         CALL GETLNAME
         PUSH HL
         LD   HL,RANCON
         LD   A,10
         CALL PLACARD
         OR   A
         RET
;
;FIGHT(A-x max)->A-1=PERDU,0=GAGNE,2=ABANDON
;
LORDX    DEFS 1
GUARDX   DEFS 1
LORDVU   DEFS 1
GUARDVU  DEFS 1
;
LORDM    DEFS 1
LORDT    DEFS 1
GUARDM   DEFS 1
GUARDT   DEFS 1
LBOT     DEFS 1
GBOT     DEFS 1
XMAX     DEFS 1
;
FSPEED   EQU  3
LTOUCHED EQU  2
GTOUCHED EQU  3
LMOVING  EQU  4
GMOVING  EQU  5
CLOSDIST EQU  20
;
FIGHT
         LD   HL,LORDM
         LD   B,6
F_INIT   LD   (HL),0
         INC  HL
         DJNZ F_INIT
         LD   (XMAX),A
         LD   A,1
         CALL GETLUT
         LD   A,B
         LD   (LARG1),A
         LD   A,C
         LD   (HAUT),A
         LD   (BUFF1),DE
         LD   (ADD1),HL
         LD   A,1
         LD   HL,SPRBUF
         CALL GETSPR
         LD   (SPRITE1),HL
         LD   A,2
         CALL GETLUT
         LD   A,B
         LD   (LARG2),A
         LD   (BUFF2),DE
         LD   (ADD2),HL
         LD   A,(IX+00)
         LD   HL,SPRBUF
         CALL GETSPR
         LD   (SPRITE2),HL
         JP   F_START
F_BCLE
         CALL MULTIDO

F_START  LD   A,FSPEED
         CALL MILPAUSE

         LD   A,(LORDT)
         OR   A
         JR   Z,F_NLTOUC
         DEC  A
         LD   (LORDT),A
         LD   A,(LORDX)
         CP   0
         JP   Z,F_ABAND
         DEC  A
         DEC  A
         LD   (LORDX),A
         LD   HL,#FE00
         LD   B,3
         CALL MULTSET1
         JP   F_GUARD
F_NLTOUC
         LD   A,(LORDM)
         OR   A
         JR   Z,F_NLMOVE
         CP   LMOVING/2
         DEC  A
         LD   (LORDM),A
         JP   NC,F_LNOP
         LD   HL,#0000
         LD   B,1
         CALL MULTSET1
         JP   F_GUARD
F_NLMOVE
         CALL GETJOY
         JR   NC,F_NLCLIC
         LD   A,LMOVING
         LD   (LORDM),A
         XOR  A
         LD   (LBOT),A
         LD   HL,#0000
         LD   B,4
         CALL MULTSET1
         CALL TSTCLOSE
         JR   C,LCLOSE
         JP   F_GUARD
LCLOSE   LD   A,(GUARDM)
         CP   GMOVING/2
         JR   C,HITG
         LD   A,8
         CALL BRUIT
         JP   F_GUARD
HITG     LD   A,9
         CALL BRUIT
         XOR  A
         LD   (GBOT),A
         LD   A,GTOUCHED
         LD   (GUARDT),A
         LD   A,(GUARDVU)
         DEC  A
         LD   (GUARDVU),A
         PUSH AF
         CALL RVUMETRE
         POP  AF
         JP   Z,F_GAGNE
         JP   F_GUARD
F_NLCLIC
         BIT  2,A
         JR   Z,F_NLLEFT
         LD   A,(LORDX)
         CP   0
         JP   Z,F_ABAND
         DEC  A
         DEC  A
         LD   (LORDX),A
         LD   A,(LBOT)
         INC  A
         LD   B,A
         CP   4
         JR   NZ,F_LBOTL0
         LD   B,2
         XOR  A
F_LBOTL0 LD   (LBOT),A
         LD   HL,#FE00
         CALL MULTSET1
         JP   F_GUARD
F_NLLEFT
         BIT  3,A
         JR   Z,F_NLRIGH
         CALL TSTCLOSE
         JP   C,F_LNOP
         LD   HL,LORDX
         INC  (HL)
         INC  (HL)
         LD   A,(LBOT)
         INC  A
         LD   B,A
         CP   4
         JR   NZ,F_LBOTR0
         LD   B,2
         XOR  A
F_LBOTR0 LD   (LBOT),A
         LD   HL,#0200
         CALL MULTSET1
         JP   F_GUARD
F_NLRIGH
         AND  #03
         JR   Z,F_LNOP
         LD   A,LMOVING
         LD   (LORDM),A
         XOR  A
         LD   (LBOT),A
         LD   HL,#0000
         LD   B,5
         CALL MULTSET1
         JP   F_GUARD
F_LNOP
         LD   HL,(ADD1)
         LD   (OLDADD1),HL

F_GUARD
         LD   A,(GUARDT)
         OR   A
         JR   Z,F_NGTOUC
         DEC  A
         LD   (GUARDT),A
         LD   A,(GUARDX)
         LD   HL,XMAX
         CP   (HL)
         JP   Z,F_GNOP
         INC  A
         INC  A
         LD   (GUARDX),A
         LD   HL,#0200
         LD   B,9
         CALL MULTSET2
         JP   F_BCLE
F_NGTOUC
         LD   A,(GUARDM)
         OR   A
         JR   Z,F_NGMOVE
         CP   GMOVING/2
         DEC  A
         LD   (GUARDM),A
         JP   NC,F_GNOP
         LD   B,7
         LD   HL,#0000
         CALL MULTSET2
         JP   F_BCLE
F_NGMOVE
         CALL TSTCLOSE
         JP   NC,F_NGTRY
         LD   A,4
         CALL RND
         CP   3
         JR   NZ,F_NGRIGH
         LD   A,(GUARDX)
         LD   HL,XMAX
         CP   (HL)
         JP   Z,F_GNOP
         INC  A
         INC  A
         LD   (GUARDX),A
         LD   A,(GBOT)
         INC  A
         LD   B,A
         CP   4
         JR   NZ,F_GBOTR0
         LD   B,2
         XOR  A
F_GBOTR0 LD   (GBOT),A
         LD   A,6
         ADD  A,B
         LD   B,A
         LD   HL,#0200
         CALL MULTSET2
         JP   F_BCLE
F_NGRIGH
         CP   2
         JR   Z,F_NGCLIC
         LD   A,GMOVING
         LD   (GUARDM),A
         XOR  A
         LD   (GBOT),A
         LD   B,10
         LD   HL,#0000
         CALL MULTSET2
         LD   A,(LORDM)
         CP   LMOVING/2
         JR   C,HITL
         LD   A,8
         CALL BRUIT
         JP   F_BCLE
HITL     LD   A,9
         CALL BRUIT
         XOR  A
         LD   (LBOT),A
         LD   A,LTOUCHED
         LD   (LORDT),A
         LD   A,(LORDVU)
         DEC  A
         LD   (LORDVU),A
         PUSH AF
         CALL LVUMETRE
         POP  AF
         JP   Z,F_PERDU
         JP   F_BCLE
F_NGCLIC
         LD   A,GMOVING
         LD   (GUARDM),A
         XOR  A
         LD   (GBOT),A
         LD   HL,#0000
         LD   B,11
         CALL MULTSET2
         JP   F_BCLE
F_NGTRY
         LD   HL,GUARDX
         LD   A,4
         CALL RND
         CP   4
         JR   NC,FRECUL0
         LD   DE,#FE00
         DEC  (HL)
         DEC  (HL)
         JR   FRECUL1
FRECUL0  LD   A,(XMAX)
         CP   (HL)
         JR   Z,F_GNOP
         LD   DE,#0200
         INC  (HL)
         INC  (HL)
FRECUL1
         LD   A,(GBOT)
         INC  A
         LD   B,A
         CP   4
         JR   NZ,F_GBOTL0
         LD   B,2
         XOR  A
F_GBOTL0 LD   (GBOT),A
         LD   A,6
         ADD  A,B
         LD   B,A
         EX   DE,HL
         CALL MULTSET2
         JP   F_BCLE
F_GNOP
         LD   HL,(ADD2)
         LD   (OLDADD2),HL
         JP   F_BCLE
;
F_ABAND
         LD   A,2
         RET
;
F_GAGNE
         LD   HL,(ADD2)
         LD   (OLDADD2),HL
         CALL MULTIDO
         LD   A,2
         CALL LUTOFF
         LD   A,1
         CALL LUTON
         LD   A,2
         CALL LUTSAVE
         CALL LUTON
         LD   HL,GUARDEAD
         CALL ANIMATE
         LD   A,1
         CALL LUTOFF
         LD   A,2
         CALL LUTON
         LD   A,1
         CALL LUTSAVE
         CALL LUTON
         LD   A,1
         PUSH IX
         CALL GETLUT
         LD   H,(IX+01)
         LD   L,(IX+02)
         POP  IX
         LD   A,1
         LD   B,1
         CALL LUTMODV
F_GAGNE0 LD   A,(LORDX)
         INC  A
         INC  A
         LD   (LORDX),A
         LD   HL,XMAX
         CP   (HL)
         JR   NC,F_GAGNE2
         LD   HL,#0200
         LD   A,(LBOT)
         INC  A
         LD   B,A
         CP   4
         JR   NZ,F_LBOTW0
         LD   B,2
         XOR  A
F_LBOTW0 LD   (LBOT),A
         CALL SPRMOVE
         LD   A,6
         CALL MILPAUSE
         JR   F_GAGNE0
F_GAGNE2 LD   A,0
         RET
GUARDEAD
         DEFB 2
         DEFB #BA,13,-7,0,30
         DEFB #BA,14,-27,0,30
;
F_PERDU
         CALL MULTIDO
         LD   A,1
         RET
;
TSTCLOSE
         PUSH BC
         LD   BC,(LORDX)
         LD   A,B
         SUB  C
         CP   CLOSDIST
         POP  BC
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
         ADD  A,3
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
SPRMOVE
         CALL MULTSET1
         LD   HL,(ADD1)
         LD   DE,(OLDADD1)
         LD   BC,(LARG1)
         CALL SUBST
         LD   (SPRMOFF+1),HL
         LD   HL,(BUFF1)
         LD   (SPRMBUF+1),HL
         LD   HL,(SPRITE1)
         LD   (SPRMSPR+1),HL
         LD   A,(LARG1)
         LD   (SPRMLA1+1),A
         LD   (SPRMLA2+1),A
         LD   (SPRMLA3+1),A

         LD   A,(HAUT)
         LD   B,A
         LD   DE,(OLDADD1)
         CALL TILLBOT

SPRMBCL
         PUSH BC

SPRMBUF  LD   HL,0
SPRMLA1  LD   BC,0
         PUSH DE
         LDIR

SPRMOFF  LD   HL,0
         ADD  HL,DE
         PUSH HL

         LD   DE,(SPRMBUF+1)
SPRMLA2  LD   BC,0
         LDIR
         LD   (SPRMBUF+1),DE

         POP  HL
SPRMSPR  LD   DE,0
SPRMLA3  LD   B,0
         CALL MERGE
         LD   (SPRMSPR+1),DE

         POP  DE
         LD   HL,#800
         ADD  HL,DE
         JR   NC,SPRMCAL
         LD   DE,-#3FB0
         ADD  HL,DE
SPRMCAL  EX   DE,HL

         POP  BC
         DJNZ SPRMBCL
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
;
;LVUMETRE(A-Intensite)
;
LVUMETRE
         PUSH BC
         PUSH HL

         LD   C,#C3               ;GREEN
         LD   HL,16*256+3         ;LEFT VU
         JR   VUMETRE
;
;RVUMETRE(A-Intensite)
;
RVUMETRE
         PUSH BC
         PUSH HL

         LD   C,#C0               ;RED
         LD   HL,96*256+3         ;RIGHT VU
;
VUMETRE  CALL SCRADD
         LD   B,3
VUMETR0
;VUFILL
         PUSH HL
         PUSH BC
         PUSH AF

         LD   B,24
VUFILL0  OR   A
         JR   NZ,VUFILL1
         LD   C,#0F          ;BLACK
VUFILL1  LD   (HL),C
         INC  HL
         DEC  A
         DJNZ VUFILL0

         POP  AF
         POP  BC
         POP  HL
         CALL   NEXTLINE
         DJNZ VUMETR0

         POP  HL
         POP  BC
         RET

	read "TEXTE_RAID.ASM"
