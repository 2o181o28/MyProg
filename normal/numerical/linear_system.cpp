// 测试各种线性方程组数值求解算法的精度和速度，为清华的数值分析课程编写的。
// 包含方法：Gauss，Cholesky，共轭梯度法，GMRES
// 可以使用正常的浮点数和gmpxx提供的高精度浮点数运算。
#include<bits/stdc++.h>
#include<gmpxx.h>
using namespace std;
using ld=double;
const int prec=10, N=5010, M=110;
int n;

void gauss(const ld inp[N][N]){
	static ld a[N][N],x[N];
	for(int i=1;i<=n;i++)
		copy(inp[i]+1,inp[i]+n+2,a[i]+1);
	for(int i=1;i<=n;i++){
		int mp=0;ld mx=-1;
		for(int j=i;j<=n;j++)if(abs(a[j][i])>mx){
			mx=abs(a[j][i]);
			mp=j;
		}
		for(int j=i;j<=n+1;j++)swap(a[mp][j],a[i][j]);
		for(int j=i+1;j<=n;j++){
			ld f=a[j][i]/a[i][i];
			for(int k=i;k<=n+1;k++)
				a[j][k]-=a[i][k]*f;
		}
	}
	for(int i=n;i;i--){
		x[i]=a[i][n+1];
		for(int j=i+1;j<=n;j++)x[i]-=x[j]*a[i][j];
		x[i]/=a[i][i];
	}
/*	puts("Gauss:");
	for(int i=1;i<=n;i++){
		cout<<fixed<<setprecision(prec)<<x[i]<<endl;
	}
	puts("");*/
	ld m=0;
	for(int i=1;i<=n;i++)m=max(m,(ld)abs(x[i]-1));
	cout<<fixed<<setprecision(prec)<<m<<endl;
}

void cholesky(const ld inp[N][N]){
	static ld l[N][N],x[N];
	for(int j=1;j<=n;j++){
		l[j][j]=inp[j][j];
		for(int k=1;k<j;k++)l[j][j]-=l[j][k]*l[j][k];
		l[j][j]=sqrt(l[j][j]);
		for(int i=j+1;i<=n;i++){
			l[i][j]=inp[i][j];
			for(int k=1;k<j;k++)
				l[i][j]-=l[i][k]*l[j][k];
			l[i][j]/=l[j][j];
		}
	}
	for(int i=1;i<=n;i++){
		x[i]=inp[i][n+1];
		for(int k=1;k<i;k++)x[i]-=l[i][k]*x[k];
		x[i]/=l[i][i];
	}
	for(int i=n;i;i--){
		for(int k=i+1;k<=n;k++)x[i]-=l[k][i]*x[k];
		x[i]/=l[i][i];
	}
/*	puts("Cholesky:");
	for(int i=1;i<=n;i++){
		cout<<fixed<<setprecision(prec)<<x[i]<<endl;
	}
	puts("");*/
	ld m=0;
	for(int i=1;i<=n;i++)m=max(m,(ld)abs(x[i]-1));
	cout<<fixed<<setprecision(prec)<<m<<endl;
}

ld dot(ld a[N],ld b[N]){
	ld res=0;
	for(int i=1;i<=n;i++)res+=a[i]*b[i];
	return res;
}

ld norm(ld a[N]){return dot(a,a);}

void mul(const ld a[N][N],const ld x[N],ld out[N]){
	fill(out+1,out+1+n,0);
	for(int i=1;i<=n;i++)
		for(int j=1;j<=n;j++)
			out[i]+=a[i][j]*x[j];
}

