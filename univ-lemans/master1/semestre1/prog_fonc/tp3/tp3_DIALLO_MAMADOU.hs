-- NOM : DIALLO
-- PRENOM : MAMADOU

------------------------ question 1 -------------------------
-------- question a
n_premier_termes n = n

-------- question b
n_impairs n =
  if (n `mod` 2) == 0 then 0
  else n

-------- question c
n_signe_nombre n =
  if (n `mod` 2) == 0 then -n
  else n

somme_termes u 0 = u 0
somme_termes u n = (u n) + (somme_termes u (n-1))

-------- question d
inv100 x = somme_termes (\n -> (1-x)^n) 100

------------------------ question 2 -------------------------
somme_filtre n f =
  if n == 0 then n
  else if(f n) then n + (somme_filtre (n-1) f)
  else somme_filtre (n-1) f

-------- question a
pair_inf_10 n =
  if ((n `mod` 2) == 0) && n <= 10 then
    True
  else
    False

-------- question b
divide n p =
  if (n `mod` p) == 0 then
    True
  else
    False

est_parfait n =
  if((somme_filtre n (divide n)) `div` 2) == n then True
  else False

------------------------ question 3 -------------------------
-------- question a
applyn n f x =
  if n == 1 then f x
  else f (applyn (n-1) f x)

x_plus_1 x = x + 1

-------- question b
power x n = applyn (n-1) (\p -> x*p) x

------------------------ question 3 -------------------------
-------- question a
verif_ligne nb_ligne i =
  if (i >= 1 && i <= nb_ligne) then True
  else False

verif_colonne nb_colonne j =
  if (j >= 1 && j <= nb_colonne) then True
  else False


exemple (i,j) =
  if (verif_ligne 6 i) && (verif_colonne 5 j) then
    ("vrai",2*i+j)
  else
    ("faux",0)

-------- question b

identite_4_4 (i,j) =
  if (verif_ligne 4 i) && (verif_colonne 4 j) then
    if i == j then
      ("vrai",1)
    else
      ("vrai",0)
  else
    ("faux",0)

-------- question c
dim m = (nligne m 1, ncolonne m 1)

nligne m i =
  if m (i,1) == ("faux",0) then i-1
  else nligne m (i+1)

ncolonne m j =
  if m (1,j) == ("faux",0) then j-1
  else ncolonne m (j+1)

-------- question d

add_mat (mat_A,mat_B) (i,j) =
  if dim mat_A == dim mat_B then
    ("vrai",snd(mat_A (i,j)) + snd(mat_B (i,j)))
  else
    ("faux",0)

-------- question e
-- add_mat (exemple,identite_4_4) (2,2)
-- retourne ("faux",0) car les deux matrices n'ont pas la meme dimension

-------- question f
identite_6_5 (i,j) =
  if (verif_ligne 6 i) && (verif_colonne 5 j) then
    if i == j then
      ("vrai",1)
    else
      ("vrai",0)
  else
    ("faux",0)

---------------------------- FIN ----------------------------
