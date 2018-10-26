import numpy as np

# ----Q 1 ------------

n = np.arange(100)
print(n)
# print(n.size)
# print(type(n))
# print(n.dtype)
# print(n.ndim)

# ----Q 2 ------------
t=(n.copy())/100  # Création d'un nouveau vecteur t égal à n
print(t)
print('[n]= ',n,'\n') # Valeurs de n
t=np.arange(0,1,0.010) # Commande permettant de créer t directement sans passer par n
print('[t]= ',t) # Valeurs de t

print(np.where(t==0.50))
print("l'index de t correspondant à la valeur de 50 ms: ",np.where(t==0.05))
