#!/usr/bin/env python3
import sys

def A(k,x1,x2,x3,x4,x5):
	def B():
		nonlocal k
		k-=1
		return A(k,B,x1,x2,x3,x4)
	if k<=0: return x4()+x5()
	return B()
	
sys.setrecursionlimit(1000000)
print(A(10,lambda:1,lambda:-1,lambda:-1,lambda:1,lambda:0))
