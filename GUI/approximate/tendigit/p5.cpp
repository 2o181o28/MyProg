#include<bits/stdc++.h>
using namespace std;
using ld=double;
using numbers::pi;
const int nt=1000,np=1e4;
const ld L=-3,R=3,h=(R-L)/np;
ld a[np+10],val[np+10];
int que[np+10];
ld H(ld x){return 0.1*x*x+0.1*sin(6*x)+0.03*sin(12*x);}
int main(){
	for(int i=0;i<np;i++)a[i]=H(i*h+L);
	ld mnt=0,mnx=0,mny=INFINITY;
	for(int i=1;i<nt;i++){
		ld theta=(ld)i/nt*pi-pi/2,k=tan(theta);
		int len=cos(theta)/h+.5,qL=0,qR=0;
		for(int j=0;j<np;j++){
			val[j]=a[j]-k*(j*h+L);
			while(qL<qR && val[que[qR-1]]<=val[j])qR--;
			que[qR++]=j;
			if(j>=len){
				ld midx=(j-len/2.)*h+L,midy=k*midx+val[que[qL]];
				if(midy<mny)mnt=theta,mny=midy,mnx=midx;
				if(qL<qR && que[qL]==j-len)qL++;
			}
		}
	}
	printf("%.10lf %.10lf %.10lf\n",mnt,mnx,mny);
	return 0;
}
//tgt=0.2370863921 ans=0.0768977459
