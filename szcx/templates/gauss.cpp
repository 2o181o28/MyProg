	for(i=0;i<n;i++){
        int mk=-1;double m=-1;
        for(j=0;j<n;j++)if(!v[j]&&fabs(ma[j][i])>m)m=fabs(ma[j][i]),mk=j;
        f[i]=mk;v[mk]=1;
        for(j=0;j<n;j++)if(fabs(ma[j][i])>1e-10&&!v[j])
            for(k=n;k>=i;k--)
                ma[j][k]=ma[mk][k]-ma[mk][i]/ma[j][i]*ma[j][k];
    }
    for(int ni=n-1;ni>=0;ni--){
        double &k=x[ni];
        int i=f[ni];
        k=ma[i][n];
        for(j=ni+1;j<n;j++)k-=ma[i][j]*x[j];
        k/=ma[i][ni];
        if(k!=k||k>1e10||k<-1e10){
            puts("No Solution");
            return 0;
        }
    } 
