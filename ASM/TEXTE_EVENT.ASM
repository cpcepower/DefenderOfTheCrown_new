BATBACK  DEFB EVENT_SIDE,"BATBACK .DEF"
BATSPR   DEFB EVENT_SIDE,"BATSPR  .SPR"
PLOTTERS DEFB EVENT_SIDE,"PLOTTERS.DEF"

ROBGIVE  DEFB 5,8,28
         DEFB "Robin a envoy[ ",#FC," hommes pour combattre vos c`tes.",#FF

EFFECTIF
         DEFB 16,1,22
         DEFB "Hommes restant",#F9
         DEFB "Votre          Arm[e "
         DEFB "arm[e         ennemie"
         DEFB #F9
         DEFB #FB,"  Soldats   ",#FB,#F9
         DEFB #FB," Chevaliers ",#FB,#F9
         DEFB #FB," Catapultes ",#FB,#FF

OPTIONS
         DEFB 1,1,13
         DEFB "Tactique ?",#F9
         DEFB #FE,"Contourner   ",#FE
         DEFB #FD
         DEFB #FD
         DEFB #FD
         DEFB #FD
         DEFB #FD
         DEFB #FF

HALFTXT
         DEFW HALFTXT1
         DEFW HALFTXT2
         DEFW HALFTXT0
HALFTXT0
         DEFB 4,10,30
         DEFB "Juste apr]s la collecte des taxes, votre sheriff est "
         DEFB "tomb[ dans une embuscade normande... Vous perdez la moiti[ "
         DEFB "de vos revenus, ",#FC," pi]ces d'or, ce mois-ci.",#FF
HALFTXT1
         DEFB 4,10,30
         DEFB "Des hors-la-loi normands ont attaqu[ un collecteur de taxes "
         DEFB "saxon. Sir ",#FD," perd la moiti[ de ses revenus, ",#FC
         DEFB " pi]ces d'or, ce mois-ci.",#FF
HALFTXT2
         DEFB 4,10,30
         DEFB "Les hommes de Robin ont attaqu[ les Normands. Sir ",#FD
         DEFB " perd la moiti[ de ses revenus, ",#FC
         DEFB " pi]ces d'or, ce mois-ci.",#FF

CATATXT
         DEFW CATAP1
         DEFW CATAP2
         DEFW CATAP0
CATAP0
         DEFB 4,10,30
         DEFB "Des espions normands ont sabot[ vos catapultes. Les fabuleuses "
         DEFB "machines de si]ge sont reduites en fragments de bois.",#FF
CATAP1
         DEFB 4,10,30
         DEFB "Les espions normands ont sabot[ des catapultes. Sir ",#FD
         DEFB " perd toutes ses armes de si]ge.",#FF
CATAP2
         DEFB 4,10,30
         DEFB "Robin et ses hommes ont attaqu[ Sir ",#FD,". Ils ont vol[ son "
         DEFB "ravitaillement et detruit ses catapultes.",#FF

REVOTXT
         DEFW REVOLT1
         DEFW REVOLT1
         DEFW REVOLT0
REVOLT0
         DEFB 4,10,30
         DEFB "Des traitres ont foment[ une r[volte chez vous. Vous perdez "
         DEFB #FC," soldats pour r[cup[rer votre ch&teau.",#FF
REVOLT1
         DEFB 4,10,30
         DEFB "Les vassaux se sont r[volt[s contre Sir ",#FD
         DEFB ". Il perd ",#FC," soldats pour r[cup[rer son ch&teau.",#FF
DESETXT0
         DEFB 4,10,30
         DEFB #FC," soldats ont d[sert[ vos rangs pour rejoindre l'arm[e de "
         DEFB "Sir ",#FD,".",#FF
DESETXT1
         DEFB 4,10,30
         DEFB #FC," soldats ont d[sert[ les rangs de Sir ",#FD
         DEFB " pour rejoindre votre arm[e.",#FF
