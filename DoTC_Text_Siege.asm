;
SIEGE_SAXLONG	db SIDE_SIEGE,"SAXLONG DEF"
SIEGE_NORMLONG	db SIDE_SIEGE,"NORMLONGDEF"
SIEGE_SPRSIEGE	db SIDE_SIEGE,"SPRSIEGESPR"
SIEGE_MUS	db SIDE_SIEGE,"SIEGE   MUS"
SIEGE_SCASTLE	db SIDE_SIEGE,"SCASTLE DEF"
SIEGE_NCASTLE	db SIDE_SIEGE,"NCASTLE DEF"
SIEGE_MCATSPR	db SIDE_SIEGE,"MCATSPR SPR"
SIEGE_CATANIM	db SIDE_SIEGE,"CATANIM SPR"
SIEGE_CATSPR	db SIDE_SIEGE,"CATSPR  SPR"
;SIEGE_SONS	db SIDE_SIEGE,"DEFENDERSON"

SIEGTXT
         db 2,10,36
         db "- LE SIEGE -",#F9
         db "Vous rassemblez votre arm[e et vous preparez pour un si]ge"
         db " difficile. Vous allez devoir percer une br]che dans le mur"
         db " du ch&teau et prendre l'avantage sur la d[fense de Sir "
         db #FD,"...",EOT
;
SIEGMENU
         db 4,3,30
         db "Effectifs des arm[es :",#F9
         db "Votre arm[e    Arm[e ennemie  ",#F9
         db #FB,"  Soldats   ",#FB,#F9
         db #FB," Chevaliers ",#FB,#F9
         db #FB," Catapultes ",#FB,#F9
         db "R[sistance du ch^teau ",#FB,#F9
         db "Jours restant ",#FB,#F9,#F9
         db "Quelle munition utiliser ?",#F9,#F9
         db #FE,"Boulets   ",#FE,"                  ",#F9,#F9
         db #FE,"Feux grecs",#FE,"                  ",#F9,#F9
         db #FE,"Epid[mie  ",#FE,"                  ",#F9,#F9
         db #FE,"   Commencer le combat !   ",#FE
         db EOT
;
