// find roots of a polynomial over F_{998244353}
#include<bits/stdc++.h>
using namespace std;
using ll=long long;
using poly=vector<ll>;
const int N=2000;
const ll mod=998244353;
ll C[N+10][N+10];
default_random_engine E{random_device{}()};
uniform_int_distribution<ll> U(0,mod-1);
ll po(ll a,ll b=mod-2){ll r=1;for(;b;b/=2,a=a*a%mod)if(b&1)r=r*a%mod;return r;}
void trim(poly&a){
	while(a.size()>1&&!a.back())a.pop_back();
}
int is_zero(const poly&p){return p.size()==1&&!p[0];}
poly operator*(const poly&a,const poly&b){
	poly c(a.size()+b.size()-1);
	for(int i=0;i<a.size();i++)
		for(int j=0;j<b.size();j++)(c[i+j]+=a[i]*b[j])%=mod;
	return c;
}
poly gcd(poly a,poly b){
	if(b.size()>a.size())swap(a,b);
	while(!is_zero(b)){
		ll c=a.back()*po(b.back())%mod;
		for(int i=(int)a.size()-1,j=(int)b.size()-1;~j;j--,i--)
			(a[i]-=b[j]*c)%=mod;
		trim(a);
		if(b.size()>a.size()||is_zero(a))swap(a,b);
	}
	return a;
}
poly operator/(poly a,const poly&b){
	int m=a.size(),n=b.size();ll iv=po(b.back());
	poly c(m-n+1);
	for(int i=m-1;i>=n-1;i--){
		c[i-n+1]=a[i]*iv%mod;
		for(int j=1;j<n;j++)(a[i-j]-=b[n-j-1]*c[i-n+1])%=mod;
	}
	return c;
}
poly operator%(poly a,const poly&b){
	int n=b.size();ll iv=po(b.back());
	for(int i=(int)a.size()-1;i>=n-1;i--){
		ll c=a[i]*iv%mod;
		for(int j=1;j<n;j++)(a[i-j]-=b[n-j-1]*c)%=mod;
		a.pop_back();
	}
	trim(a);
	return a;
}
poly po(poly a,ll b,const poly&m){
	poly r{1};for(;b;b/=2,a=a*a%m)if(b&1)r=r*a%m;return r;
}
poly shift(const poly&a,ll b){// a(x+b)
	int n=a.size();poly c(n);
	for(int i=0;i<n;i++){
		ll t=a[i];
		for(int j=0;j<=i;j++){
			(c[i-j]+=t*C[i][j])%=mod;
			(t*=b)%=mod;
		}
	}
	return c;
}
poly diff(const poly&a){
	int n=a.size();poly b(n-1);
	for(int i=1;i<n;i++)b[i-1]=i*a[i]%mod;
	return b;
}
void norm(poly&a){
	ll iv=po(a.back());
	for(ll&x:a)(x*=iv)%=mod;
}
basic_string<ll> factor(poly x){
	int n=x.size();norm(x);
	if(n==2)return {-x[0]};
	poly p,ox=x;ll t;
	do{
		t=U(E);x=shift(ox,t);
		p=po({0,1},mod-1>>1,x);
	}while(p.size()==1 && (p[0]*p[0]-1)%mod==0);
	poly q=p;++p[0]%=mod,--q[0]%=mod;
	basic_string<ll> ans;
	for(int i=0;i<n&&!x[i];i++)ans+=(ll)0;
	ans+=factor(gcd(p,x))+factor(gcd(q,x));
	for(ll&x:ans)(x+=t)%=mod;
	return ans;
}
void init_C(int n){
	for(int i=0;i<=n;i++){
		C[i][0]=1;
		for(int j=1;j<=i;j++)
			C[i][j]=(C[i-1][j-1]+C[i-1][j])%mod;
	}
}
int main(){
	int n;scanf("%d",&n);
	init_C(n);poly p(n+1);
	for(int i=n;~i;i--)scanf("%lld",&p[i]);
	poly sfp=p/gcd(p,diff(p));
	for(ll x:factor(sfp)){
		do{
			printf("%lld\n",(x+mod)%mod);
			p=p/poly{-x,1};
		}while(is_zero(p%poly{-x,1}));
	}
	assert(p==vector<ll>{1});
	return 0;
}