DESETXT2
         DEFB 4,10,30
         DEFB #FC," soldats ont d[sert[ les rangs de Sir ",#FD
         DEFB " pour rejoindre l'arm[e de Sir ",#FD,".",#FF

VIKITXT
         DEFW VIKING1
         DEFW VIKING1
         DEFW VIKING0
VIKING0
         DEFB 4,10,30
         DEFB "Un raid viking menace vos territoires. Votre arm[e repousse "
         DEFB "la menace mais vous perdez ",#FC," hommes au combat.",#FF
VIKING1
         DEFB 4,10,30
         DEFB "Sir ",#FD," a perdu ",#FC," hommes lors d'un raid viking.",#FF

DANETXT
         DEFW DANES1
         DEFW DANES1
         DEFW DANES0
DANES0
         DEFB 4,10,30
         DEFB "Les Danois envahissent l'Angleterre semant la d[solation "
         DEFB "travers le territoire de ",#FD,". Votre influence est perdue "
         DEFB "dans le chaos.",#FF
DANES1
         DEFB 4,10,30
         DEFB "Les Danois envahissent et prennent le territoire de ",#FD
         DEFB " Sir ",#FD,".",#FF
CHANTXT0
         DEFB 4,10,30
         DEFB "Des espions normands ont sem[ les graines de l'agitation. "
         DEFB "Les vassaux se r[voltent en ",#FD," et Sir ",#FD," s'y "
         DEFB " rend en nouveau ma@tre.",#FF
CHANTXT1
         DEFB 4,10,30
         DEFB "Las de sa tyrannie, les vassaux de ",#FD," fomentent une "
         DEFB "r[volte contre Sir ",#FD," et Sir ",#FD," s'y rend en "
         DEFB "nouveau ma@tre.",#FF
CHANTXT2
         DEFB 4,10,30
         DEFB "Las de sa tyrannie, les vassaux de ",#FD," fomentent une "
         DEFB "r[Volte contre Sir ",#FD," et implorent votre protection.",#FF

NOINTXT  DEFW NOINTXT1
         DEFW NOINTXT2
         DEFW NOINTXT0
NOINTXT0
         DEFB 4,10,30
         DEFB "Un complot soul]ve la r[gion de ",#FD,". Les vassaux "
         DEFB "refusent de s'acquiter de la taxe.",#FF
NOINTXT1
         DEFB 4,10,30
         DEFB "Dr[ss[s contre Sir ",#FD,", les vassaux de la r[gion de ",#FD
         DEFB " refusent de payer la taxe ce mois ci.",#FF
NOINTXT2
         DEFB 4,10,30
         DEFB "Sir ",#FD," essaye d'augmenter les taxes dans la r[gion de "
         DEFB #FD,". Les vassaux refusent de payer ce mois-ci.",#FF

KNIGTXT
         DEFW KNIGTXT1
         DEFW KNIGTXT2
         DEFW KNIGTXT0
KNIGTXT0
         DEFB 4,10,30
         DEFB "Trois chevaliers allemands viennent se joindre votre arm[e."
         DEFB #FF
KNIGTXT1
         DEFB 4,10,30
         DEFB "Trois chevaliers allemands viennent se joindre l'arm[e de Sir "
         DEFB #FD,".",#FF
KNIGTXT2
         DEFB 4,10,30
         DEFB "Trois chevaliers francais rejoignent l'arm[e de Sir ",#FD,".",#FF

MONETXT
         DEFW MONETXT1
         DEFW MONETXT2
         DEFW MONETXT0
MONETXT0
         DEFB 4,10,30
         DEFB "Robin a devalis[ une caravanne normande. Il envoie vingt "
         DEFB "pi]ces d'or pour aider votre cause.",#FF
MONETXT1
         DEFB 4,10,30
         DEFB "De loyaux vassaux de Sir ",#FD," lui envoient une aide de vingt "
         DEFB "pi]ces d'or.",#FF
MONETXT2
         DEFB 4,10,30
         DEFB "Sir ",#FD," a pill[ une propriet[ saxone. Il en retire "
         DEFB "vingt pi]ces d'or.",#FF
