#include<cstdio> 
#include<algorithm>
#include<sstream>
#include<iostream>
using namespace std;
struct elem{
	char s[2];
	int m,k,val[10];
}e[120];
int n,i,j,M,q[120],nm[120],v[120];
char buf[200];
void print(int k){
	int i,p[120],s=0,g=nm[1];
	for(i=1;i<=k;i++){
		p[i]=i,s+=v[i]*nm[i];
		if(i>1)g=__gcd(g,nm[i]);
	}
	if(s||g>1)return;
	sort(p+1,p+1+k,[&](int x,int y){
		int a=v[x],b=v[y];
		return b<0&&a>0 || a*b>0&&abs(a)<abs(b);
	});
	for(i=1;i<=k;i++){
		int x=p[i];
		if(nm[x]==1)
			printf(e[q[x]].s);
			else printf("%s%d",e[q[x]].s,nm[x]);
	}
	puts("");
}
void dfs(int dep,int s,int now){
	if(now>M||dep==5)return;
	if(s>n){
		if(now==M)print(dep-1);
		return;
	}
	dfs(dep,s+1,now);
	elem &a=e[s];
	for(int i=1;i<=(M-now)/a.m;i++)
		for(int j=1;j<=a.k;j++){
			q[dep]=s;nm[dep]=i;v[dep]=a.val[j];
			dfs(dep+1,s+1,now+a.m*i);
		}
}
int main(){
	gets(buf);
	sscanf(buf,"%d",&n);
	for(i=1;i<=n;i++){
		gets(buf);
		stringstream s(buf);
		elem &a=e[i];
		s>>a.s>>a.m;
		while(s>>a.val[++a.k]);
		--a.k;
	}
	scanf("%d",&M);
	dfs(1,1,0);
	system("pause");
	return 0;
}
