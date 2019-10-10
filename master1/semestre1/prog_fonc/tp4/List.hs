-- NOM : DIALLO
-- PRENOM : MAMADOU


module List where
------------------------ question 1 -------------------------
-------- question a

somme l = case l of {
  []  -> 0;
  t:r -> t + (somme r)
}

produit l = case l of {
  []  -> 1;
  t:r -> t * (produit r)
}

longueur l = case l of {
  []  -> 0;
  _:r -> 1 + (longueur r)
}

inserer el l = case l of {
  []  -> [el];
  t:r -> if el < t then
          el:t:r;
         else
          t:(inserer el r);
}

trier l = case l of {
  []  -> [];
  t:r -> inserer t (trier r);
}

concatener l1 l2 = case l1 of {
  []  -> l2;
  t:r -> t:(concatener r l2);
}

-------- question b
inverse l = inv2 l []
inv2 l lres = case l of {
  []  -> lres;
  t:r -> inv2 r (t:lres);
}

------------------------ question 2 -------------------------

supprimer el l = suppr el l []
suppr el l lres = case l of {
  []  -> lres;
  t:r -> if el == t then
          (suppr el r lres)
         else
          t:(suppr el r lres);
}

-------- question a
max_un l = max_un_ch l (head l)
max_un_ch l res = case l of {
    [] -> res;
    t:r -> if t > res then
            max_un_ch r t;
           else
            max_un_ch r res;
}

-------- question b
max_deux l =
  let max1 = max_un l in
  let max2 = max_un (supprimer max1 l) in
  (max1,max2)

-------- question c
max_trois l =
  let max1 = max_un l in
  let l2 = supprimer max1 l in
  let max2 = max_un l2 in
  let max3 = max_un (supprimer max2 l2) in
  (max1,max2,max3)

--------- question 3 -------------------------
-------- question a

intervalle_asc inf sup = int_asc inf sup []
int_asc inf sup lres =
  if inf == sup then
    sup:lres
  else
    inf:(int_asc (inf+1) sup lres)

-------- question a
intervalle_desc inf sup = int_desc inf sup []
int_desc inf sup lres =
  if inf == sup then
    sup:lres
  else
    int_desc (inf+1) sup (inf:lres)


--------- question 4 -------------------------
-------- question a
prefixes l = pref [] l [[]]
pref tcour l lres = case l of {
    [] -> lres;
    t:r -> let tab = (concatener tcour [t]) in inserer tab (pref tab r lres)
}

-------- question b
suffixes l = suff [] (inverse l) [[]]
suff tcour l lres = case l of {
    [] -> lres;
    t:r -> let tab = (concatener [t] tcour) in (suff tab r (tab:lres))
}

------- question 5 -------------------------
-------- question a
inferieur u v = u < v

-------- question b
conjugue u i = conj u i [] [] 1
conj u i lres1 lres2 cpt = case u of {
    [] -> concatener lres2 lres1;
    t:r -> if cpt < i then (conj r i (concatener lres1 [t]) lres2 (cpt+1))
           else (conj r i lres1 (concatener lres2 [t]) (cpt+1))
}

-------- question c

liste_conjugues u = list_conj u [] 2
list_conj u lres i =
  if i == (longueur u)+1 then
    lres
  else
    (conjugue u i):(list_conj u lres (i+1))

lyndon u = ldn u (liste_conjugues u)
ldn u l = case l of {
    [] -> True;
    v:r -> if (inferieur u v) then ldn u r
           else False
}

-------- question d
appartient el l = case l of {
  []  -> False;
  t:r -> if el == t then True
         else appartient el r;
}

insere_liste l1 l2 = case l1 of {
    [] -> l2;
    t:r -> if (appartient t l2) then insere_liste r l2
           else insere_liste r (inserer t l2)
}

-------- question e
concat_mot_liste m l lres = case l of {
    [] -> lres;
    t:r -> concat_mot_liste m r (inserer (concatener m t) lres)
}

concat_liste_liste l1 l2 lres = case l1 of {
    [] -> lres;
    t:r -> concatener (concat_mot_liste t l2 []) (concat_liste_liste r l2 lres)
}

fusion_liste l1 l2 = fus_l (concat_liste_liste l1 l2 []) []
fus_l l lres = case l of {
    [] -> insere_liste lres [];
    t:r -> if lyndon t then fus_l r (t:lres)
           else fus_l r lres
}

-------- question f

genere 1 = [[0],[1]]
genere n = insere_liste (fusion_liste (genere 1) (genere (n-1))) (fusion_liste (genere (n-1)) (genere 1))



---------------------------- FIN ----------------------------
