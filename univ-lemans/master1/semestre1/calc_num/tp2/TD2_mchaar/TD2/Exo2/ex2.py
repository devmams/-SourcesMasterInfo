import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
from scipy.io import wavfile

###########################################
#             Méthode Signal              #
###########################################
def signal(t,frequence0,amplitude,k):
    return amplitude * np.sin(2. * np.pi *k* frequence0 * t)



def main():

    t = np.arange(0,1,0.01)
    f0=10 # Frèquence 10 Hz
    f0Modifie = 1000 # Frèquence modifié à 1000 Hz
    b=np.array([[1,0,1/3,0,1/5,0,1/7,0,1/9],[1,0,-1/9,0,1/25,0,-1/49,0,1/81],[1,-1/2,1/3,-1/4,1/5,-1/6,1/7,-1/8,1/9]])


    fe=8000 # frequence d'echantionnage
    D=1 # période d'observation
    N=int(D*fe)+1 # nombre de points
    te = np.linspace(0, 1, N) # Grille d'echantillonnage
    signal_name=("Signal Carré","Signal Triangulaire","Signal en Dent de Scie") # Noms des signaux à traiter

    ##########################
    # Parcours des signaux   #
    ##########################
    for signal_type,sig_name in zip(range(3),signal_name):
        k=1
        somme_signaux_reel,somme_signaux_modifie, somme_signaux_echantionne, somme_signaux_modifie_echantionne  = None, None, None, None
        for amplitude in b[signal_type,:]:
            # F0=10 Hz
            signal_reel=np.array(signal(t,f0,amplitude,k))
            signal_echantillonne=np.array(signal(te,f0,amplitude,k))

            signal_modifie=np.array(signal(t,f0Modifie,amplitude,k))
            signal_Modifie_echantillonne=np.array(signal(te,f0Modifie,amplitude,k))
            if somme_signaux_reel  is None:
                somme_signaux_reel  = signal_reel
                somme_signaux_echantionne = signal_echantillonne
                somme_signaux_modifie= signal_modifie
                somme_signaux_modifie_echantionne = signal_Modifie_echantillonne
            else:
                somme_signaux_reel += signal_reel
                somme_signaux_echantionne += signal_echantillonne
                somme_signaux_modifie += signal_modifie
                somme_signaux_modifie_echantionne += signal_Modifie_echantillonne

            k+=1

        signal_wav=np.tile(somme_signaux_reel,1313)
        wavfile.write(sig_name+'_10Hz_'+'.wav',fe,signal_wav)

        signal_wav_Modifie=np.tile(somme_signaux_modifie,1312)
        wavfile.write(sig_name+'_1000Hz_'+'.wav',fe,signal_wav_Modifie)

        plt.plot(t, somme_signaux_reel)
        plt.show()

        # ###############################
        # # Nom du signal et ses labels #
        # ###############################
        plt.figure(sig_name)
        plt.xlabel('temps (s)')
        plt.ylabel('amplitude (UA)')
        plt.grid(True)

        # ###########################
        # # signal et échantillonné #
        # ###########################
        plt.subplot(1, 2, 1)
        plt.title("Frèquence 10Hz")
        plt.plot(t,somme_signaux_reel,'b',label=u"Signal réel 10Hz")
        plt.stem(te,somme_signaux_echantionne, 'r', label = u"Signal echantillonné")

        # ####################################
        # # signal modifié et échantillonné  #
        # ####################################
        plt.subplot(1, 2, 2)
        plt.title("Frèquence 1000Hz")
        plt.plot(t,somme_signaux_modifie,'b',label=u"Signal réel 1000Hz")
        plt.stem(te,somme_signaux_modifie_echantionne, 'r', label = u"Signal echantillonné")

        # ##########################################
        # # Affichage et sauvegarde du signal  #
        # ##########################################
        plt.savefig(sig_name)
        plt.show()

        #################
        # Remarque:     #
        #################
        # La décomposition en série de Fourier peut être généralisée au cas des signaux non-périodiques. Dans ce cas, le signal est décomposé en une somme d’exponentielles complexes:
        # Formule mathématique sur la feuille de TD
        # où X(f) correspond à la transformée de Fourier du signal x(t).


###################
# Methode Main    #
###################
if __name__=="__main__":
    main()
