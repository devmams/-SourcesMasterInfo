import Factorielle
import Fibonnaci
import Pow2_test
main = do
  putStr $ "Entrez une valeur : "
  n <- readLn
  ------------------------------------- Factorielle -------------------------------------
  -- putStrLn $ "Factorielle non Terminale de 50 = " ++ show (fac1 100)
  -- putStrLn $ "Nombre d'appel Factorielle non Terminale de 50 = " ++ show (fac1_cpt 100)
  -- putStrLn $ "Factorielle Terminale de 50 = " ++ show (fac2 100)
  -- putStrLn $ "Nombre d'appel Factorielle Terminale de 50 = " ++ show (fac2_cpt 100)
  -------------------------------------- Fibonnaci --------------------------------------
  -- putStrLn $ "Fibonnaci non Terminale de " ++ show(n) ++ " = " ++ show (fibo1 n)
  -- putStrLn $ "Nombre d'appel Fibonnaci non Terminale de " ++ show(n) ++ " = " ++ show (fibo1_cpt n)
  -- putStrLn $ "Fibonnaci Terminale de " ++ show(n) ++ " = " ++ show (fibo2 n)
  -- putStrLn $ "Nombre d'appel Fibonnaci Terminale de " ++ show(n) ++ " = " ++ show (fibo2_cpt n)
  -------------------------------------- Pow2_test --------------------------------------
  -- putStr $ "Pow2Test non Terminale de " ++ show(n) ++ " = "
  print $ pow2_test1 n
