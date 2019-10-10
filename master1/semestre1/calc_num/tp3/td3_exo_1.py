import numpy.random as nr
import numpy as np
import matplotlib.pyplot as plt
N = 10000
x = []
# for i in range(N):
#     e = nr.uniform(0,9);
#     x.append(e)
# print(x)
# x = nr.uniform(0,9,N)
x = np.linspace(0,9,N)
print(x)
# ---------- question 3 ------------
y_uni = nr.uniform(0,10,N)
y_uni.sort()
x.sort()
# plt.plot(x,y_uni)
# plt.show()
# plt.hist(y_uni,20)
# plt.show()
# ---------- question 5 ------------
y_norm = nr.normal(4,1.5,N)
# print(y_norm)
y_norm.sort()
# plt.plot(x,y_norm)
# plt.show()
# plt.hist(y_norm,20)
# plt.show()

# ----------question 6 ------------
y_tri = nr.triangular(0,4,9,N)
# print(y_tri)
y_tri.sort()
# plt.plot(x,y_tri)
# plt.show()
# plt.hist(y_tri,20)
# plt.show()

# ------- expo ---------
y_exp = nr.exponential(4,N)
# print(y_exp)
y_exp.sort()
# plt.plot(x,y_exp)
# plt.show()
# plt.hist(y_exp,20)
# plt.show()

# ---------- question 7 ------------


# ---------- question 8 ------------
plt.plot(x,y_uni)
plt.plot(x,y_norm)
plt.plot(x,y_tri)
plt.plot(x,y_exp)
plt.show()
