; ------------------------------------------------------------------------------
; Defender of The Crown (c)1988 B.RIVE
; ------------------------------------------------------------------------------
; Optimization and improvement 2012 by Megachur
; ------------------------------------------------------------------------------
; Todo
; blackout -a revoir fondu des couleurs vers noir
; intégrer pour le player un player1_lord_name initialisé dans choose et gestion
; dans l'affichage du texte ! -> evite les appel à getlname, les puhs hl avant placard, etc!
; getstr à remplacer par getstridx !?
; initialiser un cadre random à init et s'en servir plutôt que de faire tout le temps appel à random_cadre
; passer par une jumptable plutôt que les jps xxxx ?
; faire une recherche sur tous les readfiles pour contrôle
; voir pour optimiser la boucle regen0 avec le call affreg
; voir pour faire un fading de la musique dans music_off !
; attention, buffer de menusave dans bufspr !
; revoir getlut -> rajouter les gets et voir si conservation de x,y ?
; rajouter le mode deux joueurs et l'image de choix 
; rajouter des archers en achat et combat !
; rajouter un concours d'arc à la joute ?
; ------------------------------------------------------------------------------
	read "DoTC_binary_header.asm"

DONE EQU 0

	write ".\BIN\DOTC.BIN"
;;	write direct "a:DOTC.BIN",DOTC_MAIN_START

	org DOTC_MAIN_START

list:DOTC_MAIN_ADDRESS:nolist

	jp main

; Declaration des liens
;MAIN_JUMP	equ 1

;	read "link.asm"

;-> à revoir
RETSIEGE
	dw RETSIEGE
;LORD
	;dw LORD
SAVEBUF
	dw SAVEBUF
;         DEFW LUTTAB

TAMPON
	ds 20,0

	read "DoTC_Skeleton.asm"

	read "DoTC_Attak.asm"
	read "DoTC_Misc.asm"
	read "DoTC_Text_Menus.asm"
	read "DoTC_Bibli.asm"
	read "DoTC_Disc.asm"
	read "DoTC_Arrow.asm"
; ---------------------------
music_on:
; ---------------------------
	push bc
	push hl
	ld hl,current_music_enable_play
	ld (hl),&01
	SET_ACTIVE_MEMORY_BANK MEMORY_BANK1
	call init_music
        SET_ACTIVE_MEMORY_BANK MEMORY_BANK0
	pop hl
	pop bc
	ret
; ---------------------------
music_off:
; ---------------------------
	push af
	push bc
	push de
	push hl
	ld hl,current_music_enable_play
	ld (hl),&00
	call psg_sound_reset
	pop hl
	pop de
	pop bc
	pop af
	ret
; ---------------------------
music_load:
 ; ---------------------------
	SET_ACTIVE_MEMORY_BANK MEMORY_BANK1

	push hl

	ld hl,filename_player_ayc
	ld de,BUFMUS
	call readfile

	pop hl

	ld de,MUSIC_ADDRESS
	call readfile

	call init_music

	ld a,1
	ld (current_music_enable_play),a

        SET_ACTIVE_MEMORY_BANK MEMORY_BANK0

	ret

	read "../include/psg_sound_reset.asm"
	read "../include/vbl_wait.asm"
;	read "../include/crtc_set_regs.asm"
;	read "../include/data_crtc_basic_value.asm"
	read "../include/keyboard_manager.asm"
	read "../include/z80_interruption.asm"
	read "DoTC_interruption.asm"
	read "../include/fdc.asm"

	read "DoTC_Police.asm"
	read "DoTC_Text.asm"
	read "DoTC_Screen.asm"
	read "DoTC_Sprite.asm"
	read "DoTC_Initialize.asm"
;
;	read "DoTC_Data_Screen_Address_Table.asm"
;
; ---------------------------
; Datas
; ---------------------------
	read "DoTC_Data.asm"
; ------------------------------------------------------------------------------
list
DOTC_MAIN_ASM_LONG equ $-DOTC_MAIN_START
DOTC_MAIN_ASM_END
nolist
