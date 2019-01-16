/* les entrées */
entree(crudites).
entree(terrine).
entree(melon).
/* les viandes (avec légumes associés) */
viande(steack).
viande(poulet).
viande(gigot).
/* les poissons (avec légumes associés) */
poisson(bar).
poisson(saumon).
/* les desserts */
dessert(sorbet).
dessert(creme).
dessert(tarte).
% dessert(mousse_choco).
/* composition d'un menu simple : une entréRee ET un plat ET un dessert */
menu_simple(E, P, D) :- entree(E), plat(P), dessert(D).
/* le plat de résistance : viande OU poisson */
plat(P) :- viande(P).
plat(P) :- poisson(P).

% Quels sont les menus simples avec des crudités en entrée
m_s_a_crudite_en_entrees(E, P, D) :- menu_simple(E, P, D) , E == 'crudites'.

% Peut-on avoir un menu avec des crudités et une mousse au chocolat ?
% solution : rajouter un dessert mousse_choco

m_a_crudite_mousse_choco(E,P,D) :- dessert(D), D == 'mousse_choco' ,m_s_a_crudite_en_entrees(E, P, D).

% Quels sont les menus avec du poisson comme plat ?

menu_avec_poisson(E,P,D) :- plat(P), poisson(P), menu_simple(E, P, D).

% Quels sont les menus avec du melon en entrée et du poisson comme plat ?

menu_melon_poisson(E,P,D) :- entree(E), E == 'melon', menu_avec_poisson(E,P,D).
