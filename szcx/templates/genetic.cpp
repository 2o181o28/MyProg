inline double sqr(double x){return x*x;}
inline double rand01(){return rand()/(double)RAND_MAX;}
	for(int gen=1;gen<60000;++gen){
		int mn=1e9,mx=-1e9;
		for(i=1;i<=m;i++){
			f[i]=ftns(i);
			if(f[i]<mn)mn=f[i];
			if(f[i]<ans||f[i]==ans && ls(i))ans=f[i],memcpy(ansv,a[i],sizeof ansv);
			if(f[i]>mx)mx=f[i];
		}
	//	for(i=1;i<=n;i++)printf("%d%c",ansv[i],i==n?'\n':' ');
		int cnt=0;
		for(i=1;i<=m;i++)if(sqr(rand01())>(f[i]-mn)/(double)(mx+1e-8-mn))
			memcpy(b[++cnt],a[i],sizeof a[i]),bf[cnt]=f[i];
		memcpy(f,bf,sizeof bf);memcpy(a,b,sizeof b);
		for(i=1;i<cnt;i++){
			int p=i;
			for(j=i+1;j<=cnt;j++)
				if(f[j]<f[p])p=j;
			swap(a[i],a[p]);
		}
		for(i=1;i<=m-cnt;i++)memcpy(a[cnt+i],a[i],sizeof a[i]);
		for(i=2;i<=cnt;++i)swap(a[i],a[rand()%i+1]);
		for(i=1;i<cnt;i+=2)if(rand01()<0.5){
			swap(a[i][rand()%n+1],a[i][rand()%n+1]);
			swap(a[i+1][rand()%n+1],a[i+1][rand()%n+1]);
			if(rand01()<0.05)random_shuffle(a[i]+1,a[i]+n+1);
			if(rand01()<0.05)random_shuffle(a[i+1]+1,a[i+1]+n+1);
		}
	}
	printf("%d\n",ans);
	for(i=1;i<=n;i++)printf("%d%c",ansv[i],i==n?'\n':' ');
