; ------------------------------------------------------------------------------
; 
; ---------------------------

	run start

	org &1000

start
	di

	ld hl,&0038
	ld (hl),&fb
	inc hl
	ld (hl),&c9

	ei

	ld hl,packfire_decrunch
	ld (packfire_partial_decrunch_call),hl
	ld hl,reg0_index_decrunch_save_regs
	call packfire_decrunch_partial

decrunch_loop
	ld hl,main_loop
	ld (packfire_partial_decrunch_call),hl
	ld hl,reg0_index_decrunch_save_regs
	call packfire_decrunch_partial

	jr decrunch_loop

	ret

	read "test_packfire.asm"

	nolist

	MACRO REG_DATA_C reg_data_ptr

	db 1
	dw reg_data_ptr

	ENDM

	MACRO REG_DATA reg_data_ptr

	db 0
	dw reg_data_ptr

	ENDM

	org &4000
; ---------------------------
MUSIC_CRUNCH
; ---------------------------
reg_table
	REG_DATA_C reg0_index
	REG_DATA_C reg1_index
	REG_DATA_C reg2_index
	REG_DATA reg3_index
	REG_DATA reg4_index
	REG_DATA reg5_index
	REG_DATA reg6_index
	REG_DATA_C reg7_index
	REG_DATA_C reg8_index
	REG_DATA_C reg9_index
	REG_DATA rega_index
	REG_DATA regb_index
	REG_DATA regc_index
	REG_DATA regd_index
	REG_DATA rege_index
	REG_DATA regf_index
; ---------------------------
reg0_index
	incbin "DOTCINTR.R0.pck"
reg1_index
	incbin "DOTCINTR.R1.pck"
reg2_index
	incbin "DOTCINTR.R2.pck"
reg3_index
	incbin "DOTCINTR.R3"
reg4_index
	incbin "DOTCINTR.R4"
reg5_index
	incbin "DOTCINTR.R5"
reg6_index
	incbin "DOTCINTR.R6"
reg7_index
	incbin "DOTCINTR.R7.pck"
reg8_index
	incbin "DOTCINTR.R8.pck"
reg9_index
	incbin "DOTCINTR.R9.pck"
rega_index
	incbin "DOTCINTR.R10"
regb_index
	incbin "DOTCINTR.R11"
regc_index
	incbin "DOTCINTR.R12"
regd_index
	incbin "DOTCINTR.R13"
rege_index
	incbin "DOTCINTR.R14"
regf_index
	incbin "DOTCINTR.R15"
; ---------------------------
reg0_index_decrunch_save_regs
	ds 8*2,0
	dw reg0_index
	dw reg0_index_decrunch
	ds 2*2,0
reg1_index_decrunch_save_regs
	ds 12*2,0
reg2_index_decrunch_save_regs
	ds 12*2,0
reg7_index_decrunch_save_regs
	ds 12*2,0
reg8_index_decrunch_save_regs
	ds 12*2,0
reg9_index_decrunch_save_regs
	ds 12*2,0
; ---------------------------
reg0_index_decrunch
	ds &100,0
reg1_index_decrunch
	ds &100,0
reg2_index_decrunch
	ds &100,0
reg7_index_decrunch
	ds &100,0
reg8_index_decrunch
	ds &100,0
reg9_index_decrunch
	ds &100,0
list:MUSIC_CRUNCH_END equ $-MUSIC_CRUNCH:nolist
