;
;Noms des personnages
;
CHARACTERS_NAMES_IDX
	dw saxon1, saxon2, saxon3, saxon4
	dw normand1,normand2,normand3,normand4,normand5
	dw lady1,lady2,lady3,lady4
CHARACTERS_NAMES
saxon1
	db "Wilfried of Hivanoe",EOL
saxon2
	db "Cedric of Rotherwood",EOL
saxon3
	db "Geoffrey Longsword",EOL
saxon4
	db "Wolfric the Wild",EOL
normand1
	db "Brian de Bois-Guilbert",EOL
normand2
	db "Phillip Malvoisin",EOL
normand3
	db "Reginald Font-de-Boeuf",EOL
normand4
	db "Edmund the Grim",EOL
normand5
	db "Roger Falconbridge",EOL
lady1
	db "Rebecca of York",EOL
lady2
	db "Katherine of Nottingham",EOL
lady3
	db "Anne of Lancashire",EOL
lady4
	db "Rosalind of Bedford",EOL
;
;Prenoms des saxons
;
PRENOMS
         DEFB "Wilfried",#FF
         DEFB "Cedric",#FF
         DEFB "Geoffrey",#FF
         DEFB "Wolfric",#FF
;
;Noms des territoires
;
LANDS_IDX
	dw land1,land2,land3,land4,land5,land6,land7,land8,land9,land10
	dw land11,land12,land13,land14,land15,land16,land17,land18
land1
	db "Cumbria",EOL
land2
	db "Yorkshire",EOL
land3
	db "Lancashire",EOL
land4
	db "Lincolnshire",EOL
land5
	db "Nottingham",EOL
land6
	db "Gwynedd",EOL
land7
	db "Leicester",EOL
land8
	db "Norfolk",EOL
land9
	db "Clwyd",EOL
land10
	db "Cambridge",EOL
land11
	db "Glamorgan",EOL
land12
	db "Buckingham",EOL
land13
	db "Gloucester",EOL
land14
	db "Essex",EOL
land15
	db "Hampshire",EOL
land16
	db "Dorset",EOL
land17
	db "Sussex",EOL
land18
	db "Cornwall",EOL
;
;Preposition pour chaque region
;
; used by DIVERS.AFFLAND() only
;
LANDS_PREPOSI_IDX
	dw landp1,landp2,landp3,landp4,landp5,landp6,landp7,landp8,landp9,landp10
	dw landp11,landp12,landp13,landp14,landp15,landp16,landp17,landp18

landp1
	db "au",EOL
landp2
	db "au",EOL
landp3
	db "au",EOL
landp4
	db "au",EOL
landp5
	db "^ ",EOL
landp6
	db "en",EOL
landp7
	db "^ ",EOL
landp8
	db "au",EOL
landp9
	db "en",EOL
landp10
	db "^ ",EOL
landp11
	db "au",EOL
landp12
	db "^ ",EOL
landp13
	db "^ ",EOL
landp14
	db "en",EOL
landp15
	db "au",EOL
landp16
	db "au",EOL
landp17
	db "au",EOL
landp18
	db "en",EOL
;
;Noms des mois
;
MOIS
         DEFB "JAN ",#FF
         DEFB "FEV ",#FF
         DEFB "MARS",#FF
         DEFB "AVR ",#FF
         DEFB "MAI ",#FF
         DEFB "JUIN",#FF
         DEFB "JUIL",#FF
         DEFB "AOUT",#FF
         DEFB "SEPT",#FF
         DEFB "OCT ",#FF
         DEFB "NOV ",#FF
         DEFB "DEC ",#FF
;
;Noms des niveaux
;
LEVEL
         DEFB "FAIBLE",#FF
         DEFB "MOYEN",#FF
         DEFB "BON",#FF
         DEFB "FORT",#FF

;	read "TEXTE_MENUS.ASM"
