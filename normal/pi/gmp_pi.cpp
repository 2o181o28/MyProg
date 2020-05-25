//usr/bin/c++ $0 -o ${0%.cpp} -O3 -lgmp -lgmpxx; time ./${0%.cpp} > /dev/null; exit
#include<bits/stdc++.h>
#include<gmpxx.h>
using namespace std;
int prec=1<<20;
int main(){
	mpf_set_default_prec(prec*log2(10));
	mpf_class a=1,b=a/sqrt(2*a),t=1./4;
	for(int i=1;i<=prec;i*=2){
		auto olda=a;
		a=(a+b)/2;
		b=sqrt(olda*b);
		t-=(olda-a)*(olda-a)*i;
	}
	cout<<fixed<<setprecision(prec)<<(a+b)*(a+b)/(4*t)<<endl;
}
