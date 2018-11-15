% Predicat : afficheLigne/1
% exemple : afficheLigne([x,o,x]).
% resultat : x   o   x
% explication : ce predicat affiche sur une ligne les éléments d'une liste.

afficheLigne([A,B,C]) :-
	write(A), tab(3),
	write(B), tab(3),
	write(C), tab(3).
               ici la liste doit être de taille 3.

% Predicat : afficheGrille/1
% exemple : afficheGrille([[o,x,o],[x,x,o],[o,o,x]]).
% resultat :  o   x   o
%             x   x   o
%             o   o   x
% expliation : ce predicat affiche tous les élément d'une grille.
%							 chaque élément de la grille est une liste
afficheGrille([[A1,B1,C1],[A2,B2,C2],[A3,B3,C3]]) :-
	afficheLigne([A1,B1,C1]), nl,
	afficheLigne([A2,B2,C2]), nl,
	afficheLigne([A3,B3,C3]).


% Predicat : succNum/2
% exemple : succNum(1,A).
% resultat : A = 2;
% explication : ce predicat defini les successeurs des nombres 1 et 2.
succNum(1,2).
succNum(2,3).


% Predicat : succAlpha/2
% exemple : succAlpha(b,X).
% resultat : X = c;
% explication : ce predicat defini les successeurs des lettres a et b.
succAlpha(a,b).
succAlpha(b,c).


% Predicat : ligneDeGrille(NumLigne, Grille, Ligne).
% Satisfait si Ligne est la ligne numero NumLigne dans la Grille
% exemple cond. arrêt : ligneDeGrille(1,[[o,x,o],[x,x,o],[o,o,x]],L).
% résultat : L = [o, x, o];

% exemple cond. générale : ligneDeGrille(3,[[o,x,o],[x,x,o],[o,o,x]],L).
% resultat : L = [o, o, x]

% explication : ce predicat nous retourne la liste numéro NumLigne de notre grille.
ligneDeGrille(1, [Test |_], Test).
ligneDeGrille(NumLigne, [_|Reste],Test) :- succNum(I, NumLigne),
		ligneDeGrille(I,Reste,Test).


% Predicat : caseDeLigne(Col, Liste, Valeur).
% Satisfait si Valeur est dans la colonne Col de la Liste
% exemple cond. arrêt : caseDeLigne(C,[x,o,x],x).
% résultat : C = a ;

% exemple cond. générale : caseDeLigne(C,[x,o,x],o).
% resultat : C = b ;

% explication : ce predicat nous retourne la colonne de Valeur dans la liste
caseDeLigne(a, [A|_],A).
caseDeLigne(Col, [_|Reste],Test) :- succAlpha(I, Col),caseDeLigne(I,Reste, Test).


% Predicat : caseDeGrille(NumCol, NumLigne, Grille, Case).
% Satisfait si Case est la case de la Grille en position NumCol-NumLigne
% exemple : caseDeGrille(a,1,[[o,x,o],[x,x,o],[o,o,x]],E).

% resultat : E = o

% explication : ce predicat nous retourne l'element qui se trouve à la ligne L et la colonne C
caseDeGrille(C,L,G, Elt) :- ligneDeGrille(L,G,Res),caseDeLigne(C,Res,Elt).


% Predicat : afficheCaseDeGrille(Colonne,Ligne,Grille) .
% exemple : afficheCaseDeGrille(b,1,[[o,x,o],[x,x,o],[o,o,x]]).

% resultat : x

% explication : ce predicat affiche l'element a la position colonne = C et ligne = L
afficheCaseDeGrille(C,L,G) :- caseDeGrille(C,L,G,Case),write(Case).


% Predicat : leCoupEstValide/3
% exemple : leCoupEstValide(b,1,[[o,-,o],[x,x,-],[-,-,-]]).

% resultat : true

% explication : ce predicat verifie si la case de colonne C et de Ligne L est vide ou pas.
% 							retourne true si vide et false sinon
leCoupEstValide(C,L,G) :- caseDeGrille(C,L,G,-).


% Predicat : coupJoueDansLigne/4
% version bof
% exemple : coupJoueDansLigneBof(a,o,[-,X,Y],L).

% resultat : L = [o, X, Y].

% explication : ce predicat ajoute l'élément Val à la colonne a,b ou c d'une Ligne