void conj_grad(const ld a[N][N]){
	static ld x[N],r[N],p[N],Ap[N];
	fill(x+1,x+1+n,0);
	for(int i=1;i<=n;i++)r[i]=a[i][n+1];
	copy(r+1,r+1+n,p+1);
	for(int k=0;;k++){
		ld norm_rk=norm(r);
		if(norm_rk<1e-30)break;
		mul(a,p,Ap);
		ld alpha=norm_rk/dot(Ap,p);
		for(int i=1;i<=n;i++)x[i]+=alpha*p[i];

		/*double m=0;
		for(int i=1;i<=n;i++)m=max(m,abs(x[i]-1));
		printf("%d %.10lf\n",k,m);*/

		if(alpha*sqrt(norm(p))<1e-30 || k==n-1)break;
		for(int i=1;i<=n;i++)r[i]-=alpha*Ap[i];
		ld beta=norm(r)/norm_rk;
		for(int i=1;i<=n;i++)p[i]=r[i]+beta*p[i];
	}
/*	puts("Conjugate gradient:");
	for(int i=1;i<=n;i++){
		cout<<fixed<<setprecision(prec)<<x[i]<<endl;
	}
	puts("");*/
/*	ld m=0;
	for(int i=1;i<=n;i++)m=max(m,(ld)abs(x[i]-1));
	printf("$n=%d$& $%.3Le$ &",n,(long double)m);*/
}

void conj_grad_with_jacobi(const ld a[N][N]){
	static ld x[N],r[N],p[N],Ap[N],z[N];
	fill(x+1,x+1+n,0);
	for(int i=1;i<=n;i++)r[i]=a[i][n+1],z[i]=r[i]/a[i][i];
	copy(z+1,z+1+n,p+1);
	for(int k=0;;k++){
		ld dot_zr=dot(z,r);
		if(dot_zr<1e-30)break;
		mul(a,p,Ap);
		ld alpha=dot_zr/dot(Ap,p);
		for(int i=1;i<=n;i++)x[i]+=alpha*p[i];

		/*printf("%d ",k);
		double m=0;
		for(int i=1;i<=n;i++)m=max(m,abs(x[i]-1).get_d());
		printf("%.10lf\n",m);*/

		if(alpha*sqrt(norm(p))<1e-30 || k==n-1)break;
		for(int i=1;i<=n;i++)r[i]-=alpha*Ap[i],z[i]=r[i]/a[i][i];
		ld beta=dot(z,r)/dot_zr;
		for(int i=1;i<=n;i++)p[i]=z[i]+beta*p[i];
	}
/*	puts("Conjugate gradient:");
	for(int i=1;i<=n;i++){
		cout<<fixed<<setprecision(prec)<<x[i]<<endl;
	}
	puts("");*/
/*	ld m=0;
	for(int i=1;i<=n;i++)m=max(m,(ld)abs(x[i]-1));
	printf("$%.3Le$ &",(long double)m);*/
}

void conj_grad_with_gauss_seidel(const ld a[N][N]){
	static ld x[N],r[N],p[N],Ap[N],z[N],S[N][N];
	for(int j=1;j<=n;j++){
		ld v=1/sqrt(a[j][j]);
		for(int i=j;i<=n;i++)S[i][j]=a[i][j]*v;
	}
	auto solve_z=[&]{
		for(int i=1;i<=n;i++){
			z[i]=r[i];
			for(int j=1;j<i;j++)z[i]-=S[i][j]*z[j];
			z[i]/=S[i][i];
		}
		for(int i=n;i;i--){
			for(int j=i+1;j<=n;j++)z[i]-=S[j][i]*z[j];
			z[i]/=S[i][i];
		}
	};

	fill(x+1,x+1+n,0);
	for(int i=1;i<=n;i++)r[i]=a[i][n+1];
	solve_z();
	copy(z+1,z+1+n,p+1);
	for(int k=0;;k++){
		ld dot_zr=dot(z,r);
		if(dot_zr<1e-30)break;
		mul(a,p,Ap);
		ld alpha=dot_zr/dot(Ap,p);
		for(int i=1;i<=n;i++)x[i]+=alpha*p[i];

		/*printf("%d: ",k);
		ld m=0;
		for(int i=1;i<=n;i++)m=max(m,(ld)abs(x[i]-1));
		printf("%.4Le\n",(long double)m);*/

		if(alpha*sqrt(norm(p))<1e-30 || k==n-1)break;
		for(int i=1;i<=n;i++)r[i]-=alpha*Ap[i];
		solve_z();
		ld beta=dot(z,r)/dot_zr;
		for(int i=1;i<=n;i++)p[i]=z[i]+beta*p[i];
	}
/*	puts("Conjugate gradient:");
	for(int i=1;i<=n;i++){
		cout<<fixed<<setprecision(prec)<<x[i]<<endl;
	}
	puts("");*/
/*	ld m=0;
	for(int i=1;i<=n;i++)m=max(m,(ld)abs(x[i]-1));
	printf("$%.3Le$ \\\\\n",(long double)m);*/
}

