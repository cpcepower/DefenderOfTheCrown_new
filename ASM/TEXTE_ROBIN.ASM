NORMLONG	db ROBIN_SIDE,"NORMLONG.DEF"
ROBMUS		db ROBIN_SIDE,"ROBIN   .MUS"

OKRAID
         DEFB 2,10,36
         DEFB "A votre arriv[ ^ Sherwood, vous demandez l'aide de Robin. "
         DEFB 34,"Je t'attendais",34,",dit-il. Puis, apr]s un moment de "
         DEFB "reflexion, il se tourne vers fr]re Tuck. ",34,"Pr[pare mon "
         DEFB "[p[e, j'ai deux mots ^ dire ^ ces normands.",34,#FF
OKCONQ
         DEFB 2,10,36
         DEFB "A votre arriv[ ^ Sherwood, vous demandez l'aide de Robin. "
         DEFB 34,"Je t'attendais",34,",dit-il. Puis, apr]s un moment de "
         DEFB "reflexion, il accepte de vous aider. ",34,"J'enverrai "
         DEFB "assez de mes hommes pour te porter ^ la victoire.",34,#FF
DEJA
         DEFB 4,12,32
         DEFB "Vous revenez a Sherwood. ",34,"Pourquoi reviens-tu dej^ ?",34
         DEFB ", demande Robin. ",34,"L'aide que je t'ai offerte lors de "
         DEFB "notre derni]re rencontre, tient toujours.",34,#FF
TROP
         DEFB 4,12,32
         DEFB "Robin vous acceuille ^ Sherwood et fait donner une f\te. "
         DEFB 34,"Comment vont les Saxons ?",34," demande Robin. Vous "
         DEFB "lui repondez en demandant son aide...",34,"Je t'avais promis "
         DEFB "de t'aider trois fois. Tu peux maintenant affronter les "
         DEFB "Normands seul.",34,#FF
;
