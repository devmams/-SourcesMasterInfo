module Pow2_test where
---------- pow2_test1 --------------
pow2_test1 n =
  if n == 0 then False
  else if (n `mod` 2)  /= 0 then False
  else if n == 1 then True
  else pow2_test1 (n `div` 2)
