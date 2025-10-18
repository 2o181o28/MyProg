// Find the sum of the distances from each point to every other point in a two-dimensional plane.
// FMM implementation, relative error <= 1e-6.
#include<bits/stdc++.h>
using namespace std;
using ld=double;
const int N=2e5+10,P=11,D=5,LEN=(1<<(2*D+2))/3+10;
const ld MIN_X=-1e9,MAX_X=1e9,MIN_Y=-1e9,MAX_Y=1e9;
ld C[P][P],coeff[2*P][2*P][4*P],rf[P];
int n;
struct po{ld x,y;int id;};
vector<po> v[LEN];
ld M[LEN][P][P],L[LEN][P][P],cx[LEN],cy[LEN],ans[N];

void init_coeff(){
	coeff[0][0][0]=rf[0]=1;
	for(int i=0;i<2*P;i++){
		//    \partial_x (sum coeff[i-1][j][k] x^k y^{i+j-k-1}) / hypot(x,y)^{2i+2j-3}
		// = (hypot(x,y)^{2i+2j-3} (sum coeff[i-1][j][k] k x^{k-1} y^{i+j-k-1}) - 
		//   (sum coeff[i-1][j][k] x^k y^{i+j-k-1}) (2i+2j-3) hypot(x,y)^{2i+2j-5} x) / (x^2+y^2)^{2i+2j-3}
		// = ((x^2+y^2) (sum coeff[i-1][j][k] k x^{k-1} y^{i+j-k-1}) - 
		//   (2i+2j-3) (sum coeff[i-1][j][k] x^{k+1} y^{i+j-k-1}) ) / hypot(x,y)^{2i+2j-1}
		if(i)for(int k=0;k<i;k++){
			if(k)coeff[i][0][k-1]+=coeff[i-1][0][k]*k;
			coeff[i][0][k+1]+=coeff[i-1][0][k]*(k-2*i+3);
		}
		// \partial_y = ((x^2+y^2) (sum coeff[i][j-1][k] x^{k} (i+j-k-1) y^{i+j-k-2}) - 
		//              (2i+2j-3) (sum coeff[i][j-1][k] x^{k} y^{i+j-k}) ) / hypot(x,y)^{2i+2j-1}
		for(int j=1;j<2*P;j++){
			for(int k=0;k<i+j;k++){
				coeff[i][j][k]+=coeff[i][j-1][k]*(-i-j-k+2);
				if(i+j-k-1)coeff[i][j][k+2]+=coeff[i][j-1][k]*(i+j-k-1);
			}
		}
	}
	for(int i=1;i<P;i++)rf[i]=rf[i-1]/i;
	for(int i=0;i<P;i++){
		C[i][0]=1;
		for(int j=1;j<=i;j++)C[i][j]=C[i-1][j-1]+C[i-1][j];
	}
}

// diff(sqrt(x**2+y**2), x,i, y,j)
ld diff(ld x,ld y,int i,int j){
	ld ans=0;
	if(abs(x)<abs(y)){
		ld t=pow(y,i+j),t1=x/y;
		for(int k=0;k<=i+j;k++)ans+=coeff[i][j][k]*t,t*=t1;
	}else{
		ld t=pow(x,i+j),t1=y/x;
		for(int k=i+j;~k;k--)ans+=coeff[i][j][k]*t,t*=t1;
	}
	return ans/pow(x*x+y*y,i+j-.5);
}

int pos(int px,int py,int dep){
	// 2^dep*2^dep nodes per layer
	return ((1<<2*dep)+2)/3+(py<<dep)+px; 
}

// The distribution of points must be relatively uniform,
// ootherwise the brute force part will take too long for some parts.
// D: about round(log_4(N/P^2))
void build(vector<po> &now, ld l=MIN_X,ld r=MAX_X, ld u=MAX_Y,ld d=MIN_Y,int px=0,int py=0,int dep=0){
	int p=pos(px,py,dep);
	cx[p]=(l+r)/2,cy[p]=(u+d)/2;
	if(dep==D){
		v[p]=now;
		for(po&x:now){
			ld t=1;
			for(int k1=0;k1<P;k1++){
				ld t1=t;
				for(int k2=0;k1+k2<P;k2++)	
					M[p][k1][k2]+=t1,t1*=x.y-cy[p];
				t*=x.x-cx[p];
			}
		}
		return;
	}
	vector<po> vs[2][2];
	for(po&x:now)vs[x.x>=cx[p]][x.y<=cy[p]].push_back(x);
	int S=pos(2*px,2*py,dep+1);
	build(vs[0][0],l,cx[p],u,cy[p],2*px,2*py,dep+1);
	build(vs[1][0],cx[p],r,u,cy[p],2*px+1,2*py,dep+1);
	build(vs[0][1],l,cx[p],cy[p],d,2*px,2*py+1,dep+1);
	build(vs[1][1],cx[p],r,cy[p],d,2*px+1,2*py+1,dep+1);
	ld tmp[2][P][P]={0};
	// horizontal M2M
	for(int k=0;k<P;k++){
		ld t=1, dc=(r-l)/4;
		for(int j=k;~j;j--){
			for(int i=0;i+k<P;i++)
				tmp[0][k][i]+=C[k][j]*t*(M[S+1][j][i]+M[S][j][i]*(k-j&1?-1:1)),
				tmp[1][k][i]+=C[k][j]*t*(M[S+(1<<dep+1)+1][j][i]+M[S+(1<<dep+1)][j][i]*(k-j&1?-1:1));
			t*=dc;
		}
	}
	// vertical M2M
	for(int i=0;i<P;i++)for(int k=0;i+k<P;k++){
		ld t=1, dc=(u-d)/4;
		for(int j=k;~j;j--)
			M[p][i][k]+=C[k][j]*t*(tmp[0][i][j]+tmp[1][i][j]*(k-j&1?-1:1)),
			t*=dc;
	}
}

