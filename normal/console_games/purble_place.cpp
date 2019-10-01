#include<bits/stdc++.h>
using namespace std;
using ll=long long;
using pa=pair<int,int>;
const int n=6;
int a[10],b[10],ca[10],cb[10],mp[10][10];
basic_string<int> st,t;
void dcd(int x,int *a){
	for(int t=1;t<=n;t++)a[t]=x%n+1,x/=n;
}
pa clc(int i,int j){
	int c1=0,c2=0;
	dcd(i,a);dcd(j,b);
	memset(ca,0,sizeof ca);
	memset(cb,0,sizeof cb);
	for(int k=1;k<=n;k++){
		if(a[k]==b[k])c1++;
		ca[a[k]]++,cb[b[k]]++;
	}
	for(int k=1;k<=n;k++)c2+=min(ca[k],cb[k]);
	return {c1,c2-c1};
}
int main(){
	for(int i=0;i<int(pow(n,n)+.5);i++)st+=i;
	while(st.size()>1){
		double mn=1e18;int Mp;
		for(int i:st){
			double tot=0;
			memset(mp,0,sizeof mp);
			for(int j:st){
				auto [x,y]=clc(i,j);
				mp[x][y]++;
			}
			for(int i=0;i<=n;i++)for(int j=0;j<=n;j++)if(mp[i][j]){
				double p=mp[i][j]*1./st.size();
				tot+=p*log(p);
			}
			if(tot<mn)mn=tot,Mp=i;
		}
		dcd(Mp,a);
		for(int i=1;i<=n;i++)printf("%d ",a[i]);
		puts("");t={};
		int x,y;scanf("%d%d",&x,&y);
		for(int i:st){
			auto [a,b]=clc(Mp,i);
			if(a==x&&b==y)t+=i;
		}
		st=t;
	}
	dcd(st[0],a);
	for(int i=1;i<=n;i++)printf("%d ",a[i]);
	puts("");
	return 0;
}
