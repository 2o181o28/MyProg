#include<bits/stdc++.h>
using namespace std;
using ld=double;
using numbers::pi;
const ld len=1e-3,X0=0.236840737186153,R0=0.902411405309193;
ld H(ld x){return 0.1*x*x+0.1*sin(6*x)+0.03*sin(12*x);}
ld dH(ld x){return 0.2*x+0.6*cos(6*x)+0.36*cos(12*x);}
ld chk(ld x0){
	ld k=dH(x0),b=H(x0);
	// k(x-x0)+b = h(x)
	ld rx=R0;
	// x:=x-f/f' = x-(k*(x-x0)+b-h(x))/(k-dH(x))
	for(int i=0;i<5;i++)rx-=(k*(rx-x0)+b-H(rx))/(k-dH(rx));
	return H(rx)+sqrt(k*k/(1+k*k))/2;
}
void tri(ld l,ld r){
	if(r-l<1e-11){
		printf("tgt=%.10lf ans=%.10lf\n",(r+l)/2,chk((r+l)/2));
		return;
	}
	ld m1=l+(r-l)/3,m2=r-(r-l)/3;
	if(chk(m1)<chk(m2))tri(l,m2);
	else tri(m1,r);
}
int main(){
	tri(X0-len,X0+len);
	return 0;
}
// ans=0.0768977459
