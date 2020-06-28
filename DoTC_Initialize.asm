; ------------------------------------------------------------------------------
; from INIT.ASM
; ------------------------------------------------------------------------------
init:
; ---------------------------
	ld a,(AMSDOS_current_drive)	; Get AMSDOS current drive
	ld (current_drive),a

	di

	ex (sp),hl			; get call back adr
	ld sp,STACK_PILE
	push hl

	SET_MEMORY_BANK %10011100	; Set Interrupt and Upper/Lower rom area disable

	SET_MEMORY_BANK MEMORY_BANK0
	ld (active_memory_bank),bc	; Activate MEMORY_BANK0

	ld hl,PALFIX-11
	call sauv_image_pal

	call wait_vbl

	SET_VAL_hl &0038,&c3		; Set game_interrupt as new interrupt
	inc hl
	ld (hl),z80_interruption
	inc hl
	ld (hl),z80_interruption/&100

	ld hl,&8000			; Clear memory (&8000 to &ffff)
	ld (hl),&00
	ld de,&8001
	ld bc,&7fff
	ldir

	call keyboard_init_scan

	call wait_vbl

	ei

	ret
; ---------------------------
; reinitialisation des donnees du jeu
inivar:
; ---------------------------
	ld hl,1149
	ld (cour_an),hl
	ld a,10
	ld (cour_moi),a
	ld a,0
	ld (outjout),a
	ld a,3
	ld (rob_help),a

	ld a,9
	ld hl,lordsdef
	ld de,lords
inivar0
	ld bc,LORDS_LENGTH-10-1
	ldir
	push hl
	ld h,d
	ld l,e
	inc de
	ld (hl),&00
	ld bc,LORDS_LENGTH-5-1
	ldir
	pop hl
	dec a
	jr nz,inivar0

	ld a,REGIONS_NB
	ld hl,regions
	ld de,LORDS_LENGTH/2
inivar1
	ld b,LORDS_LENGTH/2
inivar2
	ld (hl),0
	inc hl
	djnz inivar2
	add hl,de
	dec a
	jr nz,inivar1
	ret
; ------------------------------------------------------------------------------
