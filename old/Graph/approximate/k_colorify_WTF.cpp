#include<bits/stdc++.h>
using namespace std;
using ll=long long;
using uc=unsigned char;
const int k=3,Mx=10;
int m,n,_,cnt[Mx+5],vl[1<<20];double v[Mx+5][k],sm[Mx+5][k];
struct st{int a[k];int x,y;}b[1<<20];
uc a[1010][1010][k];
template<class A,class B> double dis(A x[],B y[]){
	double ans=0;
	for(int i=0;i<k;i++)ans+=pow(x[i]-y[i],2);
	return ans;
}
int main(){
	srand(clock()+time(0));
	scanf("P6\n%d%d\n255\n",&m,&n);
	for(int i=1;i<=n;i++)
		for(int j=1;j<=m;j++){
			fread(a[i][j],1,3,stdin);++_;
			for(int t=0;t<3;t++)b[_].a[t]=a[i][j][t];
			b[_].x=i,b[_].y=j;
		}
	for(int i=1;i<=Mx;i++){
		int p=rand()%_+1;
		for(int j=0;j<3;j++)v[i][j]=b[p].a[j];
	}
	for(int d=1;d<=100;d++){
		memset(sm,0,sizeof sm);
		memset(cnt,0,sizeof cnt);
		for(int i=1;i<=_;i++){
			double mn=1e9;vl[i]=0;
			for(int j=1;j<=Mx;j++)if(dis(v[j],b[i].a)<mn)
				mn=dis(v[j],b[i].a),vl[i]=j;
			for(int j=0;j<k;j++)sm[vl[i]][j]+=b[i].a[j];
			cnt[vl[i]]++;
		}
		for(int i=1;i<=Mx;i++)
			for(int j=0;j<k;j++)
				v[i][j]=sm[i][j]/cnt[i];
	}
	for(int i=1;i<=_;i++){
		double mn=1e9;int mp=0;
		for(int j=1;j<=Mx;j++)if(dis(v[j],b[i].a)<mn)
			mn=dis(v[j],b[i].a),mp=j;
		for(int j=0;j<k;j++)a[b[i].x][b[i].y][j]=v[mp][j]+.5;
	}
	printf("P6\n%d %d\n255\n",m,n);
	for(int i=1;i<=n;i++)
		for(int j=1;j<=m;j++)
			fwrite(a[i][j],1,3,stdout);
	return 0;
}
