; ------------------------------------------------------------------------------
; CONSTANTS
; ------------------------------------------------------------------------------
	read "../include/memory_bank_constants.asm"
; ---------------------------
AMSDOS_current_drive			equ &aa00       ; redefined in loader &a700 -> &aa00
STACK_PILE				equ DOTC_MAIN_START
DOTC_LOADER_ADDRESS			equ &4800
DOTC_MAIN_START				equ &0100
BUFFER_DATA				equ DOTC_LOADER_ADDRESS
BUFIMA					equ DOTC_LOADER_ADDRESS
BUFSPRLOAD				equ BUFIMA+16+2		; +2 = skip file length (palette and screen)
BUFSPR					equ BUFSPRLOAD+2	; +2 = skip file length (sprite)
BUFOVL					equ &8800
BUFMUS					equ &4000

MUSIC_ADDRESS				equ BUFMUS+&800	; Adresse fichier compacte
BUFFER_ADDRESS				equ &6000	; +&1000 buffer free !
DECRUBUF				equ &7000	; doit valoir x000 ou x800 (cf ATTRIBU)

DOTC_DEFEAT_ADDRESS			equ BUFOVL
DOTC_EVENT_ADDRESS			equ BUFOVL
DOTC_INTRO_ADDRESS			equ BUFOVL
DOTC_JOUST_ADDRESS			equ BUFOVL
DOTC_RAID_ADDRESS			equ BUFOVL
DOTC_ROBIN_ADDRESS			equ BUFOVL
DOTC_SIEGE_ADDRESS			equ BUFOVL
DOTC_VICTORY_ADDRESS			equ BUFOVL

DOTC_MUSICINT_ADDRESS			equ BUFMUS


PLAY_AY_SAVE_REGS                       equ 1
	IFNDEF PLAY_AY_SAVE_REGS
let init_music				= BUFMUS+6
let play_music				= BUFMUS
	ELSE
let init_music				= BUFMUS+27
let play_music				= BUFMUS
	ENDIF

EXEC_EVENT                              equ BUFOVL+2    ; +2 = skip file length
EXEC_BATTLE                             equ BUFOVL+2+3
EXEC_CONQUEST                           equ BUFOVL+2+6
; ---------------------------
DIRECTORY_LAST_SECTOR_USER_DEFINE	equ &c5
; ---------------------------
SCREEN_WIDTH				equ 80
SCREEN_ADDRESS				equ &c000
CRTC_SCREEN_ADDRESS 			equ &3000
CRTC_TOTAL_NUMBER_OF_REGISTERS_TO_SET	equ 15
; ---------------------------
ACTIVE_MEMORY_BANK_MANAGEMENT		equ 1
;Z80_INTERRUPTION_SAVE_SP               equ 1
Z80_INTERRUPTION_PUSH_IY		equ 1
Z80_INTERRUPTION_PUSH_IX		equ 1
;Z80_INTERRUPTION_LOADING_MUSIC_PLAY     equ 1
;Z80_INTERRUPTION_LOADING_MUSIC_PLAY_NUMBER      equ 1
; ---------------------------
; DOTC
; ---------------------------
SIDE_DEFEAT		equ "2"
SIDE_EVENT		equ "0"
SIDE_INTRO		equ "0"
SIDE_JOUST		equ "2"
SIDE_MAIN               equ "0"
SIDE_SIEGE		equ "0"
SIDE_RAID		equ "1"
SIDE_ROBIN		equ "0"
SIDE_VICTORY		equ "0"
; ---------------------------
EVT_PROB		equ  6
EVENT_NB		equ 10
EOT			equ &ff		; end of text
	IFDEF DOTC_MAIN_ADDRESS
D16BUFF			equ TAMPON	;6
DIMRESU			equ TAMPON	;3
	ENDIF
; ---------------------------
LUTIN_NB		equ 32
SPRITE_TABLE_IDX        equ 0

LUTIN_X				equ 0
LUTIN_Y				equ LUTIN_X+1
LUTIN_ACTUAL_SCREEN_ADDRESS	equ LUTIN_Y+1
LUTIN_SPRITE_ADDRESS		equ LUTIN_ACTUAL_SCREEN_ADDRESS+2
LUTIN_ANIMATION_TABLE		equ LUTIN_SPRITE_ADDRESS+2

LUTIN_LENGTH			equ LUTIN_ANIMATION_TABLE+2
; ---------------------------
REGIONS_NB		equ 18			; -Sherwood
REGIONS_NB_ALL		equ REGIONS_NB+1	; +Sherwood
REGIONS_LENGTH		equ 16
OBJESZ   EQU  5
         ;0->distance /#FF si inaccessible
         ;1-2->cout
         ;3->Type     /#FF si interdit
         ;4->valeur
OBJETAB_LENGTH  EQU  REGIONS_NB*OBJESZ

REGION_CONSTRUCTION	equ &00
REGION_SOLDATS		equ &01
REGION_CHEVALIERS	equ &03
REGION_CATAPULTES	equ &05
REGION_PROPRIO		equ &07
REGION_TAXES		equ &08
REGION_VASSEAUX		equ &09
REGION_LIGNE		equ &0a
REGION_COLONNE		equ &0b
REGION_Y_CHATEAU	equ &0c
REGION_X_CHATEAU	equ &0d
REGION_Y_LORD		equ &0e
REGION_X_LORD		equ &0f

CONSTRUCTION_RIEN	equ 00
CONSTRUCTION_ACASTLE	equ 01
CONSTRUCTION_ECASTLE	equ 02
CONSTRUCTION_GARNISON	equ 03
; ---------------------------
LORDS_NB		equ 09
LORDS_NB_AMI		equ 02
LORDS_NB_ENNEMI		equ 03
LORDS_LENGTH		equ 16

LORD_TYPE		equ &00
LORD_LEADERSHIP		equ &01
LORD_SWORDPLAY		equ &02
LORD_JOUSTING		equ &03
LORD_HATE_FOR_YOU	equ &04
LORD_WIFE		equ &05
LORD_CASTLE		equ &06
LORD_REGION		equ &07
LORD_SOLDATS		equ &08
LORD_CHEVALIERS		equ &0a
LORD_CATAPULTES		equ &0c
LORD_TRESOR		equ &0e

LORD_TYPE_KILL		equ &00
LORD_TYPE_AMI		equ &01
LORD_TYPE_ENNEMI	equ &02
LORD_TYPE_PLAYER	equ &03

LADY_MAX		equ &04

;MUSIC_ON	equ &ff
;MUSIC_OFF	equ &00
;play_music	equ TICKROUT
; ------------------------------------------------------------------------------
