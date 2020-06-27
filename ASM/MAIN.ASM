;
;MAIN.ASM
;   Header de DEFENDER OF THE CROWN
;   (c)1988 B.RIVE
;

	read "constant.asm"

	write direct "a:MAIN.BIN",START

         ORG  START
;
;Flags d'assemblage conditionnel
;
_DEBUG   EQU  0
_PRINT   EQU  0
;
;Macros
;

; original NEXTLINE 17 -> 26+1
; new 7 -> 16

	MACRO INLINE_BC26_HL

	ld a,h
	add a,&08
	ld h,a
	jr nc,$+12

	ld a,l
	add a,#50
	ld l,a
	ld a,h
	adc a,-#40
	res 3,a
	ld h,a


	ENDM

    IF _PRINT
;
    MACRO PRN VAL
         CALL PRINT
         DEFB VAL
         DEFB #FF
       ENDM
;
   MACRO PRNF
         CALL PRINT
         DEFB "OK"
         DEFB #FF
       ENDM
;
    ELSE

    MACRO PRN
       ; #P1
       ENDM
;
   MACRO PRNF
       ENDM
;
    ENDIF
;
;Point d'entree
;
         JP   MAIN
;
;*******************************************************************************
; Declaration des liens
;*******************************************************************************
MAIN_JUMP	equ 1

	read "link.asm"
;
;DATA
;
RETSIEGE
         DEFW RETSIEGE
         DEFW ANIBUF
         DEFW LORD
         DEFW LUTTAB

TAMPON   DEFS 20
OBJETAB	defs OBJETAB_LENGTH,0
;
;
;*******************************************************************************
; Declaration des parametres constants
;*******************************************************************************
;
PISTSIZE EQU  6000
NBREG    EQU  19
NBLUT    EQU  32
EVT_PROB EQU  6
;
;*******************************************************************************
; Declaration des pointeurs de memoire
;*******************************************************************************
SAVEBUF  DEFS 2
ANIBUF   DEFS 2
;*******************************************************************************
; Donnees constantes
;*******************************************************************************
;
;Noms des Fichiers
;
INTRO    DEFB "0INTRO   .BIN"   ; 1INTRO
VICTOIRE DEFB "0VICTOIRE.BIN"   ;1VICTOIRE
DEFAITE  DEFB "0DEFAITE .BIN"   ;1DEFAITE
JOUTE    DEFB "3JOUTE   .BIN"   ; 2JOUTE
SIEGE    DEFB "2SIEGE   .BIN"
RAID     DEFB "1RAID    .BIN"
EVENT    DEFB "2EVENT   .BIN"
ROBIN    DEFB "2ROBIN   .BIN"

TACTMAP  DEFB "2TACTMAP .DEF"
NAMES    DEFB "0NAMES   .DEF"   ;1NAMES
SCASTLE  DEFB "2SCASTLE .DEF"

SONS     DEFB "2DEFENDER.SON"

PROVINCE DEFB "2TACTSPR .SPR"
FACES    DEFB "2FACES   .SPR"
CATANIM  DEFB "2CATANIM .SPR"
CATSPR   DEFB "2CATSPR  .SPR"
;
;Plan
;
ADJATAB     ;        11  1111111
            ;        87  65432109  87654321
         DEFB %00000000,%00000000,%00000110 ;1
         DEFB %00000000,%00000000,%00011101 ;2
         DEFB %00000000,%00000001,%01110011 ;3
         DEFB %00000000,%00000010,%11010010 ;4
         DEFB %00000000,%00000000,%01001110 ;5
         DEFB %00000000,%00000101,%00000100 ;6
         DEFB %00000000,%00011011,%00011100 ;7
         DEFB %00000000,%00100010,%00001000 ;8
         DEFB %00000000,%00010100,%01100100 ;9
         DEFB %00000000,%00101000,%11001000 ;10
         DEFB %00000000,%00010001,%00100000 ;11
         DEFB %00000000,%01110010,%01000000 ;12
         DEFB %00000000,%11001101,%01000000 ;13
         DEFB %00000001,%01001010,%10000000 ;14
         DEFB %00000001,%10111000,%00000000 ;15
         DEFB %00000010,%01010000,%00000000 ;16
         DEFB %00000000,%01100000,%00000000 ;17
         DEFB %00000000,%10000000,%00000000 ;18

	read "TEXTE_MAIN.ASM"
;
;Donnees initiales des lords
;Leadership,Swordplay,Jousting,Hate for you
LORDSDEF
         DEFB 0,7,6,8,0      ;WILFRED
         DEFB 0,10,4,7,0     ;CEDRIC
         DEFB 0,6,9,6,0      ;GEOFFREY
         DEFB 0,5,5,10,0     ;WOLFRIC
         DEFB 0,8,8,10,5     ;BRIAN
         DEFB 0,7,6,8,5      ;PHILLIP
         DEFB 0,5,10,7,5     ;REGINALD
         DEFB 0,10,8,5,5     ;EDMUND
         DEFB 0,8,9,8,5      ;ROGER
;
;Donnees des chateaux
;   Ink,Land
CHATO
         DEFB 4,1
         DEFW PREFER1
         DEFB 1,5
         DEFW PREFER5
         DEFB 11,9
         DEFW PREFER9
         DEFB 7,8
         DEFW PREFER8
         DEFB 0,12
         DEFW PREFER12
         DEFB 8,18
         DEFW PREFER18
