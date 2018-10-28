#include<cstdio> 
#include<cmath>
#include<cstring>
#include<algorithm>
using namespace std;
const int n=18,m=3 + 1;
#define cmatrix const matrix&

struct matrix{
	int x,y;
	double a[210][210];
	matrix(int x=1,int y=1):x(x),y(y){memset(a,0,sizeof a);}
};
matrix operator * (cmatrix A,cmatrix B){
	matrix res(A.x,B.y);
	for(int i=1;i<=res.x;i++)
		for(int k=1;k<=A.y;k++)
			for(int j=1;j<=res.y;j++)
				res.a[i][j]+=A.a[i][k]*B.a[k][j];
	return res;
}
matrix T(cmatrix A){
	matrix B(A.y,A.x);
	for(int i=1;i<=A.x;i++)
		for(int j=1;j<=A.y;j++)
			B.a[j][i]=A.a[i][j];
	return B;
}
matrix inv(matrix A){
	int n=A.x,i,j,k,is[A.x+10],js[A.y+10];
	for(k=1;k<=n;k++){
		double mx=0;
		for(i=k;i<=n;i++)
			for(j=k;j<=n;j++)if(abs(A.a[i][j])>mx){
				mx=abs(A.a[i][j]);
				is[k]=i,js[k]=j;
			}
		for(i=1;i<=n;i++)
			swap(A.a[k][i],A.a[is[k]][i]);
		for(i=1;i<=n;i++)
			swap(A.a[i][k],A.a[i][js[k]]);
		A.a[k][k]=1/A.a[k][k];
		for(j=1;j<=n;j++)if(j!=k)
			A.a[k][j]*=A.a[k][k];
		for(i=1;i<=n;i++)if(i!=k)
			for(j=1;j<=n;j++)if(j!=k)
				A.a[i][j]-=A.a[i][k]*A.a[k][j];
		for(i=1;i<=n;i++)if(i!=k)
			A.a[i][k]=-A.a[i][k]*A.a[k][k];
	}
	for(k=n;k>=1;k--){
		for(i=1;i<=n;i++)
			swap(A.a[js[k]][i],A.a[k][i]);
		for(i=1;i<=n;i++)
			swap(A.a[i][is[k]],A.a[i][k]);
	} 
	return A;
}
double eval(matrix &p,double x){
	double ret=0;
	for(int i=p.x;i;i--)ret=ret*x+p.a[i][1];
	return ret;
}
matrix A(n,m),y(n,1);
int i,j;FILE *f;
int main(){
	f=fopen("example.txt","r");
	for(i=1;i<=n;i++)fscanf(f,"%lf%lf",&A.a[i][2],&(y.a[i][1]));
	for(i=1;i<=n;i++) {
		A.a[i][1]=1;
		for(j=3;j<=m;j++)A.a[i][j]=A.a[i][j-1]*A.a[i][2];
	}
	matrix res=inv(T(A)*A)*T(A);
	res=res*y;
	for(i=1;i<=m;i++)printf("%.10lf\n",res.a[i][1]);
	for(i=1;i<=n;i++){
		printf("%.10lf %.10lf\n",eval(res,A.a[i][2]),y.a[i][1]);
	}
	return 0;
}
