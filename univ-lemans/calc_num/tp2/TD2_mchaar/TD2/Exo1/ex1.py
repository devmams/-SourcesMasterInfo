import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile
import os

###########################################
#             Méthode Signal              #
###########################################
def signal(t,frequence0,amplitude,phase):
    return amplitude * np.sin(2. * np.pi * frequence0 * t+phase)

#######################################
#                 Main                #
#######################################

def main():
    ########################## Questions 1, 2 et 3 ###################################
    n = np.arange(100) #  Création d'un vecteur n contenant des entiers allant de 0 à 99
    print("le type de n: ",type(n),"\nle type des éléments de n: ",n.dtype,"\nles dimentions de n: ", n.ndim)
    t=(n.copy())/100  # Création d'un nouveau vecteur t égal à n
    t=np.arange(0,1,0.011) # Commande permettant de créer t directement sans passer par n
    print('[n]= ',n,'\n') # Valeurs de n
    print('[t]= ',t) # Valeurs de t
    print("l'index de t correspondant à la valeur de 50 ms: ",np.where(t==0.05))
    ########################### Questions 4, 5 et 6 ##################################
    amplitude=1.5 # amplitude
    phase=0 # phase
    f0=300 # frequence
    fe=1000 # frequence d'echationnage
    D=1 # période d'observation
    N=int(D*fe)+1 # nombre de points

    te = np.linspace(0, 1, N) # Grille d'echantillonnage
    #te1=te[5:16] # te entre 50 ms et 150 ms. Remarque:plus qu'on augmente fe plus le signal se decale vers la gauche
    te1 = np.linspace(0.05, 0.15, N) # te entre 50 ms et 150 ms. Remarque: Intuitivement, nous pouvons penser qu’une bonne restitution du signal nécessite une fréquence d’échantillonnage élevée.
    t1=t[5:16] # t1 entre 50 ms et 150 ms.
    print("[te]= ",te) # Valeurs de te
    ####################################################
    #            Trace du Signal                       #
    ####################################################
    plt.title('exercice 1 Question 5')
    plt.xlabel('temps (s)')
    plt.ylabel('amplitude (UA)')
    plt.plot(t, signal(t,f0,amplitude,phase), 'b', label = u"Signal reel")
    plt.stem(te, signal(te,f0,amplitude,phase), 'r', label = u"Signal echantillonné")
    plt.plot(t1, signal(t1,f0,amplitude,phase), 'y', label = u"Signal reel[50-150]ms")
    plt.stem(te1, signal(te1,f0,amplitude,phase), 'gray', label = u"Signal echantillonné[50-150]ms")
    plt.grid()
    plt.legend()
    plt.show()

    ##########################################################################################################################################
    # Question 6: Intuitivement, nous pouvons penser qu’une bonne restitution du signal nécessite une fréquence d’échantillonnage élevée.    #
    ##########################################################################################################################################

    ##############################################################
    #                   Question 7:                              #
    ##############################################################
    # N° #  Fe  #   F0    # Période T0 réelle #  Période mesurée #
    ##############################################################
    # 1  #1000Hz#   10Hz  #        0.1 s      #      0.1 s       #
    # 2  #1000Hz#   300Hz #        0.004 s   #      0.005        #
    # 3  #1000Hz#   500Hz #        0.002 s    #       -          #
    # 4  #1000Hz#   900Hz #        0.0011 s   #     0.007 s      #
    ##############################################################
    # Que remarquez-vous ?
    # Lorsque Fe = 2f0, l’échantillonnage n’est plus capable de capturer la fréquence de la sinusoïde. (https://www.youtube.com/watch?v=jQDjJRYmeWg)
    # Lorsque Fe < 2f0, on parle de repliement du spectre (aliasing). (https://www.youtube.com/watch?v=jHS9JGkEOmA)

    # Question 8:

    f_name=("Signal1.wav","Signal2.wav","Signal3.wav")
    f=(300,500,900)

    for fichier_name,f0 in zip(f_name,f):
            print(fichier_name,f0)
            signal_wav=signal(t,f0,amplitude,phase)
            signal_wav=np.tile(signal_wav,1313)
            wavfile.write(fichier_name,fe,signal_wav)
    #Remarque importante:
    #Les résultats de ces observations sont fondamentaux pour le traitement du signal. Le théorème de Shannon formalise la condition permettant d’échantillonner correctement un signal.
    #Fe > 2fmax
    #La fréquence la plus élevée que l’oreille peut entendre est d’environ 20 kHz. C’est pour cela que la
    #fréquence d’échantillonnage utilisée pour les supports audio numérique est généralement de 44.1 kHz.
if __name__=="__main__":
	main()