void qry(int px=0,int py=0,int dep=0){
	int p=pos(px,py,dep);
	auto M2L=[&](int p1){ // 1/3 total time
		ld tm[P][P],td[2*P][2*P];
		memcpy(tm,M[p1],sizeof tm);
		for(int k=0;k<P;k++)
			for(int i=0;i+k<P;i++) tm[k][i]*=rf[k]*rf[i];
		ld dx=cx[p1]-cx[p],dy=cy[p1]-cy[p];
		for(int k1=0;k1<=2*(P-1);k1++)
			for(int k2=0;k1+k2<=2*(P-1);k2++)
				td[k1][k2]=diff(dx,dy,k1,k2);
		for(int k=0;k<P;k++)
			for(int i=0;i+k<P;i++){
				ld t=0;
				for(int k1=0;k1<P;k1++)
					for(int i1=0;i1+k1<P;i1++)
						t+=td[k+k1][i+i1]*tm[k1][i1];
				L[p][k][i]+=t*rf[k]*rf[i]*(i+k&1?-1:1);
			}
	};
	
	ld len=(MAX_X-MIN_X)/(1<<dep);
	// near blocks M2L
	if(dep>=2)for(int dx:{-1,0,1})for(int dy:{-1,0,1}){
		int npx=px/2+dx,npy=py/2+dy;
		if(dx==0&&dy==0 || npx<0 || npx>=(1<<dep-1) || npy<0 || npy>=(1<<dep-1))
			continue;
		int p_n=pos(npx,npy,dep-1);
		if(max(abs(cx[p_n]-cx[p]),abs(cy[p_n]-cy[p]))>2*len)
			M2L(p_n);
		else for(int dx1:{0,1})for(int dy1:{0,1}){
			int p_s=pos(npx*2+dx1,npy*2+dy1,dep);
			if(max(abs(cx[p_s]-cx[p]),abs(cy[p_s]-cy[p]))>1.1*len)
				M2L(p_s);
		}
	}
	
	if(dep==D){ // 1/2 total time
		for(po&x:v[p]){
			ld dx=x.x-cx[p],dy=x.y-cy[p],t=1,r=0;
			for(int k=0;k<P;k++){
				ld t1=t;
				for(int i=0;i+k<P;i++)
					r+=L[p][k][i]*t1, t1*=dy;
				t*=dx;
			}
			for(int dx:{-1,0,1})for(int dy:{-1,0,1}){
				int npx=px+dx,npy=py+dy;
				if(npx<0 || npx>=(1<<dep) || npy<0 || npy>=(1<<dep))continue;
				for(po&y:v[pos(npx,npy,dep)])
					r+=sqrt((x.x-y.x)*(x.x-y.x)+(x.y-y.y)*(x.y-y.y));
			}
			ans[x.id]=r;
		}
		return;
	}
	
	if(dep>=2){
		ld tmp[2][P][P]={0};
		// horizontal L2L
		for(int j=0;j<P;j++){
			ld t=1, dc=len/4;
			for(int k=j;~k;k--){
				for(int i=0;i+j<P;i++)
					tmp[0][k][i]+=C[j][k]*t*L[p][j][i]*(k-j&1?-1:1),
					tmp[1][k][i]+=C[j][k]*t*L[p][j][i];
				t*=dc;
			}
		}
		// vertical L2L
		int S=pos(2*px,2*py,dep+1);
		for(int _:{0,1})for(int i=0;i<P;i++)for(int j=0;i+j<P;j++){
			ld t=1, dc=len/4;
			for(int k=j;~k;k--)
				L[S+(1<<dep+1)+_][i][k]+=C[j][k]*t*tmp[_][i][j]*(k-j&1?-1:1),
				L[S+_][i][k]+=C[j][k]*t*tmp[_][i][j],
				t*=dc;
		}
	}
	
	for(int dx:{0,1})for(int dy:{0,1})
		qry(px*2+dx,py*2+dy,dep+1);
}

int main(){
	init_coeff();
	scanf("%d",&n);
	vector<po> x(n);
	for(int i=0;i<n;i++)
		scanf("%lf%lf",&x[i].x,&x[i].y),x[i].id=i;
	build(x);
	qry();
	for(int i=0;i<n;i++)printf("%.3lf\n",ans[i]);
	return 0;
}
