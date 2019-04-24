def dfs(d):
	if d>n: return 1
	res=0
	for i in range(1,n+1):
		if (a[i]==0) and (b[i+d]==0) and (c[i+n-d]==0):
			a[i]=b[i+d]=c[i+n-d]=1
			res+=dfs(d+1)
			a[i]=b[i+d]=c[i+n-d]=0
	return res

n=int(input())
a=[0]*(2*n+1)
b=[0]*(2*n+1)
c=[0]*(2*n+1)
print(dfs(1))
