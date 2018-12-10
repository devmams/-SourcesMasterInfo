module Abr where
import Tree

------------------------ question 1 -------------------------
--------------question a

arbre_abr = Node(
              Node(Node(Empty,1,Empty),3,Node(Node(Empty,4,Empty),6,Node(Empty,7,Empty))),
              8,
              Node(Empty,10,Node(Node(Empty,13,Empty),14,Empty))
            )

arbre_abr_test = Node(
              Node(Node(Empty,1,Empty),3,Node(Node(Empty,6,Empty),4,Node(Empty,7,Empty))),
              8,
              Node(Empty,10,Node(Node(Empty,13,Empty),14,Empty))
            )

            -- int test(arbre *ar)
            -- {
            --     if (ar==NULL)
            --         return 1;
            --     if ((!(ar->fg)) && (!(ar->fd)))
            --         return 1;
            --     if (!(ar->fg) && (ar->fd))
            --         return ((ar->x)<(ar->fd->x))*test(ar->fd);
            --     if ((ar->fg) && (!(ar->fd)))
            --         return ((ar->x)>(ar->fg->x))*test(ar->fg);
            --     if ((ar->fg) && (ar->fd))
            --         return (test(ar->fd)*test(ar->fg));
            -- }
-- liste_triee l n = case l of {
--   []  -> True;
--   t:r -> if n <= t then (liste_triee r t)
--          else False;
-- }
--
-- bien_forme arbre = let l = (liste_symetrique arbre) in (liste_triee (tail l) (head l))

bien_forme arbre = case arbre of {
                      Empty -> True;
                      Node(Empty,_,Empty) -> True;
                      Node(g,r,Empty) -> (sup_g g r) && (bien_forme g);
                      Node(Empty,r,d) -> (sup_d d r) && (bien_forme d);
                      Node(g,r,d) -> (bien_forme g) && (bien_forme d);
}
sup_g arbre n = case arbre of {
                  Node(_,r,_) -> if n > r then True else False;
}
sup_d arbre n = case arbre of {
                  Node(_,r,_) -> if n < r then True else False;
}

-- sup arbre n = case arbre of {
--                       Node(Empty,r,Empty) -> if n > r then True else False;
--                       Node(g,r,_) -> if n > r then (sup g r) else False;
--                       Node(_,r,d) -> if n < r then (sup d r) else False;
-- }

--------------question b
insere arbre elt = ins arbre elt Empty
ins arbre elt a_res = case arbre of {
  Empty -> Node(Empty,elt,Empty);
  Node(g,r,d) -> if elt == r then Node(g,r,d)
                 else if elt > r then Node(g,r,(ins d elt a_res))
                 else Node((ins g elt a_res),r,d)
}
--
-- res = insere arbre_abr 9
-- aff_res = putStrLn $ afficher res

--------------question c

liste_vers_arbre l = lva l Empty
lva l a_res = case l of {
  []  -> a_res;
  t:r -> lva r (insere a_res t)
}
--
-- l = liste_vers_arbre ([8,3,10,1,6,14,4,7,13])
-- aff_l  = putStrLn $ afficher l

--------------question d
arbre_vers_liste arbre = (liste_symetrique arbre)

--------------question e
tri l = let a = (liste_vers_arbre l) in arbre_vers_liste a

---------------------------- FIN ----------------------------
