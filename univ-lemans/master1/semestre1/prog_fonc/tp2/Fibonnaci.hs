module Fibonnaci where
---------- fibo1 --------------
fibo1 0 = 0
fibo1 1 = 1
fibo1 n = fibo1(n-2) + fibo1(n-1)

fibo1_cpt 0 = 0
fibo1_cpt 1 = 0
fibo1_cpt n = 1 + fibo1_cpt (n-1)

---------- fibo2 --------------
fibo2 n = fibo2' n 0
fibo2' 0 res = 0
fibo2' 1 res = 1
fibo2' n res = (fibo2'(n-2) res) + (fibo2'(n-1) res)

fibo2_cpt n = fac2_cpt' n 0
fac2_cpt' 0 res = res
fac2_cpt' 1 res = res
fac2_cpt' n res = (fac2_cpt'(n-2) (res+1)) + (fac2_cpt'(n-1) (res+1))
