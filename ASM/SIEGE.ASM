;
;SIEGE.ASM
;

	read	"LINK.ASM"

	write direct "a:SIEGE.BIN",BUFOVL

         ORG  BUFOVL

;
;
;EXESIEGE(A-LORD1,B-LORD2,C-REGION) -> A-CASTRESI
;
         JP   EXESIEGE
;
SAXLONG  DEFB "2SAXLONG .DEF"
NORMLONG DEFB "2NORMLONG.DEF"
SPRSIEGE DEFB "2SPRSIEGE.SPR"
SIEGE    DEFB "2SIEGE   .MUS"
SCASTLE  DEFB "2SCASTLE .DEF"
NCASTLE  DEFB "2NCASTLE .DEF"
MCATSPR  DEFB "2MCATSPR .SPR"
CATANIM  DEFB "2CATANIM .SPR"
CATSPR   DEFB "2CATSPR  .SPR"
SONS     DEFB "2DEFENDER.SON"
;
DAYS     DEFS 1
CASTLE   DEFS 1
BOULDERS DEFS 1
GREEKS   DEFS 1
DISEASE  DEFS 1
SIEGVAL  DEFB 7,10,8,3,1
SIEGCAST DEFS 2
LORD1    DEFS 1
LORD2    DEFS 1
REGION   DEFS 1
PROJECT  DEFS 1
POWER    DEFS 1
DISTAB   DEFB 0,25,51,76,102,128
LOWTAB   DEFB 1,10,17,22,26,29,32
;
;
EXESIEGE
         LD   (LORD1),A
         LD   A,B
         LD   (LORD2),A
         LD   A,C
         LD   (REGION),A

         LD   HL,SIEGVAL
         LD   DE,DAYS
         LD   BC,5
         LDIR
         LD   A,(LORD2)
         CALL LGETYPE
         LD   HL,SAXLONG
         DEC  A
         PUSH AF
         JR   Z,ESSAXON
         LD   HL,NORMLONG
ESSAXON
	call load_decomp_scr
         LD   HL,SPRSIEGE
         LD   DE,SPRBUF
         CALL READFILE
         POP  AF
         PUSH AF
         LD   A,2
         LD   HL,28*256+85
         JR   NZ,ESSAXON3
         LD   A,1
         LD   HL,36*256+92
ESSAXON3 CALL AFFSPR
         LD   HL,SIEGE
         CALL LOADMUS
         LD   HL,BUFIMA
         CALL SETPAL
         LD   A,8
         CALL WAIT_PAUSE
         LD   HL,SCASTLE
         POP  AF
         JR   Z,ESSAXON2
         LD   HL,NCASTLE
ESSAXON2 LD   (SIEGCAST),HL
         CALL ONOFF
         LD   A,2
         LD   (LORDCOL+1),A
         CALL AFFSIEGE
         CALL ONOFF
         LD   A,4
         CALL WAIT_PAUSE
         LD   A,(LORD2)
         CALL GETLNAME
         PUSH HL
         LD   HL,SIEGTXT
         LD   A,14
         CALL PLACARD
         CALL OFF
ESMENU
         LD   HL,MCATSPR
         LD   DE,MUSBUF
         CALL READFILE
         LD   HL,(DAYS)
         LD   H,0
         PUSH HL
         LD   A,(CASTLE)
         LD   DE,10
         LD   HL,0
         LD   B,A
ESCASCAL ADD  HL,DE
         DJNZ ESCASCAL
         PUSH HL
         LD   A,(REGION)
         CALL RGETCATA
         PUSH HL
         LD   A,(LORD1)
         CALL LGETCATA
         PUSH HL
         LD   A,(REGION)
         CALL RGETCHEV
         PUSH HL
         LD   A,(LORD1)
         CALL LGETCHEV
         PUSH HL
         LD   A,(REGION)
         CALL RGETSOLD
         PUSH HL
         LD   A,(LORD1)
         CALL LGETSOLD
         PUSH HL
         LD   A,1
         LD   HL,(RETSIEGE)
         LD   (HL),A
         LD   HL,SIEGMENU
         CALL MENUTEXT
         XOR  A
         LD   HL,(RETSIEGE)
         LD   (HL),A
         CALL MAFFPROJ
ESCHOOSE CALL MENUTEX1
         CP   4
         JP   Z,RENVOIE

         LD   HL,BOULDERS-1
         LD   E,A
         LD   D,0
         ADD  HL,DE
         LD   C,(HL)
         DEC  C
         JP   M,ESCHOOSE
         DEC  (HL)
         PUSH AF
         CALL MENUREST
         LD   HL,CATANIM
         LD   DE,SPRBUF
         CALL READFILE
         POP  AF

         CALL EXETHROW       ;A-Type de projectile
         CALL MUSBUF+3
         LD   HL,DAYS
         DEC  (HL)
         LD   A,(HL)
         OR   A
         JP   Z,RENVOIE
         LD   A,1
         CALL MILPAUSE
         JP   ESMENU
