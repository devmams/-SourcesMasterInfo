from sklearn import datasets
import numpy as np

######################
#
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

    return [dim1,dim2]

######################
#
######################
def variance(matrice,target,y,classe,att):
    i=0
    taille = 0
    var=0
    while i < len(matrice):
        if target[i] == classe :
            var += (matrice[i,att]-y)**2
            taille += 1
        i += 1

    return var/taille

######################
#
######################
def covariance(matrice,target,x,y,classe,att1,att2):
    i=0
    taille = 0
    cov=0
    while i < len(matrice):
        if target[i] == classe :
            cov += (matrice[i,att1]-x)+(matrice[i,att2]-y)
            taille += 1
        i += 1

    return cov/taille

######################
#
######################
def matriceVarianceCovariance(matrice,target,classe):
    
    vecMoyen = vecteurMoyen(matrice,target,classe)
    
    var1 = variance(matrice,target,vecMoyen[0],classe,0)
    var2 = variance(matrice,target,vecMoyen[1],classe,1)
    cov1 = covariance(matrice,target,var1,var2,classe,0,1)
    cov2 = covariance(matrice,target,var2,var1,classe,1,0)
    
    return [[var1,cov1],[cov2,var2]]


irisData = datasets.load_iris()
#print(irisData.data)
#print(irisData.target)

CirisData = np.c_[irisData.data.reshape(len(irisData.data),-1),irisData.target.reshape(len(irisData.target),-1)]
np.random.seed(987654321)
np.random.shuffle(CirisData)
shuffledIrisData = CirisData[ :, :irisData.data.size//len(irisData.data)].reshape(irisData.data.shape)
shuffledIrisTarget = CirisData[ :, irisData.data.size//len(irisData.data) :].reshape(irisData.target.shape)
#print(shuffledIrisData)
#print(shuffledIrisTarget)

#----- division des données
#donnees apprentissage <- 100 premiers exemples
donneesApp = shuffledIrisData[0:100,:]
targetApp  = shuffledIrisTarget[0:100]
#print("----------------------------------")
print(donneesApp)
print(targetApp)

#donnees dev <- 30 exemples suivants
donneesDev = shuffledIrisData[100:130,:]
targetDev  = shuffledIrisTarget[100:130]
#print("----------------------------------")
#print(donneesDev)
#print(targetDev)

#donnees test <- 20 derniers exemples
donneesTest = shuffledIrisData[130:150,:]
targetTest  = shuffledIrisTarget[130:150]
#print("----------------------------------")
#print(donneesTest)
#print(targetTest)

#----------------- Calcule des paramètres du classieur Bayésien(on travail sur les deux premières dimenssions)

#----- Calcule des vecteurs moyen

#---classe 0
vecteurMoyen0 = vecteurMoyen(donneesApp[:,0:2],targetApp,0)
print(vecteurMoyen0)

#---classe 1
vecteurMoyen1 = vecteurMoyen(donneesApp[:,0:2],targetApp,1)
print(vecteurMoyen1)

#---classe 2
vecteurMoyen2 = vecteurMoyen(donneesApp[:,0:2],targetApp,2)
print(vecteurMoyen2)

#----- calcule de la matrice variance covariance


#---classe 0
varCov0 = matriceVarianceCovariance(donneesApp[:,0:2],targetApp,0)
print(varCov0)

#---classe 1
varCov1 = matriceVarianceCovariance(donneesApp[:,0:2],targetApp,1)
print(varCov1)

#---classe 2
varCov2 = matriceVarianceCovariance(donneesApp[:,0:2],targetApp,2)
print(varCov2)









