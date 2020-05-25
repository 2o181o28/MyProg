/* BM template
Input : n
	sequence of length n
Output: the found formula
*/
#include<bits/stdc++.h>
#define L(x) (~(x)?l[x]:0)
using namespace std;
using ll=long long;
const ll mod=1e9+7;
ll po(ll a,ll b){ll r=1;for(;b;b/=2,a=a*a%mod)if(b&1)r=r*a%mod;return r;}
ll a[10010],res[10010];
int n;
int BM(int n){
	ll tr[10010],tmp[10010];
	int c,p=-1,l[10010];res[0]=1;
	for(int i=0;i<n;i++){
		ll d=0;l[i]=L(i-1);
		for(int j=i-l[i];j<=i;j++)(d+=a[j]*res[i-j])%=mod;
		if(!d)continue;
		memcpy(tmp,res,sizeof res);
		if(~p)for(int j=0;j<=L(p-1);j++)(res[j+i-p]-=d*c%mod*tr[j])%=mod;
		l[i]=max(i+1-l[i],l[i]);
		if(l[i]>L(i-1))p=i,c=po(d,mod-2),memcpy(tr,tmp,sizeof tmp);
	}
	for(int i=1;i<=l[n-1];i++)res[i]*=-1;
	return l[n-1];
}
int main(){
	scanf("%d",&n);
	for(int i=0;i<n;i++)scanf("%lld",a+i),a[i]%=mod;
	int l=BM(n);printf("%d\n",l);
	for(int i=1;i<=l;i++)printf("%lld%c",(res[i]+mod)%mod," \n"[i==l]);
	return 0;
}
