struct SAM{
	struct{int fa,l,ch[26];}a[1<<20];
	int tot,ls;
	SAM(){tot=ls=1;}
	void ins(int c){
		int p=ls,np=++tot;ls=np;a[np].l=a[p].l+1;
		for(;p&&!a[p].ch[c];p=a[p].fa)a[p].ch[c]=np;
		if(!p){a[np].fa=1;return;}
		int q=a[p].ch[c],nq;
		if(a[q].l==a[p].l+1){a[np].fa=q;return;}
		a[nq=++tot]=a[q];a[np].fa=a[q].fa=nq;
		a[nq].l=a[p].l+1;
		for(;p&&a[p].ch[c]==q;p=a[p].fa)a[p].ch[c]=nq;
	}
}tr;
