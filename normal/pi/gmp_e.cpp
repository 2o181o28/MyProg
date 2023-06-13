//usr/bin/c++ $0 -o ${0%.cpp} -std=c++20 -Wall -Wextra -Wno-unused-result -Ofast -march=native -lgmp -lgmpxx; ./${0%.cpp}; exit
#include<bits/stdc++.h>
#include<gmpxx.h>
using namespace std;
using ll=long long;
int n;

// this calculates (l-1)!(sum l..r 1/k!). the denominator must be l(l+1)(l+2)...(r)
pair<mpz_class,mpz_class> solve(int l,int r){
	if(l==r){
		return {1,l};
	}
	int mid=(l+r)>>1;
	auto [p1,q1]=solve(l,mid);
	auto [p2,q2]=solve(mid+1,r);
	// p1/q1 + (l-1)!/mid! p2/q2 = p1/q1 + p2/q2/q1
	return {p1*q2+p2,q1*q2};
}

int main(){
	scanf("%d",&n);
	// e-(1+...+1/n!) ~ 1/(n!n)
	auto prec=(lgamma(n+1)+log(n))/log(2);
	int digits=prec*log10(2);
	printf("%d digits\n",digits);
	mpf_set_default_prec(prec);
	
	auto [p,q]=solve(2,n);
	cout<<fixed<<setprecision(digits)<<2+mpf_class{p}/q<<"\n";
	return 0;
}
