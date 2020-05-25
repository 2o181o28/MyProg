#include<bits/stdc++.h>
using namespace std;
const int N=1<<20;
int n,Q,son[N],fa[N],siz[N],dep[N],up[N];
int L[N],R[N],Fa[N],b[N],tDep[N],_t;
basic_string<int> v[N];
void dfs(int p,int f=0){
	fa[p]=f;dep[p]=dep[f]+1;siz[p]=1;
	for(int i:v[p])if(i!=f){
		dfs(i,p),siz[p]+=siz[i];
		if(siz[i]>siz[son[p]])son[p]=i;
	}
}
void work(int&p,int f,int d,int l,int r){
	for(int i=l,s=siz[b[l]];i<r;i++)if(2*(s-siz[b[i+1]])>=s-siz[b[r]]){
		p=b[i];Fa[p]=f;tDep[p]=d;
		work(L[p],p,d+1,l,i);work(R[p],p,d+1,i+1,r);
		return;
	}
}
void dfs1(int p){
	int _=0;
	for(int i=p;i;i=son[i]){
		up[i]=p;
		for(int j:v[i])if(j!=fa[i] && j!=son[i])dfs1(j);
	}
	for(int i=p;i;i=son[i])b[_++]=i;
	b[_]=0;work(p,fa[p],0,0,_);
}
struct bst{
	int mx[N]={(int)-1e9},vl[N],ad[N];
	void upd(int p){mx[p]=max({vl[p],mx[L[p]],mx[R[p]]})+ad[p];}
	int qry(int&x,int f){
		int re=-1e9,ox=R[x];
		for(;x!=f;x=Fa[ox=x]){
			if(ox==R[x])re=max({re,vl[x],mx[L[x]]});
			re+=ad[x];_t++;
		}
		return re;
	}
	void ins(int&x,int w,int f){
		for(int ox=R[x];x!=f;x=Fa[ox=x]){
			if(ox==R[x])L[x]&&(ad[L[x]]+=w,mx[L[x]]+=w),vl[x]+=w;
			upd(x);_t++;
		}
	}
	int qry_slow(int l,int r,int f){
		int reL=-1e9,reR=-1e9,oL=L[l],oR=R[r];
		auto advL=[&]{
			if(oL==L[l])reL=max({reL,vl[l],mx[R[l]]});
			reL+=ad[l];l=Fa[oL=l];
		};
		auto advR=[&]{
			if(oR==R[r])reR=max({reR,vl[r],mx[L[r]]});
			reR+=ad[r];r=Fa[oR=r];
		};
		for(;tDep[l]>tDep[r];)advL(),_t++;
		for(;tDep[r]>tDep[l];)advR(),_t++;
		for(;l!=r;)advL(),advR(),_t+=2;
		int re=max({reL,reR,vl[l]});
		for(;l!=f;l=Fa[l])re+=ad[l],_t++;
		return re;
	}
}tr;
int qry(int u,int v){
	int ans=-1e9;
	while(up[u]!=up[v])if(dep[up[u]]>dep[up[v]])
		ans=max(ans,tr.qry(u,fa[up[u]]));
	else ans=max(ans,tr.qry(v,fa[up[v]]));
	if(dep[u]>dep[v])swap(u,v);
	return max(ans,u==up[u]?tr.qry(v,fa[up[v]]):tr.qry_slow(u,v,fa[up[u]]));
}
void ins(int u,int v,int w){
	while(up[u]!=up[v])if(dep[up[u]]>dep[up[v]])
		tr.ins(u,w,fa[up[u]]);
	else tr.ins(v,w,fa[up[v]]);
	if(dep[u]>dep[v])swap(u,v);
	tr.ins(v,w,fa[up[v]]);
	if(u!=up[u])u=fa[u],tr.ins(u,-w,fa[up[u]]);
}
int main(){
	scanf("%d%d",&n,&Q);
	for(int i=1;i<n;i++){
		int x,y;scanf("%d%d",&x,&y);
		v[x]+=y;v[y]+=x;
	}
	dfs(1);dfs1(1);
	while(Q--){
		int op,x,y,w;scanf("%d%d%d",&op,&x,&y);
		if(op)printf("%d\n",qry(x,y));
		else scanf("%d",&w),ins(x,y,w);
	}
	fprintf(stderr,"$%.2lf\\times 10^%d$\n",_t/pow(10,(int)log10(_t)),(int)log10(_t));
	return 0;
}
