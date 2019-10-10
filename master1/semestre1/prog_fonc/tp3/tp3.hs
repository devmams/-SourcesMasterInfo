n_premier n = n

n_nb_impairs n =
  if (n `mod` 2) == 0 then 0
  else n

n_oppose n =
  if (n `mod` 2) == 0 then -n
  else n


somme_termes u 0 = u 0
somme_termes u n = (u n) + (somme_termes u (n-1))

inv100 x = somme_termes (\n -> (1-x)^n) 100

pair n =
  if ((n `mod` 2) == 0) && n <= 10 then True
  else False

divise n p =
  if (n `mod` p) == 0 then
    True
  else
    False

somme_filtre n f =
  if n == 0 then n
  else if(f n) then n + (somme_filtre (n-1) f)
  else somme_filtre (n-1) f

est_parfait n =
  if((somme_filtre n (divise n)) `div` 2) == n then True
  else False

applyn n f x =
  if n == 1 then f x
  else f (applyn (n-1) f x)

x_plus_1 x = x + 1

power x n = applyn (n-1) (\p -> x*p) x