RENVOIE
         LD   A,(CASTLE)
         RET

AFFSIEGE
	call load_decomp_scr
         LD   HL,CATSPR
         LD   DE,SPRBUF
         CALL READFILE
         LD   A,2           ;CATAPULTE
         LD   HL,256*64+57
         CALL AFFSPR
         LD   A,3           ;SOLDATS
         LD   HL,256*8+68
         CALL AFFSPR
         LD   A,4           ;CHEVALIER
         LD   HL,256*128+98
         CALL AFFSPR
         LD   HL,CATANIM
         LD   DE,SPRBUF
         CALL READFILE
         LD   HL,(ANIBUF)
         LD   (HL),#00
         INC  HL
         LD   (HL),#34
         CALL LUTINIT
         LD   A,7
         LD   HL,256*80+58
         CALL LUTIN          ;PANIER
         LD   B,1
         LD   HL,256*80+58
         CALL LUTMODV
         LD   A,48
         LD   HL,256*82+123
         CALL LUTIN          ;MUR
         LD   B,42
         LD   HL,256*82+123
         CALL LUTMODV
         CALL LUTOFF
         LD   HL,256*82+102
         LD   A,9
         CALL LUTIN          ;PROJECTILE
         CALL LUTOFF
         LD   HL,BUFIMA
         CALL SETPAL
         CALL SETFLASH
LORDCOL  LD   B,2
         LD   C,B
         LD   A,9
	jp #BC32          ;SCR SET INK
;
MAFFPROJ
         LD   A,(BOULDERS)
         OR   A
         JR   Z,MAFFGREE
         LD   B,A
         LD   A,1
         LD   HL,256*60+100
         CALL MAFFPRO0
MAFFGREE LD   A,(GREEKS)
         OR   A
         JR   Z,MAFFDIS
         LD   B,A
         LD   A,2
         LD   HL,256*60+84
         CALL MAFFPRO0
MAFFDIS  LD   A,(DISEASE)
         OR   A
         RET  Z
         LD   B,A
         LD   A,3
         LD   HL,256*60+68
MAFFPRO0
         PUSH DE
         PUSH BC
         PUSH HL
         CALL SCRADD
         EX   DE,HL
         LD   HL,MUSBUF
         CALL GETSPR
         EX   DE,HL
         CALL PUTSPR
         POP  HL
         POP  BC
         POP  DE
         PUSH AF
         LD   A,8
         ADD  A,H
         LD   H,A
         POP  AF
         DJNZ MAFFPRO0
         RET
;
EXETHROW
         PUSH AF
         LD   HL,SONS
         LD   DE,MUSBUF
         CALL READFILE
         POP  AF
         LD   (PROJECT),A
         LD   B,A
         ADD  A,4
         LD   C,A            ;C=Load2 correspondant au projectile
         INC  B              ;B=Load1 correspondant au projectile
         LD   C,B
         LD   A,1
         LD   HL,256*80+58
         CALL LUTMODV
EXETHRO0 CALL GETJOY
         JR   NC,EXETHRO0
         LD   B,16
         LD   HL,256*80+56
EXETHRO1 PUSH BC
         LD   A,1
         DEC  L
         LD   B,C
         CALL LUTMODV
         LD   A,2
         CALL BRUIT
         LD   A,15
         CALL MILPAUSE
         CALL GETJOY
         POP  BC
         JR   C,EXETHCLI
         DJNZ EXETHRO1
EXETHCLI LD   A,55
         SUB  L
         SRL  A
         ADD  A,4            ;A = 4 -> 11
         LD   (POWER),A
         LD   A,1
         LD   B,C
         LD   L,76
         CALL LUTMODV
         LD   A,3
         CALL BRUIT
         LD   A,20
         CALL MILPAUSE
         LD   A,1
         LD   B,8
         LD   HL,256*82+84
         CALL LUTMODV

         LD   A,(POWER)
         LD   HL,MONTTAB-12
         LD   E,A
         LD   D,0
         ADD  HL,DE
         ADD  HL,DE
         ADD  HL,DE
         LD   IX,MONT+8
         LD   B,3
         LD   DE,5
SETPENT  LD   A,(HL)
         LD   (IX+00),A
         INC  HL
         ADD  IX,DE
         DJNZ SETPENT

         LD   A,(PROJECT)
         DEC  A
         JP   Z,ISBOULD
         DEC  A
         JP   Z,ISGREEK
