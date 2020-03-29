//radix sort:
void tsort(int i){
	memset(c,0,sizeof c);int p=0;
	for(int j=1;j<=i;j++)tp[++p]=n-i+j;
	for(int j=1;j<=n;j++)
		c[rnk[j]]++,sa[j]>i&&(tp[++p]=sa[j]-i);
	for(int j=1;j<=y;j++)c[j]+=c[j-1];
	for(int j=n;j;j--)sa[c[rnk[tp[j]]]--]=tp[j];
}
	for(int i=1;i<=n;i++)sa[i]=i,rnk[i]=s[i];
	tsort(0);
	for(int i=1;i==1 || y<n;i<<=1){
		tsort(i);y=0;
		for(int j=1;j<=n;tp[sa[j++]]=y)
			y+=rnk[sa[j]]!=rnk[sa[j-1]]||rnk[sa[j]+i]!=rnk[sa[j-1]+i];
		memcpy(rnk,tp,sizeof tp);
	}

// std::sort:
void Init_SA(){
	for(int i=1;i<=n;i++)rnk[i]=s[i],sa[i]=i;
	for(int i=1;i<=n;i<<=1){
		sort(sa+1,sa+1+n,[&](int a,int b){
			return rnk[a]<rnk[b]||rnk[a]==rnk[b]&&rnk[a+i]<rnk[b+i];
		});
		for(int j=1,cnt=0;j<=n;nrnk[sa[j++]]=cnt)
			cnt+=rnk[sa[j]]!=rnk[sa[j-1]]||rnk[sa[j]+i]!=rnk[sa[j-1]+i];
		memcpy(rnk,nrnk,sizeof nrnk);
	}
}

void Init_height(){
	for(int i=1,k=0;i<=n;st[0][rnk[i++]-1]=k)
		for(k&&k--;s[i+k]==s[sa[rnk[i]-1]+k];k++);
}
