// 绘制Newton分形。
// 使用的问题来自清华的数值分析课程作业。这个作业提供了两种naive的迭代方式，要我们使用steffensen加速
// 代码里绘制的是正宗的牛顿迭代产生的分形。很容易把它改成绘制迭代psi_1或psi_2产生的分形。
#include<bits/stdc++.h>
using namespace std;
using cmp=complex<double>;
const double mx=4,eps=1e-10;

const int red[]={0xB71C1C,0xC62828,0xD32F2F,0xE53935,0xF44336,0xEF5350,0xE57373,0xEF9A9A,0xFFCDD2},
	green[]={0x1B5E20,0x2E7D32,0x388E3C,0x43A047,0x4CAF50,0x66BB6A,0x81C784,0xA5D6A7,0xC8E6C9},
	blue[]={0x0D47A1,0x1565C0,0x1976D2,0x1E88E5,0x2196F3,0x42A5F5,0x64B5F6,0x90CAF9,0xBBDEFB};
const cmp w=(-1.+sqrt(3)*1i)/2.;
int n=1000;

cmp phi_1(cmp x){return (20.-2.*x*x-x*x*x)/10.;}
cmp phi_2(cmp x){
	cmp v=pow(20.-10.*x-2.*x*x,1./3),u=v;
	for(cmp b:{w*v,w*w*v})if(abs(x-u)>abs(x-b))u=b;
	return u;
}

auto steffensen(auto phi){
	return [=](cmp x){
		return x-(phi(x)-x)*(phi(x)-x)/(phi(phi(x))-2.*phi(x)+x);
	};
}

auto psi_1=steffensen(phi_1);
auto psi_2=steffensen(phi_2);

int calc(cmp x){
	for(int t=0;t<50;t++){
		//x=psi_2(x);
		x-=(x*x*x+2.*x*x+10.*x-20.)/(3.*x*x+4.*x+10.);
		if(abs(x*x*x+2.*x*x+10.*x-20.)<=eps){
			int c=clamp(t/2,0,8);
			return x.real()<0?x.imag()>0?red[c]:green[c]:blue[c];
		}
	}
	return 0x000000;
}
int main(){
	FILE *f=fopen("newton_fractal.ppm","wb");
	fprintf(f,"P6\n%d %d\n255\n",n,n);
	for(int i=0;i<n;i++)for(int j=0;j<n;j++){
		cmp p=2*mx*j/n-mx+(mx-2*mx*i/n)*1i;
		int clr=calc(p);
		fputc(clr>>16,f);fputc((clr>>8)&255,f);fputc(clr&255,f);
	}
	return 0;
}
