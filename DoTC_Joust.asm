; ------------------------------------------------------------------------------
; from JOUTE.ASM
; ---------------------------
	read "DoTC_binary_header.asm"

	WRITE_DOTC_BIN_FILE JOUST, DOTC_JOUST_ADDRESS, DOTC_JOUST_LENGTH
;
;joute(a-lord) -> carry=1 si interdit de joute
;
joute
;
;joutinit
;
	ld   (joust_lord1),a
	ld   hl,joust_lordsout
	ld bc,&0901
joutini0 ld   (hl),c
	inc  hl
	djnz joutini0
;
;joutrump
;
	load_decomp_scr JOUST_TRUMP
	ld   hl,JOUST_MUS
	call music_load
	call set_image_pal
	ld   a,5
	call wait_pause
	ld   a,(joust_lord1)
	call getlname
	push hl
	ld   hl,tournois
	ld   a,10
	call placard
	call music_off

;	ld   hl,JOUST_SONS
;	ld   de,BUFMUS
;	call readfile

joutnext
;
;testfin
;
	ld   hl,joust_lordsout
	ld   b,9
testbcl  ld   a,(hl)
	inc  hl
	or   a
	jr  nz,testfin_end
	djnz testbcl
	call gallanim
	ld   hl,joutvict
	ld   a,10
	call placard
	xor  a
	ret    ; fin joute
testfin_end
	call casenlor
	call nc,seladv
	call selstake
	call runjoute
	cp   2
	jp   c,killedit
	jp   z,wonit
	ld   a,(joust_region2)
	or   a
	jr   z,lostlea
	call getreg
	ld   a,(joust_lord2)
	ld   (ix+07),a
	ld   a,(joust_lord1)
	call getlord
	ld   a,(joust_region2)
	cp   (iy+07)
	jr   nz,joutef
	ld   a,(joust_lord1)
	call lgethome
	ld   (iy+07),a
	jr   joutef
lostlea
	ld   a,(joust_lord1)
	call getlord
	ld   a,(iy+01)
	sub  3
	jr   c,joutef
	inc  a
	ld   (iy+01),a
joutef
	or   a
	ret
wonit
	ld   a,(joust_region1)
	or   a
	jr   z,wonlea
	call getreg
	ld   a,(joust_lord1)
	ld   (ix+07),a
	ld   a,(joust_lord2)
	call getlord
	ld   a,(joust_region1)
	cp   (iy+07)
	jp   nz,joutnext
	ld   a,(joust_lord2)
	call lgethome
	ld   (iy+07),a
	jp   joutnext
wonlea
	ld   a,(joust_lord1)
	call getlord
	ld   a,(iy+01)
	add  a,2
	cp   11
	jr   c,oknewlea
	ld   a,10
oknewlea ld   (iy+01),a
	jp   joutnext
killedit
	ld   b,18
killbcle ld   a,b
	call rgetprop
	ld   hl,joust_lord1
	cp   (hl)
	jr   nz,killstra
	ld   a,b
	call rgetbuil
	or   a
	jr   nz,killstra
	ld   a,b
	call getreg
	ld   (ix+07),0
killstra djnz killbcle
	ld   a,(joust_lord1)
	call lgethome
	ld   hl,0
	call rputsold
	call rputchev
	call rputcata
	ld   b,a
	ld   a,(joust_lord1)
	call getlord
	ld   (iy+07),b
	scf
	ret
;
casenlor
	ld   a,(joust_lord1)
	call lgetype
	cp   3
	ret  z

	ld   a,(joust_lord1)
	ld   (joust_lord2),a

	ld   hl,joust_lordsout-1
	ld   d,0
	ld   e,a
	add  hl,de
	ld   (hl),d	; d=0

	ld   hl,(lord)
	ld   a,(hl)
	ld   (joust_lord1),a
	scf
	ret
;
seladv
	call gallanim
	xor  a
	ld   (joust_nblords),a
	ld   a,9
