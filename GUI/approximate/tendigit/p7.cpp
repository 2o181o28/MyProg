#include<bits/stdc++.h>
using namespace std;
using ld=double;
using numbers::pi;
//const ld X0=0.649,Y0=-0.136,R=5;
const ld X0=-1.592,Y0=4.094,R=1;
ld f(ld x,ld y){return exp(-(y+x*x*x)*(y+x*x*x));}
ld g(ld,ld y){return y*y/32+exp(sin(y));}
ld solve(ld theta){
	ld l=0,r=R,mid,c=cos(theta),s=sin(theta);
	while(r-l>1e-11){
		mid=(l+r)/2;
		ld x=X0+mid*c,y=Y0+mid*s;
		if(f(x,y)>g(x,y))l=mid;
		else r=mid;
	}
	return (r+l)/2;
}
int main(){
	int n;scanf("%d",&n);
	ld ans=0;
	for(int i=0;i<n;i++)
		ans+=pow(solve(i*2*pi/n),2);
	printf("%.10lg\n",ans/2*(2*pi/n));
	return 0;
}
// 1000: 2.089257904
// 1000: 0.02577197675
// 2.115029881
