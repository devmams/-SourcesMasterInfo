module Factorielle where
---------- fac1 --------------
fac1 0 = 1
fac1 n = n * fac1 (n-1)

fac1_cpt 0 = 0
fac1_cpt n = 1 + fac1_cpt (n-1)

---------- fac2 --------------
fac2 n = fac2' n 1
fac2' 0 res = res
fac2' n res = fac2' (n-1) (n*res)

fac2_cpt n = fac2_cpt' n 0
fac2_cpt' 0 res = res
fac2_cpt' n res = fac2_cpt' (n-1) (res+1)
