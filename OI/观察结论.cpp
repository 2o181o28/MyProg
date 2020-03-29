/*
Input : n
Output: 若干相邻整数和为n的所有方案
Complexity: O(sqrt(n))
*/
#include<cstdio>
#include<cmath>
#include<vector>
#include<algorithm>
using namespace std;
int n,i,k;long long l;
vector<long long> a;
int main() {
	scanf("%d",&n);
	for(i=1;i<2*sqrt(n);i++){
		k=n/i;
		if(!(n%i)&&(i%2)&&(l=2*k-i+1>>1)>0)a.push_back((l<<32)+(2*k+i-1)/2);
		if(!(n%i)&&(k%2)&&(l=k-2*i+1>>1)>0)a.push_back((l<<32)+(2*i+k-1)/2);
	}
	sort(a.begin(),a.end());
	for(i=0;i<a.size()-1;i++)
		printf("%d ",a[i]>>32),printf("%d\n",a[i]&0xffffffff);
	return 0;
}
