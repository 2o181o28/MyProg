struct LCT{
	struct node{int ch[2],rev,xr,fa;}a[maxn];
	int b[maxn];
	void pushdown(int p){
		if(a[p].rev)
			a[L(p)].rev^=1,a[R(p)].rev^=1,
			a[p].rev=0,swap(L(p),R(p));
	}
	inline int nroot(int x){return x==L(F(x)) || x==R(F(x));}
	inline void update(int p){a[p].xr=a[L(p)].xr^a[R(p)].xr^b[p];}
	inline int son(int x){return R(F(x))==x;}
	void rotate(int x){
		int f=F(x),ff=F(f);
		pushdown(f),pushdown(x);
		int c=son(x),t=a[x].ch[!c];
		if(nroot(f))a[ff].ch[son(f)]=x;F(x)=ff;
		a[f].ch[c]=t;if(t)F(t)=f;
		a[x].ch[!c]=f;F(f)=x;
		update(f);
	}
	void splay(int p,int f=0){
		for(pushdown(p);nroot(p);rotate(p))
			if(nroot(f=F(p)))rotate(son(p)==son(f)?f:p);
		update(p);
	}
	void access(int p){
		int t=p;
		for(int y=0;p;p=F(y=p))
			splay(p),R(p)=y,update(p);
		splay(t);
	}
	int findrt(int p){
		for(access(p);;p=L(p)){
			pushdown(p);
			if(!L(p))return p;
		}
	}
	void makert(int p){access(p);a[p].rev^=1;}
	void link(int u,int v){makert(u);if(findrt(v)!=u)F(u)=v;}
	void cut(int u,int v){
		makert(u);access(v);
		pushdown(v);
		if(F(u)==v&&!R(u))F(u)=L(v)=0;
		update(v);
	}
	void ins(int x,int v){splay(x);a[x].xr^=b[x]^v;b[x]=v;}
}tr;
