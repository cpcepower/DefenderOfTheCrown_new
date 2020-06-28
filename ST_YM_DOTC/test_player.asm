BUFMUS					equ &4000
MUSIC_ADDRESS				equ BUFMUS+&800	; Adresse fichier compacte
BUFFER_ADDRESS				equ BUFMUS+&2000; +&1000 buffer free !
DECRUBUF				equ BUFMUS+&3000; doit valoir x000 ou x800 (cf ATTRIBU)

PLAY_AY_SAVE_REGS	equ 1

	org &4000
;;	read "H:/work/include/play_ay_v1_1.asm"
	read "C:\work\include\play_ay_v1_1a.asm"

	org &4800

;	incbin "SIEGE.AYC"
;	incbin "..\Musique\test\crunch\YM020.ayc"
	incbin "..\Musique\test\crunch\SONG_042.ayc"

	org &1000

	run start

start	di

	ld hl,&c9fb
	ld (&0038),hl

	ei

	call init_music

loop	call vbl_wait
	halt
	halt

	ld bc,&7f10
	out (c),c
	ld a,&4b
	out (c),a

	call play_music

	ld bc,&7f10
	out (c),c
	ld a,&54
	out (c),a

	jr loop

	read "C:\work\include\vbl_wait.asm"
