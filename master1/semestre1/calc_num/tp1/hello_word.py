def AfficherLigne(line):
    print(line.strip("\n"))

def StockerLigne(line, dicPron):
    mot = ""
    val = ""
    i = 0
    while(line[i] != ';'):
        mot += line[i]
        i += 1;
    while(line[i+1] != ';'):
        i += 1;
    i += 2
    while(i+1 != len(line)):
        val += line[i+1]
        i += 1;
    dicPron[mot] = val.strip("\n")

def AfficherPron(m, dicPron):
    print(dicPron.get(m))

def AfficherMots(p, dicPron):
    liste = []
    for mot,pron in dicPron.items():
        if pron == p:
            liste.append(mot)
    print("il y a ",len(liste)," mot(s) de prononciation ","/",p,"/ qui sont :")
    for mot in liste:
        print(mot)

def main():
    f = open("synpaflex-pronunciation-dictionary.txt","r",encoding="utf8")
    lignes = f.readlines()
    dicPron = dict()
    for ligne in lignes:
        StockerLigne(ligne, dicPron)
    AfficherMots('k u l e',dicPron)
    AfficherMots('a b ɛ s ɛ',dicPron)
    f.close()

if __name__ == "__main__":
    main()
