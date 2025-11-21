// FMM solution to https://www.luogu.com.cn/problem/P3338
#include<bits/stdc++.h>
using namespace std;
using ld=double;
const int N=1e5+10,P=32,T=2*P,S=1<<(2+__lg(N/T));
int n;
ld q[N], M[S][P], L[S][P], C[2*P][2*P], ans[N];
void build(ld l=1, ld r=n+1, int p=1){
	ld c=(r+l)/2;
	if(abs(r-l)<=T){
		for(int i=ceil(l);i<r;i++){
			double v=1;
			for(int k=0;k<P;k++)
				M[p][k]+=q[i]*v, v*=i-c;
		}
		return;
	}
	build(l,c,2*p), build(c,r,2*p+1);
	for(int k=0;k<P;k++){
		ld t=1, dc=(r-l)/4;
		for(int j=k;~j;j--)
			M[p][k]+=C[k][j]*t*(M[2*p+1][j]+M[2*p][j]*(k-j&1?-1:1)), t*=dc;
	}
}
void qry(ld l=1, ld r=n+1, int p=1){
	ld c=(r+l)/2;
	auto L2L=[&](ld l1, ld r1, int p1){
		ld c1=(l1+r1)/2;
		for(int k=0;k<P;k++){
			ld t=1;
			for(int j=0;k+j<P;j++)
				L[p][k]+=C[k+j+1][j]*t*L[p1][k+j], t*=c-c1;
		}
	};
	auto M2L=[&](ld l1, ld r1, int p1){
		if(l1<1 || r1>n+1) return;
		ld cm=(l1+r1)/2, iv=1/(cm-c), t=iv*iv*(l1<l?1:-1);
		for(int k=0;k<P;k++){
			ld t1=t;
			for(int j=0;j<P;j++)
				L[p][k]+=C[k+j+1][j]*t1*M[p1][j], t1*=-iv;
			t*=iv;
		}
	};
	if(p>=8)L2L(p&1?l*2-r:l, p&1?r:r*2-l, p/2);
	if(p&1) M2L(l-3*(r-l),l-(r-l),p/2-1), M2L(r+(r-l),r+2*(r-l),p+2);
	else M2L(r+(r-l),r+3*(r-l),p/2+1), M2L(l-2*(r-l),l-(r-l),p-2);
	if(abs(r-l)<=T){
		int st=max(1,(int)ceil(l*2-r)), ed=min(n+1,(int)ceil(r*2-l));
		for(int i=ceil(l);i<r;i++){
			ld t=1;
			for(int k=0;k<P;k++)
				ans[i]+=(k+1)*t*L[p][k], t*=i-c;
			for(int j=st;j<ed;j++)
				ans[i]+=j==i?0:q[j]/(ld(j-i)*(j-i))*(j>i?-1:1);
		}
		return;
	}
	qry(l,c,2*p), qry(c,r,2*p+1);
}
int main(){
	for(int i=0;i<2*P;i++){
		C[i][0]=1;
		for(int j=1;j<=i;j++) C[i][j]=C[i-1][j-1]+C[i-1][j];
	}
	scanf("%d",&n);
	for(int i=1;i<=n;i++)scanf("%lf",q+i);
	build();
	qry();
	for(int i=1;i<=n;i++)printf("%.3lf\n",ans[i]);
	return 0;
}
