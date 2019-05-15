void FFT(ll *a,int lg,int f){
	for(int i=0;i<(1<<lg);i++)if(i<rev[i])swap(a[i],a[rev[i]]);
	for(int i=0,j;i<lg;i++)
		for(j=0,p=w[f][i+1];j<(1<<lg);j++)if(j&1<<i){
			ll l=a[j^1<<i],r=a[j]*p[j&(1<<i)-1];
			a[j^1<<i]=(l+r)%mod,a[j]=(l-r)%mod;
		}
}


// 3 to 2

	for(int i=0;i<2*n;i++)
		a[i]=cmp(x[i],-y[i]);
	for(int i=0;i<N;i++)
		rev[i]=rev[i>>1]>>1|(i&1)<<lg-1,
		w[i]=exp(cmp(0,-2*acos(-1)*i/N));
	FFT(a);
	for(int i=0;i<N;i++){
		cmp p=a[i],q=conj(a[N-i&N-1]);
		b[i]=conj((p+q)*(p-q)*cmp(0,.25));
	}
	FFT(b);
	
//fwt

void FWT(ll *a,int f,int tp){
	for(int i=0;i<lg;i++)
		for(int j=0;j<N;j++)if(j&1<<i){
			int t=j^1<<i;
			if(tp==OR)(a[j]+=f*a[t])%=mod;else
			if(tp==AND)(a[t]+=f*a[j])%=mod;else{
				ll tmp=a[t]+a[j];
				a[j]=(a[t]-a[j])*f%mod;
				a[t]=tmp*f%mod;
			}
		}
}
