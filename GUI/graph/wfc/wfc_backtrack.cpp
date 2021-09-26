#include<bits/stdc++.h>
using namespace std;
using ll=long long;
auto F=fopen("1.ppm","rb");
uniform_real_distribution<double> U;default_random_engine E;
const ll mod=1e11+3;
const int k=3;
unordered_map<ll,int> ump;
int w,h,n,m,mp[1010][1010],cnt[1<<20],fin;
int idx[1<<20],idy[1<<20],col[1010][1010];
ll hsh[1<<17][10][10];
struct st{
	basic_string<int> op;
	double e;
	void calc(){
		int t=0;e=0;double p;
		for(int i:op)t+=cnt[i];
		for(int i:op)p=cnt[i]*1./t,e-=log(p)*p;
	}
}a[1010][1010];
struct segTree{
	double a[1<<21];int p[1<<21],N;
	void init(int sz){
		for(N=1;N<sz+2;N*=2);for(int i=0;i<(1<<21);i++)a[i]=1e9;
		for(int i=1+N;i<=sz+N;i++)p[i]=i-N;
	}
	void ins(int x,double v){
		for(a[x+=N]=v,x/=2;x;x/=2)
			if(a[x*2]>a[x*2+1]+1e-10 || fabs(a[x*2]-a[x*2+1])<1e-10&&(rand()&1))
				a[x]=a[x*2+1],p[x]=p[x*2+1];
			else a[x]=a[x*2],p[x]=p[x*2];
	}
}tr;
void dfs(int dep){
	printf("%d\n",dep);
	if(tr.a[1]>1e7){fin=1;return;}
	int ps=tr.p[1],vl=tr.a[1],x=(ps-1)/(m-k+1)+1,y=(ps-1)%(m-k+1)+1;
	tr.ins(ps,1e8);a[x][y].e=1e8;
	unordered_set<int> bn;
	basic_string<int> yb[10][10];
	double ov[10][10];
	stt:
	int t=0,cs=0,c=0;
	for(int i:a[x][y].op)if(!bn.count(i))t+=cnt[i],c++;
	if(!c){tr.ins(ps,vl);a[x][y].e=vl;return;}
	double re=U(E)*t;
	for(int i:a[x][y].op)if(!bn.count(i) && (t-=cnt[i])<=re)
		{cs=i;break;}
	for(int i=x;i<x+k;i++)
		for(int j=y;j<y+k;j++)
			col[i][j]=mp[i-x+idx[cs]][j-y+idy[cs]];
	for(int i=x-k+1;i<x+k;i++)if(i>=1&&i<=n-k+1)
		for(int j=y-k+1;j<y+k;j++)if(j>=1&&j<=m-k+1&&a[i][j].e<1e7){
			ll v=0;
			for(int x1=i;x1<i+k;x1++)for(int y1=j;y1<j+k;y1++)
				if(x1>=x&&x1<x+k && y1>=y&&y1<y+k)v=(v<<24|col[x1][y1])%mod;
			yb[i-x+k][j-y+k]={};
			for(int t:a[i][j].op)if(hsh[t][x-i+k][y-j+k]==v)
				yb[i-x+k][j-y+k]+=t;
			if(!yb[i-x+k][j-y+k].size()){bn.insert(cs);goto stt;}
		}
	for(int i=x-k+1;i<x+k;i++)if(i>=1&&i<=n-k+1)
		for(int j=y-k+1;j<y+k;j++)if(j>=1&&j<=m-k+1){
			ov[i-x+k][j-y+k]=a[i][j].e;
			if(a[i][j].e<1e7)
				swap(a[i][j].op,yb[i-x+k][j-y+k]),
				a[i][j].calc(),tr.ins((i-1)*(m-k+1)+j,a[i][j].e);
		}
	dfs(dep+1);if(fin)return;
	for(int i=x-k+1;i<x+k;i++)if(i>=1&&i<=n-k+1)
		for(int j=y-k+1;j<y+k;j++)if(j>=1&&j<=m-k+1&&ov[i-x+k][j-y+k]<1e7)
			swap(a[i][j].op,yb[i-x+k][j-y+k]),a[i][j].e=ov[i-x+k][j-y+k],
			tr.ins((i-1)*(m-k+1)+j,a[i][j].e);
	bn.insert(cs);goto stt;
}
int main(){
	E.seed(clock());
	fscanf(F,"P6\n%d%d\n%*d\n",&w,&h);
	for(int i=1;i<=h;i++)
		for(int j=1;j<=w;j++)fread(mp[i]+j,3,1,F);
	for(int i=1;i<=h-k+1;i++)
		for(int j=1;j<=w-k+1;j++){
			ll v=0;
			for(int x=i;x<i+k;x++)for(int y=j;y<j+k;y++)
				v=(v<<24|mp[x][y])%mod;
			if(!ump.count(v))ump[v]=ump.size()+1;
			cnt[ump[v]]++;idx[ump[v]]=i,idy[ump[v]]=j;
			for(int x=i-k+1;x<i+k;x++)for(int y=j-k+1;y<j+k;y++){
				ll vv=0;
				for(int x1=x;x1<x+k;x1++)if(x1>=i&&x1<i+k)
					for(int y1=y;y1<y+k;y1++)if(y1>=j&&y1<j+k)(vv=vv<<24|mp[x1][y1])%=mod;
				hsh[ump[v]][x-i+k][y-j+k]=vv;
			}
		}
	scanf("%d%d",&n,&m);
	tr.init((n-k+1)*(m-k+1));
	for(int i=1;i<=n-k+1;i++)
		for(int j=1;j<=m-k+1;j++){
			for(size_t t=1;t<=ump.size();t++)a[i][j].op+=t;
			a[i][j].calc();
			tr.ins((i-1)*(m-k+1)+j,a[i][j].e);
		}
	for(int i=1;i<=n;i++)for(int j=1;j<=m;j++)col[i][j]=0x7f7f7f;
	dfs(0);assert(fin);
	F=fopen("2.ppm","wb");
	fprintf(F,"P6\n%d %d\n255\n",m,n);
	for(int i=1;i<=n;i++)
		for(int j=1;j<=m;j++)fwrite(col[i]+j,3,1,F);
	return 0;
}
