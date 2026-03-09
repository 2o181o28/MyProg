#include<bits/stdc++.h>
using namespace std;
using ld=double;
using numbers::pi;

namespace Int{
const ld x[]={0.,1./3*sqrt(5-2*sqrt(10./7)),1./3*sqrt(5+2*sqrt(10./7))},
		 w[]={128./225,(322+13*sqrt(70))/900,(322-13*sqrt(70))/900};
ld g_l(auto f,ld l,ld r){
	ld m=(l+r)/2,h=(r-l)/2;
	return h*(w[0]*f(m)+w[1]*(f(m-x[1]*h)+f(m+x[1]*h))+w[2]*(f(m-x[2]*h)+f(m+x[2]*h)));
}
ld int_g(auto f, ld l, ld r, int n=30){
	ld res=0,h=(r-l)/n;
	for(int i=0;i<n;i++)res+=g_l(f,l+i*h,l+(i+1)*h);
	return res;
}
}

ld F(ld u){return sinh(2)/(cosh(2)-cos(2*u));}
ld G(ld v, int n=3e4){
	ld lim=F(pi/2),res=0;
	for(int i=-n;i<=n;i++)																						
		res+=(F(atan(v+i*pi))-lim)/(pow(v+i*pi,2)+1);
	return res+lim*F(v);
}

int main(){
	printf("%.10lg\n",Int::int_g([](ld x){
		return sin(x)*sin(x)*G(x);
	},0,pi)/pi);
	return 0;
}
//20: 0.3909921622
