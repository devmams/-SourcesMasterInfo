import requests
import numpy as np
from pylab import *

fichier = open("house-votes-84.txt", "r")
lignes = fichier.readlines()

def repOuDem(ch):
    if(ch == 'republican'):
        return 1
    else:
        return -1

def choixVote(c):
    if c=='y':
        return 1
    if c=='n':
        return -1
    else:
        return 0


Data = []
Target = []

i = 0
for ligne in lignes:
    t = ligne.split(',')
    # print(t[1])
    Target.append(repOuDem(t[0]))
    i = 0
    for i in range(1,len(t)-1):
        print(t[i])
        Data.append(choixVote(t[i]))
    i += 1

print(Target)
print(Data)
Data = np.reshape(Data,(-1,15))
print(Data)
fichier.close()