void gmres(const ld a[N][N],int m){
	static ld r[N],v[M][N],h[M][M],x[N];
	fill(x+1,x+1+n,0);
	for(int i=1;i<=n;i++)r[i]=a[i][n+1];
	const int c=4;
	for(int t=1;t<=c;t++){
		ld beta=sqrt(norm(r));
		for(int i=1;i<=n;i++)v[1][i]=r[i]/beta;
		for(int i=1;i<=m+1;i++)
			fill(h[i]+1,h[i]+1+m,0);
		for(int i=1;i<=m;i++){ // Arnoldi
			ld Av[N];mul(a,v[i],Av);
			copy(Av+1,Av+1+n,v[i+1]+1);
			for(int j=1;j<=i;j++){
				h[j][i]=dot(v[j],Av);
				for(int k=1;k<=n;k++)v[i+1][k]-=h[j][i]*v[j][k];
			}
			h[i+1][i]=sqrt(norm(v[i+1]));
			for(int k=1;k<=n;k++)v[i+1][k]/=h[i+1][i];
		}
		static ld omega[M][M],R[M][M],g[3][3],no[3][M]; // QR
		for(int i=1;i<=m+1;i++)
			fill(omega[i]+1,omega[i]+1+(m+1),0),
			fill(R[i]+1,R[i]+1+m,0);
		omega[1][1]=1;
		for(int i=0;i<m;i++){
			omega[i+2][i+2]=1;
			ld rho=0,sigma=h[i+2][i+1];
			for(int j=1;j<=i+1;j++)
				rho+=omega[i+1][j]*h[j][i+1];
			// Givens rotation
			g[1][1]=g[2][2]=rho/hypot(rho,sigma);
			g[2][1]=-(g[1][2]=sigma/hypot(rho,sigma));
			for(int j:{1,2}){
				fill(no[j]+1,no[j]+1+(i+2),0);
				for(int k:{1,2})
					for(int l=1;l<=i+2;l++)
						no[j][l]+=g[j][k]*omega[i+k][l];
			}
			for(int j:{1,2})copy(no[j]+1,no[j]+1+(i+2),omega[i+j]+1);
		}
		for(int i=1;i<=m;i++)
			for(int j=1;j<=m+1;j++)
				for(int k=max(i,j-1);k<=m;k++)
					R[i][k]+=omega[i][j]*h[j][k];
		static ld y[M],Vy[N];
		for(int i=1;i<=m;i++)y[i]=beta*omega[i][1];
		for(int i=m;i;i--){
			for(int j=i+1;j<=m;j++)y[i]-=y[j]*R[i][j];
			y[i]/=R[i][i];
		}
		fill(Vy+1,Vy+1+n,0);
		for(int i=1;i<=m;i++)
			for(int j=1;j<=n;j++)
				Vy[j]+=y[i]*v[i][j];
		for(int i=1;i<=n;i++)
			for(int j=1;j<=n;j++)
				r[i]-=a[i][j]*Vy[j];
		for(int i=1;i<=n;i++)x[i]+=Vy[i];
		ld mx=0;
		for(int i=1;i<=n;i++)mx=max(mx,(ld)abs(x[i]-1));
//		printf("%d : %.3Le\n",t,(long double)mx);
		cout<<m<<' '<<t<<' '<<fixed<<setprecision(prec)<<mx<<endl;
	}
/*	puts("GMRES 1 iteration:");
	for(int i=1;i<=n;i++)
		cout<<fixed<<setprecision(prec)<<x[i]<<endl;
	puts("");*/
}

int main(){
	mpf_set_default_prec(prec*log2(10));

	int m;scanf("%d%d",&n,&m);
	static ld h[N][N];
	for(int i=1;i<=n;i++){
		h[i][n+1]=0;
		for(int j=1;j<=n;j++)
			h[i][j]=1./(i+j-1),
			h[i][n+1]+=h[i][j];
	}

//	gauss(h);
//	cholesky(h);
//	conj_grad(h);
//	conj_grad_with_jacobi(h);
//	conj_grad_with_gauss_seidel(h);
	gmres(h,m);
	return 0;
}
