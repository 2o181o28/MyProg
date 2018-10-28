#pragma GCC optimize("Ofast")
#include<bits/stdc++.h>
#define int64 long long
#define comp complex<double>
#define Pi acos(-1)
using namespace std;

const int LOG=19,DMAXLEN=(1<<LOG),
	MAXLEN=DMAXLEN>>1,BASE=10000;
const comp C_I(0,1);
	
int _DEBUG=0;
int _l,_rev[LOG+2][DMAXLEN],_pow10[9];
comp _w[LOG+2][DMAXLEN];

struct decimal{
	int sgn,intt;int64 a[MAXLEN+10];
	decimal(){sgn=1;intt=0;memset(a,0,sizeof(int64)*(MAXLEN+1));}
}_a,_b,_t;

void print(decimal x){
	freopen("pi.txt","w",stdout);
	printf("%d.",x.sgn*x.intt);
	for(int i=1;i<=MAXLEN;i++)printf("%04lld",x.a[i]);
	puts(""); 
}

decimal operator + (decimal a,decimal b);
decimal operator - (decimal a){decimal b=a;b.sgn*=-1;return b;}

bool operator < (decimal a,decimal b){
	if(a.sgn!=b.sgn)return a.sgn<b.sgn;
	if(a.sgn==-1)return (-b)<(-a);
	if(a.intt!=b.intt)return a.intt<b.intt;
	for(int i=1;i<=_l;i++)
		if(a.a[i]!=b.a[i])return a.a[i]<b.a[i];
	return 0;
}

decimal operator - (decimal a,decimal b){
	if(a.sgn==1 && b.sgn==-1)return a+(-b);
	if(a.sgn==-1 && b.sgn==1)return -(b+(-a));
	if(a.sgn==-1 && b.sgn==-1)return (-b)-(-a);
	if(a<b)return -(b-a);
	decimal c;
	int64 jw=0;
	for(int i=_l;i;i--){
		c.a[i]=(BASE+a.a[i]-jw-b.a[i])%BASE;
		jw=a.a[i]-jw<b.a[i];
	}
	c.intt=a.intt-b.intt-jw;
	return c;
}

decimal operator + (decimal a,decimal b){
	if(a.sgn==1 && b.sgn==-1)return a-(-b);
	if(a.sgn==-1 && b.sgn==1)return b-(-a);
	if(a.sgn==-1 && b.sgn==-1)return -((-b)+(-a));
	decimal c;
	int64 jw=0;
	for(int i=_l;i;i--){
		c.a[i]=(a.a[i]+b.a[i]+jw)%BASE;
		jw=a.a[i]+b.a[i]+jw>=BASE;
	}
	c.intt=a.intt+b.intt+jw;
	return c;
}

decimal operator * (decimal a,int b){ //a.sgn>0;b>0
	decimal c;
	int64 jw=0;
	for(int i=_l;i;i--){
		c.a[i]=(a.a[i]*b+jw)%BASE;
		jw=(a.a[i]*b+jw)/BASE;
	}
	c.intt=a.intt*b+jw;
	return c;
}

decimal operator * (int a,decimal b){return b*a;}

decimal operator >>(decimal a,int b){ //b=1
	decimal c;
	c.intt=a.intt>>1;c.sgn=a.sgn;
	int64 jw=a.intt&1;
	for(int i=1;i<=_l;i++){
		c.a[i]=(a.a[i]+jw*BASE)>>1;
		jw=(a.a[i]+jw*BASE)&1;
	}
	c.a[_l+1]=jw*BASE>>1;
	return c;
}

int toarr(decimal a,int64 *c,int &Flen){
	for(int i=_l;i;i--)c[_l-i]=a.a[i];
	for(int i=DMAXLEN-1;i>=_l;i--)c[i]=0;
	c[_l]=a.intt;
	if(_l==MAXLEN && a.intt){
		int sf=log10(a.intt)+1,pow1=_pow10[4-sf],pow2=_pow10[sf]; 
		for(int i=0;i<_l-1;i++)
			c[i]=c[i]/pow2+c[i+1]%pow2*pow1;
		c[_l-1]=c[_l-1]/pow2+a.intt*pow1;
		c[_l]=0;Flen=(_l<<2)-sf;
		return MAXLEN;
	}else{
		Flen=_l<<2;
		return _l+(a.intt!=0);
	}
}

