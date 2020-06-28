; ---------------------------
	read "DoTC_Data_Colors.asm"
; ---------------------------
OBJETAB		ds OBJETAB_LENGTH,0
; ---------------------------
; Declaration des pointeurs de memoire
; ---------------------------
ANIBUF   DEFS 2
; ---------------------------
; Noms des Fichiers
; ---------------------------
filename
	ds 8+3,0
filename_intro
	db SIDE_MAIN,	"INTRO   BIN"
filename_player_ayc
	db SIDE_MAIN,	"PLAYER  BIN"
filename_victory
	db SIDE_MAIN,"VICTORY BIN"
filename_defeat
	db SIDE_MAIN,	"DEFEAT  BIN"
filename_joute
	db SIDE_MAIN,	"JOUST   BIN"
SIEGE
	db SIDE_MAIN,	"SIEGE   BIN"
RAID
	db SIDE_MAIN,	"RAID    BIN"
filename_event
	db SIDE_MAIN,	"EVENT   BIN"
ROBIN
	db SIDE_MAIN,	"ROBIN   BIN"

filename_tactmap
	db SIDE_MAIN,	"TACTMAP DEF"
filename_names
	db SIDE_MAIN,	"NAMES   DEF"
SCASTLE
	db SIDE_MAIN,	"SCASTLE DEF"

;SONS
;	db SIDE_MAIN,	"DEFENDERSON"

filename_province
	db SIDE_MAIN,	"TACTSPR SPR"
FACES
	db SIDE_MAIN,	"FACES   SPR"
CATANIM
	db SIDE_MAIN,	"CATANIM SPR"
CATSPR
	db SIDE_MAIN,	"CATSPR  SPR"
; ---------------------------
; Donnees du joueur 1
; ---------------------------
player1_lord_id		ds 1,0
let lord = player1_lord_id
player1_lord		ds 2,0
player1_lordname	ds 2,0 ; à valider
player1_region		ds 2,0
; ---------------------------
; Declaration des variables globales
; ---------------------------
LASTJOY			db 0
;LORD     ds 1
REGION1  ds 1
REGION2  ds 1
LORD1    ds 1
LORD2    ds 1
CASTRESI ds 1	;Ces deux sont liees
ROB_HELP ds 1	; par BATTLE
DECOMPTE ds 1
SENS     ds 1
COUR_MOI ds 1
COUR_AN  ds 2
LASTJOUT ds 1
OUTJOUT  ds 1
; ---------------------------
fladd		dw 0
flbuf		ds 18*4
flrow		db 199
flcol		db 0
flstate		ds 1
flvitfl		ds 1
flvit		ds 1

; ---------------------------
flash_colors
	db 04, &4e
	db 05, &4a
; ---------------------------
sprite_table
	REPEAT LUTIN_NB
	dw LUTIN_LENGTH*SPRITE_TABLE_IDX+sprite_data
LET SPRITE_TABLE_IDX = SPRITE_TABLE_IDX+1
	REND
sprite_data
	ds LUTIN_NB*LUTIN_LENGTH
; ---------------------------
;Donnees initiales des lords - Leadership,Swordplay,Jousting,Hate for you
; ---------------------------
lordsdef
	db 00,07,06,08,00	;WILFRED
	db 00,10,04,07,00	;CEDRIC
	db 00,06,09,06,00	;GEOFFREY
	db 00,05,05,10,00	;WOLFRIC
	db 00,08,08,10,05	;BRIAN
	db 00,07,06,08,05	;PHILLIP
	db 00,05,10,07,05	;REGINALD
	db 00,10,08,05,05	;EDMUND
	db 00,08,09,08,05	;ROGER
; ---------------------------
; Donnees des chateaux
; Ink,Land
chato
; ---------------------------
	db 4,1
	dw prefer1
	db 1,5
	dw prefer5
	db 11,9
	dw prefer9
	db 7,8
	dw prefer8
	db 0,12
	dw prefer12
	db 8,18
	dw prefer18
; ---------------------------
;preferences
; ---------------------------
prefer1
	db 1,8,12,18,2,4,3,5,10
	db 7,14,17,15,16,13,6,9,11
	db 0
prefer5
	db 5,12,18,8,7,10,14,17,15
	db 16,13,4,3,2,1,6,9,11
	db 0
prefer9
	db 9,18,8,12,13,6,11,16,15
	db 17,14,10,7,4,5,3,2,1
	db 0
prefer8
	db 8,5,1,9,4,10,2,7,14
	db 3,12,17,15,6,11,13,16,18
	db 0
prefer12
	db 12,1,9,5,7,3,4,2,13
	db 6,11,10,8,14,15,16,17,18
	db 0
