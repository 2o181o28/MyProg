void gauss(){
	int f[1010]={},v[1010]={};
	for(int i=1;i<=n;i++){
		int mk=-1;
		for(int j=1;j<=n;j++)if(!v[j]&&ma[j][i])mk=j;
		f[i]=mk;v[mk]=1;
		for(int j=1;j<=n;j++)if(ma[j][i]&&!v[j]){
			ll p=ma[mk][i]*po(ma[j][i],mod-2)%mod;
			for(int k=n+1;k>=i;k--)
				ma[j][k]=(ma[mk][k]+mod-p*ma[j][k]%mod)%mod;
		}
	}
/*	for(int i=1;i<=n;i++)
		for(int j=1;j<=n+1;j++)
			printf("%lld%c",ma[i][j]," \n"[j>n]);*/
	for(int ni=n;ni;ni--){
		int i=f[ni];x[ni]=ma[i][n+1];
		for(int j=ni+1;j<=n;j++)x[ni]=(x[ni]+mod-ma[i][j]*x[j]%mod)%mod;
		(x[ni]*=po(ma[i][ni],mod-2))%=mod;
	}
}
