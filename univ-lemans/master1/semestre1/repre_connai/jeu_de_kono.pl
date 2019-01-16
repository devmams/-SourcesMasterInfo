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

afficherLigne([],N) :- write('|'), nl.
afficherLigne([E|L],N) :- atom_concat('|',N,X), write(X), atom_concat('|',E,X1), write(X1), afficherLigne(L,N).

afficherGrille([]).
afficherGrille([L|G]) :- afficherLigne(L,0), afficherGrille(G).

% afficherGrille([['X','X','X','X'],['X','X','X','X'],['O','O','O','O'],['O','O','O','O']]).
% afficherGrille([[1,2,3,4],[1,2,3,4],[5,6,7,8],[5,6,7,8]]).











%
