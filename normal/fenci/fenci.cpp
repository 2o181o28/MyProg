#include<bits/stdc++.h>
#include<sys/time.h>
#define key first
#define value second
#define uch unsigned char
using namespace std;

const int maxw=5000000;
const double minzy=1;
typedef string wd;
typedef int arr[maxw+10];
double minnh;
vector<pair<int,string> > wds;
wd s;char ch,fl[1024];
int i,l,len,maxl;
struct timeVal{int sec,usec;}sTime,eTime;
arr a,posi,rposi,sa,w,c;
map<wd,int> ps;map<wd,double> nhd,zy;

inline wd towd(int l,int r){
	if (posi[l]>rposi[r])
		swap(l,r);
	return '\0'+s.substr(posi[l],rposi[r]-posi[l]+1);
}

void getp(){
	int i,j;
	wd str;
	for(i=1;i<=maxl;i++)
		for(j=1;j<=l-i+1;j++){
			str=towd(j,j+i-1);
			if (!ps.count(str))
				ps[str]=1;
				else ps[str]++;
		}
} 

void getn(){
	int i,len;
	double p1,p2,nh;
	for (auto it=zy.begin();it!=zy.end();++it) {
		p1=ps[it->key]/(double)l;nh=1e100;
		i=1;len=it->key.length()-1;
		if(len==1)continue;
		while (i<=len) {
			if (i>1) {
				p2=(ps['\0'+it->key.substr(1,i-1)]/(double)l)*(ps['\0'+it->key.substr(i,len-i+1)]/(double)l);
				if (p1/p2<nh) nh=p1/p2;
			}
			if ((uch)it->key[i]>127) i+=2; else ++i;
		}
		nhd[it->key]=nh;
	}
}

int cmp(int p1,int p2){
	while (a[p1]==a[p2]&&p1<l&&p2<l) ++p1,++p2;
	return a[p1]<a[p2];
}

void getzy(){
	int i,j,k,f,le,cnt;
	double tzy;
	for(i=1;i<=l;i++)sa[i]=i;
	sort(sa+1,sa+l+1,cmp);
	for(j=2;j<=maxl;j++){
		le=cnt=0;
		for(i=1;i<=l;i++){
			f=1;
			if (i!=l) for(k=0;k<j;k++)
				if ((sa[i]+k>l)||(sa[i+1]+k>l)||(a[sa[i]+k]!=a[sa[i+1]+k]))
					{f=0;break;}
			if (sa[i]+j<=l) {
				++cnt;
				if ((le>0)&&(w[le]==a[sa[i]+j])) ++c[le]; else {
					++le;
					w[le]=a[sa[i]+j];
					c[le]=1;
				}
			} else if (sa[i]+j>l+1) continue;
			if (f==0||i==l) {
				tzy=0;
				for(k=1;k<=le;k++) tzy=tzy-log(c[k]/(double)cnt)*(c[k]/(double)cnt);
				string tmp=towd(sa[i],sa[i]+j-1);
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
	for (auto it=zy.begin();it!=zy.end();++it) {
		string k=it->key;
		if (nhd[k]>l/minnh&&it->value>minzy&&k.find('\n')==string::npos)
			wds.push_back(make_pair(ps[k],k));
	}
}

double getTime(timeVal &a,timeVal &b){
	return b.sec-a.sec+(b.usec-a.usec)/1e6;
}

int main(int argc,char* argv[]){
	if (argc==1) {
		printf("Input max length : ");
		fgets(fl,11,stdin);sscanf(fl,"%d",&maxl);
		printf("File name : ");
		fgets(fl,1024,stdin);
	} else if (argc==2) maxl=10,strcpy(fl,argv[1]);
	  else maxl=atoi(argv[1]),strcpy(fl,argv[2]);
	gettimeofday((timeval*)&stime,NULL);
	freopen(fl,"r",stdin);
	s=(char)0;
	while ((ch=getchar())!=EOF) s=s+ch;
	freopen("con","r",stdin);
	i=1;l=0;int len=s.length()-1;
	while (i<=len) {
		posi[++l]=i;
		if ((uch)s[i]>127)
			a[l]=((uch)s[i]<<8)+s[i+1],rposi[l]=i+1,i+=2;
			else a[l]=s[i]=tolower(s[i]),rposi[l]=i,++i;
	}
	minnh=log10(l)*log10(l)*50-400; 
	if(minnh<400.0)minnh=400.0;
	getp();putchar('*');
	getzy();putchar('*');
	for (i=1;i<=l/2;i++)
		swap(a[i],a[l+1-i]),
		swap(posi[i],posi[l+1-i]),
		swap(rposi[i],rposi[l+1-i]);
	getzy();putchar('*');
	for (i=1;i<=l/2;i++)
		swap(a[i],a[l+1-i]),
		swap(posi[i],posi[l+1-i]),
		swap(rposi[i],rposi[l+1-i]);
	getn();puts("*");
	getwds();
	sort(wds.begin(),wds.end()),reverse(wds.begin(),wds.end());
	for (i=0;i<(int)wds.size();i++) {
		printf("%20s %4d",wds[i].second.substr(1).c_str(),wds[i].first);
		if (i%3==2) puts("");
	}
	gettimeofday((timeval*)&eTime,NULL);
	printf("\nFound %d words. Time used : %.3lf (s)\n",(int)wds.size(),getTime(sTime,eTime));
	getchar();getchar();
	return 0;
}
