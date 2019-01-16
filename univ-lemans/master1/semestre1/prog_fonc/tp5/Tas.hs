module Tas where
import Tree
import List
-- import Abr
------------------------ question 1 -------------------------

arbre_tas = Node(
              Node(Node(Node(Empty,90,Empty),21,Node(Empty,22,Empty)),20,Node(Empty,80,Node(Empty,81,Empty))),
              8,
              Node(Node(Node(Empty,75,Empty),12,Node(Empty,20,Empty)),10,Node(Node(Empty,80,Empty),11,Empty))
            )

arbre_abr = Node(
              Node(Node(Empty,1,Empty),3,Node(Node(Empty,4,Empty),6,Node(Empty,7,Empty))),
              8,
              Node(Empty,10,Node(Node(Empty,13,Empty),14,Empty))
            )

--------------question a

bien_forme_tas arbre = case arbre of {
                      Empty -> True;
                      Node(Empty,_,Empty) -> True;
                      Node(g,r,Empty) -> if((sup_fils g r)) then (bien_forme_tas g) else False;
                      Node(Empty,r,d) -> if((sup_fils d r)) then (bien_forme_tas d) else False;
                      Node(g,r,d) -> ((sup_fils g r) && (bien_forme_tas g)) && ((sup_fils d r) && (bien_forme_tas d))
}

sup_fils arbre n = case arbre of {
                  Node(_,r,_) -> r >= n;
}

--------------question b
insere_tas arbre elt = ins_tas arbre elt Empty
ins_tas arbre elt a_res = case arbre of {
  Empty -> Node(Empty,elt,Empty);
  Node(g,r,d) -> if r == elt then Node(g,r,d)
                 else if elt < r then Node(g,elt,(ins_tas d r a_res))
                 else Node((ins_tas g elt a_res),r,d)
}

--------------question c

liste_vers_arbre_tas l = lva_tas l Empty
lva_tas l a_res = case l of {
  []  -> a_res;
  t:r -> lva_tas r (insere_tas a_res t)
}

--------------question d

arbre_vers_liste_tas arbre = trier (liste_symetrique arbre)

--------------question d

tri_tas l = let a = (liste_vers_arbre_tas l) in arbre_vers_liste_tas a
---------------------------- FIN ---------------------------