selscan  ld   (joust_lord2),a
	ld   hl,joust_lordsout-1
	ld   e,a
	ld   d,0
	add  hl,de
	ld   a,(hl)
	or   a
	jr   z,pas_la
	ld   a,(joust_lord2)
	call lgetype
	cp   3
	jr   z,pas_la
	or   a
	jr   z,pas_la
	ld   hl,selcode2
	push hl
	ld   a,(joust_lord2)
	call getlname
	push hl
	ld   hl,selcode
	push hl
	ld   hl,joust_nblords
	inc  (hl)
	ld   a,(hl)
ecri_tab ld   de,(joust_lord2)
	ld   d,0
	ld   hl,joust_lordsout-1
	add  hl,de
	ld   (hl),a
	ld   a,(joust_lord2)
	dec  a
	jr   nz,selscan
	jr   scan_fin
pas_la   ld   hl,nopcode
	push hl
	push hl
	push hl
	xor  a
	jr   ecri_tab

scan_fin ld   hl,joutsel
	call menutext
	call menurest
	ld   d,a
	ld   a,(joust_nblords)
	cp   d
	jr   nc,sel_ok
	call affmap
joutemap call execarte
	jr   nc,joutemap
	xor  a
	ld   (joust_indic),a
	jp   seladv
sel_ok   ld   hl,joust_lordsout-1
	sub  d
	inc  a
	ld   d,0
retrieve inc  hl
	inc  d
	cp   (hl)
	jr   nz,retrieve
	ld   (hl),0
	ld   a,d
	ld   (joust_lord2),a
	ret
;
selstake
	xor  a
	ld   (joust_region1),a
	ld   (joust_region2),a
	ld   a,(joust_lord2)
	ld   d,a
	call tstfree
	jr   nc,noreg
	ld   de,(joust_lord1-1)
	call tstfree
	jr   c,yesreg
noreg    ld   a,(joust_lord2)
	call getlname
	push hl
	ld   hl,forfame
	ld   a,7
	call placard
	ret
yesreg   ld   hl,stakes
	call menutext
	call menurest
	cp   1
	jr   z,yeslea
	call affmap
selreg   call choixreg
	ld   (joust_region1),a
	call rgetprop
	ld   de,(joust_lord2)
	cp   e
	jr   z,yeshis
	ld   hl,nothis
	ld   a,5
	call placard
	jr   selreg
yeshis   ld   a,(joust_region1)
	call rgetbuil
	or   a
	jr   z,yesempty
	ld   hl,notempty
	ld   a,5
	call placard
	jr   selreg
yesempty call lordchoo
	ld   (joust_region2),a
	call getrname
	push hl
	ld   a,(joust_lord2)
	call getlname
	push hl
	ld   hl,forreg
	ld   a,7
	call placard
	ret
yeslea   ld   a,(joust_lord2)
	call getlname
	push hl
	ld   hl,forlead
	ld   a,7
	call placard
	ret
;
tstfree
	ld   b,18
tstfr1   ld   a,b
	call rgetprop
	cp   d
	jr   nz,tstfr2
	ld   a,b
	call rgetbuil
	or   a
	scf
	ret  z
tstfr2   djnz tstfr1
	or   a
	ret
;
lordchoo
	push bc
	push hl
	ld   a,(joust_lord2)
	call lgetpref
	ld   a,(joust_lord1)
	ld   c,a
lordcho0 ld   a,(hl)
	call rgetprop
	cp   c
	jr   nz,lordcho1
	ld   a,(hl)
	call rgetbuil
	or   a
	jr   z,lordcho2
lordcho1 inc  hl
	ld   a,(hl)
	or   a
	jr   nz,lordcho0
lordcho2 ld   a,(hl)
	pop  hl
	pop  bc
	ret
;
;
;lance()
;
lance
	push af
	push bc
	push de
	push hl
	ld   hl,Joust_sprno
	inc  (hl)
	call getjoy
	ld   c,a
	bit  0,c
	jr   z,lanc0
	ld   a,1
	ld   (dyl),a
lanc0    bit  1,c
	jr   z,lanc1
	ld   a,-1
	ld   (dyl),a
lanc1    bit  2,c
	jr   z,lanc2
	ld   a,-1
	ld   (dxl),a
lanc2    bit  3,c
	jr   z,lanc3
	ld   a,1
	ld   (dxl),a
