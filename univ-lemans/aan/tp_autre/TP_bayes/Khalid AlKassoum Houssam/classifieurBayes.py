#=======================================================
#       Khalid Al-kassoum Houssam
#       7/10/16
#=======================================================

from sklearn import datasets
import numpy as np
import math

#============================================================== Methodes ==============================================================

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
#Methode qui permet de calculer la proba a priori d'une classe
#@classe  : la classe dont on veu le vecteur moyen (esperance)
######################
def probPriorie(target,classe):
    taille = 0
    i=0
    while i < len(target):
        if target[i] == classe :
            taille += 1
        i+=1
    return taille/len(target)


######################
#Methode qui permet de calculer le vecteur moyen pour chaque classe
#@matrice : la matrice contenant les valeurs des caracteristiques
#@target  : le tableau qui garde la reference entre les lignes  de la matrice et la classe correspondante
#@classe  : la classe dont on veu le vecteur moyen (esperance)
######################
def vecteurMoyen(matrice,target,classe):
    
    dim1=0.0
    dim2=0.0

    taille = 0
    i=0
    while i < len(matrice):
        if target[i] == classe :
            
            dim1 += matrice[i,0]
            dim2 += matrice[i,1]
        
            taille += 1
        i += 1
    
    dim1 = dim1/taille
    dim2 = dim2/taille

    return np.asarray([dim1,dim2])




######################
#Methode qui permet de calculer la variance pour chaque caracteristique de chaque classe
#@matrice : la matrice contenant les valeurs des caracteristiques
#@target  : le tableau qui garde la reference entre les lignes  de la matrice et la classe correspondante
#@y       : le vecteur moyenne(esperance) a utiliser pour le calcule  des variances
#@classe  : la classe dont on veu le vecteur moyen (esperance)
######################
def variance(matrice,target,y,classe):
    i=0
    taille = 0
    var1=0
    var2=0
    while i < len(matrice):
        if target[i] == classe :
            var1 += (matrice[i,0]-y[0])**2
            var2 += (matrice[i,1]-y[1])**2
            taille += 1
        i += 1
    
    return np.asarray([var1/taille,var2/taille])

######################
#Methode qui permet de calculer la matrice variance-covariance sur deux caracteristique d'une classe
#@matrice : la matrice contenant les valeurs des caracteristiques
#@target  : le tableau qui garde la reference entre les lignes  de la matrice et la classe correspondante
#@y       : le vecteur moyenne(esperance) a utiliser pour la premiere caracteristique
#@classe  : la classe sur la qu'elle porte le calcule
######################
def covariance(matrice,target,y,classe):
    i=0
    taille = 0
    cov=0
    while i < len(matrice):
        if target[i] == classe :
            cov += (matrice[i,0]-y[0])+(matrice[i,1]-y[1])
            taille += 1
        i += 1
    
    return cov/taille


######################
#Methode qui permet de calculer la probabiliter pour une valeur en utilisant une loi gossien
#@x       : le valeur dont on veut calculer la probabilité
#@moyenne : la moyenne a utiliser pour cette attribut
#@variance: la variance
######################
def probabilite(x, moyenne,varCov):
  
  
    A = np.transpose(x-moyenne)
    B = np.linalg.inv(varCov)
    C = x-moyenne
    exponent =math.exp(-0.5* np.inner(np.inner(A,B),C))
    D = math.pow(np.linalg.norm(varCov),0.5)
    return (1 / (2*math.pi* D)) * exponent

######################
#Methode qui renvoi la classe la plus approprier a un element
#
######################
classe = classifieur(donneesTest[cpt],classe0,classe1,classe2,probApriories)
def classifieur(element,classe0,classe1,classe2,appriorie):
    probClasse0 = appriorie[0] * probabilite(element, classe0[0],classe0[1])
    probClasse1 = appriorie[1] * probabilite(element, classe1[0],classe1[1])
    probClasse2 = appriorie[2] * probabilite(element, classe2[0],classe2[1])

    if(probClasse0 > probClasse1 and probClasse0>probClasse2):
        return 0
    if(probClasse1 > probClasse0 and probClasse1>probClasse2):
        return 1
    return 2

#======================================================================================================================================


#================================================================ MAIN ================================================================


print('============== CLASSIFIEUR BAYESIEN ============')

print(" 1- largeur petale")
print(" 2- longueur petale")
print(" 3- largeur sepale")
print(" 4- longueur sepale")


c1 = int(input("choisisser la 1er caracteristique :"))
c2 = int(input("choisisser la 2em caracteristique :"))

c1 = c1-1
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

#----------------- Calcule des paramètres du classieur Bayésien

#----- Calcule des probabilitées a priorie
probApriori0= probPriorie(targetApp,0)
probApriori1= probPriorie(targetApp,1)
probApriori2= probPriorie(targetApp,2)

#----- Calcule des vecteurs moyens

#---classe 0
vecteurMoyen0 = vecteurMoyen(donneesApp,targetApp,0)
#print(vecteurMoyen0)

#---classe 1
vecteurMoyen1 = vecteurMoyen(donneesApp,targetApp,1)
#print(vecteurMoyen1)

#---classe 2
vecteurMoyen2 = vecteurMoyen(donneesApp,targetApp,2)
#print(vecteurMoyen2)


#----- Calcule des variances

#---classe 0
variances0 = variance(donneesApp,targetApp,vecteurMoyen0,0)

