from sklearn import datasets
import numpy as np
import math


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
    dim3=0.0
    dim4=0.0
    taille = 0
    i=0
    while i < len(matrice):
        if target[i] == classe :
            dim1 += matrice[i,0]
            dim2 += matrice[i,1]
            dim3 += matrice[i,2]
            dim4 += matrice[i,3]
            
            taille += 1
        i += 1
    
    dim1 = dim1/taille
    dim2 = dim2/taille    dim3 = dim3/taille
    dim4 = dim4/taille

    return [dim1,dim2,dim3,dim4]




######################
#Methode qui permet de calculer la variance pour chaque caracteristique de chaque classe
#@matrice : la matrice contenant les valeurs des caracteristiques
#@target  : le tableau qui garde la reference entre les lignes  de la matrice et la classe correspondante
#@y       : la moyenne(esperance) a utiliser pour le calcule  de la variance
#@classe  : la classe dont on veu le vecteur moyen (esperance)
#@att     : l'indice de la caracteristique dans la matrice sur la quelle porte le calcule de la variance
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
#Methode qui permet de calculer la covariance entre deux caractères d'une classe
#@matrice : la matrice contenant les valeurs des caracteristiques
#@target  : le tableau qui garde la reference entre les lignes  de la matrice et la classe correspondante
#@y       : la moyenne(esperance) a utiliser pour le calcule  de la variance
#@classe  : la classe dont on veu le vecteur moyen (esperance)
#@att     : l'indice de la caracteristique dans la matrice sur la quelle porte le calcule de la variance
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
#Methode qui permet de calculer la matrice variance-covariance sur deux caracteristique d'une classe
#@matrice : la matrice contenant les valeurs des caracteristiques
#@target  : le tableau qui garde la reference entre les lignes  de la matrice et la classe correspondante
#@y1      : la moyenne(esperance) a utiliser pour la premiere caracteristique
#@y2      : la moyenne(esperance) a utiliser pour la deuxieme caracteristique
#@classe  : la classe sur la qu'elle porte le calcule
#@att1    : l'indice de la caracteristique 1 dans le vecteur des caractéristique
#@att2    : l'indice de la caracteristique 2 dans le vecteur des caractéristique
######################
def covariance(matrice,target,y1,y2,classe,att1,att2):
    i=0
    taille = 0
    cov=0
    while i < len(matrice):
        if target[i] == classe :
            cov += (matrice[i,att1]-y1)+(matrice[i,att2]-y2)
            taille += 1
        i += 1
    
    return cov/taille


######################
#Methode qui permet de calculer la probabiliter pour une valeur en utilisant une loi gossien
#@x       : le valeur dont on veut calculer la probabilité
#@moyenne : la moyenne a utiliser pour cette attribut
#@variance: la variance
######################
def probabilite(x, moyenne, variance):
    exponent = math.exp(-(math.pow(x-moyenne,2)/(2*math.pow(variance,2))))
    return (1 / (math.sqrt(2*math.pi) * variance)) * exponent

######################
#Methode qui renvoi la classe la plus approprier a un element
#
######################
def classifieur(element,att1,att2, classe0,classe1,classe2,appriorie):
    probClasse0 = appriorie[0] * probabilite(element[att1], classe0[0][att1], classe0[1][att1]) * probabilite(element[att2], classe0[0][att2], classe0[1][att2])
    probClasse1 = appriorie[1] * probabilite(element[att1], classe1[0][att1], classe1[1][att1]) * probabilite(element[att2], classe1[0][att2], classe1[1][att2])
    probClasse2 = appriorie[2] * probabilite(element[att1], classe2[0][att1], classe2[1][att1]) * probabilite(element[att2], classe2[0][att2], classe2[1][att2])

    if(probClasse0 > probClasse1 and probClasse0>probClasse2):
        return 0
    if(probClasse1 > probClasse0 and probClasse1>probClasse2):
        return 1
    return 2




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


#----- divion des données
#donnees apprentissage <- 100 premiers exemples
donneesApp = shuffledIrisData[0:100,:]
targetApp  = shuffledIrisTarget[0:100]
#print("----------------------------------")
#print(donneesApp)
#rint(targetApp)

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


#----------------- Calcule des paramètres du classieur Bayésien

#----- Calcule des vecteurs moyen

#vecteurMoyen = [Esperance Long Pet,Esperance Lar Pet, Esperance Lon Sep,Esperance Lar Set ]

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
varianceLonPet0 = variance(donneesApp,targetApp,vecteurMoyen0[0],0,0)
varianceLarPet0 = variance(donneesApp,targetApp,vecteurMoyen0[1],0,1)
varianceLonSep0 = variance(donneesApp,targetApp,vecteurMoyen0[2],0,2)
varianceLarSet0 = variance(donneesApp,targetApp,vecteurMoyen0[3],0,3)
variance0=[varianceLonPet0,varianceLarPet0,varianceLonSep0,varianceLarSet0]

#---classe 1
varianceLonPet1 = variance(donneesApp,targetApp,vecteurMoyen1[0],1,0)
varianceLarPet1 = variance(donneesApp,targetApp,vecteurMoyen1[1],1,1)
varianceLonSep1 = variance(donneesApp,targetApp,vecteurMoyen1[2],1,2)
varianceLarSet1 = variance(donneesApp,targetApp,vecteurMoyen1[3],1,3)
variance1=[varianceLonPet1,varianceLarPet1,varianceLonSep1,varianceLarSet1]