lanc3
	ld   a,(dxl)
	ld   d,a
	ld   a,(dyl)
	ld   e,a
;	push bc
;	call vbl_wait
;	pop bc
	call efflance
	ld   a,(xlance)
	add  a,d
	add  a,d
	cp   xmin
	jr   c,noxmov
	cp   xmax
	jr   nc,noxmov
	ld   (xlance),a
noxmov   ld   a,(ylance)
	add  a,e
	add  a,e
	add  a,e
	add  a,e
	cp   ymin
	jr   c,noymov
	cp   ymax
	jr   nc,noymov
	ld   (ylance),a
noymov
	call afflance
	call lancspr

;	ld   a,(soundind)
;	inc  a
;	cp   4
;	jr   nz,lance0
;	xor  a
;lance0   ld   (soundind),a
;	or   a
;	ld   a,5
;	call z,bruit
	pop  hl
	pop  de
	pop  bc
	pop  af
	ret
;
soundind db 0
ylance   db 0
xlance   db 0
dxl      ds 1
dyl      ds 1
;
lancspr
	push ix
	push bc
	push de
	push hl
	push af
	ld   a,(Joust_sprno)
	ld   hl,BUFSPR
	call getspr
	ld   ix,yla
	ld   (ix+04),c
	ld   (ix+05),b
	ld   bc,(ylance)
	ld   (ix+00),c
	ld   (ix+01),b
	ld   (spradd),hl
	ld   hl,anicharg+3
	ld   de,5
	ld   a,(Joust_sprno)
	call rdtab
	ld   a,(hl)
	ld   (ix+02),a
	inc  hl
	ld   a,(hl)
	ld   (ix+03),a
	ld   b,11
	ld   de,scrbuf
lancspr0 call joust_test
	inc  de
	inc  (ix+01)
	inc  (ix+01)
	bit  2,b
	jr   nz,lancspr1
	call joust_test
	inc  de
lancspr1 inc  (ix+01)
	inc  (ix+01)
	call joust_test
	inc  de
	dec  (ix+01)
	dec  (ix+01)
	dec  (ix+01)
	dec  (ix+01)
	dec  (ix+00)
	dec  b
	jp   p,lancspr0
	pop  af
	pop  hl
	pop  de
	pop  bc
	pop  ix
	ret
;
joust_test
	ld   a,(ix+03)
	cp   (ix+01)
	jr   c,test0
	ret  nz
test0    add  a,(ix+05)
	add  a,(ix+05)
	cp   (ix+01)
	ret  c
	ret  z
	ld   a,(ix+02)
	cp   (ix+00)
	ret  c
	sub  (ix+04)
	inc  a
	cp   (ix+00)
	jr   c,test1
	ret  nz
test1    ld   hl,(spradd)
	push de
	ld   a,(ix+01)
	sub  (ix+03)
	srl  a
	ld   e,a
	ld   d,0
	add  hl,de
	ld   e,(ix+05)
	ld   a,(ix+02)
	sub  (ix+00)
test2    or   a
	jr   z,test3
	add  hl,de
	dec  a
	jr   test2
test3    ld   a,(hl)
	ld   (hl),rouge
	pop  de
	ld   (de),a
	ret
;
yla      ds 1
xla      ds 1
ys       ds 1
xs       ds 1
dys      ds 1
dxs      ds 1
spradd   ds 2
rouge    equ  #c0
Joust_sprno    ds 1
;
lancinit
	ld   a,9
	call random
	dec  a
	sla  a
	add  a,xbull-8
	ld   (xlance),a
	ld   a,9
	call random
	dec  a
	sla  a
	sla  a
	add  a,ybull-16
	ld   (ylance),a
	call afflance
	ld   a,1
	ld   (Joust_sprno),a
	ld   (dxl),a
	ld   (dyl),a
	jp lancspr
;
scrbuf   ds 32
;
afflance
	push hl
	push de
	push bc
	push af
	ld   de,scrbuf
	ld   hl,(ylance)
	call scradd
	ld   b,11