coupJoueDansLigneBof(a, Val, [-, X, Y], [Val, X, Y]).
coupJoueDansLigneBof(b, Val, [X, -, Y], [X, Val, Y]).
coupJoueDansLigneBof(c, Val, [X, Y, -], [X, Y, Val]).

% version recursive
% exemple cond. arrêt : coupJoueDansLigne(a,x,[-,X,Y],L).
% résultat : L = [x, X, Y] ;

% exemple cond. générale : coupJoueDansLigne(c,o,[-,X,-],L).
% resultat : L = [-, X, o] ;

% explication : ce predicat ajoute l'élément Val à la colonne a,b ou c d'une Ligne de façon recursives
coupJoueDansLigne(a, Val, [-|Reste],[Val|Reste]).
coupJoueDansLigne(NomCol, Val, [X|Reste1],[X|Reste2]):-
		succAlpha(I,NomCol),
		coupJoueDansLigne(I, Val, Reste1, Reste2).


% Predicat : coupJoueDansGrille/5
% exemple cond. arrêt : coupJoueDansGrille(a,1,x,[[-,-,-],[-,-,-],[-,-,-]],L).
% résultat : L = [[x, -, -], [-, -, -], [-, -, -]] ;

% exemple cond. générale : coupJoueDansGrille(c,3,x,[[-,-,-],[-,-,-],[-,-,-]],L).
% resultat : L = [[-, -, -], [-, -, -], [-, -, x]] ;

% explication : ce predicat ajoute l'élément Val dans notre grille à la position de colonne NCol et de ligne Nligne
coupJoueDansGrille(NCol,1,Val,[A|Reste],[B|Reste]):- coupJoueDansLigne(NCol, Val, A, B).
coupJoueDansGrille(NCol, NLig, Val, [X|Reste1], [X|Reste2]):- succNum(I, NLig),
					coupJoueDansGrille(NCol, I, Val, Reste1, Reste2).

%  ?- coupJoueDansGrille(a,2,x,[[-,-,x],[-,o,-],[x,o,o]],V).
%  V = [[-,-,x],[x,o,-],[x,o,o]] ;
%  no



% Predicat : ligneFaite/2
%
% version bof
% ligneFaiteBof(x,[x,x,x]).
% ligneFaiteBof(o,[o,o,o]).
% ligneFaiteBof(-,[-,-,-]).

% exemple cond. arrêt : ligneFaite(E,[x]).
% résultat : E = x ;

% exemple cond. générale : ligneFaite(o,[o,o,o]).
% resultat : E = o ;

% explication : ce predicat verifie si tous les elements de la liste sont identiques
ligneFaite(Val, [Val]).
ligneFaite(Val, [Val|R]) :- ligneFaite(Val, R).


% Predicat : ligneExiste/3
% ?- ligneExiste(x,[[x,-,x],[x,x,x],[-,o,-]],V).
% V = 2 ;

% exemple cond. arrêt : ligneExiste(x,[[x,x,x],[-,-,x],[-,o,-]],L).
% résultat : L = 1 ;

% exemple cond. générale : ligneExiste(o,[[x,x,o],[-,-,x],[o,o,o]],L).
% resultat : L = 3 ;

% explication : ce predicat verifie s'il existe une ligne de notre grille qui à tous ces éléments identiques à Val
ligneExiste(Val, [L1|_], 1) :- ligneFaite(Val, L1).
ligneExiste(Val, [_|R], NumLigne) :- succNum(I,NumLigne), ligneExiste(Val, R, I).


% Predicat : colonneExiste/3
% exemple cond. arrêt : colonneExiste(x,[[x,o,x],[x,-,x],[x,o,-]],C).
% résultat : C = a ;

% exemple cond. générale : colonneExiste(-,[[x,o,-],[x,-,-],[-,o,-]],C).
% resultat : C = c ;

% explication : ce predicat verifie s'il existe une colonne de notre grille qui à tous ces éléments identiques à Val
colonneExiste(Val, [[Val|_],[Val|_],[Val|_]], a).
colonneExiste(Val, [[_|R1],[_|R2],[_|R3]], NomCol) :-
	succAlpha(I,NomCol),
	colonneExiste(Val, [R1,R2,R3], I).


% Predicats diagonaleDG/2 et diagonaleGD/2
% exemple : diagonaleGD(o,[[o,-,-],[-,o,-],[-,-,o]]).

% resultat : true

