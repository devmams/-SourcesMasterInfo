import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
from numpy.fft import fft
###########################################
#             Méthode Signal              #
###########################################
def signal(t,frequence0,amplitude,k): 
    return amplitude * np.sin(2. * np.pi *k* frequence0 * t)



def main():
    t = np.arange(0,1,0.01)
    f0=120 # Frèquence 120 Hz
    b=np.array([1,0,1/3,0,1/5,0,1/7,0,1/9])

    fe=8000 # frequence d'echationnage
    D=1 # période d'observation
    N=int(D*fe)+1 # nombre de points   
    te = np.linspace(0, 1, N) # Grille d'echantillonnage
    F=1/t
    ##########################
    # Parcours des signaux   #
    ##########################
    k=1
    for amplitude in b:
        # F0=120 Hz
        signal_reel=np.array(signal(t,f0,amplitude,k))   
        signal_echantillonne=np.array(signal(te,f0,amplitude,k))
        X = fft(np.array(signal(t,f0,amplitude,k)))
        Xe = fft(np.array(signal(te,f0,amplitude,k)))
        k+=1


    print("X= ",X)
    ###############################
    # Nom du signal et ses labels #
    ###############################
    plt.figure("Signal Carré")
    plt.xlabel('temps (s)')
    plt.ylabel('amplitude (UA)')
    plt.grid(True)
    
    ###########################
    # signal et échantillonné #
    ###########################
    plt.title("Frèquence 120Hz")

    #plt.plot(t,signal_reel,'b',label=u"Signal réel 120Hz")
    #plt.stem(te,signal_echantillonne, 'r', label = u"Signal echantillonné")
    plt.plot(t,signal_reel,'b',label=u"Signal réel 120Hz")
    #plt.plot(te,Xe, 'r', label = u"Signal echantillonné")
    ##########################################
    # Affichage et sauvegarde du signal  #
    ##########################################
    #plt.savefig("signal_caree")
    plt.show()
    

    ##################
    #   Question 3:  #
    ##################
    #
    #   On remarque que FFT s'annule sur deux valeur de t
    #

    ##################
    #   Question 4:  #
    ##################
    # X=0 if Fe in [0-1/0.13[ OR ]1/0.13-1/0.86[ OR ]1/0.86-1]
    # X=177.084 if Fe=1/0.13 OR Fe=1/0.86
    
    ##################
    #   Question 5:  #
    ##################
    module=np.abs(X)
    puissance=np.abs(X)**2
    phase=np.angle(X)
    plt.subplot(1, 2, 1)
    plt.title("Module de FFT ")
    #plt.plot(F,module,'b')
    plt.subplot(1, 2, 2)
    plt.title("Phase de FFT")
    #plt.plot(F,phase,'r')
    plt.grid(True)
   # plt.show()
###################
# Methode Main    #
###################
if __name__=="__main__":
    main()