affl0    push hl
	ld   a,(hl)
	ld   (de),a
	inc  de
	ld   (hl),rouge
	inc  hl
	bit  2,b
	jr   nz,affl1
	ld   a,(hl)
	ld   (de),a
	inc  de
	ld   (hl),rouge
affl1    inc  hl
	ld   a,(hl)
	ld   (de),a
	inc  de
	ld   (hl),rouge
	pop  hl
	call nextline
	dec  b
	jp   p,affl0
	pop  af
	pop  bc
	pop  de
	pop  hl
	ret
;
efflance
	push hl
	push de
	push bc
	push af
	ld   de,scrbuf
	ld   hl,(ylance)
	call scradd
	ld   b,11
effl0    push hl
	ld   a,(de)
	ld   (hl),a
	inc  de
	inc  hl
	bit  2,b
	jr   nz,effl1
	ld   a,(de)
	ld   (hl),a
	inc  de
effl1    inc  hl
	ld   a,(de)
	ld   (hl),a
	inc  de
	pop  hl
	call nextline
	dec  b
	jp   p,effl0
	pop  af
	pop  bc
	pop  de
	pop  hl
	ret
;
;
;gallanim()
;
gallanim
	LOAD_DECOMP_SCR JOUST_GALLERY
	ld   hl,JOUST_GKNIGHT
	ld   de,BUFSPRLOAD
	call readfile

	ld   hl,(anibuf)
	ld   (hl),e
	inc  hl
	ld   (hl),d
	call lutinit
	ld   hl,256*0+174
	ld   a,1
	call affspr
	ld   hl,256*34+97
	ld   a,2
	call lutin
	call luton
	ld   hl,256*36+60
	ld   a,4
	call lutin
	call luton
	call set_image_pal
	ld   a,7
	ld   hl,256*126+71
	call lutin
	ld   a,9
	ld   hl,256*116+107
	call lutin
;	ld   hl,anigal
;	ld   de,retadd
;	call animateb
	ld   hl,joust_indic
	ld   a,(hl)
	ld   (hl),1
	or   a
	ret  z
	ld   a,(joust_lord2)
	call getlname
	push hl
	ld   hl,txtvict
	ld   a,3
	call placard
retadd   ret
;
;runjoute
;
runjoute
runagain
	LOAD_DECOMP_SCR JOUST_JOUSTOP
	ld   hl,JOUST_JTOPSPR
	ld   de,BUFSPRLOAD
	call readfile

	ld   hl,(anibuf)
	ld   (hl),e
	inc  hl
	ld   (hl),d
	call lutinit
	ld   a,15
	call lutin
	ld   a,30
	call lutin
	call set_image_pal
;	ld   hl,topmove1
;	call animate
;	ld   b,2
;	ld   hl,topmove2
;runjout2 call animate
;	djnz runjout2
;	ld   hl,topmove3
;	call animate
runjtst
	LOAD_DECOMP_SCR JOUST_TENTS
	ld   hl,JOUST_CHARGE
	ld   de,BUFSPRLOAD
	call readfile
	ld   hl,(anibuf)
	ld   (hl),e
	inc  hl
	ld   (hl),d
	call lutinit
	ld   a,19
	call lutin
	call set_image_pal
	call lancinit
;	ld   a,5
;	call bruit
;	ld   hl,anicharg
;	ld   de,lance
;	call animateb
;	ld   a,6
;	call bruit
	ld   a,4
	call wait_pause

	ld   a,(ylance)
	cp   ytoolow
	ld   a,1
	jr   c,viewjout

	ld   a,(joust_lord1)
	call getlord
	ld   a,(iy+03)
	inc  a
	srl  a
	dec  a
	dec  a
	ld   b,a
	ld   a,(xlance)
	sub  xbull
	jr   nc,dxpos
	neg
dxpos    srl  a
	cp   b
	jr   nc,lrate
	ld   a,(ylance)
	sub  ybull
	jr   nc,dypos
	neg
dypos    srl  a
	srl  a
	cp   b
	jr   nc,lrate
	ld   a,2
	jr   viewjout

lrate
	ld   a,(joust_lord2)
	call getlord
	ld   b,(iy+03)
	ld   a,10
	call random
	cp   b
	jr   nc,nrate
	ld   a,3
	jr   viewjout

