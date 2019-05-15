struct LCT{
	struct node{int rv,vl=1e9,mn=vl,ch[2];}a[1<<18];
	int y,t,F[1<<18];
	int son(int x){return x==R(F[x]);}
	int nr(int x){return x==R(F[x])||x==L(F[x]);}
	void pushdn(int p){if(a[p].rv)swap(L(p),R(p)),a[L(p)].rv^=1,a[R(p)].rv^=1,a[p].rv=0;}
	void pushup(int p){a[p].mn=min({a[p].vl,a[L(p)].mn,a[R(p)].mn});}
	void rotate(int p){
		int f=F[p],g=F[f];pushdn(f),pushdn(p);
		int k=son(p),t=a[p].ch[!k];
		if(nr(f))a[g].ch[son(f)]=p;F[p]=g;
		a[p].ch[!k]=f,F[f]=p;
		a[f].ch[k]=t,F[t]=f;pushup(f);
	}
	void splay(int p){
		for(pushdn(p);nr(p);rotate(p))
			if(nr(F[p]))rotate(son(F[p])==son(p)?F[p]:p);
		pushup(p);
	}
	void access(int p){
		for(t=p,y=0;p;p=F[y=p])splay(p),R(p)=y,pushup(p);
		splay(t);
	}
	void makert(int p){access(p),a[p].rv^=1;}
	void link(int u,int v){makert(u),F[u]=v;}
	void ins(int p,int v){makert(p),a[p].vl=v,pushup(p);}
}tr;
