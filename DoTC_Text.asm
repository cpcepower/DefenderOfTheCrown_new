; ------------------------------------------------------------------------------; from TXT.ASM; ---------------------------; Ensemble des routines d'affichage de texte.; ---------------------------; centrage d'un texte (le curseur doit etre deja positionne); a -> largeur du champ; hl-> adresse du textecentre; ---------------------------	push hl	push bc	push af	ld b,0centre0	ld a,(hl)	inc a	jr z,centre1	inc b	inc hl	jr centre0centre1	pop af	sub b	srl a	jr z,centre3	ld b,acentre2	ld a," "	call TXT_OUTPUT	djnz centre2centre3	pop bc	pop hl	ret; ---------------------------; affichage d'un texte; hl -> adresse du texte; hl <- adresse de l'octet apres EOT; modifies- hlaffmebis; ---------------------------	push afaffmebi0	ld a,(hl)	inc hl	cp EOT	jr z,affmebi1	call TXT_OUTPUT	jr affmebi0affmebi1	pop af	ret; ---------------------------; affichage d'un menu et selection d'une option; hl -> adresse du texte; sp -> variables; a  <- indice de l'option choisie (0->nbchp); hl <- adresse de l'octet suivant le texte; modifies- af,hl; ---------------------------champs		ds 32	 ;4 octets pour definir chaque champnbchp		ds 1	 ;compteur de delimiteur de champs (2*nbe de champs)stack		ds 2linebuff	ds 80nbchar		ds 25txtcol		ds 1txtrow		ds 1txtnbcol	ds 1txtnbrow	ds 1tosave		db 0;menutext	ld a,1	ld (tosave),amenutex0	ld (stack),sp	push de	push ix	ld de,(nbchar)	xor a	ld (nbchp),a	ld a,(hl)	ld (txtcol),a	inc hl	ld a,(hl)	ld (txtrow),a	inc hl	ld a,(hl)	ld (txtnbcol),a	inc hl	push hl	ld ix,(stack)	inc ix	inc ix	ld (stack),ix	call txtcalc	ld (txtnbrow),a	ld a,(tosave)	or a	call nz,menusave	call txtcadre	pop hl	ld ix,(stack)	call txtaff	ld (stack),ix	pop ix	pop de	pop hl	ld sp,(stack)	push hl	xor a	ld (tosave),a	ld a,(nbchp)	or a	ret z;	ld a,(retsiege);	or a;	ret nzmenutex1 call afleche	call menusel	push af	call efleche	pop af	ret;;txtcalc;txtcalc	push bc	push de	push iy	call ffbuff	ld de,nbchar	ld c,0	ld a,(txtnbcol)	ld b,atxtcalc0 push bc	call actbuff	inc b	ld c,0txtcalc1 call nxtchar	cp EOT	jr z,txtcalc4	cp #f9	jr z,txtcalc3	inc c	djnz txtcalc1txtcalc2 call prvchar	dec c	cp " "	jr nz,txtcalc2	call nxtchartxtcalc3 ld a,c	ld (de),a	inc de	pop bc	inc c	jr txtcalc0txtcalc4 ld a,c	ld (de),a	pop bc	ld a,c	inc a	pop iy	pop de	pop bc	ret;;ffbuff;ffbuff	ld de,linebuff	push de	ld a,EOT	ld b,80ffbuff0 ld (de),a	inc de	djnz ffbuff0	pop iy	ret;;nxtchar;nxtcharnxtchar0 ld a,(iy+00)	cp EOT	jr z,nxtchar1	inc iy	cp #fe	jr z,nxtchar0	retnxtchar1 ld a,(hl)	inc hl	cp #f0	jr nc,nxtchar3	ld (iy+00),a	inc iy	retnxtchar3 cp EOT	ret z	cp #f9	ret z	cp #fe	jr z,nxtchar1	push hl	call getvar	cp #fb	call z,convd16b	cp #fc	call z,convd16	push iynxtchar4 ld a,(hl)	cp EOT	jr z,nxtchar5	ld (iy+00),a	inc iy	inc hl	jr nxtchar4nxtchar5 pop iy	pop hl	jr nxtchar0;;prvchar;prvchar	dec iy	ld a,(iy+00)	ret;;;txtaff;txtaff	push de	push bc	push iy	push hl	ld a,(txtcol)	ld h,a	inc h	ld a,(txtrow)	ld l,a	inc l	call TXT_SET_CURSOR	pop hl	call ffbuff	ld de,nbchartxtaff0 call actbuff	ld a,(de)	or a	jr z,txtaff3	ld b,a	ld a,(txtnbcol)	sub b	srl atxtaff1 or a	jr z,txtaff2; right	push hl	ld hl,(screen_text_cursor_position_xy)  ; &b726	inc h	ld (screen_text_cursor_position_xy),hl	pop hl	dec a	jr txtaff1txtaff2 call exechar	djnz txtaff2txtaff3 ld a,(iy+00)	cp EOT	jr z,txtaff4	cp #20	jr nz,txtaff5	inc iy	jr txtaff5txtaff4 ld a,(hl)	cp #20	jr nz,txtaff5	inc hltxtaff5 call nz,exechar	cp EOT	jr z,txtaff6	inc de	call cr	jr txtaff0txtaff6 pop iy	pop bc	pop de	ret;;cr;cr	push hl	push af	call TXT_GET_CURSOR	ld a,(txtcol)	ld h,a;	inc h	ld (screen_text_cursor_position_xy),hl	pop af	pop hl	ret;;actbuff;actbuff	push af	push bc	push hl	ld hl,linebuff	ld b,80actbuff0 ld a,(iy+00)	cp EOT	jr z,actbuff1	ld (hl),a	inc hl	dec b	inc iy	jr actbuff0actbuff1 ld (hl),EOT	inc hl	djnz actbuff1	ld iy,linebuff	pop hl	pop bc	pop af	ret;;exechar;execharexechar0 ld a,(iy+00)	inc iy	cp EOT	jr nz,exechar1	dec iy	ld a,(hl)	inc hlexechar1 cp #f0	jr nc,exechar3	jp TXT_OUTPUTexechar3 cp #fe	jr nz,exechar6	call delim	jr exechar0exechar6 cp EOT	ret z	cp #f9	ret z	push hl	call getvar	cp #fb	call z,convd16b	cp #fc	call z,convd16	push iyexechar4 ld a,(hl)	cp EOT	jr z,exechar5	ld (iy+00),a	inc iy	inc hl	jr exechar4exechar5 pop iy	pop hl	jr exechar0;;delim;delim	push hl	push de	ld hl,nbchp	ld a,(hl)	push af	inc (hl)	call TXT_GET_CURSOR	pop af	rra	jr nc,delim0	dec hdelim0 rla	ex de,hl;addhlaa	add a,a	add a,champs	ld l,a	adc a,champs/&100	sub a,l	ld h,a	ld (hl),e	inc hl	ld (hl),d	pop de	pop hl	ret;;affd16;affiche le nombre decimal contenu par hl;affd16	push hl	push af	push de	ld a," "	ld (dechar+1),a	ld de,10000	call affd160	ld de,1000	call affd160	ld de,100	call affd160	ld de,10	call affd160	ld de,1	ld a,"0"	ld (dechar+1),a	call affd160	pop de	pop af	pop hl	retaffd160 ld a,#ff	or aaffd161 sbc hl,de	inc a	jr nc,affd161	add hl,dedechar add a," "	cp " "	jp z,TXT_OUTPUT	cp " "+10	jp nc,TXT_OUTPUT	add a,"0"-" "	call TXT_OUTPUT	ld a,"0"	ld (dechar+1),a	ret;;convd16b;convd16b	push de	push bc	ld bc,d16buff	ld a,#37	 ;scf	ld (firstb0),a	call convdb0	ld a,#ff	ld (bc),a	ld hl,d16buff	pop bc	pop de	retconvdb0 ld de,10000	call convdb1	ld de,1000	call convdb1	ld de,100	call convdb1	ld de,10	call convdb1	ld de,1	ld a,#b7	 ;or a	ld (firstb0),aconvdb1 xor aconvdb2 sbc hl,de	inc a	jr nc,convdb2	add hl,de	add a,"0"-1	cp "0"	jr nz,convdb3firstb0 scf	jr nc,convdb3	ld a," "	ld (bc),a	inc bc	retconvdb3 ld (bc),a	inc bc	ld a,#b7	 ;or a	ld (firstb0),a	ret;;convd16;convd16	push de	push bc	ld bc,d16buff	ld a,#37	 ;scf	ld (first0),a	call convd0	ld a,#ff	ld (bc),a	ld hl,d16buff	pop bc	pop de	retconvd0 ld de,10000	call convd1	ld de,1000	call convd1	ld de,100	call convd1	ld de,10	call convd1	ld de,1	ld a,#b7	 ;or a	ld (first0),aconvd1 xor aconvd2 sbc hl,de	inc a	jr nc,convd2	add hl,de	add a,"0"-1	cp "0"	jr nz,convd3first0 scf	ret cconvd3 ld (bc),a	inc bc	ld a,#b7	 ;or a	ld (first0),a	ret; ---------------------------; selection d'une option selon le menu defini par menutext; a <- indice de l'option choisie; modifies- af;selection d'une option selon les parametres chpnb et champs cree par menutext;oknull permet le retour sans selection; ---------------------------chpsel		ds 1	;champ selectionne courantoknull		db 0;menusel; ---------------------------	push hl	push bc	push ix	xor a	ld (chpsel),a	scfmenusel0	call mfleche	push af	call gflech1	srl h	srl h	inc h	ld a,199	sub l	ld l,a	srl l	srl l	srl l	inc l	ld a,(nbchp)	srl a	ld b,a	ld ix,champsmenusel1 ld a,h	sub (ix+01)	jr c,menusel2	ld a,l	sub (ix+00)	jr c,menusel2	ld a,(ix+03)	sub h	jr c,menusel2	ld a,(ix+02)	sub l	jr nc,menusel3menusel2 inc ix	inc ix	inc ix	inc ix	djnz menusel1	ld hl,chpsel	ld a,(hl)	or a	call nz,invchp	xor a	ld (hl),amenusel4 pop af	jr nc,menusel0	ld a,(chpsel)	ld c,a	ld a,(oknull)	or c	jp z,menusel0	ld a,c	or a	call nz,invchp	pop ix	pop bc	pop hl	retmenusel3 ld a,(nbchp)	srl a	sub b	inc a	ld hl,chpsel	cp (hl)	jr z,menusel4	ld b,(hl)	ld (hl),a	ld a,b	or a	call nz,invchp	ld a,(hl)	call invchp	jr menusel4;;invchp;inverse le champ no a de la table champs;invchp	push bc	push de	push hl	push af	ld hl,champs	dec a	sla a	call rdtab16	dec h	dec l	push hl	push af	call SCR_CHAR_POSITION	pop af	push hl	pop bc	inc a	ld hl,champs	call rdtab16	pop de	push bc	or a	sbc hl,de	ld b,h	sla b	ld c,l	sla c	sla c	sla c	push bc	call vbl_wait	 ;mc wait flyback	call gflech2	call memscr	pop bc	pop hlinvchp0 push bc	push hlinvchp1 ld a,(hl)	xor #c0	ld (hl),a	inc hl	djnz invchp1	pop hl	call nextline	pop bc	dec c	jr nz,invchp0	call gflech2	push hl	call scrmem	pop hl	call flon	pop af	pop hl	pop de	pop bc	ret;;menusave;menusave	push de	push hl	push bc	push af	ld a,(txtcol)	ld h,a	ld a,(txtrow)	ld l,a	dec h	dec l	call SCR_CHAR_POSITION	ld a,(txtnbrow)	inc a	inc a	sla a	sla a	sla a	ld b,a	ld a,(txtnbcol)	inc a	inc a	sla a	ld c,a	ld de,(savebuf)menusav0 push bc	push hl	ld b,0	ldir	pop hl	call nextline	pop bc	djnz menusav0	pop af	pop bc	pop hl	pop de	ret;;menurest;menurest	push de	push hl	push bc	push af	ld a,(txtcol)	ld h,a	ld a,(txtrow)	ld l,a	dec h	dec l	call SCR_CHAR_POSITION	ld a,(txtnbrow)	inc a	inc a	sla a	sla a	sla a	ld b,a	ld a,(txtnbcol)	inc a	inc a	sla a	ld c,a	ld de,(savebuf)menures0	push bc	push hl	ld b,0	ex de,hl	ldir	ex de,hl	pop hl	call nextline	pop bc	djnz menures0	pop af	pop bc	pop hl	pop de	ret;;;menucadr; affiche le cadre du menu pointe par hl;txtcadre	push ix	push de	push bc	push af	push hl	ld a,(txtcol)	ld h,a	ld a,(txtrow)	ld l,a	dec h	dec l	call SCR_CHAR_POSITION	ld a,(txtnbrow)	ld c,a	ld a,(txtnbcol)	ld b,a	ld ix,charhg	call affchar	push hl	push bcmenuc0	inc hl	inc hl	ld ix,charh	call random_cadre	call affchar	djnz menuc0	inc hl	inc hl	ld ix,charhd	call affchar	pop bc	pop hlmenuc1	ld de,80	add hl,de	push bc	push hl	ld ix,charg	call random_cadre	call affchar	ld de,&7ff ; 121	ld c,&f3menuc10 inc hl	inc hl	push hl	ld a,8aff_char_fond	ld (hl),c	inc hl	ld (hl),c	add hl,de	dec a	jr nz,aff_char_fond	pop hl	djnz menuc10	inc hl	inc hl	ld ix,chard	call random_cadre	call affchar	pop hl	pop bc	dec c	jr nz,menuc1	ld de,80	add hl,de	ld ix,charbg	call affcharmenuc2	inc hl	inc hl	ld ix,charb	call random_cadre	call affchar	djnz menuc2	inc hl	inc hl	ld ix,charbd	call affchar	pop hl	pop af	pop bc	pop de	pop ix	ret;random_cadre	ld a,4	call random	dec a	add a,a	; x2	add a,a ; x4	add a,a ; x8	add a,a ; x16	add a,ixl	ld ixl,a	adc a,ixh	sub a,ixl	ld ixh,a	ret;affchar	push hl	push de	push bc	push ix	ld b,8affchar0 ld a,(ix+00)	call afftran	inc hl	inc ix	ld a,(ix+00)	call afftran	ld de,#7ff	add hl,de	inc ix	djnz affchar0	pop ix	pop bc	pop de	pop hl	ret;afftran	push af	rrca	rrca	and #cc	cpl	and (hl)	ld (hl),a	pop af	or (hl)	ld (hl),a	ret;;;definition des caracteres de bordure de parchemins;charhg	db #00,#00,#00,#00,#00,#33,#00,#73	db #11,#73,#11,#f3,#11,#f3,#11,#f3charhd	db #00,#00,#00,#00,#33,#00,#b3,#00	db #b3,#22,#f3,#22,#f3,#22,#f3,#22charbg	db #11,#f3,#11,#f3,#11,#f3,#11,#73	db #00,#73,#00,#33,#00,#00,#00,#00charbd	db #f3,#22,#f3,#22,#f3,#22,#b3,#22	db #b3,#00,#33,#00,#00,#00,#00,#00charh	db #00,#00,#00,#00,#00,#00,#33,#33	db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#f3	db #00,#00,#00,#00,#33,#33,#f3,#f3	db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#f3	db #00,#00,#00,#00,#11,#33,#33,#f3	db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#f3	db #00,#00,#00,#00,#33,#00,#b3,#33	db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#f3charg	db #11,#f3,#11,#f3,#11,#f3,#11,#f3	db #33,#f3,#73,#f3,#73,#f3,#73,#f3	db #73,#f3,#73,#f3,#73,#f3,#33,#f3	db #11,#f3,#11,#f3,#11,#f3,#11,#f3	db #73,#f3,#73,#f3,#33,#f3,#11,#73	db #33,#f3,#73,#f3,#73,#f3,#73,#f3	db #11,#f3,#11,#f3,#11,#f3,#33,#f3	db #73,#f3,#33,#f3,#11,#f3,#11,#f3chard	db #f3,#22,#f3,#22,#f3,#22,#f3,#22	db #f3,#22,#f3,#22,#f3,#22,#f3,#22	db #f3,#b3,#f3,#b3,#f3,#b3,#f3,#b3	db #f3,#b3,#f3,#b3,#f3,#b3,#f3,#b3	db #f3,#22,#f3,#22,#f3,#33,#f3,#b3	db #f3,#33,#f3,#22,#f3,#22,#f3,#22	db #f3,#b3,#f3,#b3,#f3,#b3,#f3,#33	db #b3,#22,#f3,#33,#f3,#b3,#f3,#b3charb	db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#f3	db #f3,#f3,#33,#33,#00,#00,#00,#00	db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#f3	db #33,#33,#00,#00,#00,#00,#00,#00	db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#f3	db #f3,#33,#33,#22,#00,#00,#00,#00	db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#f3	db #33,#73,#00,#33,#00,#00,#00,#00;charm;	db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#f3;	db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#f3