#---classe 1
variances1 = variance(donneesApp,targetApp,vecteurMoyen1,1)

#---classe 2
variances2 = variance(donneesApp,targetApp,vecteurMoyen2,2)



#----- Calcule des covariances

#---classe 0
cov0 = covariance(donneesApp,targetApp,vecteurMoyen0,0)
print('cov0 :',cov0)
#---classe 0
cov1 = covariance(donneesApp,targetApp,vecteurMoyen1,1)
print('cov1 :',cov1)
#---classe 0
cov2 = covariance(donneesApp,targetApp,vecteurMoyen2,2)
print('cov2 :',cov2)


#----- Calcule des  matrice variance-covariances

#---classe 0
varCov0 = np.asarray([[vecteurMoyen0[0],cov0],[cov0,vecteurMoyen0[1]]])

#---classe 1
varCov1 = np.asarray([[vecteurMoyen1[0],cov1],[cov1,vecteurMoyen1[1]]])

#---classe 2
varCov2 = np.asarray([[vecteurMoyen2[0],cov2],[cov2,vecteurMoyen2[1]]])




#classe[vecteurMoyenne,matVarCov]
classe0 = [vecteurMoyen0,varCov0]
classe1 = [vecteurMoyen1,varCov1]
classe2 = [vecteurMoyen2,varCov2]
probApriories=[probApriori0,probApriori1,probApriori2]



cpt = 0
targetF =[]

while(cpt < len(donneesDev)):
    classe = classifieur(donneesDev[cpt],classe0,classe1,classe2,probApriories)
    print(donneesDev[cpt] , ' classe : ',classe)
    targetF.append(classe)
    cpt += 1

print(targetDev)


correcte=[0,0,0]
confusion=[[0,0,0],[0,0,0],[0,0,0]]
cpt = 0
while(cpt < len(targetF)):
    
    if(targetF[cpt]==0):
        if(targetDev[cpt]==0):
            correcte[0] += 1
        elif(targetDev[cpt]==1):
            confusion[0][1]+=1
        elif(targetDev[cpt]==2):
            confusion[0][2]+=1
    
    elif(targetF[cpt]==1):
        if(targetDev[cpt]==0):
            confusion[1][0]+=1
        elif(targetDev[cpt]==1):
            correcte[1] += 1
        elif(targetDev[cpt]==2):
            confusion[1][2]+=1
    
    elif(targetF[cpt]==2):
        if(targetDev[cpt]==0):
            confusion[2][0]+=1
        elif(targetDev[cpt]==1):
            confusion[2][1]+=1
        elif(targetDev[cpt]==2):
            correcte[2] += 1
    
    cpt += 1


print('CLASSE            0      1      2   ')
print('-------------------------------------')
print('0     |           %.2d    %.2d      %.2d   '%(correcte[0],confusion[0][1],confusion[0][2]))
print('1     |           %.2d    %.2d      %.2d   '%(confusion[1][0],correcte[1],confusion[1][2]))
print('2     |           %.2d    %.2d      %.2d   '%(confusion[2][0],confusion[2][1],correcte[2]))

print('bonne classification %d'%(correcte[0]+correcte[1]+correcte[2]))
print('mauvaise classification %d'%(confusion[0][1]+confusion[0][2]+confusion[1][0]+confusion[1][2]+confusion[2][0]+confusion[2][1]))



#---------------------------------------------TEST------------------------------------------------------------------

cpt = 0
targetT =[]

while(cpt < len(donneesTest)):
    classe = classifieur(donneesTest[cpt],classe0,classe1,classe2,probApriories)
    print(donneesTest[cpt] , ' classe : ',classe)
    targetT.append(classe)
    cpt += 1

print(targetTest)


correcte=[0,0,0]
confusion=[[0,0,0],[0,0,0],[0,0,0]]
cpt = 0
while(cpt < len(targetT)):
    
    if(targetT[cpt]==0):
        if(targetTest[cpt]==0):
            correcte[0] += 1
        elif(targetTest[cpt]==1):
            confusion[0][1]+=1
        elif(targetTest[cpt]==2):
            confusion[0][2]+=1
    
    elif(targetT[cpt]==1):
        if(targetTest[cpt]==0):
            confusion[1][0]+=1
        elif(targetTest[cpt]==1):
            correcte[1] += 1
        elif(targetTest[cpt]==2):
            confusion[1][2]+=1
    
    elif(targetT[cpt]==2):
        if(targetTest[cpt]==0):
            confusion[2][0]+=1
        elif(targetTest[cpt]==1):
            confusion[2][1]+=1
        elif(targetTest[cpt]==2):
            correcte[2] += 1
    
    cpt += 1


print('CLASSE            0      1      2   ')
print('-------------------------------------')
print('0     |           %.2d    %.2d      %.2d   '%(correcte[0],confusion[0][1],confusion[0][2]))
print('1     |           %.2d    %.2d      %.2d   '%(confusion[1][0],correcte[1],confusion[1][2]))
print('2     |           %.2d    %.2d      %.2d   '%(confusion[2][0],confusion[2][1],correcte[2]))

print('bonne classification %d'%(correcte[0]+correcte[1]+correcte[2]))
print('mauvaise classification %d'%(confusion[0][1]+confusion[0][2]+confusion[1][0]+confusion[1][2]+confusion[2][0]+confusion[2][1]))

#======================================================================================================================================

