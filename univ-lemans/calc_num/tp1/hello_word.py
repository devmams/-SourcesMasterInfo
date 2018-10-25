# f = open("synpaflex-pronunciation-dictionary.txt","r",encoding="utf8")
# numLigne = input("entrez le numero de ligne ")
# for i in range(int(numLigne)):
#     res = f.readline()
#     print(res.strip("\n"))
# f.close()

def AfficherLigne(line):
    print(line.strip("\n"))

def StockerLigne(line, dictPron):
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
    # print(mot)
    val = val.strip("\n")
    # print(val)
    dictPron[mot] = val
    print(dictPron)

def main():
    f = open("synpaflex-pronunciation-dictionary.txt","r",encoding="utf8")
    numLigne = input("entrez le numero de ligne ")
    for i in range(int(numLigne)):
        res = f.readline()
        # print(res.strip("\n"))
    dictPron = dict()
    preLigne = f.readline()
    # AfficherLigne(preLigne)
    StockerLigne(res, dictPron)

    f.close()

if __name__ == "__main__":
    main()
