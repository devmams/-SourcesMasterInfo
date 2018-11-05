#=======================================================
#       Khalid Al-kassoum Houssam
#       4/11/16
#=======================================================

from sklearn import datasets
import numpy as np
import math

######################
#Methode qui permet de d'extraire deux colonne dans une matrice
#@classe  : la classe dont on veu le vecteur moyen (esperance)
######################

def extraireColonnes(matrice,col1,col2):
    
    i=0
    resulte = matrice[0:len(matrice),0:2]
    while i < len(matrice):
        resulte[i] = [ matrice[i][col1] , matrice[i][col2] ]
        i+=1
    return resulte

######################
#Methode qui permet de calculer la distance de Manhattan entre deux elements 
#@x  : le premier element
#@y  : le deuxieme element
######################

def distanceManhattan(x,y):
    
    distance = 0.0
    distance = np.abs(x[0]-y[0]) + np.abs(x[1]-y[1])
    return distance

######################
#Methode qui permet de calculer la distance de Euclidienne entre deux elements 
#@x  : le premier element
#@y  : le deuxieme element
######################

def distanceEuclidienne(x,y):
    
    distance = 0.0
    distance = np.sqrt( np.absolute(x[0]-y[0]) + np.absolute(x[1]-y[1]) )
    return distance

######################
#Methode qui permet de ranger les element d'un tableau à deux dimention dans l'ordre decroissant en comparant sur la deuxieme dimention
#@tab  : le tableau a ranger
######################

def ordredecroissantTab(tab):

    i = 0
    while(i < len(tab)-1):

        if(tab[i][1] < tab[i+1][1]) :
            tab[i][0],tab[i][1] ,tab[i+1][0],tab[i+1][1] = tab[i+1][0],tab[i+1][1],tab[i][0],tab[i][1]
            i = -1

        i = i+1


######################
#Methode qui cherche les k plus proches voisins d'un élément
#@data     : l'ensemble dans lequel on cherche les plus proches voisins 
#@element  : l'element dont on cherche les k plus proche voisin
#@k        : le nombre k plus proche voisin a trouver
#@d        : type de distance utilise (1 = ecludienne , 2 = Manhattan)
######################

def chercheKpp(data,element,k,d):

    kpp = np.array([[-1,100000000.0]]*k) #tableau qui contiendra [indice,distance] des k plus proches voisin de element dans data
    i=0

    while(i < len(data)):

        if(d == 1):
            distance = distanceEuclidienne(element,data[i])#on calcule la distance de element a un element de data
        else :
            distance = distanceManhattan(element,data[i])#on calcule la distance de element a un element de data

        if(distance < kpp[0,1]):#si la distance est inferieur celui de l'element le plus distant dans kpp
           kpp[0] = [i,distance]
           ordredecroissantTab(kpp)
        i = i+1
    return kpp
    
######################
#Methode qui permet de dir la classe d'appartenance d'un element apres vote de ses plus proche voisins
#@kpp  : les k plus proche voisin d'un element
######################

def resultVote(kpp,target):
    voteClasse0 = 0
    voteClasse1 = 0
    voteClasse2 = 0

    i = 0
    while(i < len(kpp)):
        if(target[int(kpp[i,0])] == 0):
            voteClasse0 = voteClasse0 +1
        elif(target[int(kpp[i,0])] == 1):
            voteClasse1 = voteClasse1 +1
        elif(target[int(kpp[i,0])] == 2):
            voteClasse2 = voteClasse2 +1
        i = i+1

    if(voteClasse0 > voteClasse1 and voteClasse0 > voteClasse2):
        return 0
    if(voteClasse1 > voteClasse0 and voteClasse1 > voteClasse2):
        return 1
    return 2

#================================================================ MAIN ================================================================


print('============== CLASSIFIEUR Knn ============')

print(" 1- longueur petale")
print(" 2- longueur sepale")
print(" 3- largeur  petale")
print(" 4- largeur  sepale")

c1 = int(input("choisisser la 1er caracteristique :"))
c2 = int(input("choisisser la 2em caracteristique :"))

