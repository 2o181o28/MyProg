#include<bits/stdc++.h>
using namespace std;
using ld=double;
using cmp=complex<ld>;
const int K=10;
ld C[K][K];
ld f(ld x){return 1/log(x);}
ld Df(ld x,int k){
	ld r=0;
	for(int i=0;i<=k;i++)r+=C[k][i]*f(x+i)*(k-i&1?-1:1);
	return r;
}
cmp solve(int k){
	if(k==5){
		const int N=1e6;
		cmp ans=0;
		for(int i=2;i<N;i++)ans+=exp(1i*(ld)i)*Df(i,k);
		return ans;
	}
	return (exp(2i)*Df(2,k) + exp(1i)*solve(k+1))/(1.-exp(1i));
}
int main(){
	for(int i=0;i<K;i++){
		C[i][0]=1;
		for(int j=1;j<=i;j++)
			C[i][j]=C[i-1][j-1]+C[i-1][j];
	}
	printf("%.10lg\n",solve(0).imag());
	return 0;
}
// 0.6839137864
