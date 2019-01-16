# var = list(range(10))
# print(type(var))
# var = "informatique"
# print(type(var))
# var = {"info":3, "math":5, "musique":10, "foot":7}
# print(type(var))
# print(var['math'])


f = open("text.txt","r",encoding="utf8")
for ligne in f:
    print(ligne)
f = open("text.txt","w",encoding="utf8")
f.write("M1 : premiere annez de master")
f.close()
