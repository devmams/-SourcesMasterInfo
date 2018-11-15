% Predicat : afficheGrille/1
% recursive avec les succNum et succApha
% Se décompose en plusieurs étapes
% -> affichePremiereLigne :
%    afficher la premiere ligne en fonction de la longueur de la première ligne de la grille :
%    la condition terminale permet d afficher la valeur de la derniere colonne, quelque
%    soit le dernier element qui reste dans le tableau;
%    On parcourt la ligne mais le contenu de cette ligne ne nous interesse pas.
% -> afficheGrilleSimple :
%    afficher la grille en gérant les numéros de ligne avec le succNum;
% -> afficheGrille :
%    appelle les deux predicats precedants;
%

affichePremiereLigne(Val,[_]):- tab(1),write('| '),write(Val),writeln(' |').
affichePremiereLigne(Val,[_|Suite]):-
	tab(1),write('| '),write(Val),succAlpha(Val,Val2),
	affichePremiereLigne(Val2,Suite).

afficheGrilleSimple(_,[X]) :- tab(1), afficheLigne(X).
afficheGrilleSimple(N,[Tete|Reste]):-
	tab(1),afficheLigne(Tete),
	succNum(N,N1),write(N1),
	afficheGrilleSimple(N1,Reste).

afficheGrille([Tete|Suite]):-
	tab(2),affichePremiereLigne(a,Tete),
	write('1'),
	afficheGrilleSimple(1,[Tete|Suite]).



%%% Permet d afficher la grille au demarrage du jeu
% Predicat : afficheGrilleDep/0
% Usage : afficheGrilleDep affiche la grille de depart du jeu d othello,
%         sous la forme d une grille

afficheGrilleDep(0):-
	grilleDeDepart(G),
	afficheGrille(G),!.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
afficheGrilleDep(1):-
	grilleDeDepart(G),
	afficheGrille(G),!.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predicat : succNum/2
% Usage : succNum(X,Y) est satisfait si Y est le successeur de X
succNum(1,2).
succNum(2,3).
succNum(3,4).
succNum(4,5).
succNum(5,6).
succNum(6,7).
succNum(7,8).




% Predicat : succAlpha/2
% Usage : succAlpha(X,Y) est satisfait si Y est le successeur de X
%	 (ordre lexico-graphique)
succAlpha(a,b).
succAlpha(b,c).
succAlpha(c,d).
succAlpha(d,e).
succAlpha(e,f).
succAlpha(f,g).
succAlpha(g,h).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predicat : afficheLigne/1
% Usage : affigheLigne(Ligne)est satisfait si Ligne est une ligne d une grille de
%         morpion et qu elle l affiche proprement a l ecran.
afficheLigne([Tete]):-
	tab(1),write('| '),write(Tete),writeln(' |'),!.
afficheLigne([Tete|Suite]):-
	tab(1),write('| '),write(Tete),
	afficheLigne(Suite).



  %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Predicat : afficheGrille/1
% recursive avec les succNum et succApha
% Se décompose en plusieurs étapes
% -> affichePremiereLigne :
%    afficher la premiere ligne en fonction de la longueur de la première ligne de la grille :
%    la condition terminale permet d afficher la valeur de la derniere colonne, quelque
%    soit le dernier element qui reste dans le tableau;
%    On parcourt la ligne mais le contenu de cette ligne ne nous interesse pas.
% -> afficheGrilleSimple :
%    afficher la grille en gérant les numéros de ligne avec le succNum;
% -> afficheGrille :
%    appelle les deux predicats precedants;
%

affichePremiereLigne(Val,[_]):- tab(1),write('| '),write(Val),writeln(' |').
affichePremiereLigne(Val,[_|Suite]):-
	tab(1),write('| '),write(Val),succAlpha(Val,Val2),
	affichePremiereLigne(Val2,Suite).

afficheGrilleSimple(_,[X]) :- tab(1), afficheLigne(X).
afficheGrilleSimple(N,[Tete|Reste]):-
	tab(1),afficheLigne(Tete),
	succNum(N,N1),write(N1),
	afficheGrilleSimple(N1,Reste).

afficheGrille([Tete|Suite]):-
	tab(2),affichePremiereLigne(a,Tete),
	write('1'),
	afficheGrilleSimple(1,[Tete|Suite]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Permet d afficher la grille au demarrage du jeu
% Predicat : afficheGrilleDep/0
% Usage : afficheGrilleDep affiche la grille de depart du jeu d othello,
%         sous la forme d une grille

afficheGrilleDep(G):-
	% grilleDeDepart(G),
	afficheGrille(G),!.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predicat : saisieUnCoup/2
% Usage : saisieUnCoup(NomCol,NumLig) permet de saisir un coup a jouer

saisieUnCoup(NomCol,NumLig):-
	writeln('Entrez votre coup (sans oublier le point) :'),
 	writeln('Colonne (a, b, c, d, e, f, g ou h) : '),
	saisieColonne(NomCol),
	writeln('Ligne (1, 2, 3, 4, 5, 6, 7 ou 8) : '),
	saisieLigne(NumLig).

% on peut affiner le predicat en testant les valeurs donnees par l utilisateur avec
% saisieColonne et saisieLigne.

% Predicat : saisieColonne/1
% Usage : saisieColonne(NomCol) permet d eviter les erreurs de saisie de la colonne
saisieColonne(NomCol):-
	read(NomCol),
	member(NomCol,[a,b,c,d,e,f,g,h]),!.

saisieColonne(NomCol):-
	writeln('Nom de colonne incorrect'),
	writeln('Colonne (a, b, c, d, e, f, g ou h) : '),
	saisieColonne(NomCol).


% Predicat : saisieLigne/1
% Usage : saisieLigne(NumLig) permet d eviter les erreurs de saisie de la ligne

saisieLigne(NumLig):-
	read(NumLig),
	member(NumLig,[1,2,3,4,5,6,7,8]),!.

saisieLigne(NumLig):-
	writeln('Coup invalide'),
	saisieUnCoup(_NomCol,NumLig).


jeu(o):-consult(otello).
jeu(t):-consult(tictactoe).

lanceJeux:-
writeln("Quel jeu voulez vous jouer ? t pour tictacttoe et o pour othello "),read(jeuo),
jeu(jeuo),
lanceJeu.
