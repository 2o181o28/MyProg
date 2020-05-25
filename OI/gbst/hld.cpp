#include<bits/stdc++.h>
using namespace std;
const int N=1<<20;
int son[N],siz[N],fa[N],up[N],pos[N],dep[N],n,Q,_;
int _a[N*10],_m[N*10],*_pa=_a,*_pm=_m,_t;
basic_string<int> v[N];
struct segTree{
	int *ad,*mx,m;
	void build(int n){
		m=1;while(m<n+2)m*=2;
		ad=_pa,mx=_pm;_pa+=m*2+1,_pm+=m*2+1;
		for(int i=m+1;i<=m+n;i++)
			for(int j=i;j&&mx[j];j/=2)mx[j]=0;
	}
	void upd(int p){mx[p]=ad[p]+max(mx[p*2],mx[p*2+1]);}
	int qry(int l,int r){
		int L=-1e9,R=-1e9;
		for(l+=m-1,r+=m+1;l^r^1;l/=2,r/=2){
			if(~l&1)L=max(L,mx[l|1]);
			if(r&1)R=max(R,mx[r^1]);
			L+=ad[l/2];R+=ad[r/2];
			_t+=2;
		}
		for(l/=2;l;l/=2)L+=ad[l],R+=ad[l],_t++;
		return max(L,R);
	}
	void ins(int l,int r,int w){
		for(l+=m-1,r+=m+1;l^r^1;l/=2,r/=2){
			if(~l&1)ad[l|1]+=w,mx[l|1]+=w;
			if(r&1)ad[r^1]+=w,mx[r^1]+=w;
			upd(l/2),upd(r/2);_t+=2;
		}
		for(l/=2;l;l/=2)upd(l),_t++;
	}
}tr[N];
void dfs(int p,int f=0){
	fa[p]=f;dep[p]=dep[f]+1;siz[p]=1;
	for(int i:v[p])if(i!=f){
		dfs(i,p),siz[p]+=siz[i];
		if(siz[i]>siz[son[p]])son[p]=i;
	}
}
void dfs1(int p,int u){
	up[p]=u;if(p==u)_=0;pos[p]=++_;
	if(son[p])dfs1(son[p],u);
	else tr[u].build(pos[p]);
	for(int i:v[p])if(i!=fa[p] && i!=son[p])dfs1(i,i);
}
int qry(int u,int v){
	int ans=0;
	while(up[u]!=up[v])if(dep[up[u]]>dep[up[v]])
		ans=max(ans,tr[up[u]].qry(pos[up[u]],pos[u])),u=fa[up[u]];
	else ans=max(ans,tr[up[v]].qry(pos[up[v]],pos[v])),v=fa[up[v]];
	if(pos[u]>pos[v])swap(u,v);
	return max(ans,tr[up[u]].qry(pos[u],pos[v]));
}
void ins(int u,int v,int w){
	while(up[u]!=up[v])if(dep[up[u]]>dep[up[v]])
		tr[up[u]].ins(pos[up[u]],pos[u],w),u=fa[up[u]];
	else tr[up[v]].ins(pos[up[v]],pos[v],w),v=fa[up[v]];
	if(pos[u]>pos[v])swap(u,v);
	tr[up[u]].ins(pos[u],pos[v],w);
}
int main(){
	memset(_m,192,sizeof _m);
	scanf("%d%d",&n,&Q);
	for(int i=1;i<n;i++){
		int x,y;scanf("%d%d",&x,&y);
		v[x]+=y;v[y]+=x;
	}
	dfs(1);dfs1(1,1);
	while(Q--){
		int op,u,v,w;
		scanf("%d%d%d",&op,&u,&v);
		if(op)printf("%d\n",qry(u,v));
		else scanf("%d",&w),ins(u,v,w);
	}
	fprintf(stderr,"$%.2lf\\times 10^%d$\n",_t/pow(10,(int)log10(_t)),(int)log10(_t));
	return 0;
}
