#include<bits/stdc++.h>
#define extended long double
#define re real()
#define im imag()
#define Tau 2*__builtin_acosl(-1)
using namespace std;
const extended eps=1e-10;
typedef complex<extended> compd;
vector<compd> ans;
inline compd F(compd x){return pow(x,5)-2.l*pow(x,2)+1.l;}
inline bool deq(extended a,extended b,extended eps){return fabs(a-b)<eps;}
inline extended Dec(extended a,extended b){
	extended ret=a-b;
	return deq(ret,Tau,1)?ret-Tau:(deq(ret,-Tau,1)?ret+Tau:ret);
}
extended getwdn(compd st,compd ed){
	extended ret=0;
	if(!deq(ed.re,st.re,eps/2.))
		for(compd dv=max(eps/2.,(ed.re-st.re)/1000.);st.re<ed.re;st+=dv)
			ret+=Dec(arg(F(st+dv)),arg(F(st)));
	else
		for(compd dv(0,max(eps/2.,(ed.im-st.im)/1000.));st.im<ed.im;st+=dv)
			ret+=Dec(arg(F(st+dv)),arg(F(st)));
	return ret;
}
void dfs(extended l,extended r,extended u,extended d,int dep){
	if(r-l<eps || u-d<eps){ans.push_back(compd((l+r)/2,(u+d)/2));return;}
	if(dep&1){
		extended mid=(l+r)/2;
		compd lu(l,u),mu(mid,u),ru(r,u),ld(l,d),rd(r,d),md(mid,d);
		extended a=getwdn(lu,mu),b=getwdn(mu,ru),c=-getwdn(rd,ru),
			dd=-getwdn(md,rd),e=-getwdn(ld,md),f=getwdn(ld,lu),g=getwdn(md,mu);
		if(!deq(a-g+e+f,0,.5))dfs(l,mid,u,d,dep+1);
		if(!deq(b+c+dd+g,0,.5))dfs(mid,r,u,d,dep+1);
	}else{
		extended mid=(u+d)/2;
		compd lu(l,u),ru(r,u),ld(l,d),rd(r,d),lm(l,mid),rm(r,mid);
		extended a=getwdn(lu,ru),b=-getwdn(rm,ru),c=-getwdn(rd,rm),
			dd=-getwdn(ld,rd),e=getwdn(ld,lm),f=getwdn(lm,lu),g=getwdn(lm,rm);
		if(!deq(a+b-g+f,0,.5))dfs(l,r,u,mid,dep+1);
		if(!deq(g+c+dd+e,0,.5))dfs(l,r,mid,d,dep+1);
	}
}
int main(){
	dfs(-10,10,10,-10,0);
	for(auto c:ans)
		printf("%.10Lf%+.10Lfi\n",c.re,c.im);
	return 0;
}