nrate
	ld   a,4

viewjout
	push af
	LOAD_DECOMP_SCR JOUST_SIDE
	pop  af

	push af
	ld   hl,JOUST_SIDEDEAD
	cp   2
	jr   c,sidefile
	ld   hl,JOUST_SIDEWON
	jr   z,sidefile
	ld   hl,JOUST_SIDELOST
sidefile
	ld   de,BUFSPRLOAD
	call readfile

	ld   hl,(anibuf)
	ld   (hl),e
	inc  hl
	ld   (hl),d
	call lutinit
	ld   a,3
	ld   hl,256*110+76
	call lutin
	ld   a,1
	ld   hl,76
	call lutin
	call set_image_pal
	ld   b,11
sidebcl
;	push bc
;	ld   b,4
;	ld   hl,#fe00
;	call multset1
;	ld   b,2
;	ld   hl,#0200
;	call multset2
;	call multido
;	ld   b,3
;	ld   hl,#fe00
;	call multset1
;	ld   b,1
;	ld   hl,#0200
;	call multset2
;	call multido
;	pop  bc
;	djnz sidebcl

;	pop  af
;	push af

;	ld   ix,animkill
;	ld   b,8
;	dec  a
;	jr   z,sideopt
;	ld   ix,animwon
;	ld   b,8
;	dec  a
;	jr   z,sideopt
;	ld   b,6
;	ld   ix,animlost
;	dec  a
;	jr   z,sideopt
;	ld   b,6
;	ld   ix,animnul
;sideopt
;	push bc
;	ld   b,(ix+00)
;	inc  ix
;	ld   h,(ix+00)
;	inc  ix
;	ld   l,0
;	push ix
;	call multset1
;	pop  ix
;	ld   b,(ix+00)
;	inc  ix
;	ld   h,(ix+00)
;	inc  ix
;	ld   l,0
;	push ix
;	call multset2
;	call multido
;	pop  ix
;	pop  bc
;	djnz sideopt

	pop  af
	push af
	ld   hl,txtkill
	dec  a
	jr   z,sideopt2
	ld   hl,txtwon
	dec  a
	jr   z,sideopt2
	ld   hl,txtlost
	dec  a
	jr   z,sideopt2
	ld   hl,txtnul
sideopt2 ld   a,10
	call placard
	pop  af
	cp   4
	jp   z,runagain
	ret
