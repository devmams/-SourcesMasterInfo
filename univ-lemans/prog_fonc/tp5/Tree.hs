module Tree where
import List
------------------------ question 1 -------------------------
data Tree a = Empty | Node(Tree a, a, Tree a) deriving Show

arbre = Node(
              Node(Node(Empty,4,Empty),2,Node(Node(Empty,7,Empty),5,Node(Empty,8,Empty))),
              1,
              Node(Empty,3,Node(Node(Empty,9,Empty),6,Empty))
            )

-- max a b = if a >= b then a else b

hauteur arbre = case arbre of {
                  Empty -> 0;
                  Node(g,_,d) -> max( (hauteur g) + 1) ((hauteur d) + 1) ;
}

nb_feuilles arbre = case arbre of{
                      Empty -> 0;
                      Node(Empty,_,Empty) -> 1;
                      Node(g,_,d) -> (nb_feuilles g) + (nb_feuilles d);

}

-- prefixe = 1, 2, 4, 5, 7, 8, 3, 6, 9
-- symetrique = 4, 2, 7, 5, 8, 1, 3, 9, 6
-- postfixe = 4, 7, 8, 5, 2, 9, 6, 3, 1

liste_prefixe arbre = liste_pre arbre []
liste_pre arbre l =
  case arbre of{
    Empty -> l;
    Node(g,r,d) -> concatener (concatener [r] (liste_pre g l)) (liste_pre d l);
}

liste_symetrique arbre = liste_sym arbre []
liste_sym arbre l =
  case arbre of{
    Empty -> l;
    Node(g,r,d) -> concatener (concatener (liste_sym g l) [r]) (liste_sym d l);
}

liste_postfixe arbre = liste_post arbre []
liste_post arbre l =
  case arbre of{
    Empty -> l;
    Node(g,r,d) -> concatener (concatener (liste_post g l) (liste_post d l)) [r];
}

-- -----------------------------------------------------------------------------

liste_prof_noeud arbre = prof_nd arbre [] 1
prof_nd arbre l h =
  case arbre of{
    Empty -> l;
    Node(g,r,d) -> concatener (concatener [(r,h)] (prof_nd g l (h+1))) (prof_nd d l (h+1));
}

espace h ch =
  if h == 1 then ch
  else espace (h-1) (ch ++ "   ")


afficher arbre = aff (liste_prof_noeud arbre)
aff l = case l of {
  []  -> "";
  (nd,h):r ->  (espace h "") ++ "|__" ++ show(nd) ++ "\n" ++ (aff r)
}
















---------------------------- FIN ----------------------------
