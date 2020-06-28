; ---------------------------
; Names of characters
; ---------------------------
CHARACTERS_NAMES_IDX
	dw saxon1, saxon2, saxon3, saxon4
	dw normand1,normand2,normand3,normand4,normand5
	dw lady1,lady2,lady3,lady4
CHARACTERS_NAMES
saxon1
	db "Wilfried of Hivanoe",EOT
saxon2
	db "Cedric of Rotherwood",EOT
saxon3
	db "Geoffrey Longsword",EOT
saxon4
	db "Wolfric the Wild",EOT
normand1
	db "Brian de Bois-Guilbert",EOT
normand2
	db "Phillip Malvoisin",EOT
normand3
	db "Reginald Font-de-Boeuf",EOT
normand4
	db "Edmund the Grim",EOT
normand5
	db "Roger Falconbridge",EOT
lady1
	db "Rebecca of York",EOT
lady2
	db "Katherine of Nottingham",EOT
lady3
	db "Anne of Lancashire",EOT
lady4
	db "Rosalind of Bedford",EOT
; ---------------------------
;Prenoms des saxons
; ---------------------------
PRENOMS
	DEFB "Wilfried",EOT
	DEFB "Cedric",EOT
	DEFB "Geoffrey",EOT
	DEFB "Wolfric",EOT
; ---------------------------
;Noms des territoires
; ---------------------------
LANDS_IDX
	dw land1,land2,land3,land4,land5,land6,land7,land8,land9,land10
	dw land11,land12,land13,land14,land15,land16,land17,land18
land1
	db "Cumbria",EOT
land2
	db "Yorkshire",EOT
land3
	db "Lancashire",EOT
land4
	db "Lincolnshire",EOT
land5
	db "Nottingham",EOT
land6
	db "Gwynedd",EOT
land7
	db "Leicester",EOT
land8
	db "Norfolk",EOT
land9
	db "Clwyd",EOT
land10
	db "Cambridge",EOT
land11
	db "Glamorgan",EOT
land12
	db "Buckingham",EOT
land13
	db "Gloucester",EOT
land14
	db "Essex",EOT
land15
	db "Hampshire",EOT
land16
	db "Dorset",EOT
land17
	db "Sussex",EOT
land18
	db "Cornwall",EOT
; ---------------------------
;Preposition pour chaque region
; ---------------------------
; used by DIVERS.AFFLAND() only
;
LANDS_PREPOSI_IDX
	dw landp1,landp2,landp3,landp4,landp5,landp6,landp7,landp8,landp9,landp10
	dw landp11,landp12,landp13,landp14,landp15,landp16,landp17,landp18

landp1
	db "au",EOT
landp2
	db "au",EOT
landp3
	db "au",EOT
landp4
	db "au",EOT
landp5
	db "^ ",EOT
landp6
	db "en",EOT
landp7
	db "^ ",EOT
landp8
	db "au",EOT
landp9
	db "en",EOT
landp10
	db "^ ",EOT
landp11
	db "au",EOT
landp12
	db "^ ",EOT
landp13
	db "^ ",EOT
landp14
	db "en",EOT
landp15
	db "au",EOT
landp16
	db "au",EOT
landp17
	db "au",EOT
landp18
	db "en",EOT
; ---------------------------
;Noms des mois
; ---------------------------
MOIS
	DEFB "JAN ",EOT
	DEFB "FEV ",EOT
	DEFB "MARS",EOT
	DEFB "AVR ",EOT
	DEFB "MAI ",EOT
	DEFB "JUIN",EOT
	DEFB "JUIL",EOT
	DEFB "AOUT",EOT
	DEFB "SEPT",EOT
	DEFB "OCT ",EOT
	DEFB "NOV ",EOT
	DEFB "DEC ",EOT
; ---------------------------
;Noms des niveaux
; ---------------------------
LEVEL
	DEFB "FAIBLE",EOT
	DEFB "MOYEN",EOT
	DEFB "BON",EOT
	DEFB "FORT",EOT

;	read "TEXTE_MENUS.ASM"
