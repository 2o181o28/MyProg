/*
Visualizing an Elementary_cellular_automaton.
input : initial 0-1 sequence of length 2^k
output: first 2^{k-1} generations 
default-rule: 110
*/
#include<bits/stdc++.h>
using namespace std;
using ll=long long;
constexpr int S=110;
bitset<1<<16> b,c;
int N;
int main(){
	scanf("%d",&N);N*=2;
	for(int i=0;i<N/2;i++){
		char c;scanf(" %c",&c);
		b[i+N/4]=c-'0';
	}
	freopen("1.ppm","wb",stdout);
	printf("P6\n%d %d\n255\n",N/4,N/4);
	for(int i=0;i<N/4;i++){
		for(int j=i+1;j<N-i-1;j++)
			c[j]=S>>(b[j-1]|b[j]*2|b[j+1]*4)&1;
		b=c;
		for(int i=N/4;i<N/2;i++){
			char a[]={char(!b[i]*255),char(!b[i]*255),char(!b[i]*255)};
			fwrite(a,1,3,stdout);
		}
	}
	return 0;
}