print("K = le nombre de voisins les plus proches utiliser pour le vote ")
print("D = la distance pour la mesure de similarite (1 pour distanceEuclidienne et 2 pour distanceManhattan")
k  = int(input("entrer la valeur de K:"))
D  = int(input("entrer la valeur de D:"))

c1 = c1-1 #car dans le programme les indices commance a 0
c2 = c2-1

#----- chargement et melange des données
irisData = datasets.load_iris()
CirisData = np.c_[irisData.data.reshape(len(irisData.data),-1),irisData.target.reshape(len(irisData.target),-1)]
np.random.seed(987654321)
np.random.shuffle(CirisData)
shuffledIrisData = CirisData[ :, :irisData.data.size//len(irisData.data)].reshape(irisData.data.shape)
shuffledIrisTarget = CirisData[ :, irisData.data.size//len(irisData.data) :].reshape(irisData.target.shape)

#on extrait les deux colonnes sur les quelles on travailleura
shuffledIrisData = extraireColonnes(shuffledIrisData,c1,c2)

#----- divion des données
#donnees apprentissage <- 100 premiers exemples
donneesApp = shuffledIrisData[0:100,:]
targetApp  = shuffledIrisTarget[0:100]

#donnees dev <- 30 exemples suivants
donneesDev = shuffledIrisData[100:130,:]
targetDev  = shuffledIrisTarget[100:130]

#donnees test <- 20 derniers exemples
donneesTest = shuffledIrisData[130:150,:]
targetTest  = shuffledIrisTarget[130:150]

targetDevPredict = [] #tableau des predictions des classes par notre classifieur pour le corpus dev

i=0
while(i < len(donneesDev)):#classification des donnees de dev

    kpp = chercheKpp(donneesApp,donneesDev[i],k,D)
    targetDevPredict.append(resultVote(kpp,targetApp))
    i = i +1

print("Target dev :")
print(targetDev)

print("Target dev predicted :")
print(targetDevPredict)


#================================================================ MATRICE DE CONFUSION TEST ================================================================
targetTestPredict = [] #tableau des predictions des classes par notre classifieur pour le corpus Test
i=0
while(i < len(donneesTest)):#classification des donnees de Test

    kpp = chercheKpp(donneesApp,donneesTest[i],k,D)
    targetTestPredict.append(resultVote(kpp,targetApp))
    i = i +1

correcte=[0,0,0]
confusion=[[0,0,0],[0,0,0],[0,0,0]]
cpt = 0
while(cpt < len(targetTestPredict)):
    
    if(targetTestPredict[cpt]==0):
        if(targetTest[cpt]==0):
            correcte[0] += 1
        elif(targetTest[cpt]==1):
            confusion[0][1]+=1
        elif(targetTest[cpt]==2):
            confusion[0][2]+=1
    
    elif(targetTestPredict[cpt]==1):
        if(targetTest[cpt]==0):
            confusion[1][0]+=1
        elif(targetTest[cpt]==1):
            correcte[1] += 1
        elif(targetTest[cpt]==2):
            confusion[1][2]+=1
    
    elif(targetTestPredict[cpt]==2):
        if(targetTest[cpt]==0):
            confusion[2][0]+=1
        elif(targetTest[cpt]==1):
            confusion[2][1]+=1
        elif(targetTest[cpt]==2):
            correcte[2] += 1
    
    cpt += 1


print('================= MATRICE DE CONFUSION TEST=================')
print('CLASSE            0      1      2   ')
print('-------------------------------------')
print('0     |           %.2d    %.2d      %.2d   '%(correcte[0],confusion[0][1],confusion[0][2]))
print('1     |           %.2d    %.2d      %.2d   '%(confusion[1][0],correcte[1],confusion[1][2]))
print('2     |           %.2d    %.2d      %.2d   '%(confusion[2][0],confusion[2][1],correcte[2]))

print('bonne classification %d'%(correcte[0]+correcte[1]+correcte[2]))
print('mauvaise classification %d'%(confusion[0][1]+confusion[0][2]+confusion[1][0]+confusion[1][2]+confusion[2][0]+confusion[2][1]))
print((correcte[0]+correcte[1]+correcte[2])/20)

