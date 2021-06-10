#include<bits/stdc++.h>
#define re real()
#define im imag()
using namespace std;
using ld=long double;
using cmp=complex<ld>;
const ld eps=1e-13,B=10;
uniform_real_distribution U(0.5-1e-3,0.5+1e-3);
default_random_engine E(clock()+time(0));
vector<cmp> ans;
/*cmp F(cmp x){return exp(x)*x-pow(x,5)+3.l*pow(x,2)-1.l;}
cmp diff_F(cmp x){return exp(x)*(x+1.l)-5.l*pow(x,4)+6.l*x;}*/
cmp F(cmp x){return pow(x,100)-2.l*pow(x,37)+137.l;}
cmp diff_F(cmp x){return 100.l*pow(x,99)-74.l*pow(x,36);}
cmp G(cmp x){return diff_F(x)/F(x);}
// Im(int F'(z)/F(z) dz)
int nonz(cmp x){return abs(x)>1;}
ld S(cmp st,cmp ed,cmp lv,cmp rv,cmp md){
	return ((lv+4.l*md+rv)/6.l*(ed-st)).im;
}
ld asr(cmp st,cmp ed,cmp lv,cmp rv,cmp md,ld Sv){
	cmp mdp=(st+ed)/2.l;
	cmp v1=G((st+mdp)/2.l),v2=G((mdp+ed)/2.l);
	ld sl=S(st,mdp,lv,md,v1),sr=S(mdp,ed,md,rv,v2);
	if(abs(sl+sr-Sv)<15e-3)return sl+sr+(sl+sr-Sv)/15.l;
	return asr(st,mdp,lv,md,v1,sl)+asr(mdp,ed,md,rv,v2,sr);
}
ld getwdn(cmp st,cmp ed){
	ld t=S(st,ed,G(st),G(ed),G((st+ed)/2.l));
	return asr(st,ed,G(st),G(ed),G((st+ed)/2.l),t);
}
void dfs(ld l,ld r,ld u,ld d,int dep){
	if(r-l<eps && u-d<eps){
		cmp x((l+r)/2,(u+d)/2);
		for(cmp c:ans)if(abs(x-c)<1e-6)return;
		ans.push_back(x);return;
	}
	if(dep&1){
		ld mid=l+(r-l)*U(E);
		cmp lu(l,u),mu(mid,u),ru(r,u),ld(l,d),rd(r,d),md(mid,d);
		auto a=getwdn(lu,mu),b=getwdn(mu,ru),c=-getwdn(rd,ru),
			dd=-getwdn(md,rd),e=-getwdn(ld,md),f=getwdn(ld,lu),g=getwdn(md,mu);
		if(nonz(a-g+e+f))dfs(l,mid,u,d,dep+1);
		if(nonz(b+c+dd+g))dfs(mid,r,u,d,dep+1);
	}else{
		ld mid=u+(d-u)*U(E);
		cmp lu(l,u),ru(r,u),ld(l,d),rd(r,d),lm(l,mid),rm(r,mid);
		auto a=getwdn(lu,ru),b=-getwdn(rm,ru),c=-getwdn(rd,rm),
			dd=-getwdn(ld,rd),e=getwdn(ld,lm),f=getwdn(lm,lu),g=getwdn(lm,rm);
		if(nonz(a+b-g+f))dfs(l,r,u,mid,dep+1);
		if(nonz(g+c+dd+e))dfs(l,r,mid,d,dep+1);
	}
}
int main(){
	dfs(-B,B,B,-B,0);
	printf("cnt=%zu\n",ans.size());
	for(cmp c:ans)
		printf("x=%.10Lf%+.10Lfi\tabs(f(x))=%.10Lf\n",c.re,c.im,abs(F(c)));
	return 0;
}
