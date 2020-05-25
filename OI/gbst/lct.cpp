#include<bits/stdc++.h>
#define F(x) a[x].fa
#define L(x) a[x].ch[0]
#define R(x) a[x].ch[1]
using namespace std;
using ll=long long;
int n,Q,_t;
struct LCT{
	struct nod{int ch[2],fa,rev,mx,vl,ad;}a[1<<20];
	int son(int x){return x==R(F(x));}
	int nr(int x){return x==R(F(x))||x==L(F(x));}
	void down(int x){
		if(a[x].rev)a[L(x)].rev^=1,a[R(x)].rev^=1,a[x].rev=0,swap(L(x),R(x));
		if(a[x].ad){
			a[x].vl+=a[x].ad;
			if(L(x))a[L(x)].ad+=a[x].ad,a[L(x)].mx+=a[x].ad;
			if(R(x))a[R(x)].ad+=a[x].ad,a[R(x)].mx+=a[x].ad;
			a[x].ad=0;
		}
	}
	void down_all(int x){if(nr(x))down_all(F(x));down(x);}
	void upd(int x){a[x].mx=max({a[L(x)].mx,a[R(x)].mx,a[x].vl})+a[x].ad;}
	void rotate(int p){
		int f=F(p),ff=F(f),k=son(p),&t=a[p].ch[!k];
		if(nr(f))a[ff].ch[son(f)]=p;F(p)=ff;
		a[f].ch[k]=t;F(t)=f;t=f;F(f)=p;
		upd(f);_t++;
	}
	void splay(int p){
		for(down_all(p);nr(p);rotate(p))
			if(nr(F(p)))rotate(son(p)==son(F(p))?F(p):p);
		upd(p);
	}
	void access(int p){
		int t=p;
		for(int y=0;p;p=F(y=p))splay(p),R(p)=y,upd(p);
		splay(t);
	}
	void makert(int p){access(p),a[p].rev^=1;}
}tr;
int main(){
	scanf("%d%d",&n,&Q);tr.a[0].mx=-1e9;
	for(int i=1;i<n;i++){
		int x,y;scanf("%d%d",&x,&y);
		tr.F(y)=x;
	}
	while(Q--){
		int op,x,y,w;scanf("%d%d%d",&op,&x,&y);
		tr.makert(x);
		tr.access(y);
		if(op)tr.upd(y),printf("%d\n",tr.a[y].mx);
		else scanf("%d",&w),tr.a[y].ad+=w,tr.upd(y);
	}
	fprintf(stderr,"$%.2lf\\times 10^%d$\n",_t/pow(10,(int)log10(_t)),(int)log10(_t));
	return 0;
}
