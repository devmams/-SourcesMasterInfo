% couleur(vert).
% couleur(jaune).
% couleur(rouge).
%
% coloriage(C1,C2,C3,C4) :- couleur(C1),couleur(C2),couleur(C3),couleur(C4),
%                           C1 \== C2,
%                           C2 \== C3,
%                           C3 \== C1, C3 \== C4,
%                           C4 \== C1.


exemple :- write('entrez qqchz : '),nl,
           read(X),
           write('vous avez ecrit : '),nl,
           write(X).
