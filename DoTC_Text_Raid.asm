RAID_NORMLONG db SIDE_RAID,"NORMLONGDEF"
RAID_SAXLONG  db SIDE_RAID,"SAXLONG DEF"
RAID_COURT    db SIDE_RAID,"COURT   DEF"
RAID_INTERIOR db SIDE_RAID,"INTERIORDEF"
RAID_BEDROOM  db SIDE_RAID,"BEDROOM DEF"
RAID_ROOMWALL db SIDE_RAID,"ROOMWALLDEF"
RAID_FIGHTERS db SIDE_RAID,"FIGHTERSSPR"
RAID_BISOU1   db SIDE_RAID,"BISOU1  SPR"
RAID_BISOU2   db SIDE_RAID,"BISOU2  SPR"
RAID_BISOU3   db SIDE_RAID,"BISOU3  SPR"
RAID_BLONDE   db SIDE_RAID,"BLONDE  SPR"
RAID_BRUNE    db SIDE_RAID,"BRUNE   SPR"
RAID_COUPLE1  db SIDE_RAID,"COUPLE1 SPR"
RAID_COUPLE2  db SIDE_RAID,"COUPLE2 SPR"
RAID_COUPLE3  db SIDE_RAID,"COUPLE3 SPR"
RAID_COUPLE4  db SIDE_RAID,"COUPLE4 SPR"
RAID_COUPLE5  db SIDE_RAID,"COUPLE5 SPR"
RAID_RAIDMUS  db SIDE_RAID,"RAID    MUS"
RAID_PRINCESS db SIDE_RAID,"PRINCESSMUS"
;RAID_SONS     db SIDE_RAID,"DEFENDERSON"

text_raid_tresor
         db 2,1,36
         db "-L'OR ENNEMI-",#F9,#F9
         db "Vous avancez pr[cautionneusement dans la chambre et scrutez "
         db "l'obscurit[, quand vous d[couvrez la lueur des torches "
         db "un coffre ouvert contenant ",#FC," pi]ces d'or. Vous vous "
         db "emparez du tr[sor de Sir ",#FD," et rejoignez vos hommes aux "
         db "portes du ch&teau. Puis, le coeur l[ger, vous entamez le "
         db "chemin du retour.",EOT

text_raid_reunion
         db 2,9,36
         db "-LES RETROUVAILLES-",#F9,#F9
         db "Votre [p[e fait payer Sir ",#FD," le prix de son forfait. "
         db "Vous avancez la lueur des torches pour aller delivrer Lady "
         db #FD,". Les retrouvailles sont douces mais vous ne pouvez vous "
         db "attarder. Juste temps, vous vous faufilez entre les portes du "
         db "chSeau vers la libert[.",EOT

text_raid_respect
         db 5,8,28
         db "La nouvelle de votre exploit se r[pand travers tout le royaume"
         db ". Vos hommes vous percoivent diff[remment. Vous remarquez plus "
         db "de respect dans leur regard.",EOT

text_raid_wonareg
         db 5,10,28
         db "Lady ",#FD," est retourn[ aupr]s de son gardien. En marque de "
         db "gratitude, Sir ",#FD," vous offre le territoire de ",#FD,".",EOT

text_raid_rescue
         db 2,9,36
         db "-LA RESCOUSSE-",#F9,#F9
         db "Sir ",#FD," a pay[ pour sa f[lonie. Vous retrouvez Lady ",#FD
         db " peletonn[e dans la chambre obscure. L'assurant de votre "
         db "amiti[, vous l'escortez vers la libert[, talonn[ par les "
         db "gardes.",EOT

text_raid_greatest
         db 2,2,36
         db "-LE VERITABLE TRESOR-",#F9,#F9
         db "Vous p[netrez dans la piece obscure, esp[rant y trouver Lady "
         db #FD," . Tout d'abord, la chambre semble vide, mais au moment o_ "
         db "vous faites demi-tour, une douce voix sort de l'ombre...elle "
         db "est ici! Dans un [lan de gratitude, elle se jette dans vos bras"
         db ". Puis, vous regagnez tous deux votre ch&teau et, durant la "
         db "semaine qui suit, la gratitude se change en amour...",EOT

text_raid_mariage
         db 2,9,36
         db "-LE MARIAGE-",#F9,#F9
         db "Votre union avec la belle Lady ",#FD," conduit une alliance "
         db "avec son tuteur, Sir ",#FD,". Las des combats, il se retire."
         db " Vous reprenez les combats avec une d[termination raviv[e par "
         db "la force que vous trouvez dans l'amour, une puissance aussi "
         db "impitoyable que l'[p[e que vous dressez contre vos ennemis."
         db EOT

text_raid_captured
         db 2,1,36
         db "-CAPTURE-",#F9,#F9
         db "Usant de toute votre habilet[, vous combatez f[rocement les "
         db "gardes mais \tes finalement captur[ et jet[ aux cachots. "
         db "Apr]s plusieurs jours, vous negociez votre liberation avec Sir "
         db #FD,", et payez une rancon de ",#FC," pi]ce",#FD," d'or. Vous "
         db "entamez le long voyage vers votre ch&teau quelque peu apauvri "
         db "mais empreint d'une nouvelle sagesse.",EOT

text_raid_retlad
         db 5,8,28
         db "Lady ",#FD," est revenue saine et sauve sous la protection "
         db "de son tuteur Sir ",#FD,".",EOT

text_raid_rancon
         db 5,8,28
         db "Sir ",#FD," vous extorque une rancon de ",#FC," pi]ces d'or "
         db "pour le retour de votre Lady.",EOT

text_raid_retraite
         db 2,1,36
         db "-LA RETRAITE-",#F9,#F9
         db "Vous d[talez comme un li]vre, tandis que, derri]re vous, la "
         db "forteresse ennemie r[sonne des railleries des vainqueurs. "
         db "Le go#t de la d[faite est amer et bien [loign[ de l'ivresse de "
         db "la victoire que vous esperiez.",EOT
;
text_raid_intro
         db 1,17,38
         db "Rassemblant vos plus fines lames, vous organisez un"
         db " raid contre le ch&teau de Sir ",#FD,". Vous \tes"
         db " sur les lieux au cr[puscule et attendez la nuit dans"
         db " les bois voisins.",EOT

text_raid_pieces   db "s"
text_raid_piece    db EOT