% explication : ce predicat verifie si la diagonale de la grille à tous ces éléments identiques à Val
diagonaleGD(Val, [[Val,_,_],[_,Val,_],[_,_,Val]]).
diagonaleDG(Val, [[_,_,Val],[_,Val,_],[Val,_,_]]).


% Predicat partieGagnee/2
% exemple : partieGagnee(x,[[-,-,-],[-,-,-],[x,x,x]]).

% resultat : true

% explication : ce predicat verifie s'il exite une ligne, une colonne ou une diagonale qui à tous ces éléments identiques à Val
partieGagnee(Val, G) :- ligneExiste(Val, G, _).
partieGagnee(Val, G) :- colonneExiste(Val, G, _).
partieGagnee(Val, G) :- diagonaleGD(Val, G).
partieGagnee(Val, G) :- diagonaleDG(Val, G).


% ?- partieGagnee(x, [[-,-,x],[-,o,-],[x,o,o]]).
% no
% ?- partieGagnee(x, [[-,-,x],[-,x,-],[x,o,o]]).
% yes --> diagonale
% ?- partieGagnee(o,[[o,-,-],[o,-,-],[o,-,-]]).
% yes --> colonne
% ?- partieGagnee(b,[[b,b,b],[g,z,t],[e,t,y]]).
% yes --> ligne



% coordonneesOuListe(NomCol, NumLigne, Liste).
% ?- coordonneesOuListe(a, 2, [a,2]). vrai.
% exemple : coordonneesOuListe(a, 2, L).

% resultat : L = [a,2]

% explication : Ce predicat retourne une liste contenant NomCol et NumLigne
coordonneesOuListe(NomCol, NumLigne, [NomCol, NumLigne]).


% duneListeALautre(LC1, Case, LC2)
% ?- duneListeALautre([[a,1],[a,2],[a,3]], [a,2], [[a,1],[a,3]]). est vrai
% exemple cond. arrêt : duneListeALautre([[a,1],[a,2],[a,3]], [a,1], L).
% résultat : L = [[a, 1], [a, 2]];

% exemple cond. générale : duneListeALautre([[a,1],[a,2],[a,3]], [a,3], L).
% resultat : L = [[a, 1], [a, 2]] ;

% explication : ce predicat verifie si LC2 est la liste LC1 sans l'element Case
duneListeALautre([A|B], A, B).
duneListeALautre([A|B], C, [A|D]):- duneListeALautre(B,C,D).


% toutesLesCasesValides(Grille, LC1, C, LC2).
% Se verifie si l'on peut jouer dans la case C de Grille et que la liste
% LC1 est une liste composee de toutes les cases de LC2 et de C.
% Permet de dire si la case C est une case ou l'on peut jouer, en evitant
% de jouer deux fois dans la meme case.

toutesLesCasesValides(Grille, LC1, C, LC2) :-
	coordonneesOuListe(Col, Lig, C),
	leCoupEstValide(Col, Lig, Grille),
	duneListeALautre(LC1, C, LC2).

% toutesLesCasesDepart
% exemple : toutesLesCasesDepart(L).
% resultat : L = [[a, 1], [a, 2], [a, 3], [b, 1], [b, 2], [b, 3], [c, 1], [c|...], [...|...]].

% explication : Ce predicat retourne toutes les cases du Jeu
toutesLesCasesDepart([[a,1],[a,2],[a,3],[b,1],[b,2],[b,3],[c,1],[c,2],[c,3]]).

% grilleDeDepart
% exemple : grilleDeDepart([L]).
% resultat : L = [[-, -, -], [-, -, -], [-, -, -]].
% explication : Ce predicat retourne une grille dont toutes les cases sont vides
grilleDeDepart([[-,-,-],[-,-,-],[-,-,-]]).

% campCPU
% exemple : campCPU(C).
% resultat : C = x.
% explication : Ce predicat defini que le camp du CPU est x
campCPU(x).

% campAdverse
% exemple : campAdverse(x,C).
% resultat : C = x.
% explication : Ce predicat defini que le camp adverse de x est o et que le quand adverse de o est x
campAdverse(x,o).
campAdverse(o,x).

