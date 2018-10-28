#include<cstdio>
int b=1000,c=200,d=0,e,f,i=0,N,a[1000010];
int main()
{
	scanf("%d",&N),N=N*10/3+20;
	while(i<N)a[i++]=c;
	for(;(N-=10)>0;printf("%03d",d+=(c+=e/b)/b),d=c%b,c=e%b)
		for(e=0,i=N;--i;a[i]=(e+=a[i]*b)%(f=i*2+1),e=e/f*i);
	return 0;
}
