;;MENUS.ASM;   (c)1988 B.RIVE;;text_welcome	db 1,10,38	db #F9,"Bienvenue Sir ",#FD,"!",#F9,EOT;MENU     db 1,18,8	db #FE," Joute  ",#FE,#F9	db #FE,"Conqu]te",#FE,#F9	db #FE,"  Raid  ",#FE,#F9	db #FE," Achat  ",#FE,#F9	db #FE,"Abandon ",#FE,#F9	db #FE,"  Fin   ",#FE	db EOT;MENU2    db 1,1,11	db #FE,"D[placement",#FE,#F9	db #FE," Transfert ",#FE,#F9	db #FE,"   Carte   ",#FE,#F9	db #FE,"   Robin   ",#FE,#F9	db #FE," Continuer ",#FE	db EOT;MENU23	db 1,1,14	db #FE," Voir R[gion  ",#FE,#F9	db #FE,"Envoyer Espion",#FE,#F9	db #FE,"  Voir Lord   ",#FE,#F9	db #FE,"  Continuer   ",#FE	db EOT;MENU5    db 15,10,18	db "Abandon",#F9,#F9	db #FE,"  OUI  ",#FE,#F9	db #FE,"  NON  ",#FE	db EOT;SELECTR	db 1,1,12	db "Choisissez une R[gion."	db EOT;NOARMY	db 1,12,38	db "D[sol[, Sir ",#FD," votre arm[e est vide."	db EOT;ATTABORT	db 1,8,15	db "Attaque annul[e."	db EOT;ATTADJA	db 1,8,15	db "Vous devez choisir une r[gion voisine.",EOT;ATTNCATA	db 1,12,38	db "Vous ne pouvez attaquer un ch&teau sans catapulte.",EOT;PASSAGE	db 4,8,32	db "Territoire Saxon",#F9	db #FE,"Chercher un passage",#FE,#F9	db #FE,"Attaquer ",#FD,#FE,EOT;RETRAITE	db 1,12,38	db "Sir ",#FD," s'est retir[ sur le territoire de ",#FD,EOT;DISCOV	db 5,10,28	db "Vous avez d[couvert l'arm[e de campagne de Sir ",#FD,EOT;COMEBACK	db 5,11,28	db "Sir ",#FD," est revenu d[fendre son ch&teau avec son arm[e.",EOT;LORDEAD	db 1,8,38	db "- VICTOIRE FEODALE -",#F9	db "Le siege s'ach]ve par votre victoire et Sir ",#FD," est"	db " envoy[ en exil. Les vassaux de ses territoires se ralient "	db "^ votre cause, et ses territoires vous reviennent.",EOT;MENUTRAN	db 1,1,24	db #FE,"        Garnison",#FD,"Arm[e",#FE,#F9	db #FE,"Soldats   : ",#FB,#FD,#FB,#FE,#F9	db #FE,"Chevaliers: ",#FB,#FD,#FB,#FE,#F9	db #FE,"Catapultes: ",#FB,#FD,#FB,#FE,#F9	db #FE,"        Continuer       ",#FE,EOT;NOTYOURS	db 1,8,38	db "Vous ne pouvez pas transf]rer d'un territoire ne vous"	db " appartenant pas.",EOT;MENUACH	db 1,17,23	db #FE,"   Prix ",#FD," -Garnison",#FE,#F9	db #FE,"    Soldats  1- ",#FB,"  ",#FE,#F9	db #FE," Chevaliers  8- ",#FB,"  ",#FE,#F9	db #FE," Catapultes 15- ",#FB,"  ",#FE,#F9	db #FE,"   Ch&teaux 20-        ",#FE,#F9	db #FE,"    Continuer         ",#FE,EOT;CONSABB	db 1,12,30	db "Vous abandonnez la construction de ce ch&teau.",EOT;CONSNOT	db 1,12,30	db "Vous ne pouvez construire sur un territoire qui"	db " ne vous appartient pas.",EOT;CONSDEJ	db 1,12,30	db "Vous avez dej^ un ch&teau sur ce territoire.",EOT;STMESS	db 4,15,30	db "R[gion : ",#FD,#F9	db #FD,#FD,#F9	db #FC," Pi]ces d'or par mois.",#F9	db #FC," Vassaux.",EOT;SPYPOOR	db 5,12,28	db "Vous n'avez pas assez d'or pour payer un espion.",EOT;SPYTXT1	db 3,8,34	db #F9,#FD," n'a pas de Lord",#F9	db "Imp`ts ",#FC,", Vassaux ",#FC,"." ,#F9,#F9	db "(SUITE)",EOTSPYTXT2	db 2,9,34	db #F9,"Garnison de ",#FD," :",#F9	db #FC," soldats, ",#FC," chevaliers,",#F9	db #FC," catapultes.",EOT;SPYTXT3	db 2,9,34	db #FD," appartient a Sir ",#FD,", son tr[sor est de "	db #FC," pi]ces d'or. Son arm[e campe dans la r[gion de "	db #FD,".",#F9	db "(SUITE)",EOTSPYTXT4	db 2,8,34	db #F9,"Garnison de ",#FD," :",#F9	db #FC," soldats, ",#FC," chevaliers,",#F9	db #FC," catapultes.",#F9,#F9	db "(SUITE)",#F9,EOTSPYTXT5	db 5,10,28	db #F9,#FD,#F9	db "         Garnison  Campagne",#F9	db "Soldats    ",#FB,"     ",#FB,"  ",#F9	db "Chevaliers ",#FB,"     ",#FB,"  ",#F9	db "Catapultes ",#FB,"     ",#FB,"  ",#F9	db #F9,EOT;SLORDTXT	db 3,10,34	db #F9	db "Sir ",#FD," habite la region de ",#FD,".",#F9	db "Ses revenus s'[l]vent ^ ",#FC," pi]ces d'or.",#F9	db "Prestige : ",#FC,", Ep[e : ",#FC,", Joute : ",#FC,", Haine "	db " envers vous : ",#FC,".",#F9,#F9,EOT;INTJOUT	db 1,8,38	db "Vous \tes interdit de joute."	db EOT;TOOEARLY	db 1,8,38	db "Les Lords viennent juste de rentrer de la derni]re joute."	db EOT;POORJOUT	db 1,8,38	db "Vous n'avez pas les fonds n[cessaires ^ l'organisation"	db " d'une joute."	db EOT;RAIDABB	db 1,8,15	db "Raid annul[."	db EOT;RAIDNOCA	db 1,8,38	db "Cette r[gion ne contient le ch&teau d'aucun Lord."	db EOT;RAIDYOU	db 1,10,38	db "Sir ",#FD,", ce ch&teau vous appartient."	db " l'auriez-vous oubli[?",EOT;STEAL    db 5,10,28	db "Sir ",#FD," a effectu[ un raid dans le ch&teau de Sir "	db #FD,", et lui a subtilis[ ",#FC," pi]ces d'or.",EOT;STELMET  db 5,10,28	db "Profitant du sommeil de vos gardes, Sir ",#FD," s'est introduit"	db " dans votre ch&teau et vous a subtilis[ ",#FC," pi]ces d'or.",EOT;KIDNAP	db 5,10,28	db "Lady ",#FD," a [t[ enlev[e et est tenue captive au ch&teau de "	db #FD,#F9,#F9,#FE,"Ignorer ses cris.",#FE,#F9	db #FE,"Voler ^ son secours.",#FE,#F9	db #FE,"Aller voir Robin.",#FE,EOT;MYRANCON db 5,7,28	db "Sir ",#FD," vous extorque une rancon de ",#FC," pi]ces d'or "	db "pour le retour de votre Lady.",EOT;VASSWIN  db 3,10,32	db "Vous perdez ",#FC," homme",#FD," en combattant les paysans.",EOTHOMMES   db "s"HOMME    db EOT;VLTXT    db 3,10,32	db "Votre arm[e est tomb[e dans une embuscade. Tous vos hommes "	db "ont [t[ tu[s.",EOT;EMBUSC	db 8,5,30	db "-EMBUSCADE-",#F9	db "Sir ",#FD," a surpris votre arm[e au campement "	db "dans la r[gion de ",#FD,". Pr[parez vous "	db "^ combattre.",EOT;DESTROY	db 8,5,30	db "Sir ",#FD," ^ [t[ vaincu par Sir ",#FD,".",EOT;GARNISON	db 8,5,30	db "-LA GARNISON-",#F9	db "Votre garnison de ",#FD," est assi]g[e par Sir ",#FD,"."	db EOT;HOMEATT	db 8,5,30	db "-ASSIEGE-",#F9	db "Soudain, votre ch&teau est attaqu[! Sir ",#FD," lance un "	db "assaut furieux et vos hommes r[sistent d[s[sp[r[ment, "	db "conscients que ce combat pourrait \tre le dernier.",EOT;RETWIF	db 9,5,30	db "Lady ",#FD," est revenue saine et sauve aupr]s de son "	db "tuteur, Sir ",#FD,".",EOT