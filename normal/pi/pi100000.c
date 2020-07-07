b=1e3,c=2e2,d,f,i,N,a[1<<20];main(e){scanf("%d",&N);for(N=N*10/3+20;i<N;a[i++]=c);for(;(N-=10)>0;printf("%03d",d+=(c+=e/b)/b),d=c%b,c=e%b)for(e=0,i=N;--i;a[i]=(e+=a[i]*b)%(f=i*2+1),e=e/f*i);}
