------------------------ question 1 -------------------------

n_premier_termes n = n

n_impairs n =
  if (n `mod` 2) == 0 then 0
  else n

n_signe_nombre n =
  if (n `mod` 2) == 0 then -n
  else n

puissance x n = puiss_rec (1-x) n 1
puiss_rec x 0 res = res
puiss_rec x n res = puiss_rec x (n-1) (res*x)

-- somme_termes u n = somme_rec u n 1
-- somme_rec u 0 res = res
-- somme_rec u n res = somme_rec u (n-1) (res+ (u n))

somme_termes u 0 = u 0
somme_termes u n = (u n) + (somme_termes u (n-1))

-- inv100 x = somme_termes (puissance x) 100
inv100 x = somme_termes (\n -> (1-x)^n) 100

------------------------ question 2 -------------------------

pair_inf_10 n =
  if ((n `mod` 2) == 0) && n <= 10 then
    True
  else
    False

divide n p =
  if (n `mod` p) == 0 then
    True
  else
    False

somme_filtre n f =
  if n == 0 then n
  else if(f n) then n + (somme_filtre (n-1) f)
  else somme_filtre (n-1) f

est_parfait n =
  if((somme_filtre n (divide n)) `div` 2) == n then True
  else False

------------------------ question 3 -------------------------
applyn n f x =
  if n == 1 then f x
  else f (applyn (n-1) f x)

x_plus_1 x = x + 1

-- x_fois_x x = x*x

power x n = applyn n (\p -> x*p) x















---------------------------- FIN ----------------------------
