void FFT(cmp* a){
    for(int i=0;i<N;i++)
        if(i<rev[i])swap(a[i],a[rev[i]]);
    for(int i=0;i<lg;i++)
        for(int j=0;j<N;j++)if(!(j&1<<i)){
            int x=j|1<<i;
            a[x]*=w[(x&(1<<i)-1)<<lg-1-i];
            cmp tmp=a[j]+a[x];
            a[x]=a[j]-a[x];a[j]=tmp;
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

void FWT(int64 *a,int f,int tp){
	for(int i=0;i<lg;i++)
		for(int j=0;j<N;j++)if(j&1<<i){
			int t=j^1<<i;
			if(tp==OR)(a[j]+=f*a[t])%=mod;else
			if(tp==AND)(a[t]+=f*a[j])%=mod;else{
				int64 tmp=a[t]+a[j];
				a[j]=(a[t]-a[j])*f%mod;
				a[t]=tmp*f%mod;
			}
		}
}