prefer18
	db 18,9,5,1,16,13,15,11,12
	db 17,6,3,2,7,4,10,14,8
	db 0
; ---------------------------
;Donnees relatives a l'etat courant de la partie
; ---------------------------
lords
;WILFRED
	ds 1	;Type
	ds 1	;Leadership
	ds 1	;Sword
	ds 1	;Joust
	ds 1	;Hate for you
	ds 1	;Wife-Help-Tired / Alive
	ds 1	;Chateau
	ds 1	;Region
	ds 2	;Soldats
	ds 2	;Chevaliers
	ds 2	;Catapultes
	ds 2	;Tresor
;
	ds 8*LORDS_LENGTH      ;Les 8 autres lords
; ---------------------------
regions
;CUMBRIA
	db 1	;Construction
	dw 0	;Soldats
	dw 0	;Chevaliers
	dw 0	;Catapultes
	db 0	;Proprio
	db 3	;Taxes
	db 5	;Vasseaux
	db 190	;Ligne
	db 78	;Colonne
	db 184	;Y chateau
	db 90	;X chateau
	db 177	;Y lord
	db 96	;X lord

;YORKSHIRE
	db 0,0,0,0,0,0,0,0,2,6,189,98,182,106,170,108
;LANCASHIRE
	db 0,0,0,0,0,0,0,0,4,3,164,84,141,92,157,90
;LINCOLNSHIRE
	db 0,0,0,0,0,0,0,0,3,6,153,114,122,122,145,122
;NOTTINGHAM
	db 1,0,0,0,0,0,0,0,2,7,143,100,134,104,135,112
;GWYNEDD
	db 0,0,0,0,0,0,0,0,2,8,139,64,113,76,130,76
;LEICESTER
	db 0,0,0,0,0,0,0,0,2,5,133,93,122,98,104,104
;NORFOLK
	db 2,0,0,0,0,0,0,0,6,5,124,130,119,138,103,140
;CLWYD
	db 1,0,0,0,0,0,0,0,3,7,124,82,112,86,98,88
;CAMBRIDGE
	db 0,0,0,0,0,0,0,0,5,3,113,116,95,128,107,120
;GLAMORGAN
	db 0,0,0,0,0,0,0,0,1,8,108,54,88,66,90,76
;BUCKINGHAM
	db 2,0,0,0,0,0,0,0,7,6,102,103,86,108,99,112
;GLOUCESTER
	db 0,0,0,0,0,0,0,0,8,2,101,90,95,96,82,94
;ESSEX
	db 0,0,0,0,0,0,0,0,6,4,87,116,73,124,81,130
;HAMPSHIRE
	db 0,0,0,0,0,0,0,0,3,4,72,100,57,120,55,108
;DORSET
	db 0,0,0,0,0,0,0,0,4,3,69,76,62,100,49,88
;SUSSEX
	db 0,0,0,0,0,0,0,0,7,4,61,114,46,126,55,134
;CORNWALL
	db 2,0,0,0,0,0,0,0,8,6,50,46,33,62,39,72
;SHERWOOD
	db 0,0,0,0,0,0,0,0,0,0,153,102
; ---------------------------
;Plan
; ---------------------------
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

	read "DoTC_Text_main.asm"
; ---------------------------
;Dessin de la fleche (72 Octets)
; ---------------------------
SWORD0
	db #0F,#00,#00,#00
	db #4F,#0A,#00,#00
	db #4F,#0A,#00,#00
	db #4F,#0A,#00,#00
	db #4F,#AF,#00,#00
	db #5F,#8F,#00,#00
	db #05,#8F,#00,#00
	db #05,#8F,#00,#00
	db #05,#8F,#0F,#00
	db #05,#FF,#3F,#0A
	db #05,#BF,#2F,#00
	db #05,#3F,#0A,#00
	db #1F,#7F,#0A,#00
	db #1F,#0F,#AF,#00
	db #05,#05,#AF,#00
	db #00,#05,#AF,#00
	db #00,#05,#AF,#00
	db #00,#00,#0A,#00
SWORD1
	db #05,#0A,#00,#00
	db #05,#8F,#00,#00
	db #05,#8F,#00,#00
	db #05,#8F,#00,#00
	db #05,#DF,#0A,#00
	db #05,#EF,#0A,#00
	db #00,#4F,#0A,#00
	db #00,#4F,#0A,#00
	db #00,#4F,#0F,#0A
	db #00,#5F,#BF,#2F
	db #00,#5F,#3F,#0A
	db #00,#1F,#2F,#00
	db #05,#3F,#AF,#00
	db #05,#2F,#5F,#0A
	db #00,#0A,#5F,#0A
	db #00,#00,#5F,#0A
	db #00,#00,#5F,#0A
	db #00,#00,#05,#00

