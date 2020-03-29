/*
use Hashlife's 1D form to emulate Rule_110 fast.
Can also be used to emulate other rules.
input : initial 0-1 sequence of length 2^k
output: the 2^{k-1}-th generation

see https://2o181o28.github.io/2020/03/29/%E4%B8%80%E7%BB%B4%E7%9A%84hashlife/
*/
#include<bits/stdc++.h>
using namespace std;
using ub=uint8_t;
using u=unsigned;
using ull=uint64_t;
using arr=basic_string<u>;
const int S=110;
const ull mod=1000000000000000003ull;
unordered_map<ull,arr> mp;
u vl[1<<24];int N;
ull hsh(arr&x){
	ull res=0;
	for(u&i:x)for(int j=0;j<32;j++)res=(res*17+(i>>j&1)+3)%mod;
	return res;
}
ub&Get(arr&a,int p){return p[(uint8_t*)a.data()];}
arr solve(arr a){
	int n=a.size(),n1=n/2,n2=n/4;
	if(n<=128){
		arr b=a;
		for(int i=0;i<n;i++){
			for(int j=i+1;j<(n*4)-i-1;j++)
				Get(b,j)=vl[Get(a,j-1)|Get(a,j)<<8|Get(a,j+1)<<16];
			a=b;
		}
		return a.substr(n2,n1);
	}
	ull hsv=hsh(a);
	if(mp.count(hsv))return mp[hsv];
	arr x=solve(a.substr(0,n1)),y=solve(a.substr(n2,n1)),z=solve(a.substr(n1,n1));
	return mp[hsv]=solve(x+y)+solve(y+z);
}
int main(){
	scanf("%d",&N);assert((N&N-1)==0 && N>=64);N/=16;
	for(u x=0;x<(1<<24);x++){
		u t=x;
		for(int i=0;i<8;i++){
			u tt=0;
			for(int j=i+1;j<24-i-1;j++)
				tt|=(S>>(t>>j-1&7)&1)<<j;
			t=tt;
		}
		vl[x]=t>>8&255;
	}
	arr a;a.resize(N);
	for(int i=0;i<N*16;i++){
		char c;scanf(" %c",&c);
		a[i/32+N/4]|=(c-'0')<<(i&31);
	}
	a=solve(a);
	for(int i=0;i<N*16;i++)printf("%c",(a[i/32]>>(i&31)&1)+'0');
	puts("");
	return 0;
}
