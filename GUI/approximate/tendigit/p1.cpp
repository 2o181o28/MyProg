#include<bits/stdc++.h>
using namespace std;
using ld=double;
const int N=30,M=60;
const int dx[]={-1,-1,0,0,1,1},dy[]={-1,0,-1,1,0,1};
ld a[M+1][N][N]={1},chs[N][N];
int chk(int x,int y){
	return y<=x && y>=0 && x>=0 && x<N;
}
ld A(int i,int j,int k){
	if(!chk(j,k))return 0;
	return a[i][j][k]/chs[j][k];
}
int main(){
	for(int j=0;j<N;j++)
		for(int k=0;k<=j;k++)
			for(int t=0;t<6;t++)
				if(chk(j+dx[t],k+dy[t]))chs[j][k]++;
	for(int i=1;i<=M;i++)
		for(int j=0;j<N;j++)
			for(int k=0;k<=j;k++)
				for(int t=0;t<6;t++)
					a[i][j][k]+=A(i-1,j+dx[t],k+dy[t]);
	ld ans=0;
	for(int i=0;i<N;i++)ans+=a[M][N-1][i];
	printf("%.15lg\n",ans);
	return 0;
}
//9.51234350207433e-06