;
;multset1
;	push bc
;	push hl
;	ld   a,1
;	call getlut
;	ld   a,b
;	ld   (larg1),a
;	ld   a,c
;	ld   (haut),a
;	ld   (oldadd1),hl
;	ld   (buff1),de
;	pop  hl
;	ld   a,(ix+01)
;	add  a,h
;	ld   (ix+01),a
;	ld   h,a
;	ld   a,(ix+02)
;	add  a,l
;	ld   (ix+02),a
;	ld   l,a
;	call scradd
;	ld   (add1),hl
;	pop  bc
;	ld   (ix+00),b
;	ld   a,b
;	ld   hl,BUFSPR
;	call getspr
;	ld   (sprite1),hl
;	ret
;multset2
;	push bc
;	push hl
;	ld   a,2
;	call getlut
;	ld   a,b
;	ld   (larg2),a
;	ld   a,c
;	ld   (haut),a
;	ld   (oldadd2),hl
;	ld   (buff2),de
;	pop  hl
;	ld   a,(ix+01)
;	add  a,h
;	ld   (ix+01),a
;	ld   h,a
;	ld   a,(ix+02)
;	add  a,l
;	ld   (ix+02),a
;	ld   l,a
;	call scradd
;	ld   (add2),hl
;	pop  bc
;	ld   (ix+00),b
;	ld   a,b
;	ld   hl,BUFSPR
;	call getspr
;	ld   (sprite2),hl
;	ret
;
;multido
;	ld   hl,(oldadd2)
;	ld   de,(oldadd1)
;	ld   bc,(larg1)
;	call subst
;	ld   (offset1+1),hl
;	ld   hl,(add1)
;	ld   de,(oldadd2)
;	ld   bc,(larg2)
;	call subst
;	ld   (offset2+1),hl
;	ld   hl,(add2)
;	ld   de,(add1)
;	ld   bc,(larg1)
;	call subst
;	ld   (offset3+1),hl
;	ld   (offset5+1),hl
;	ld   hl,(add1)
;	ld   de,(add2)
;	ld   bc,(larg2)
;	call subst
;	ld   (offset4+1),hl
;	ld   hl,(buff1)
;	ld   (bf1+1),hl
;	ld   hl,(buff2)
;	ld   (bf2+1),hl
;	ld   hl,(sprite1)
;	ld   (spr1+1),hl
;	ld   hl,(sprite2)
;	ld   (spr2+1),hl
;	ld   a,(larg1)
;	ld   (la10+1),a
;	ld   (la11+1),a
;	ld   (la12+1),a
;	ld   a,(larg2)
;	ld   (la20+1),a
;	ld   (la21+1),a
;	ld   (la22+1),a
;	ld   a,(larg1)
;	ld   c,a
;	ld   a,(larg2)
;	add  a,c
;	add  a,10
;	ld   c,a
;	ld   b,0
;	ld   hl,312
;	ld   de,(haut)
;	ld   d,0
;	or   a
;	sbc  hl,de
;	ld   d,-1
;calcbcl  sbc  hl,bc
;	inc  d
;	jr   nc,calcbcl
;	ld   a,d
;	ld   (nlig+1),a
;	ld   a,(haut)
;	ld   b,a
;	ld   de,(oldadd1)
;	call tillbot
;
;multbcl
;	push bc
;
;bf1      ld   hl,0
;la10     ld   bc,0
;	push de
;	ldir
;
;offset1  ld   hl,0
;	add  hl,de
;	ex   de,hl
;bf2      ld   hl,0
;la20     ld   bc,0
;	ldir
;
;offset2  ld   hl,0
;	add  hl,de
;	ld   de,(bf1+1)
;la11     ld   bc,0
;	ldir
;	ld   (bf1+1),de
;
;offset3  ld   de,0
;	add  hl,de
;	ld   de,(bf2+1)
;la21     ld   bc,0
;	ldir
;	ld   (bf2+1),de
;
;offset4  ld   de,0
;	add  hl,de
;spr1     ld   de,0
;la12     ld   b,0
;	call merge
;	ld   (spr1+1),de
;
;offset5  ld   de,0
;	add  hl,de
;spr2     ld   de,0
;la22     ld   b,0
;	call merge
;	ld   (spr2+1),de
;
;	pop  de
;	ld   hl,#800
;	add  hl,de
;	jr   nc,nocarr
;	ld   de,-#3fb0
;	jr   yecarr
;nocarr   ld   de,#0000
;	add  a,(hl)
;yecarr   add  hl,de
;	ex   de,hl
;
;	pop  bc
;	dec  c
;	call z,tillbot
;	dec  b
;	jp   nz,multbcl
;
;	ei
;	ret
;
;merge
;merge10  ld   a,(de)
;	and  #55
;	jr   nz,merge11
;	ld   a,(hl)
;	and  #55
;	jr   merge12
;merge11  push hl
;	pop  hl
;merge12  ld   c,a
;	ld   a,(de)
;	and  #aa
;	jr   nz,merge13
;	ld   a,(hl)
;	and  #aa
;	jr   merge14
;merge13  push hl
;	pop  hl
;merge14  or   c
;	ld   (hl),a
;	inc  hl
;	inc  de
;	bit  0,(hl)
;	bit  0,(ix+00)
;	djnz merge10
;	ret
;
;subst
;	ld   b,0
;	or   a
;	sbc  hl,bc
;	or   a
;	sbc  hl,de
;	ret
;
;tillbot
;	push bc
;	call vbl_wait
;	pop  bc
;nlig     ld   c,0
;	ret
;;
;haut     ds 1
;larg1    ds 1
;larg2    ds 1
;;
;buff1    ds 2
;oldadd1  ds 2
;add1     ds 2
;sprite1  ds 2
;;
;buff2    ds 2
;oldadd2  ds 2
;add2     ds 2
;sprite2  ds 2
;;
;animkill
;	db 4,-2
;	db 5,2
;	db 3,-2
;	db 6,2
;	db 4,-2
;	db 7,4
;	db 3,-2
;	db 8,4
;	db 4,-2
;	db 9,6
;	db 3,-2
;	db 10,6
;	db 4,-2
;	db 11,6
;	db 3,-2
;	db 12,0
;;
;animwon
;	db 4,-2
;	db 5,2
;	db 3,-2
;	db 6,1
;	db 4,-2
;	db 7,0
;	db 3,-2
;	db 8,1
;	db 4,-2
;	db 9,0
;	db 3,-2
;	db 10,1
;	db 4,-2
;	db 11,4
;	db 3,-2
;	db 12,7
;;
;animlost
;	db 5,-1
;	db 2,2
;	db 6,1
;	db 1,2
;	db 7,-1
;	db 2,2
;	db 8,0
;	db 1,2
;	db 9,-1
;	db 2,2
;	db 10,-2
;	db 1,2
;;
;animnul
;	db 4,-2
;	db 2,2
;	db 3,-2
;	db 1,2
;	db 4,-2
;	db 2,2
;	db 3,-2
;	db 1,2
;	db 4,-2
;	db 2,2
;	db 3,-2
;	db 1,2
;;
;anigal
;	db 10
;	db #2c,10,40
;	db #2a,5,20
;	db #2a,6,20
;	db #29,3,20
;	db #2b,8,100
;	db #2c,9,40
;	db #29,2,20
;	db #2a,5,20
;	db #2a,4,20
;	db #23,7
;;
anicharg
	db 19
	db #39,1,96,62,20
	db #39,2,96,62,20
	db #39,3,94,60,20
	db #39,4,93,58,20
	db #39,5,93,58,20
	db #39,6,92,56,20
	db #39,7,91,56,20
	db #39,8,90,52,20
	db #39,9,91,52,20
	db #39,10,91,50,20
	db #39,11,91,50,20
	db #39,12,90,48,20
	db #39,13,88,48,20
	db #39,14,86,46,20
	db #39,15,85,42,20
	db #39,16,86,40,20
	db #39,17,86,40,20
	db #39,18,87,36,20
	db #39,19,87,36,20
