import requests
import numpy as np
from pylab import *

######################
#Methode qui ajoute les biais a un ensemble de donnees
#@vect1       : tableau de biais
#@vect2       : tableau des donnees
######################
def ajoutBiais(vect1,vect2):

    result = np.array([ ( [0]* (len(vect2[0])+1) ) ]*len(vect2))

    i=0
    while(i < len(vect2)):
        result[i][0]=vect1[i]
        j=1
        while(j<len(result[i])):
            result[i][j] = vect2[i][j-1]
            j=j+1
        i=i+1

    return result

######################
#Methode qui transforme un tableau de string en tableau d'entier
#@data       : ensemble des donnees
######################
def convertTotabInt(data):

    result = np.array([([0]*len(data[0]))]*len(data))
    i=0
    while(i < len(data)):
        j=0
        while(j<len(data[i])):
            if(int(data[i,j]) == 0):
                result[i,j] = int(0)
            elif(int(data[i,j]) == 1):
                result[i,j] = int(1)
            else:
                result[i,j] = int(-1)

            j=j+1
        i=i+1
    return result


######################
#Methode qui multipli les donnees de la classe -1 par -1
#@data       : ensemble des donnees
######################
def inversionDonnee(data):
    i=0
    while(i < len(data)):
        if(data[i][0] == -1):
            j=1
            while(j<len(data[i])):
                r = data[i][j]*(-1)
                data[i][j] = r
                j=j+1
        i=i+1

######################
#Methode qui donne l'etiquette d'un element (1=rebulicain , -1=democrate)
#@element       : l'element dont on cherche l'etiquette
#@vecteurPoids  : le veceur poids
######################
def classify(element,vecteurPoids):

    result = sum(element * vecteurPoids)
    if(result >= 0.5):

        return 1

    return -1

######################
#Methode qui calcule le vecteur de poids
#@trainData       : les donnees a traité
#@vecteurPoids  : le veceur poids initiale
######################
def train(trainData,vecteurPoids,iteration_max,alpha):

    vecteurPoidsSup=vecteurPoids[:]#meilleur vecteur de poids si le systeme ne converge pas
    bonne_classification1 = 0 #compteur sur le nombre delement bien classe par le vectoire poid en cours de traitement
    bonne_classification2 = 0 #compteur sur le nombre delement bien classe par le meilleur vecteur poid rencontré

    iteration = 0 #compteur sur les iteration
    iteration_ok = False #boolean qui permet de savoir si le systeme a convergé pour une iteration
    while(iteration_ok == False and iteration < iteration_max):#tant que le systeme n'a pas convergé et que le nombre d'iteration < iteration_max
        print("iteration %i " % iteration)

        iteration_ok = True
        i=0
        while(i<len(trainData)):

            result = sum(trainData[i]*vecteurPoids)#le resultat de la multiplication vectorielle

            if(result < 0):#si element male classé

                '''
                si le vecteur de poid actuelle a permis de classé plus d'elements
                que le meilleur vecteur de poid precedant
                '''
                if(bonne_classification1 > bonne_classification2):
                    '''
                    alors on le definit comme nouveau meilleur vecteur de poid
                    '''
                    vecteurPoidsSup = vecteurPoids[:]
                    bonne_classification2 = bonne_classification1

                vecteurPoids = vecteurPoids + (alpha*trainData[i])
                iteration_ok = False
                bonne_classification1 = 0

            else :
                bonne_classification1 = bonne_classification1 + 1


            i=i+1
        iteration = iteration + 1

    if(iteration_ok == False):#si le systeme n'a pas converger
        return vecteurPoidsSup

    return vecteurPoids

######################
#Methode qui calcule le vecteur de poids
#@trainData       : les donnees a traité
#@vecteurPoids  : le veceur poids initiale
######################
def test(Data,vecteurPoids,target):

    #liste des classes predictes sur le corpus data
    predictedTarget =[]
    i=0
    while(i < len(Data)):#classification des donnees de Test

        predictedClass = classify(Data[i],vecteurPoids)
        predictedTarget.append(predictedClass)
        i = i +1

    predictedTarget = np.array(predictedTarget)

    cpt = 0.0
    i=0
    while(i < len(target)):#calcule du taux d'erreur sur le corpus de test

        if(target[i] != predictedTarget[i]):
            cpt = cpt + 1
        i = i+1

    taux_erreur = cpt/int(len(target))
    print("taux d'erreur = %f " %taux_erreur )
    return taux_erreur




#================================================================ MAIN ================================================================

print('============== Perceptron ============')

iteration_max = 50
# iteration_max = int(input("Entrer le nombremaximum d’iterations:"))
# alpha = float(input("Entrer la valeur du learning right :"))
alpha = 1

#----- chargement et melange des données
voting_records= requests.get('https://archive.ics.uci.edu/ml/machine-learning-databases/voting-records/house-votes-84.data')
voting_records = voting_records.text.replace('\n',',')
voting_records = voting_records.replace('republican','1')
voting_records = voting_records.replace('democrat','-1')
voting_records = voting_records.replace('y','1')
voting_records = voting_records.replace('n','-1')
voting_records = voting_records.replace('?','0')
voting_records = voting_records.split(',')
voting_records.pop()
voting_records = np.reshape(voting_records,(-1,17))


voting_records =convertTotabInt(voting_records)#tranformation de la matrice str en matrice de int


np.random.seed(987654321)
np.random.shuffle(voting_records)

'''
le systeme converge pour nb_elem_train <= 242
et en ne melangent pas les donnees de depart (mettre en commentaire np.random.shuffle(voting_records) )
'''
nb_elem_train = 335 #nombre d'element dans le corpus de train


recordsTarget = voting_records[:,0]#extraction des caracterisque du corpus globale
recordsData = voting_records[:,1:]#extraction des classes cible du corpus globale

trainData = recordsData[0:nb_elem_train,:]
trainTarget = recordsTarget[0:nb_elem_train]
trainData   = ajoutBiais(trainTarget,trainData)#ajout des biais sur le corpus de train
inversionDonnee(trainData)#inversion des signes sur le corpus de train

testData = recordsData[nb_elem_train:435,:]
testTarget = recordsTarget[nb_elem_train:435]
testData   = ajoutBiais([1]*len(testData),testData)#ajout des biais sur le corpus de test

#vecteur de poids initiale
vecteurPoids=np.array([1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])

#cacule du meilleur vecteur de poid
#vecteurPoids = train(trainData,vecteurPoids,iteration_max,alpha)

#==========================Classification des elements de test ============================
#test(testData,vecteurPoids,testTarget)


tabIteration =[]
tabTauxErreur =[]

i=0
while(i < 3000):
    tabIteration.append(i)
    #cacule du meilleur vecteur de poid
    vecteurPoids = train(trainData,vecteurPoids,i,alpha)
    tabTauxErreur.append(test(testData,vecteurPoids,testTarget))

    i=i+10

print(tabIteration)
print(tabTauxErreur)

#plot(tabIteration, tabTauxErreur, 'ro',color = 'b')
plot(tabIteration, tabTauxErreur)
#plot(x2, y2,'ro',color = 'y')

#plot(0, 3,'ro',marker='s',color = 'r')
axis([0,3000,0.0,0.1])
grid()
show()