#---classe 2
varianceLonPet2 = variance(donneesApp,targetApp,vecteurMoyen2[0],2,0)
varianceLarPet2 = variance(donneesApp,targetApp,vecteurMoyen2[1],2,1)
varianceLonSep2 = variance(donneesApp,targetApp,vecteurMoyen2[2],2,2)
varianceLarSet2 = variance(donneesApp,targetApp,vecteurMoyen2[3],2,3)
variance2=[varianceLonPet2,varianceLarPet2,varianceLonSep2,varianceLarSet2]

#----- Calcule des matrices de variance-covariance

#----- Calcule des proba à priori
Ppriorie0 = probPriorie(targetApp,0)
Ppriorie1 = probPriorie(targetApp,1)
Ppriorie2 = probPriorie(targetApp,2)

print("prob a priori classe 0 :",Ppriorie0)
print("prob a priori classe 1 :",Ppriorie1)
print("prob a priori classe 2 :",Ppriorie2)



print('CLASSE    ESPERANCE(longueur petale)   VARIANCE(longueur petale) ESPERANCE(largeur petale)   VARIANCE(largeur petale)')

print ("  0       %.4f                        %.4f                     %.4f                         %.4f  " % (vecteurMoyen0[0],varianceLonPet0,vecteurMoyen0[1],varianceLarPet0))
print ("  1       %.4f                        %.4f                     %.4f                         %.4f  " % (vecteurMoyen1[0],varianceLonPet1,vecteurMoyen1[1],varianceLarPet1))
print ("  2       %.4f                        %.4f                     %.4f                         %.4f  " % (vecteurMoyen2[0],varianceLonPet2,vecteurMoyen2[1],varianceLarPet2))

print('-----------------------------------------------------------------------------------------------------------------------------------------------------------')


print('CLASSE    ESPERANCE(longueur setale)   VARIANCE(longueur setale) ESPERANCE(largeur setale)   VARIANCE(largeur setale)')
print ("  0       %.4f                        %.4f                     %.4f                         %.4f  " % (vecteurMoyen0[2],varianceLonSep0,vecteurMoyen0[3],varianceLarSet0))
print ("  1       %.4f                        %.4f                     %.4f                         %.4f  " % (vecteurMoyen1[2],varianceLonSep1,vecteurMoyen1[3],varianceLarSet1))
print ("  2       %.4f                        %.4f                     %.4f                         %.4f  " % (vecteurMoyen2[2],varianceLonSep2,vecteurMoyen2[3],varianceLarSet2))



#----------------- MAIN -----------------------------------------------------------------------------------

print('============== CLASSIFIEUR BAYESIEN ============')

print(" 1- longueur petale")
print(" 2- longueur setale")
print(" 3- largeur  petale")
print(" 4- largeur  setale")

c1 = int(input("choisisser la 1er caracteristique :"))
c2 = int(input("choisisser la 2em caracteristique :"))

c1 = c1-1
c2 = c2-1

cpt = 0
while(cpt < len(donneesDev)):
    print(donneesDev[cpt] , ' classe : ',classifieur(donneesDev[cpt],c1,c2, [vecteurMoyen0,variance0],
                                                                            [vecteurMoyen1,variance1],
                                                                            [vecteurMoyen2,variance2],
                                                                            [Ppriorie0,Ppriorie1,Ppriorie2]))

    cpt += 1

print(targetDev)


targetF =[]
cpt = 0
while(cpt < len(donneesDev)):
    targetF.append(classifieur(donneesDev[cpt],c1,c2, [vecteurMoyen0,variance0],
                                                     [vecteurMoyen1,variance1],
                                                     [vecteurMoyen2,variance2],
                                                     [Ppriorie0,Ppriorie1,Ppriorie2]))
                                                     
    cpt += 1

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

#-----------------------TEST--------------------


cpt = 0
while(cpt < len(donneesTest)):
    print(donneesTest[cpt] , ' classe : ',classifieur(donneesTest[cpt],0,2, [vecteurMoyen0,variance0],
                                                     [vecteurMoyen1,variance1],
                                                     [vecteurMoyen2,variance2],
                                                     [Ppriorie0,Ppriorie1,Ppriorie2]))
                                                     
    cpt += 1

print(targetDev)


targetE =[]
cpt = 0
while(cpt < len(donneesTest)):
    targetE.append(classifieur(donneesTest[cpt],0,2, [vecteurMoyen0,variance0],
                               [vecteurMoyen1,variance1],
                               [vecteurMoyen2,variance2],
                               [Ppriorie0,Ppriorie1,Ppriorie2]))
                               
    cpt += 1


correcte=[0,0,0]
confusion=[[0,0,0],[0,0,0],[0,0,0]]
cpt = 0
while(cpt < len(targetE)):
    
    if(targetE[cpt]==0):
        if(targetTest[cpt]==0):
            correcte[0] += 1
        elif(targetTest[cpt]==1):
            confusion[0][1]+=1
        elif(targetTest[cpt]==2):
            confusion[0][2]+=1
    
    elif(targetE[cpt]==1):
        if(targetTest[cpt]==0):
            confusion[1][0]+=1
        elif(targetTest[cpt]==1):
            correcte[1] += 1
        elif(targetTest[cpt]==2):
            confusion[1][2]+=1
    
    elif(targetE[cpt]==2):
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





