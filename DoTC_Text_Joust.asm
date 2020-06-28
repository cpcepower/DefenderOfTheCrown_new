SELCODE  db #FE,EOT
SELCODE2 db #FE,#F9,EOT
NOPCODE  db EOT
;
JOUST_MUS	db SIDE_JOUST,"JOUST   MUS"
JOUST_GALLERY	db SIDE_JOUST,"GALLERY DEF"
JOUST_JOUSTOP	db SIDE_JOUST,"JOUSTOP DEF"
JOUST_SIDE	db SIDE_JOUST,"SIDE    DEF"
JOUST_TENTS	db SIDE_JOUST,"TENTS   DEF"
JOUST_TRUMP	db SIDE_JOUST,"TRUMP   DEF"
JOUST_GKNIGHT	db SIDE_JOUST,"GKNIGHT SPR"
JOUST_CHARGE	db SIDE_JOUST,"CHARGE  SPR"
JOUST_JTOPSPR	db SIDE_JOUST,"JTOPSPR SPR"
JOUST_SIDEDEAD	db SIDE_JOUST,"SIDEDEADSPR"
JOUST_SIDEWON	db SIDE_JOUST,"SIDEWON SPR"
JOUST_SIDELOST	db SIDE_JOUST,"SIDELOSTSPR"
;JOUST_SONS	db SIDE_JOUST,"DEFENDERSON"
;
;TEXTES
;
TOURNOIS
         db 1,9,38
         db "- LE TOURNOIS -",#F9,#F9
         db "Sir ",#FD," convie"
         db " les chevaliers Ashby o_ s'organise"
         db " la joute. C'est un jour de f\te mais"
         db " les haines de la guerre restent ^"
         db " l'esprit de chacun."
         db EOT
;
FORFAME
         db 1,10,38
         db "Vous allez combattre pour la gloire contre Sir ",#FD,EOT
;
STAKES
         db 9,10,20
         db "Choisissez la mise",#F9
         db #FE," Prestige ",#FE,#F9
         db #FE,"Territoire",#FE,EOT
;
NOTHIS
         db 1,10,38
         db "Cette r[gion n'appartient pas votre adversaire.",EOT
;
NOTEMPTY
         db 1,10,38
         db "Vous ne pouvez combattre pour une r[gion qui contient"
         db " un ch&teau.",EOT
;
FORREG
         db 5,10,28
         db "Sir ",#FD," a choisi la r[gion de ",#FD," comme mise.",EOT
;
FORLEAD
         db 1,10,38
         db "Vous mettez en jeu votre prestige contre Sir ",#FD,".",EOT
;
JOUTVICT
         db 1,5,38
         db "-LE CHAMPION-",#F9
         db "La joute s'ach]ve, et vous \tes proclam[ champion"
         db " du tournoi. Votre adresse reste invaincue, et votre"
         db " force est sans [gal. L'annonce de votre victoire se"
         db " r[pend travers tout le royaume...",EOT
;
JOUTSEL
         db 1,1,24
         db #FD,#FD,#FD
         db #FD,#FD,#FD
         db #FD,#FD,#FD
         db #FD,#FD,#FD
         db #FD,#FD,#FD
         db #FD,#FD,#FD
         db #FD,#FD,#FD
         db #FD,#FD,#FD
         db #FD,#FD,#FD
         db #FE,"Lire Carte",#FE,EOT
;
TXTKILL
         db 3,5,34
         db "-LA DISGRACE-",#F9
         db "Un coup bas abbat la monture de votre adversaire."
         db " C'est un jour noir pour tous ceux qui portent votre "
         db "nom. Vous avez transgress[ les lois de la chevalerie et "
         db "\tes banni du tournoi. Depouill[ de vos territoires, "
         db "vous vous en retournez vers un ch&teau d[sormais vide.",EOT
;
TXTLOST
         db 3,5,34
         db "-LA DEFAITE-",#F9
         db "Votre coup de lance a manqu[ le centre du bouclier de "
         db "votre adversaire, lui donnant l'occasion de vous d[sarconner."
         db " Ainsi s'ach]ve votre journ[e aux lices d'Ashby. Vous n'\tes pas"
         db " le champion, mais vos exploits resteront l'esprit de chacun. "
         db "Sur le chemin du retour, vous vous jurez de revenir et de "
         db "conqu[rir la gloire Ashby.",EOT
;
TXTWON
         db 3,5,34
         db "-LA VICTOIRE-",#F9
         db "D'un coup puissant, vous d[sarconnez votre adversaire "
         db "et lui faites mordre la poussi]re sous les acclamations "
         db "de la foule.",EOT
;
TXTNUL
         db 3,5,34
         db "-EGALITE-",#F9
         db "Se ruant l'un contre l'autre, les deux chevaliers manquent "
         db "la marque et restent en selle. Ils contournent la lice et "
         db "prennent position pour une autre tentative. Pr[parez vous "
         db "pour une autre joute.",EOT

;
TXTVICT
         db 5,8,30
         db "La foule clame votre victoire la joute sur sir ",#FD," .",EOT
;
