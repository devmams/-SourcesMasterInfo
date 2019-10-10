import requests
import numpy as np
from pylab import *

fichier = open("house-votes-84.txt", "r")
lignes = fichier.readlines()

# republican = 1 ,democrat = -1 ,y = 1, n = -1 et ? = 0
def choixVote(ch):
    if ch == 'republican':
        return 1
    elif ch == 'democrat':
        return -1
    elif ch == 'y':
        return 1
    elif ch == 'n':
        return -1
    else:
        return 0

Vote = []

i = 0
for ligne in lignes:
    ligne = ligne.replace('\n','')
    t = ligne.split(',')
    for i in range(0,len(t)):
        # print(t[i])
        Vote.append(choixVote(t[i]))

Vote = np.reshape(Vote,(-1,17))
# print("Vote :", Vote)
np.random.seed(987654321)
np.random.shuffle(Vote)
# print("-----------")
# print(Vote)


Target = Vote[:,0]
Data = Vote[:,1:]
# print("Target : ",Target)
# print("Data :",Data)

nbExempleTrain = 7

TrainData = Data[0:nbExempleTrain,:]
TrainTarget = Target[0:nbExempleTrain]

TestData = Data[nbExempleTrain:,:]
TestTarget = Data[nbExempleTrain:]
# print("-----------")
print("TrainData :\n", TrainData)
print("TrainTarget :\n", TrainTarget)
# print("TestData : ", TestData)

def classify(element,vectPoids):
    res = sum(element * vectPoids)
    # print(res)
    if(res >= 0):
        return 1
    return -1

def test(Data,Target,VectPoids):
    prediction = []
    for i in range(0,len(Data)):
        prediction.append(classify(Data[i],VectPoids))
    nbErreur = 0.0
    for i in range(0,len(Target)):
        if Target[i] != prediction[i]:
            nbErreur += 1
    return nbErreur/len(Target)

vecteurPoids = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
# print(classify(TrainData[3],vecteurPoids))
print(test(TrainData,TrainTarget,vecteurPoids))

def train():

fichier.close()
# ---------------------------------- FIN ----------------------------------
