% implemantation du jeu de kono voir lien ci-dessous pour les règles.
% lien : http://jeuxstrategieter.free.fr/Kono_complet.php

succNum(1,2).
succNum(2,3).
succNum(3,4).
succNum(4,5).
succNum(5,6).
succNum(6,7).
succNum(7,8).

succAlpha(a,b).
succAlpha(b,c).
succAlpha(c,d).
succAlpha(d,e).
succAlpha(e,f).
succAlpha(f,g).
succAlpha(g,h).

afficherGrille(G) :- afficheLigne([L1|G1]),
                    afficheLigne([L2|G2]),
                    afficheLigne([L3|G3]),
                    afficheLigne(G4).

aficherLigne(L) :- write(L),nl.


% afficherGrille([[1,2,3,4],[5,6,7,8]].











%