;;
;topmove1
;	db 16
;	db #31,1,120,36
;	db #3a,16,120,116,20
;	db #31,2,118,34
;	db #3a,17,118,120,20
;	db #31,3,113,32
;	db #3a,18,114,124,20
;	db #31,4,113,34
;	db #3a,19,114,126,20
;	db #31,5,110,34
;	db #3a,20,114,126,20
;	db #31,6,103,32
;	db #3a,21,108,122,20
;	db #31,7,101,36
;	db #3a,22,108,116,20
;	db #31,8,102,36
;	db #3a,23,109,110,20
;topmove2
;	db 8
;	db #b1,9,0,1
;	db #ba,24,0,255,6
;	db #b1,10,0,3
;	db #ba,25,0,255,6
;	db #b1,11,0,1
;	db #ba,26,0,255,6
;	db #b1,8,0,1
;	db #ba,23,0,253,6
;topmove3
;	db 8
;	db #b1,12,0,2
;	db #ba,27,0,254,9
;	db #b1,13,0,2
;	db #ba,28,0,254,9
;	db #b1,14,0,3
;	db #ba,29,0,253,9
;	db #b1,15,0,4
;	db #ba,30,0,252,9
; ---------------------------
;variables
; ---------------------------
joust_lord1    ds 1
joust_lord2    ds 1
joust_region1  ds 1
joust_region2  ds 1
joust_lordsout ds 9
joust_nblords  ds 1
joust_indic    db 0
; ---------------------------
;constantes
; ---------------------------
ytoolow  equ  39
xbull    equ  48
ybull    equ  66
xmin     equ  30
xmax     equ  70
ymin     equ  8
ymax     equ  85
; ---------------------------
	read "DoTC_Text_Joust.asm"
; ---------------------------
list:DOTC_JOUST_LENGTH equ $-DOTC_JOUST_ADDRESS:nolist