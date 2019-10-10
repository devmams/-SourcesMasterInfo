voitures([X1,X2,X3,X4,X5,X6]) :-
/* définition des domaines */
% X1 = pare-chocs, X2 = toit, X3 = enjoliveurs, X4 = carrosserie, X5 = portières, X6 = capot,
% blanc = 1, jaune = 2, rouge = 3, noir = 4

% --Question 1 --
% fd_domain(X1,[1]),
% fd_domain(X2,[3]),
% fd_domain(X3,[2,3]),
% fd_domain(X4,[1,2,3,4]),
% fd_domain(X5,[3,2,4]),
% fd_domain(X6,[3,2,4]),
%
% /* définition des contraintes */
% X1#<X4,
% X3#<X4,
% X2#<X4,
% X4#=X5,
% X5#=X6,
% fd_labeling([X1,X2,X3,X4,X5,X6]).

fd_domain(X1,[1]),
fd_domain(X2,[3]),
fd_domain(X3,[2,3]),
fd_domain(X4,[1,2,3]),
fd_domain(X5,[3,2]),
fd_domain(X6,[3,2]),

/* définition des contraintes */

% fd_cardinality([X1#<X4,X3#<X4,X2#<X4,X4#=X5,X5#=X6],5),
% fd_cardinality([X1#<X4,X3#<X4,X2#<X4,X4#=X5,X5#=X6],4),
% fd_cardinality([X1#<X4,X3#<X4,X2#<X4,X4#=X5,X5#=X6],3),
fd_cardinality([X1#<X4,X3#<X4,X2#<X4,X4#=X5,X5#=X6,X6#=X4],NbContraintes),
NbContraintes #>= 5,
fd_labeling([X1,X2,X3,X4,X5,X6]).
