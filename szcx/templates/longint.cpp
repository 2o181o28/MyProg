struct longint{
	int len,a[10010];
	longint(char *k){
		memset(this,0,sizeof(*this));
		this->len=strlen(k);
		for(int i=0;i<this->len;i++)this->a[this->len-i]=k[i]-48;
	}
	longint(int k=0){
		char s[30];
		sprintf(s,"%d",k);
		(*this)=s;
	}
};
ostream& operator << (ostream &o,longint x){
	for(int i=x.len;i>=1;i--)o<<x.a[i];
	return o;
}
longint operator - (longint a,int b){//b==1
	a.a[1]-=b;
	for(int i=1;i<=a.len;i++)if(a.a[i]<0)
		a.a[i]+=10,a.a[i+1]--;else break;
	if(a.a[a.len]==0)--a.len;
	return a;
}
bool operator <= (longint a,longint b){
	if(a.len!=b.len)return a.len<b.len;
	for(int i=a.len;i;i--)
		if(a.a[i]!=b.a[i])return a.a[i]<b.a[i];
	return true;
}
bool operator < (longint a,longint b){return !(b<=a);}
longint operator + (longint a,longint b){
	longint c;
	if(a.len<b.len)swap(a,b);
	c.len=a.len;
	for(int i=1;i<=a.len;i++)
		c.a[i]+=a.a[i]+b.a[i],
		c.a[i+1]+=c.a[i]/10,c.a[i]%=10;
	if(c.a[c.len+1])++c.len;
	return c;
}
longint operator * (longint a,longint b){//Slow
	longint c;
	for(int i=1;i<=a.len;i++)
		for(int j=1;j<=b.len;j++)
			c.a[i+j-1]+=a.a[i]*b.a[j];
	c.len=a.len+b.len-1;
	for(int i=1;i<=c.len;i++)
		c.a[i+1]+=c.a[i]/10,c.a[i]%=10;
	if(c.a[c.len+1])c.len++;
	return c;
}
longint operator >> (longint a,int b){//b==1
	longint c;int k=0;
	c.len=a.len;
	for(int i=a.len;i;i--)
		c.a[i]=a.a[i]+k*10>>1,
		k=a.a[i]&1;
	if(c.a[c.len]==0)--c.len;
	return c;
}