% joueLeCoup
% exemple : joueLeCoup([a,2],x,[[-,-,-],[-,-,-],[-,-,-]],G).
% resultat :	-   -   -
% 						x   -   -
% 						-   -   -
% explication : Ce predicat ajoute à la position Case l'élément Valeur dans la GrilleDep et affiche la grille résultante
joueLeCoup(Case, Valeur, GrilleDep, GrilleArr) :-
	coordonneesOuListe(Col, Lig, Case),
	leCoupEstValide(Col, Lig, GrilleDep),
	coupJoueDansGrille(Col, Lig, Valeur, GrilleDep, GrilleArr),
	nl, afficheGrille(GrilleArr), nl.

% saisieUnCoup
% exemple : saisieUnCoup(a,1).
% resultat : NomCol = a et NumLig = 1
% explication : Ce predicat permet de saisir un coup dans le jeu.
saisieUnCoup(NomCol,NumLig) :-
	writeln("entrez le nom de la colonne a jouer (a,b,c) :"),
	read(NomCol), nl,
	writeln("entrez le numero de ligne a jouer (1, 2 ou 3) :"),
	read(NumLig),nl.

%saisieUnCoupValide(Col,Lig,Grille):-
%	saisieUnCoup(Col,Lig),
%	leCoupEstValide(Col,Lig,Grille),
%	writef('attention, vous ne pouvez pas jouer dans cette case'), nl,
%	writef('reessayer SVP dans une autre case'),nl,
%	saisieUnCoupValide(Col,Lig,Grille).


% Predicat : moteur/3
% Usage : moteur(Grille,ListeCoups,Camp) prend en parametre une grille dans
% laquelle tous les coups sont jouables et pour laquelle
% Camp doit jouer.


% cas gagnant pour le joueur
% exemple : moteur([[o,o,o],[-,-,-],[x,x,-]],_,o).
% resultat : le camp o a gagne
% explication : Ce predicat verifie si le jouer à gagné ou pas.
moteur(Grille,_,Camp):-
	partieGagnee(Camp, Grille), nl,
	write('le camp '), write(Camp), write(' a gagne').

% cas gagnant pour le joueur adverse
% exemple : moteur([[x,x,x],[-,x,o],[o,-,-]],_,x).
% resultat : le camp x a gagne
% explication : Ce predicat verifie si le jouer adverse à gagné ou pas.
moteur(Grille,_,Camp):-
	campAdverse(CampGagnant, Camp),
	partieGagnee(CampGagnant, Grille), nl,
	write('le camp '), write(CampGagnant), write(' a gagne').

% cas de match nul, plus de coups jouables possibles
% exemple : moteur(o,[],o).
% resultat : game over
% explication : Ce predicat verifie s'il reste encore des coups possible a jouer
moteur(_,[],_) :-nl, write('game over').

% cas ou l ordinateur doit jouer
% exemple : moteur([[o,x,-],[x,-,o],[-,-,-]],[[c,3]],x).
% resultat :
% 						o   x   -
% 						x   -   o
% 						-   -   x
% explication : ce predicat permet de jouer le coup de l'ordianteur
moteur(Grille, [Premier|ListeCoupsNew], Camp) :-
	campCPU(Camp),
	joueLeCoup(Premier, Camp, Grille, GrilleArr),
	campAdverse(AutreCamp, Camp),
	moteur(GrilleArr, ListeCoupsNew, AutreCamp).

% cas ou c est l utilisateur qui joue
% exemple : moteur([[o,x,-],[x,-,o],[-,-,-]],L,x).
% resultat :
% 						o   x   -
% 						x   -   o
% 						-   -   o
% explication : ce predicat permet a l'utilisateur de jouer un coup
moteur(Grille, ListeCoups, Camp) :-
	campCPU(CPU),
	campAdverse(Camp, CPU),
	saisieUnCoup(Col,Lig),
	joueLeCoup([Col,Lig], Camp, Grille, GrilleArr),
	toutesLesCasesValides(Grille, ListeCoups, [Col, Lig], ListeCoupsNew),
	moteur(GrilleArr, ListeCoupsNew, CPU).


% Predicat : lanceJeu/0
% Usage :  lanceJeu permet de lancer une partie.

lanceJeu:-
  grilleDeDepart(G),
	toutesLesCasesDepart(ListeCoups),
	afficheGrille(G),nl,
   writeln("L ordinateur est les x et vous etes les o."),
   writeln("Quel camp doit debuter la partie ? "),read(Camp),
	toutesLesCasesDepart(ListeCoups),
	moteur(G,ListeCoups,Camp).
