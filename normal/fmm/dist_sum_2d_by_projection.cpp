// Find the sum of the distances from each point to every other point in a two-dimensional plane.
// Calculated using the expected projection length, relative error <= 1e-6.
#include<bits/stdc++.h>
using namespace std;
using ld=double;
using numbers::pi;
const int N=2e5+10,K=65;
int n,sa[N];
ld x[N],y[N],p[N],ans[N];
int main(){
	scanf("%d",&n);
	for(int i=0;i<n;i++)scanf("%lf%lf",x+i,y+i);
	iota(sa,sa+n,0);
	for(int k=0;k<K;k++){
		ld t=k*pi/K,c=cos(t),s=sin(t);
		// (1,0) to cos(theta), (0,1) to sin(theta)
		for(int i=0;i<n;i++) p[i]=c*x[i]+s*y[i];
		sort(sa,sa+n,[&](int i,int j){return p[i]<p[j];});
		ld tot=0;
		for(int i=0;i<n;i++)
			ans[sa[i]]+=i*p[sa[i]]-tot,
			tot+=p[sa[i]];
		tot=0;
		for(int i=n-1;~i;i--)
			ans[sa[i]]+=tot-(n-1-i)*p[sa[i]],
			tot+=p[sa[i]];
	}
	for(int i=0;i<n;i++)printf("%.3lf\n",ans[i]/K*(pi/2));
	return 0;
}
// 1e=4: k=13; 1e-6:k=65.
