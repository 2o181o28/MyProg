//usr/bin/c++ $0 -o ${0%.cpp} -std=c++20 -Wall -Wextra -Wno-unused-result -Ofast -march=native -lgmp -lgmpxx; ./${0%.cpp}; exit
#include<bits/stdc++.h>
#include<gmpxx.h>
using namespace std;

unordered_map<int,mpz_class> mp;

// this calculates sum l..r (-1)^{k}/(2k+1) z^{-2(k-l)-1}. the third one is z^(2(r-l+1))
tuple<mpz_class,mpz_class,mpz_class> solve(int l,int r,int z){
	if(l==r){
		return {l&1?-1:1, (2*l+1)*z, z*z};
	}
	int mid=(l+r)>>1;
	auto [p1,q1,x1]=solve(l,mid,z);
	auto [p2,q2,x2]=solve(mid+1,r,z);
	if(!mp.count(r-l+1))mp[r-l+1]=x1*x2;
	// p1/q1 + p2/q2/z^{2(mid+1-l)}
	auto denom=q2*x1;
	return {p1*denom+p2*q1,q1*denom,mp[r-l+1]};
}

// atan(1/z)
mpf_class atan_iv(int z,double prec){
	// err ~ 1/(2k+1) z^{-2k-1}
	// prec ~ log2(2k+1) + (2k+1)*log2(z)
	int k=(prec/log2(z)-1)/2;
	mp.clear();
	auto [p,q,_]=solve(0,k,z);
	return mpf_class{p}/q;
}

int main(){
	int n;scanf("%d",&n);
	auto prec=n*log2(10);
	mpf_set_default_prec(prec);
	cout<<fixed<<setprecision(n)<<-4*atan_iv(239,prec)+16*atan_iv(5,prec)<<"\n";
	return 0;
}