;
;Preferences
;
PREFER1
         DEFB 1,8,12,18,2,4,3,5,10
         DEFB 7,14,17,15,16,13,6,9,11
         DEFB 0
PREFER5
         DEFB 5,12,18,8,7,10,14,17,15
         DEFB 16,13,4,3,2,1,6,9,11
         DEFB 0
PREFER9
         DEFB 9,18,8,12,13,6,11,16,15
         DEFB 17,14,10,7,4,5,3,2,1
         DEFB 0
PREFER8
         DEFB 8,5,1,9,4,10,2,7,14
         DEFB 3,12,17,15,6,11,13,16,18
         DEFB 0
PREFER12
         DEFB 12,1,9,5,7,3,4,2,13
         DEFB 6,11,10,8,14,15,16,17,18
         DEFB 0
PREFER18
         DEFB 18,9,5,1,16,13,15,11,12
         DEFB 17,6,3,2,7,4,10,14,8
         DEFB 0
;
;
;*******************************************************************************
; Declaration des variables globales
;*******************************************************************************
;
LORD     DEFS 1
REGION1  DEFS 1
REGION2  DEFS 1
LORD1    DEFS 1
LORD2    DEFS 1
CASTRESI DEFS 1         ;Ces deux sont liees
ROB_HELP DEFS 1         ; par BATTLE
DECOMPTE DEFS 1
SENS     DEFS 1
COUR_MOI DEFS 1
COUR_AN  DEFS 2
LASTJOUT DEFS 1
OUTJOUT  DEFS 1
;
;
;
;Donnees relatives a l'etat courant de la partie
;
LORDS_LENGTH    equ 16
LORDS
;WILFRED
         DEFS 1         ;Type
         DEFS 1         ;Leadership
         DEFS 1         ;Sword
         DEFS 1         ;Joust
         DEFS 1         ;Hate for you
         DEFS 1         ;Wife-Help-Tired / Alive
         DEFS 1         ;Chateau
         DEFS 1         ;Region
         DEFS 2         ;Soldats
         DEFS 2         ;Chevaliers
         DEFS 2         ;Catapultes
         DEFS 2         ;Tresor
;
         DEFS 8*LORDS_LENGTH      ;Les 8 autres lords
;
REGIONS_LENGTH  equ 16
REGIONS
;CUMBRIA
         DEFB 1         ;Construction
         DEFW 0         ;Soldats
         DEFW 0         ;Chevaliers
         DEFW 0         ;Catapultes
         DEFB 0         ;Proprio
         DEFB 3         ;Taxes
         DEFB 5         ;Vasseaux
         DEFB 190       ;Ligne
         DEFB 78        ;Colonne
         DEFB 184       ;Y chateau
         DEFB 90        ;X chateau
         DEFB 177       ;Y lord
         DEFB 96        ;X lord

;YORKSHIRE
         DEFB 0,0,0,0,0,0,0,0,2,6,189,98,182,106,170,108
;LANCASHIRE
         DEFB 0,0,0,0,0,0,0,0,4,3,164,84,141,92,157,90
;LINCOLNSHIRE
         DEFB 0,0,0,0,0,0,0,0,3,6,153,114,122,122,145,122
;NOTTINGHAM
         DEFB 1,0,0,0,0,0,0,0,2,7,143,100,134,104,135,112
;GWYNEDD
         DEFB 0,0,0,0,0,0,0,0,2,8,139,64,113,76,130,76
;LEICESTER
         DEFB 0,0,0,0,0,0,0,0,2,5,133,93,122,98,104,104
;NORFOLK
         DEFB 2,0,0,0,0,0,0,0,6,5,124,130,119,138,103,140
;CLWYD
         DEFB 1,0,0,0,0,0,0,0,3,7,124,82,112,86,98,88
;CAMBRIDGE
         DEFB 0,0,0,0,0,0,0,0,5,3,113,116,95,128,107,120
;GLAMORGAN
         DEFB 0,0,0,0,0,0,0,0,1,8,108,54,88,66,90,76
;BUCKINGHAM
         DEFB 2,0,0,0,0,0,0,0,7,6,102,103,86,108,99,112
;GLOUCESTER
         DEFB 0,0,0,0,0,0,0,0,8,2,101,90,95,96,82,94
;ESSEX
         DEFB 0,0,0,0,0,0,0,0,6,4,87,116,73,124,81,130
;HAMPSHIRE
         DEFB 0,0,0,0,0,0,0,0,3,4,72,100,57,120,55,108
;DORSET
         DEFB 0,0,0,0,0,0,0,0,4,3,69,76,62,100,49,88
;SUSSEX
         DEFB 0,0,0,0,0,0,0,0,7,4,61,114,46,126,55,134
;CORNWALL
         DEFB 2,0,0,0,0,0,0,0,8,6,50,46,33,62,39,72
;SHERWOOD
         DEFB 0,0,0,0,0,0,0,0,0,0,153,102
;
;
;
;Declaration des dependances
;
    read "ATTAK.ASM"
    read "SQUELET.ASM"
    read "DIVERS.ASM"
    read "TEXTE_MENUS.ASM"
    read "BIBLI.ASM"
    read "DISC.ASM"
    read "FLECHE.ASM"
    read "MUSINT.ASM"
    read "POLICE.ASM"
    read "TXT.ASM"
    read "SCR.ASM"
    read "SPRITE.ASM"
    read "INIT.ASM"
;
list
MAIN_ASM_END equ $
MAIN_ASM_LONG equ $-START
nolist
