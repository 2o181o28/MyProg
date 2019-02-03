#include<bits/stdc++.h>
#define int64 long long
#define Pi acos(-1)
#define cdecimal const decimal& 
using namespace std;

struct comp{
	double x,y;
	comp operator+(const comp& b)const{return {x+b.x,y+b.y};}
	comp operator-(const comp& b)const{return {x-b.x,y-b.y};}
	comp operator*(const comp& b)const{
		return {x*b.x-y*b.y,x*b.y+y*b.x};
	}
	comp operator/(double b)const{return {x/b,y/b};}
};
comp conj(const comp &x){return comp{x.x,-x.y};}

const int LOG=19,DMAXLEN=(1<<LOG),
	MAXLEN=DMAXLEN>>1,BASE=10000;
const comp C_I{0,1};

int _l,_rev[LOG+2][DMAXLEN];
comp _w[LOG+2][DMAXLEN];

struct decimal{
	int sgn;int64 a[MAXLEN+10];
	decimal(){sgn=1;memset(a,0,sizeof(a));}
}_a,_b,_t;

void print(cdecimal x){
	freopen("pi.txt","w",stdout);
	printf("%lld.",x.sgn*x.a[0]);
	for(int i=1;i<MAXLEN;i++)printf("%04lld",x.a[i]);
	puts(""); 
}

decimal operator + (cdecimal a,cdecimal b);
decimal operator - (cdecimal a){decimal b=a;b.sgn*=-1;return b;}

bool operator < (cdecimal a,cdecimal b){
	if(a.sgn!=b.sgn)return a.sgn<b.sgn;
	if(a.sgn==-1)return (-b)<(-a);
	for(int i=0;i<_l;i++)
		if(a.a[i]!=b.a[i])return a.a[i]<b.a[i];
	return 0;
}

decimal operator - (cdecimal a,cdecimal b){
	if(a.sgn==1 && b.sgn==-1)return a+(-b);
	if(a.sgn==-1 && b.sgn==1)return -(b+(-a));
	if(a.sgn==-1 && b.sgn==-1)return (-b)-(-a);
	if(a<b)return -(b-a);
	decimal c;int64 jw=0;
	for(int i=_l-1;~i;i--){
		c.a[i]=(BASE+a.a[i]-jw-b.a[i])%BASE;
		jw=a.a[i]-jw<b.a[i];
	}
	return c;
}

decimal operator + (cdecimal a,cdecimal b){
	if(a.sgn==1 && b.sgn==-1)return a-(-b);
	if(a.sgn==-1 && b.sgn==1)return b-(-a);
	if(a.sgn==-1 && b.sgn==-1)return -((-b)+(-a));
	decimal c;int64 jw=0;
	for(int i=_l-1;~i;i--){
		c.a[i]=(a.a[i]+b.a[i]+jw)%BASE;
		jw=a.a[i]+b.a[i]+jw>=BASE;
	}
	return c;
}

decimal operator * (cdecimal a,int b){ //a.sgn>0;b>0
	decimal c;int64 jw=0;
	for(int i=_l-1;~i;i--){
		c.a[i]=(a.a[i]*b+jw)%BASE;
		jw=(a.a[i]*b+jw)/BASE;
	}
	return c;
}

decimal operator * (int a,cdecimal b){return b*a;}

decimal operator >>(cdecimal a,int b){ //b=1
	decimal c;c.sgn=a.sgn;
	int64 jw=0;
	for(int i=0;i<_l;i++){
		c.a[i]=(a.a[i]+jw*BASE)>>1;
		jw=(a.a[i]+jw*BASE)&1;
	}
	c.a[_l]=jw*BASE>>1;
	return c;
}

void fft(comp *a,int lg){
	int len=1<<lg,j;
	for(int i=0;i<len;++i)if(i<_rev[lg][i])
		swap(a[i],a[_rev[lg][i]]);
	for(int i=0;i<lg;i++)
		for(j=0;j<len;j+=1<<i+1){
			comp *p=a+j,*q=a+(j|1<<i),r;
			for(int k=0;k<1<<i;k++,q++,p++)
				r=*q*_w[i+1][k],*q=*p-r,*p=*p+r;
		}
}

comp _c1[DMAXLEN],_c2[DMAXLEN];
decimal operator * (cdecimal a,cdecimal b){
	int len=2*_l;
	for(int i=0;i<_l;i++)_c1[i]={(double)a.a[_l-1-i],(double)-b.a[_l-1-i]};
	for(int i=_l;i<len;i++)_c1[i]={};
	fft(_c1,log2(len));
	for(int i=0;i<len;i++){
		comp p=_c1[i],q=conj(_c1[(len-i)&(len-1)]);
		_c2[i]=conj((p+q)*(p-q)/4.0*C_I);
	}
	fft(_c2,log2(len));
	decimal c;c.sgn=a.sgn*b.sgn;
	for(int i=0;i<_l;i++)c.a[i]=_c2[len-i-2].x/len+0.5;
	for(int i=_l-1;i;i--)c.a[i-1]+=c.a[i]/BASE,c.a[i]%=BASE;
	return c;
}

decimal inv(cdecimal x){
	double d=0;
	for(int i=0;i<=4;i++)d+=x.a[i]/pow(BASE,i);
	d=1/d;
	decimal a;a.a[0]=d,a.sgn=x.sgn;
	for(int i=1;i<=4;i++)
		a.a[i]=d=(d-floor(d))*BASE;
	decimal two;two.a[0]=2;
	for(_l=4;_l<=MAXLEN;_l<<=1)
		a=a*(two-x*a);
	_l=MAXLEN;a=a*(two-x*a);
	return a; 
}

decimal operator / (cdecimal a,cdecimal b){return inv(b)*a;}

decimal rsqrt(cdecimal x){
	double d=0;
	for(int i=0;i<=4;i++)d+=x.a[i]/pow(BASE,i);
	d=1/sqrt(d);
	decimal a;a.a[0]=d,a.sgn=x.sgn;
	for(int i=1;i<=4;i++)
		a.a[i]=d=(d-floor(d))*BASE;
	decimal one;one.a[0]=1;
	for(_l=4;_l<=MAXLEN;_l<<=1)
		a=a+(a*(one-x*a*a)>>1);
	_l=MAXLEN;a=a+(a*(one-x*a*a)>>1);
	return a; 
}

void iinit(){
	for(int i=1;i<=LOG;i++)
		for(int j=0;j<(1<<i);j++)
			_rev[i][j]=(_rev[i][j>>1]>>1)|((j&1)<<(i-1)),
			_w[i][j]={cos(-2*Pi*j/(1<<i)),sin(-2*Pi*j/(1<<i))};
	_a.a[0]=1;
	_b.a[0]=2;_b=rsqrt(_b);
	_t.a[0]=0;_t.a[1]=2500;
}

int main(){
	iinit();
	for(int i=1,p=1;i<=LOG;i++,p<<=1){
		decimal olda=_a,diff;
		_l=MAXLEN,_a=(_a+_b)>>1;
		_b=inv(rsqrt(olda*_b));
		_l=MAXLEN,diff=olda-_a;
		_t=_t-diff*p*diff;
		printf("%.2lf%%\n",i*100./LOG);
	}
	_l=MAXLEN,_a=_a+_b;
	print(_a*_a/(4*_t)); 
	return 0;
}
