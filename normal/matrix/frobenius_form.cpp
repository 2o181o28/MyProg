/*
Compute the Frobenius normal form of A and B; if A~B, it also finds P that A=PBP^{-1}.
Time complexity: O(n^6)
*/
#include<bits/stdc++.h>
using namespace std;
using ll=long long;
const ll mod=998244353;
const int N=50;

ll po(ll a,ll b=mod-2){ll r=1;for(;b;b/=2,a=a*a%mod)if(b&1)r=r*a%mod;return r;}

// Poly
using poly=vector<ll>;
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
poly operator+(const poly&a,const poly&b){
	poly c(max(a.size(),b.size()));
	for(int i=0;i<c.size();i++)
		c[i]=((i<a.size()?a[i]:0) + (i<b.size()?b[i]:0))%mod;
	trim(c);return c;
}
poly operator-(poly a){
	for(ll&x:a)x=-x;
	return a;
}
poly operator-(const poly&a,const poly&b){return a+(-b);}
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

int is_factor(const poly&a, const poly&b){
	if(b.size()==1 || is_zero(a))return 1;
	return a%b==poly{0};
}

ostream& operator<<(ostream&o, const poly&a){
	for(int k=a.size()-1;~k;k--){
		o<<((a[k]+mod)%mod+mod/2)%mod-mod/2<<showpos;
		if(k>1)o<<"x^"<<noshowpos<<k<<showpos;
		else if(k==1)o<<"x";
	}
	return o<<noshowpos;
}

// end poly

struct Matrix{
	poly a[N+10][N+10];
	Matrix(){
		for(int i=1;i<=N;i++)for(int j=1;j<=N;j++)a[i][j]=poly{0};
	}
	poly* operator[](int k){return a[k];}
	const poly* operator[](int k)const{return a[k];}
}A,B,P1,D1,P2,D2;

Matrix operator*(const Matrix&a, const Matrix&b){
	Matrix c;
	for(int i=1;i<=N;i++)
		for(int k=1;k<=N;k++)
			for(int j=1;j<=N;j++)
				c[i][j]=c[i][j] + a[i][k]*b[k][j];
	return c;
}

ostream& operator<<(ostream& o,const Matrix& a){
	for(int i=1;i<=N;i++){
		for(int j=1;j<=N;j++)o<<a[i][j]<<' ';
		o<<'\n';
	}
	return o;
}

