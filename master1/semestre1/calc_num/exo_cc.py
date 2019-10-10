import numpy as np
import math
import numpy.random as nrd
# import matplotlib.pyplot as plt

# A = np.arange(0,100,3)
# print(A)
#
# A = np.array(np.arange(0,100,3)).reshape(2,17)
# print(A.dtype)
#
# B=np.array(np.sin((A**2)*(np.pi/12)))
# print(B)
#
# test = np.array([0,0,0,0,0,1,2,3,5])
# print(test)
# BMax = B.max()
# print(BMax)
#
# res = list(B).count(BMax)
# # res = list(test).count(0)
# print(res)

A = np.ones((12,12))
print(A)
A[0:6,0:6]=0
print(A)

A[:,4:8]=2
print(A)

A[0:1,:]*=10
# print(A.put(A[:,6:10],A[0:1,:]))
A[:,6:10]=np.sqrt(A[0:1,:].reshape(12,1).copy())
print(A)
