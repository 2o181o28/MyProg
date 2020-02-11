#!/usr/bin/env python3
a=b=c=0

def dfs(d):
	global a,b,c
	if d>n: return 1
	res=0
	for i in range(1,n+1):
		if not(a>>i&1 | b>>i+d&1 | c>>i+n-d&1):
			a|=1<<i;b|=1<<i+d;c|=1<<i+n-d
			res+=dfs(d+1)
			a^=1<<i;b^=1<<i+d;c^=1<<i+n-d
	return res

n=int(input())
print(dfs(1))
