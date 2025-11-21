// 计算Riemann zeta函数；
// 比较naive求和，Euler求和，Aitken求和的收敛速度
#include<bits/stdc++.h>
using namespace std;
using ld=long double;

const int n=20;
ld a[n+10],s;

ld C(ld n, ld m){
	return exp(lgamma(n+1) - lgamma(m+1) - lgamma(n-m+1));
}

ld get_naive_sum(){
	ld sum=0;
	for(int i=1;i<=n;i++)
		sum += a[i];
	return sum;
}

ld get_euler_sum(){
	ld sum=0;
	for(int i=1;i<=n;i++){
		ld c=0;
		for(int j=i;j<=n;j++)
			c += C(j,i) / exp2(j+1);
		sum += a[i] * c;
	}
	return sum;
}

ld get_aitken_sum(){
	ld sum=0;
	for(int i=1;i<=n;i++) sum += a[i];
	return sum - a[n]*a[n]/(a[n]-a[n-1]);
}

int main(){
	scanf("%Lf",&s);
	for(int i=1;i<=n;i++)a[i]=(i&1?1:-1) * pow(i,-s);
	
	printf("%.10Lf\n%.10Lf\n%.10Lf\n\nreal=%.10Lf\n",get_naive_sum(),get_euler_sum(),get_aitken_sum(),riemann_zeta(s) * (1-exp2(1-s)));
	return 0;
}
