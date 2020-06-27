	nolist

COMPILDISK1	equ 1
COMPILDISK2	equ 1

;	nocode

;; disc 0
;;	read "new_loader.asm"
	read "MAIN.ASM"
;;	read "INTRO.ASM"
;;	read "VICTOIRE.ASM"
;;	read "DEFAITE.ASM"
;;	read "SON.ASM"	; generate DEFENDER.SON
;;	read "RAID.ASM"
;;	read "EVENT.ASM"
;;	read "ROBIN.ASM"
;;	read "SIEGE.ASM"
;;	read "JOUTE.ASM"

; Changes
; ASM	replace 
;; : 		-> -
;; SELECT 	-> read
;; PAUSE	-> WAIT_PAUSE (ASM reserved word)
;; DIRECT	-> DIRECT_READ (ASM reserved word)
;; MOD		-> MODULO (ASM reserved word)
;; TITLE	-> TITLE_FILE (ASM reserved word)
;; END		-> END_FILE (ASM reserved word)
;; MACRO Syntax
;; FREE, DBXON, DBXOFF et ! (MUSINT.ASM)

; GKNIGHT.SPR, GALLERY.DEF -> pris de la version de CACH
; DISC.BIN
;	passage en chargement fichiers (vecteurs systemes)
;	ajout gestion drive a et b


; sortie du texte du code
; MAIN.ASM, ROBIN.ASM, VICTOIRE.ASM, RAID.ASM, DEFAITE.ASM, JOUTE.ASM, INTRO.ASM
; SIEGE.ASM

; mauvaise idée !!! call + ret -> jp car utilisation de la pile !