void dec(const Matrix& A,Matrix& P,Matrix& D, int flg){
	// A=P^{flg?-1:1}DQ
	D=A;
	for(int i=1;i<=N;i++)P[i][i]=poly{1};
	for(int i=1;i<=N;i++){
		// heuristic to get a small initial value of deg(D[i][i])
		int mn=1e9,mj=0,mk;
		for(int j=i;j<=N;j++)
			for(int k=i;k<=N;k++)if(!is_zero(D[j][k]) && D[j][k].size()<mn){
				mj=j,mk=k,mn=D[j][k].size();
			}
		if(!mj)throw"GG";
		for(int j=i;j<=N;j++)swap(D[j][mk],D[j][i]);
		for(int j=1;j<=N;j++){
			swap(D[mj][j],D[i][j]);
			if(flg)swap(P[mj][j],P[i][j]);
			else swap(P[j][mj],P[j][i]);
		}
		
		auto elem_col=[&](int t,int f,const poly& k){ // t-=kf
			for(int j=i;j<=N;j++)
				D[j][t]=D[j][t] - k*D[j][f];
		};
		
		auto elem_row=[&](int t,int f,const poly& k){ // t-=kf
			for(int j=i;j<=N;j++)
				D[t][j]=D[t][j] - k*D[f][j];
			for(int j=1;j<=N;j++)
				if(flg)
					P[t][j]=P[t][j] - k*P[f][j];
				else
					P[j][f]=P[j][f] + k*P[j][t];
		};
		
		auto check_row=[&]{
			int ps=0;
			for(int j=i+1;j<=N;j++)if(!is_factor(D[i][j],D[i][i])){
				ps=j;break;
			}
			if(!ps)return 0;
			elem_col(ps,i,D[i][ps]/D[i][i]);
			for(int j=i;j<=N;j++)swap(D[j][ps],D[j][i]);
			return 1;
		};
		
		auto check_col=[&]{
			int px=0,py;
			for(int y=i;y<=N;y++)
			for(int x=i+1;x<=N;x++)if(!is_factor(D[x][y],D[i][i])){
				px=x,py=y;goto fin;
			}
			fin:if(!px)return 0;
			if(py>i){ // D[i][i] | D[px][i]; D[i][i] | D[i][py]
				elem_col(py,i,D[i][py]/D[i][i]);
				for(int j=i+1;j<=N;j++)D[j][i]=D[j][i]+D[j][py];
				// => now D[px][i] \nmid D[i][i]
			}
			elem_row(px,i,D[px][i]/D[i][i]);
			for(int j=i;j<=N;j++)swap(D[px][j],D[i][j]);
			for(int j=1;j<=N;j++)
				if(flg)swap(P[px][j],P[i][j]);
				else swap(P[j][i],P[j][px]);
			return 1;
		};
		
		l:
		if(check_row())goto l;
		if(check_col())goto l;
			
		// time complexity: Every time check_*() returns 1, deg(D[i][i]) will decrease. 
		// so they are called O(n^2) times at most in total
		
		for(int j=i+1;j<=N;j++)
			elem_row(j,i,D[j][i]/D[i][i]),
			elem_col(j,i,D[i][j]/D[i][i]);
	}
	
	for(int i=1;i<=N;i++){
		ll iv=po(D[i][i].back());
		for(auto&x:D[i][i])(x*=iv)%=mod,(x+=mod)%=mod;
	}
}

Matrix to_fform(const Matrix&D){
	int now=1;Matrix f;
	for(int i=1;i<=N;i++)if(D[i][i].size()>1){
		int s=D[i][i].size()-1;
		for(int j=now;j<now+s;j++){
			if(j+1<now+s)f[j][j+1][0]=1;
			f[now+s-1][j][0]=(mod-D[i][i][j-now])%mod;
		}
		now+=s;
	}
	return f;
}

bool operator==(const Matrix&a, const Matrix&b){
	for(int i=1;i<=N;i++)for(int j=1;j<=N;j++)
		if(a[i][j]!=b[i][j])return 0;
	return 1;
}

void read(Matrix&a){
	for(int i=1;i<=N;i++)for(int j=1;j<=N;j++){
		int x;scanf("%d",&x);
		if(i==j)a[i][j]=poly{-x,1};
		else a[i][j]=poly{-x};
	}
}

int main(){
	read(A),read(B);
	dec(A,P1,D1,0);dec(B,P2,D2,1);
	cout<<to_fform(D1)<<"\n"<<to_fform(D2)<<"\n";
	if(D1!=D2){puts("Not similar");return 0;}
	Matrix M=P1*P2;
	
	int mx=0;
	for(int i=1;i<=N;i++)for(int j=1;j<=N;j++)
		if(M[i][j].size()>mx)mx=M[i][j].size();
	for(int i=1;i<=N;i++)for(int j=1;j<=N;j++)
		M[i][j].resize(mx);
	for(int t=mx-1;t;t--){
		for(int i=1;i<=N;i++)for(int k=1;k<=N;k++)for(int j=1;j<=N;j++)
			(M[i][j][t-1] -= A[i][k][0]*M[k][j][t])%=mod;
	}
	
	for(int i=1;i<=N;i++)for(int j=1;j<=N;j++)
		M[i][j].resize(1);
	cout<<M;
	return 0;
}

/*
xI-A = P D Q
xI-B = P1 D Q1

(D==D)

xI-A = P P1^{-1} (xI-B) Q1^{-1} Q

M(x)(xI-B)N(x)=xI-A 
=>
M(x) = (xI-A) Q(x) + P, B=PAP^{-1}

M(x)=PP1^{-1}
*/
