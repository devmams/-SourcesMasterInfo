# exo 1
# ---- question 1 ----
# f(x) = x^2 + (x/3)
# F(x) = ((x^3)/3) + ((1/6)x^2)
# integrale(f(x)) sur [0,1] = 0.5

# ---- question 2 ----
# f(x) = 3x * ln(x)
# integrale(f(x)) sur [1,e] = 3/4(1+e^2)


# ---- question 3 ----
import matplotlib.pyplot as plt
# from math import *
import numpy as np

def f(x):
    return 1/(np.sqrt(1+x**2))

n = 50
x = np.linspace(0,1,n)
y = []
for i in range(n):
    y.append(f(x[i]))
# plt.scatter(x,y)
# plt.plot(x,y)
# plt.show()

# ---- question 4 ----
def rect(f,n):
    R=0
    t=0
    h=1/n
    while t<1: #on arrive à h
        R = R+h*f(t)
        t=t+h
    return R

int_rect = rect(f,n)
print("int_rect : ", int_rect)
# n = 10 => 0.9664342616115564
# n = 50 => 0.8813613159092119
# n = 100 => 0.8828351068316722

# ---- question 5 ----
int_trap = np.trapz(y,x)
print("int_trap : ", int_trap)
# n = 10 => 0.8810097931823315
# n = 50 => 0.8813613159092119
# n = 100 => 0.8813705809160716

# ---- question 6 ----
def simps(f,n):
    S=0
    h=1/n
    L=np.linspace(0,1,n, endpoint=False) #sans le dernier element
    for t in L:
        S=S+(f(t)+4*f(t+h/2)+f(t+h))*h/6
    return S
int_simp = rect(f,n)
print("int_simp : ", int_rect)
# n = 10 => 0.9664342616115564
# n = 50 => 0.8842907340357443
# n = 100 => 0.8828351068316722