int64 _r[DMAXLEN];
decimal todecimal(int64 *r,int Flen,int sgn){
	decimal a;a.sgn=sgn;
	int l=(Flen>>2)+1;
	if(l>DMAXLEN)l=DMAXLEN;
	for(int i=0;i<l;i++){
		if(i<l-1)r[i+1]+=r[i]/BASE; 
		r[i]%=BASE;
	}
	for(int i=min((l<<2)-1,Flen+8);i>=Flen;i--)
		a.intt=a.intt*10+r[i>>2]/_pow10[i&3]%10;
	int tot=0,i,pow1=_pow10[1+((Flen-1)&3)],pow2=_pow10[3-((Flen-1)&3)];
	for(i=Flen-1;i>2;i-=4){
		if(++tot>MAXLEN)break;
		a.a[tot]=r[i>>2]%pow1*pow2;
		if(Flen&3)a.a[tot]+=r[(i>>2)-1]/pow1;
	}
	if(tot<MAXLEN && i>=0)
		a.a[++tot]=*r%pow1*pow2;
	return a;
}

int _h[DMAXLEN];
void fft(comp *a,int lg){
	int x,len=1<<lg;comp tmp;
	memset(_h,0,sizeof(int)*len);
    for(int i=0;i<len;++i)if(!_h[i])
		_h[x=_rev[lg][i]]=1,
		tmp=a[i],a[i]=a[x],a[x]=tmp;
    int t=1;
    for(int i=1;i<=lg;++i){
    	memset(_h,0,sizeof(int)*len);
        for(int j=0;j<len;++j)if(!_h[j]){
        	x=t^j;
        	a[x]*=_w[lg][(x&((1<<(i-1))-1))<<(lg-i)];
            tmp=a[j]+a[x];
            a[x]=a[j]-a[x];
            a[j]=tmp;_h[x]=1;
    	}
        t<<=1;
	}
}

int64 _r1[DMAXLEN],_r2[DMAXLEN];
comp _c1[DMAXLEN],_c2[DMAXLEN];
decimal operator * (decimal a,decimal b){
	int len1,len2,len=ceil(log2(toarr(a,_r1,len1)+toarr(b,_r2,len2)));
	for(int i=0;i<(1<<len);i++)_c1[i]=comp(_r1[i],-_r2[i]);
	fft(_c1,len);
	for(int i=0;i<(1<<len);i++){
		comp p=_c1[i],q=conj(_c1[((1<<len)-i)%(1<<len)]);
		_c2[i]=conj((p+q)*(p-q)/4.0*C_I);
	}
	fft(_c2,len);len=1<<len;
	for(int i=0;i<len;i++)_r[i]=_c2[i].real()/len+0.5;
	if(len<DMAXLEN)_r[len]=0;
	return todecimal(_r,len1+len2,a.sgn*b.sgn);
}

decimal inv(decimal x){
	double d=x.intt;
	for(int i=1;i<=4;i++)d+=x.a[i]/pow(BASE,i);
	d=1/d;
	decimal a;a.intt=d,a.sgn=x.sgn;
	for(int i=1;i<=4;i++)
		a.a[i]=d=(d-floor(d))*BASE;
	decimal two;two.intt=2;
	for(_l=2;_l<=MAXLEN;_l<<=1)
		a=a*(two-x*a);
	_l=MAXLEN;a=a*(two-x*a);
	return a; 
}

decimal operator / (decimal a,decimal b){return inv(b)*a;}

decimal rsqrt(decimal x){
	double d=x.intt;
	for(int i=1;i<=4;i++)d+=x.a[i]/pow(BASE,i);
	d=1/sqrt(d);
	decimal a;a.intt=d,a.sgn=x.sgn;
	for(int i=1;i<=4;i++)
		a.a[i]=d=(d-floor(d))*BASE;
	decimal one;one.intt=1;
	for(_l=2;_l<=MAXLEN;_l<<=1)
		a=a+(a*(one-x*a*a)>>1);
	_l=MAXLEN;a=a+(a*(one-x*a*a)>>1);
	return a; 
} 

void init(){
	_pow10[0]=1;
	for(int i=1;i<9;i++)_pow10[i]=_pow10[i-1]*10;
	for(int i=1;i<=LOG;i++)
		for(int j=0;j<(1<<i);j++)
			_rev[i][j]=(_rev[i][j>>1]>>1)|((j&1)<<(i-1)),
			_w[i][j]=comp(cos(-2*Pi*j/(1<<i)),sin(-2*Pi*j/(1<<i)));
	_a.intt=1;
	_b.intt=2;_b=rsqrt(_b);
	_t.intt=0;_t.a[1]=2500;
}

int main(){
	init();
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

