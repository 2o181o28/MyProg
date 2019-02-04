#include<bits/stdc++.h> 
#include<windows.h>
using namespace std;

const int maxw=5000000;
const double minzy=1;
using uch=unsigned char;
using arr=int[maxw+10];
double minnh;
struct st{int a;string b;};vector<st> wds;
string s;char *f,fl[1024];
int l,maxl;
arr a,posi,rposi,sa,w,c;
map<string,int> ps;map<string,double> nhd,zy;

inline string tostring(int l,int r){
	if (posi[l]>rposi[r])swap(l,r);
	return '\0'+s.substr(posi[l],rposi[r]-posi[l]+1);
}

void getp(){
	for(int i=1;i<=maxl;i++)
		for(int j=1;j<=l-i+1;j++)
			ps[tostring(j,j+i-1)]++;
} 

void getn(){
	for(auto p:zy){
		string key=p.first;
		double p1=ps[key]/(double)l,p2,nh=1e100;
		int len=key.size()-1;
		if(len==1)continue;
		for(int i=1;i<=len;){
			if(i>1){
				p2=(ps['\0'+key.substr(1,i-1)]/(double)l)*(ps['\0'+key.substr(i,len-i+1)]/(double)l);
				nh=min(nh,p1/p2);
			}
			if((uch)key[i]>127)i+=2;else ++i;
		}
		nhd[key]=nh;
	}
}

void getzy(){
	for(int i=1;i<=l;i++)sa[i]=i;
	sort(sa+1,sa+l+1,[&](int p1,int p2){
		while (a[p1]==a[p2]&&p1<l&&p2<l) ++p1,++p2;
		return a[p1]<a[p2];
	});
	for(int j=2;j<=maxl;j++){
		int le=0,cnt=0;
		for(int i=1;i<=l;i++){
			int f=1;
			if(i!=l)for(int k=0;k<j;k++)
				if (sa[i]+k>l||sa[i+1]+k>l||a[sa[i]+k]!=a[sa[i+1]+k])
					{f=0;break;}
			if(sa[i]+j<=l){
				++cnt;
				if(le>0 && w[le]==a[sa[i]+j])++c[le];else
					w[++le]=a[sa[i]+j],c[le]=1;
			}else if(sa[i]+j>l+1)continue;
			if (!f||i==l){
				double tzy=0;
				for(int k=1;k<=le;k++)tzy-=log(c[k]/(double)cnt)*(c[k]/(double)cnt);
				string tmp=tostring(sa[i],sa[i]+j-1);
				if(!zy.count(tmp))zy[tmp]=tzy;else{
					double &d=zy[tmp];d=min(d,tzy);
					if(d<=minzy)zy.erase(tmp);
				}
				le=cnt=0;
			}
		}
	}
}

void getwds(){
	for(auto pa:zy){
		string k=pa.first;
		if (ps[k]>=3 && nhd[k]>l/minnh&&pa.second>minzy&&!~k.find('\n'))
			wds.push_back({ps[k],k});
	}
}

int main(int argc,char* argv[]){
	system("chcp 936");system("cls");
	if (argc==1) {
		f=(char*)malloc(1024);
		printf("Input max length : ");
		fgets(f,11,stdin);sscanf(f,"%d",&maxl);
		printf("File name : ");
		fgets(f,1024,stdin);
	} else if (argc==2) maxl=10,f=argv[1];
	  else maxl=atoi(argv[1]),f=argv[2];
	for(int i=0,l=0;(uch)f[i]>31;i++)
		if(f[i]=='\\')fl[l]=fl[l+1]='\\',l+=2;else fl[l++]=f[i];
	DWORD stime=GetTickCount();
	freopen(fl,"r",stdin);
	s='\0';
	for(char ch;(ch=getchar())!=EOF;)s+=ch;
	freopen("con","r",stdin);
	for(int i=1;i<(int)s.size();){
		posi[++l]=i;
		if ((uch)s[i]>127)
			a[l]=(uch)s[i]<<8|s[i+1],rposi[l]=i+1,i+=2;
			else a[l]=s[i]=tolower(s[i]),rposi[l]=i,++i;
	}
	minnh=max(log10(l)*log10(l)*50-400,400.0);
	getp();putchar('*');
	for(int t:{0,1}){
		getzy();putchar('*');
		reverse(a+1,a+1+l),reverse(posi+1,posi+1+l),reverse(rposi+1,rposi+1+l);
	}
	getn();puts("*");
	getwds();
	sort(wds.begin(),wds.end(),[](st a,st b){return a.a>b.a;});
	for(int i=0;i<(int)wds.size();i++){
		printf("%20s %4d",wds[i].b.data()+1,wds[i].a);
		if (i%3==2) puts("");
	}
	printf("\nFound %zu words. Time used : %.3lf (s)\n",wds.size(),(GetTickCount()-stime)/1000.0);
	getchar();getchar();
	return 0;
}
