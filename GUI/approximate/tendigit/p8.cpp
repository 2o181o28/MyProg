#include<bits/stdc++.h>
using namespace std;
using ld=double;
using numbers::pi;
using cv=const array<ld,2>;

namespace Int{
const int N=20;
const ld x[]={0.,1./3*sqrt(5-2*sqrt(10./7)),1./3*sqrt(5+2*sqrt(10./7))},
		 w[]={128./225,(322+13*sqrt(70))/900,(322-13*sqrt(70))/900};
ld g_l(auto f,ld l,ld r){
	ld m=(l+r)/2,h=(r-l)/2;
	return h*(w[0]*f(m)+w[1]*(f(m-x[1]*h)+f(m+x[1]*h))+w[2]*(f(m-x[2]*h)+f(m+x[2]*h)));
}
ld int_g(ld l, ld r, auto f){
	ld res=0,h=(r-l)/N;
	for(int i=0;i<N;i++)res+=g_l(f,l+i*h,l+(i+1)*h);
	return res;
}
}

ld eval(cv &xs, cv &ys, cv &zs, cv &xq, cv &yq, ld qz){
	using Int::int_g;
	return int_g(xs[0],xs[1],[&](ld x){
		return int_g(ys[0],ys[1],[&](ld y){
		return int_g(zs[0],zs[1],[&](ld z){
		return int_g(xq[0],xq[1],[&](ld qx){
			return asinh((yq[1]-y)/sqrt((x-qx)*(x-qx)+(z-qz)*(z-qz)))
				-asinh((yq[0]-y)/sqrt((x-qx)*(x-qx)+(z-qz)*(z-qz)));
		});
		});
		});
	});
}

int main(){
	printf("%.12lg\n",eval({.5,1},{.5,1},{0,.5},{1.5,2},{1,1.5},0));
	return 0;
}
//0.642612609767
//1.5685938703246476
//0.9259812605576476