ISDISEAS
         LD   A,20
         CALL SETMONT
         LD   HL,MONT
         CALL ANIMATE
         LD   A,(POWER)
         LD   BC,(CASTLE)
         SUB  C
         JR   Z,DISREB
         JR   C,DISREB
         CP   1
         LD   A,28
         JP   NZ,ISOVER
         LD   DE,(DAYS)
         LD   D,0
         LD   HL,DISTAB-1
         ADD  HL,DE
         LD   B,(HL)
         LD   A,(REGION)
         CALL RGETSOLD
         CALL DIMINUE
         CALL RPUTSOLD
         LD   A,9
         CALL BRUIT
         LD   A,28
         JP   ISOVER
DISREB   LD   A,28
         JP   ISLOW
ISGREEK
         LD   A,31
         CALL SETMONT
         LD   HL,MONT
         CALL ANIMATE
         LD   A,(POWER)
         LD   BC,(CASTLE)
         SUB  C
         JR   Z,GREREB
         JR   C,GREREB
         CP   1
         LD   A,39
         JP   NZ,ISOVER
         LD   B,25
         LD   A,(REGION)
         CALL RGETSOLD
         CALL DIMINUE
         CALL RPUTSOLD
         LD   A,9
         CALL BRUIT
         LD   A,39
         JP   ISOVER
GREREB   LD   A,39
         JP   ISLOW

ISBOULD
         LD   A,9
         CALL SETMONT
         LD   HL,MONT
         CALL ANIMATE
         LD   A,(POWER)
         LD   BC,(CASTLE)
         SUB  C
         LD   A,17
         JP   C,ISLOW
         JP   NZ,ISOVER
         LD   A,3
         CALL LUTOFF
         LD   A,4
         CALL BRUIT
         LD   HL,CASTLE
         LD   A,52
         SUB  (HL)
         DEC  (HL)
         CP   48
         PUSH AF
         PUSH AF
         LD   A,2
         PUSH IX
         CALL GETLUT
         LD   H,(IX+01)
         LD   L,(IX+02)
         POP  IX
         POP  BC
         LD   A,2
         CALL LUTMODV
         LD   A,1
         PUSH IX
         CALL GETLUT
         LD   H,(IX+01)
         LD   L,(IX+02)
         POP  IX
         POP  AF
         LD   A,1
         LD   B,8
         CALL Z,LUTON
         LD   A,3
         CALL LUTSAVE
         JP   EXETHRF2

ISLOW    LD   HL,LOW+2
         LD   (HL),A
         LD   DE,(POWER)
         LD   D,0
         LD   HL,LOWTAB-4
         ADD  HL,DE
         LD   B,(HL)
LOWBCLE  LD   HL,LOW
         CALL ANIMATE
         DJNZ LOWBCLE
         JP   EXETHRF

ISOVER   CALL SETOVER
         LD   HL,OVER
         CALL ANIMATE
EXETHRF
         LD   A,3
         CALL LUTOFF
EXETHRF2 LD   A,10
	jp WAIT_PAUSE
;
SETMONT
         PUSH HL
         PUSH BC
         PUSH DE
         LD   HL,MONT+2
         LD   B,8
         LD   DE,5
SETMONT0 LD   (HL),A
         ADD  HL,DE
         INC  A
         DJNZ SETMONT0
         POP  DE
         POP  BC
         POP  HL
         RET
;
SETOVER
         PUSH HL
         PUSH BC
         PUSH DE
         LD   HL,OVER+2
         LD   B,3
         LD   DE,5
SETOVER0 LD   (HL),A
         ADD  HL,DE
         INC  A
         DJNZ SETOVER0
         POP  DE
         POP  BC
         POP  HL
         RET
;
MONTTAB
         DEFB 1,-3,-3
         DEFB 4,0,0
         DEFB 7,2,2
         DEFB 9,4,4
         DEFB 10,5,5
         DEFB 11,6,6
         DEFB 12,7,7
         DEFB 13,8,8

MONT     DEFB 8
         DEFB #3B,0,107,82,8
         DEFB #BB,1,0,0,8
         DEFB #BB,2,0,0,8
         DEFB #BB,3,0,0,8
         DEFB #BB,4,0,0,8
         DEFB #BB,5,0,0,8
         DEFB #BB,6,-4,2,8
         DEFB #BB,7,-3,0,8
LOW
         DEFB 1
         DEFB #BB,0,-1,0,3
OVER
         DEFB 3
         DEFB #BB,0,-1,0,8
         DEFB #BB,1,-1,2,8
         DEFB #BB,2,-1,0,8
;
	read "TEXTE_SIEGE.ASM"
