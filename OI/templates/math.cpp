//  ma的行列式 

ll det(){
	int rev=0;ll ans=1;
	for(int i=1;i<=n;i++){
		int p=0;
		for(int j=i;j<=n;j++)if(ma[j][i])
			{p=j;break;}
		if(!p)return 0;
		if(p!=i){
			rev^=1;
			for(int j=i;j<=n;j++)swap(ma[p][j],ma[i][j]);
		}
		for(int j=i+1;j<=n;j++)if(ma[j][i]){
			ll R=(mod-ma[j][i]*inv(ma[i][i])%mod)%mod;
			for(int k=i;k<=n;k++)
				(ma[j][k]+=ma[i][k]*R%mod)%=mod;
		}
	}
	for(int i=1;i<=n;i++)(ans*=ma[i][i])%=mod;
	if(rev)ans=(mod-ans)%mod;
	return ans;
}

// 矩阵类 ，注意栈空间
 
#define cmatrix const matrix&

struct matrix{
	int x,y;
	double a[210][210];
	matrix(int x=1,int y=1):x(x),y(y){memset(a,0,sizeof a);}
};
matrix operator * (cmatrix A,cmatrix B){
	matrix res(A.x,B.y);
	for(int i=1;i<=res.x;i++)
		for(int k=1;k<=A.y;k++)
			for(int j=1;j<=res.y;j++)
				res.a[i][j]+=A.a[i][k]*B.a[k][j];
	return res;
}
matrix T(cmatrix A){
	matrix B(A.y,A.x);
	for(int i=1;i<=A.x;i++)
		for(int j=1;j<=A.y;j++)
			B.a[j][i]=A.a[i][j];
	return B;
}
matrix inv(matrix A){
	int n=A.x,i,j,k,is[A.x+10],js[A.y+10];
	for(k=1;k<=n;k++){
		double mx=0;
		for(i=k;i<=n;i++)
			for(j=k;j<=n;j++)if(abs(A.a[i][j])>mx){
				mx=abs(A.a[i][j]);
				is[k]=i,js[k]=j;
			}
		for(i=1;i<=n;i++)
			swap(A.a[k][i],A.a[is[k]][i]);
		for(i=1;i<=n;i++)
			swap(A.a[i][k],A.a[i][js[k]]);
		A.a[k][k]=1/A.a[k][k];
		for(j=1;j<=n;j++)if(j!=k)
			A.a[k][j]*=A.a[k][k];
		for(i=1;i<=n;i++)if(i!=k)
			for(j=1;j<=n;j++)if(j!=k)
				A.a[i][j]-=A.a[i][k]*A.a[k][j];
		for(i=1;i<=n;i++)if(i!=k)
			A.a[i][k]=-A.a[i][k]*A.a[k][k];
	}
	for(k=n;k>=1;k--){
		for(i=1;i<=n;i++)
			swap(A.a[js[k]][i],A.a[k][i]);
		for(i=1;i<=n;i++)
			swap(A.a[i][is[k]],A.a[i][k]);
	} 
	return A;
} 

// 线性gay

void ins(ll x){
	for(int i=62;~i;--i)if(x&1ll<<i)
		if(!p[i]){p[i]=x;return;}
		else x^=p[i];
}
ll qry(ll x){
	for(int i=62;~i;--i)
		if((x^p[i])>x)x^=p[i];
	return x;
}

// 数论

ll mulmod(ll a,ll b,ll m){
	ll c,ans;
	a%=m;b%=m;c=(long double)a*b/m;
	ans=a*b-c*m;
	if(ans<0)ans+=m;else
	if(ans>=m)ans-=m;
	return ans;
}
ll exgcd(ll a,ll b,ll &x,ll &y){
	if(!b){x=1;y=0;return a;}
	ll r=exgcd(b,a%b,y,x);
	y-=x*(a/b);
	return r;
}

ll WestKP(vector<pair<ll,ll>>v){
	ll ret=0;
	for(auto &p:v){
		ll t=(md-1)/p.second;
		ret=(ret+p.first*t%(md-1)*inv[p.second][t%p.second])%(md-1);
	}
	return ret;
}
ll lucas(ll a,ll b,ll p){
	if(a<b || a%p<b%p)return 0;if(!a)return 1;
	return fac[p][a%p]*ifac[p][b%p]%p*ifac[p][a%p-b%p]%p*lucas(a/p,b/p,p)%p;
} 
