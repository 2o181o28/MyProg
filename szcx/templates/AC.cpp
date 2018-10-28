struct trie{
	struct node{int ch[26],cnt,fail;}a[100010];
	int rt,tot;
	int que[100010];
	void ins(char *s,int &p){
		if(!p)p=++tot;
		if(!*s){a[p].cnt=1;return;}
		ins(s+1,a[p].ch[*s-'A']);
	}
	void getFail(){
		int l=1,r=0;
		a[rt].fail=rt;
		for(int &i:a[rt].ch)
			if(i)que[++r]=i,a[i].fail=rt;else i=rt;
		while(l<=r){
			int p=que[l++];
			for(int i=0;i<26;i++)if(int &to=a[p].ch[i])
				que[++r]=to,a[to].fail=a[a[p].fail].ch[i];
			else to=a[a[p].fail].ch[i];
		}
	}
}tr;
