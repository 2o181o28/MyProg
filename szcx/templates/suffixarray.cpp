inline int Rnk(int k){return k>n?-1:rnk[k];}
bool cmp(int a,int b){
	return rnk[a]<rnk[b] || rnk[a]==rnk[b] && Rnk(a+(1<<i-1))<Rnk(b+(1<<i-1));
}

//radix sort:
	memcpy(t,s,sizeof t);sort(t+1,t+1+n);
	for(i=2;i<=n+1;i++)if(i>n || t[i]!=t[i-1])f[t[i-1]]=i-1;
	for(i=1;i<=n;i++)rnk[i]=f[s[i]],sa[i]=i;
	for(i=1;1+(1<<i)<=n;i++){
		//sort(sa+1,sa+1+n,cmp);
		int t=0;
		for(j=1;j<=n;j++)a[j].clear();
		for(j=(1<<i-1)+1;j<=n;j++)a[rnk[j]].push_back(j);
		for(j=n-(1<<i-1)+1;j<=n;j++)sa[++t]=j;
		for(j=1;j<=n;j++)for(int k:a[j])sa[++t]=k-(1<<i-1);
		t=0;for(j=1;j<=n;j++)a[j].clear();
		for(j=1;j<=n;j++)a[rnk[sa[j]]].push_back(sa[j]);
		for(j=1;j<=n;j++)for(int k:a[j])sa[++t]=k;
		cnt=nrnk[sa[1]]=1;
		for(j=1;j<n;nrnk[sa[++j]]=cnt)
			if(cmp(sa[j],sa[j+1]) || cmp(sa[j+1],sa[j]))
				++cnt;
		if(cnt==n)break;
		memcpy(rnk,nrnk,sizeof rnk);
	}
	
// std::sort:
void Init_SA(){
    for(int i=1;i<=n;i++)
        rnk[i]=s[i],sa[i]=i;
    for(int i=1;i<=n;i<<=1){
        sort(sa+1,sa+1+n,[&](int a,int b){
            return rnk[a]<rnk[b] || rnk[a]==rnk[b] && rnk[a+i]<rnk[b+i];
        });
        nrnk[sa[1]]=1;
        for(int j=2,cnt=1;j<=n;nrnk[sa[j++]]=cnt)
            cnt+=rnk[sa[j]]!=rnk[sa[j-1]] || rnk[sa[j]+i]!=rnk[sa[j-1]+i];
        memcpy(rnk,nrnk,sizeof nrnk);
    }
}

void Init_height(){
    for(int k=0,i=1;i<=n;i++){
        if(k)k--;
        while(s[i+k]==s[sa[rnk[i]-1]+k])++k;
        h[rnk[i]]=k;
    }
}
