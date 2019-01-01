//apt source pi
//cd cln-1.3.4
//./configure
//sudo make ./INSTALL
//sudo make clean
//clang++ $fullname -o $name -O2 `pkg-config --libs cln`
//time:2.1s

#include <cln/output.h>
#include <cln/real.h>
#include <cln/real_io.h>
#include <bits/stdc++.h>
using namespace std;
using namespace cln;
int lg=20;string one="1.";
int main(){
	for(int i=0;i<(1<<lg);i++)one+='0';
	auto a=cl_R(one.data()),b=sqrt(a*2)/2,t=a/4;
	for(int i=0;i<lg;i++){
		auto olda=a;
		a=(a+b)/2;b=sqrt(olda*b);
		t-=(olda-a)*(olda-a)*(1<<i);
	}
	cout<<(a+b)*(a+b)/(4*t)<<endl;
	return 0;
}
