% variable
reines([X1,X2,X3,X4]) :-  /*X = {X1, X2, X3, X4}*/

% domaine
fd_domain([X1,X2,X3,X4],[1,2,3,4]),   /*D = {1, 2, 3, 4}*/

% contraintes
% X1#\=X2
% X2#\=X3
% X3#\=X4
fd_all_different([X1,X2,X3,X4]),
1+X1#\=2+X2,
2+X2#\=3+X3,
3+X3#\=4+X4,

1-X1#\=2-X2,
2-X2#\=3-X3,
3-X3#\=4-X4,

fd_labeling([X1,X2,X3,X4]).
