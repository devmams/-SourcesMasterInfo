f = let n = 10 in print $ "variable n = " ++ show(n)

------------------------ question 1-a -------------------------

egaux (n1,n2,n3,n4) =
  if n1 == n2 && n2 == n3 && n3 == n4 then True
  else False
-- EXEMPLE
-- egaux (1,1,2,1) => False
-- egaux (1,1,1,1) => True

------------------------ question 1-b -------------------------

plus_grand (n1,n2,n3,n4) =
  if n1 >= n2 && n1 >= n3 && n1 >= n4 then n1
  else if n2 >= n3 && n2 >= n4 then n2
  else if n3 >= n4 then n3
  else n4
-- EXEMPLE
-- plus_grand (6,5,13,-19) => 13

------------------------ question 1-c -------------------------
plus_eloigne (n1,n2,n3,n4) =
  let res1 = abs(n1-n1) in
  let res2 = abs(n1-n2) in
  let res3 = abs(n1-n3) in
  let res4 = abs(n1-n4) in
  let res = plus_grand(res1,res2,res3,res4) in
  if res == res1 then n1
  else if res == res2 then n2
  else if res == res3 then n3
  else n4
-- EXEMPLE
-- plus_eloigne (6,5,13,-19) => -19

------------------------ question 2-a -------------------------

chaine_lineaire_deux (d1,d2) =
  if fst(d1) == fst(d2) then True
  else if fst(d1) == snd(d2) then True
  else if snd(d1) == fst(d2) then True
  else if snd(d1) == snd(d2) then True
  else False

------------------------ question 2-b -------------------------

chaine_lineaire_trois (d1,d2,d3) =
  if chaine_lineaire_deux (d1,d2) then
    if fst(d1) == fst(d2) then
      chaine_lineaire_deux( (snd(d1),snd(d2)) , d3)
    else if fst(d1) == snd(d2) then
      chaine_lineaire_deux( (snd(d1),fst(d2)) , d3)
    else if snd(d1) == fst(d2) then
      chaine_lineaire_deux( (fst(d1),snd(d2)) , d3)
    else if snd(d1) == snd(d2) then
      chaine_lineaire_deux( (fst(d1),fst(d2)) , d3)
    else
      False
  else
    False

------------------------ question 3 --------------------------

unite n =
  case n of
    0  -> ""
    1  -> "un"
    2  -> "deux"
    3  -> "trois"
    4  -> "quatre"
    5  -> "cinq"
    6  -> "six"
    7  -> "sept"
    8  -> "huit"
    9  -> "neuf"
    10 -> "dix"
    11 -> "onze"
    12 -> "douze"
    13 -> "treize"
    14 -> "quatorze"
    15 -> "quinze"
    16 -> "seize"

dizaine n =
  case n of
    0 -> ""
    1 -> "dix"
    2 -> "vingt"
    3 -> "trente"
    4 -> "quarante"
    5 -> "cinquante"
    6 -> "soixante"
    7 -> "soixante"
    8 -> "quatre-vingts"
    9 -> "quatre-vingts"


decompose n =
  if n <= 16 then
    (0,n)
  else
    divMod n 10

ortho_nomrbre n =
  let decomp = decompose n in
  if fst(decomp) == 7 || fst(decomp) == 9  then
    dizaine(fst(decomp)) ++ "-" ++ unite(10+snd(decomp))
  else
    if fst(decomp) == 0 || snd(decomp) == 0 then
      dizaine(fst(decomp)) ++ unite(snd(decomp))
    else
      dizaine(fst(decomp)) ++ "-" ++ unite(snd(decomp))


-- à faire le dernier exo

---------------------------- FIN -------------------------------
