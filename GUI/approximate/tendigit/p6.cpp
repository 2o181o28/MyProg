#include<bits/stdc++.h>
using namespace std;
using ld=double;
using numbers::pi;
const int kmax=3000,N=1e8,S=N/10,thres=3;
// f[k][1]: start with 2; f[k][2]: start with 4
ld f[kmax+10][3],sum2,sum1;
int g[N+10]={1};
int main(){
	f[1][0]=.8,f[1][1]=f[1][2]=.1;
	for(int k=2;k<=kmax;k++){
		f[k][1]=(f[k-1][0]+f[k-1][1]+f[k-1][2])/10;
		f[k][0]=8*f[k][1];
		f[k][2]=(f[k-1][0]+f[k-1][2])/10;
		if(k>thres)sum2+=f[k][2],sum1+=f[k][1];
	}
	sum2*=10,sum1*=10;
	for(int i=1;i<N;i++)g[i]=i%100==42?0:g[i/10];
	ld ans=0;
	for(int i=1;i<S;i++)ans+=g[i]/(ld)i;
	for(int i=S;i<10*S;i++)if(g[i]){
		ld pw=1;
		for(int j=0;j<thres;j++){
			ld freq=(i%10==4?f[j+1][2]:f[j+1][1])*10;
			ld L=i*pw,R=(i+1)*pw-1;
			ld H=log(R)-log(L)+(1./R+1./L)/2;
			ans+=H*freq;
			pw*=10;
		}
		ans+=(log(i+1)-log(i))*(i%10==4?sum2:sum1);
	}
	printf("%.12lg\n", ans);
	return 0;
}
//228.4463042
// https://en.wikipedia.org/wiki/Kempner_series
// (Decimal('228.446304159230813254148086126250588432570915006362795371418675788225766262326731028429759'),
