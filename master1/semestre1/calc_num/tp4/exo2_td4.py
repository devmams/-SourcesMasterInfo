import numpy as np
import random as rd
# ---- question 1 ----
def jeu_grand_petit():
    a_trouver = int(input("entrez le nombre a trouver : "));
    trouve = False
    while(trouve == False):
        res = int(input("entrez un nombre : "))
        if(res == a_trouver): trouve = True
        elif(a_trouver < res): print("trop grand")
        else: print("trop petit")
    return "bravo vous avez gangné !!"

# print(jeu_grand_petit())

# ---- question 2 ----

# def jeu_grand_petit_auto():
#     a_trouver = int(input("entrez le nombre a trouver : "));
#     trouve = False
#     while(trouve == False):
#         # res = int(input("entrez un nombre : "))
#         res = rd.randint(1,10)
#         if(res == a_trouver): trouve = True
#         elif(a_trouver < res): print("trop grand")
#         else: print("trop petit")
#     return "bravo vous avez gangné !!"

print(rd.randint(1,10))
