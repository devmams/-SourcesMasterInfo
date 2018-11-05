import numpy as np
from pylab import *



x = [17.3,7.7,10.4,5.1,5,56.9,79.7,3.5,57.8,124,15.1,4.3,39,8.7,6.9,57.7,252.7]
y = [327.4,179.5,279.4,139.1,92.5,926.7,2186.3,96.8,523.9,935.9,444.2,119.7,300.7,201.9,194.7,1592.9,5142.2]

#X = np.vstack((x,y))
X1=np.asarray(x)
Y1=np.asarray(y)
xmean  = X1.mean()
ymean = Y1.mean()

accu = 0
var=0
for i in range(0,len(X1)):
    accu = accu + (X1[i] - xmean )*(Y1[i] - ymean ) # - xmean)(Y1[i]-ymean) )
    var  = var+(X1[i]-xmean)**2

print(accu)
print(var)

B1 = accu/var
print(B1)
B0 = ymean-B1*xmean
print(B0)

yestime = (X1*B1 + B0)
print(yestime)

SCE = 0
SCR = 0
for i in range(0,len(X1)):
	SCE = SCE + (yestime[i]-ymean)**2
	SCR = SCR + (yestime[i]-Y1[i])**2

SCT = SCE + SCR

print(SCE/SCT)

#x1 = [2,1,2, 1]
#y1 = [2,2,-2,-2]

#x2 = [4,6,6,6]
#y2 = [0,0,1,-1]

'''
plot(x, y, 'ro',color = 'b')   # modif
plot(x, yestime)
#plot(x2, y2,'ro',color = 'y')

#plot(0, 3,'ro',marker='s',color = 'r')
axis([0,300,0,6000])
grid()          
show()
'''
#print(np.cov(X1,Y1))
'''
resulte = np.cov(X)/varX
print("B1 = ",resulte)
'''