/*
Input : n
Output: 若干相邻整数和为n的所有方案
Complexity: O(sqrt(n))
*/
#include<cstdio>
#include<cstdlib>
#include<cmath>
using ll=long long;
ll n,k,l;int cnt;
struct st{ll x,y;}a[1000010];
int cmp(const void*a,const void*b){
	ll t=((st*)a)->x-((st*)b)->x;
	return t?t>0?1:-1:0;
}
int main() {
	scanf("%lld",&n);
	for(ll i=1;i<2*sqrtl(n);i++){
		k=n/i;
		if(!(n%i)&&(i&1)&&(l=2*k-i+1>>1)>0)a[cnt++]={l,(2*k+i-1)/2};
		if(!(n%i)&&(k&1)&&(l=k-2*i+1>>1)>0)a[cnt++]={l,(2*i+k-1)/2};
	}
	qsort(a,cnt,16,cmp);
	// 为了“修旧如旧”，没有使用std::sort
	// 复杂度分析：n的因子个数是O(n^eps)的，所以对a数组做快排是o(sqrt(n))的
	for(int i=0;i+1<cnt;i++)
		printf("%lld %lld\n",a[i].x,a[i].y);
	return 0;
}
