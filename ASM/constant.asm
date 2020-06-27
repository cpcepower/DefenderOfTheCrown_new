;	IFNDEF  DEFINE_CONSTANT

;DEFINE_CONSTANT equ 1

	list

AMSDOS_current_drive	equ &aa00       ; redefined in new_loader &a700 -> &aa00


NB_REGIONS	equ 18		; 19=Sherwood
NB_EVENT	equ 10

OBJESZ   EQU  5
         ;0->distance /#FF si inaccessible
         ;1-2->cout
         ;3->Type     /#FF si interdit
         ;4->valeur
OBJETAB_LENGTH  EQU  NB_REGIONS*OBJESZ

FIRST    EQU  #40
BUFFER_DATA		equ &0040
START    EQU  #4000
LAST     EQU  #B100
FIN      EQU  #8A00
BUFIMA   EQU  FIRST
SPRBUF   EQU  BUFIMA+16
NBENT    EQU  64
SZENT    EQU  16
DIRBUF   EQU  -NBENT*SZENT+LAST
MUSBUF   EQU  DIRBUF-#B00
BUFOVL   EQU  MUSBUF-#1800

EOL	equ &FF

DEFAITE_SIDE	equ "0"
INTRO_SIDE	equ "0"
JOUTE_SIDE	equ "3"
RAID_SIDE	equ "1"
ROBIN_SIDE	equ "2"
EVENT_SIDE	equ "2"
VICTOIRE_SIDE	equ "0"

NB_LADY equ 4

	nolist

;	ENDIF
