#include<bits/stdc++.h>
using namespace std;
using ll=long long;
using uc=unsigned char;
const int k=3,Mx=10;
int l_msb(int x,int y){
	return x<y&&(x<(x^y));
}
int cmp_z(int x[],int y[]){
	int msd=0;
	for(int i=1;i<k;i++)
		if(l_msb(x[msd]^y[msd],x[i]^y[i]))
			msd=i;
	return x[msd]<y[msd];
}
int m,n,_,vis[k],f[k];
struct st{int a[k];int x,y;}b[1<<20];
uc a[1010][1010][k];
double ma[k][k+1],T[k+1][k],x[k];
template<class A,class B> double dis(A x[],B y[]){
	double ans=0;
	for(int i=0;i<k;i++)ans+=pow(x[i]-y[i],2);
	return ans;
}
void solve(){
	memset(vis,0,sizeof vis);
	for(int i=0;i<k;i++){
		double mx=0;int p=-1;
		for(int j=0;j<k;j++)if(abs(ma[j][i])>mx && !vis[j])mx=abs(ma[j][i]),p=j;
		assert(~p);
		vis[p]=1;f[i]=p;
		for(int j=0;j<k;j++)if(!vis[j])
			for(int t=k;t>=i;t--)
				ma[j][t]-=ma[p][t]*ma[j][i]/ma[p][i];
	}
	for(int i=k-1;~i;i--){
		x[i]=ma[f[i]][k];
		for(int j=i+1;j<k;j++)x[i]-=x[j]*ma[f[i]][j];
		x[i]/=ma[f[i]][i];
	}
}
int chk(int mid){
	int tot=1,stt=1;double now[k],old[k],r=0;
	for(int i=0;i<k;i++)now[i]=b[1].a[i];
	for(int i=2;i<=_;i++){
		if(dis(now,b[i].a)<=r+1e-8)continue;
		memcpy(old,now,sizeof now);
		for(int j=0;j<k;j++)now[j]=b[i].a[j];r=0;
		for(int j=stt;j<i;j++){
			if(dis(now,b[j].a)<=r+1e-8)continue;
			for(int t=0;t<k;t++)now[t]=(b[i].a[t]+b[j].a[t])/2.;
			r=dis(now,b[j].a);
			for(int t=stt;t<j;t++){
				if(dis(now,b[t].a)<=r+1e-8)continue;
				for(int x=0;x<k;x++)T[0][x]=0;
				for(int x=0;x<k;x++)T[1][x]=b[j].a[x]-b[i].a[x];
				for(int x=0;x<k;x++)T[2][x]=b[t].a[x]-b[i].a[x];
				memset(ma,0,sizeof ma);
				for(int y=0;y<k-1;y++)
					for(int x=0;x<k;x++)
						ma[y][x]=2*(T[y+1][x]-T[y][x]),
						ma[y][k]+=pow(T[y+1][x],2)-pow(T[y][x],2);
				ma[k-1][0]=T[1][1]*T[2][2]-T[2][1]*T[1][2];
				ma[k-1][1]=T[2][0]*T[1][2]-T[2][2]*T[1][0];
				ma[k-1][2]=T[1][0]*T[2][1]-T[2][0]*T[1][1];
				solve();
				for(int t=0;t<k;t++)now[t]=x[t]+b[i].a[t];
				r=dis(now,b[j].a);
				for(int tt=stt;tt<t;tt++){
					if(dis(now,b[tt].a)<=r+1e-8)continue;
					for(int x=0;x<k;x++)T[0][x]=b[i].a[x];
					for(int x=0;x<k;x++)T[1][x]=b[j].a[x];
					for(int x=0;x<k;x++)T[2][x]=b[t].a[x];
					for(int x=0;x<k;x++)T[3][x]=b[tt].a[x];
					memset(ma,0,sizeof ma);
					for(int y=0;y<k;y++)
						for(int x=0;x<k;x++)
							ma[y][x]=2*(T[y+1][x]-T[y][x]),
							ma[y][k]+=pow(T[y+1][x],2)-pow(T[y][x],2);
					solve();
					for(int t=0;t<k;t++)now[t]=x[t];
					r=dis(now,b[i].a);
				}
			}
		}
		if(r>mid){
			++tot;
			for(int j=stt;j<i;j++)
				for(int t=0;t<k;t++)a[b[j].x][b[j].y][t]=old[t]+.5;
			for(int j=0;j<k;j++)now[j]=b[i].a[j];r=0;
			stt=i;
		}
	}
	for(int j=stt;j<=_;j++)for(int t=0;t<k;t++)a[b[j].x][b[j].y][t]=now[t]+.5;
	return tot<=Mx;
}
int main(){
	scanf("P6\n%d%d\n255\n",&m,&n);
	for(int i=1;i<=n;i++)
		for(int j=1;j<=m;j++){
			fread(a[i][j],1,3,stdin);++_;
			for(int t=0;t<3;t++)b[_].a[t]=a[i][j][t];
			b[_].x=i,b[_].y=j;
		}
	sort(b+1,b+1+_,[](st a,st b){return cmp_z(a.a,b.a);});
	int l=0,r=3*256*256,mid;
	while(l<r){
		mid=l+r>>1;
		if(chk(mid))r=mid;else l=mid+1;
	}
	chk(l);
	printf("P6\n%d %d\n255\n",m,n);
	for(int i=1;i<=n;i++)
		for(int j=1;j<=m;j++)
			fwrite(a[i][j],1,3,stdout);
	return 0;
}
