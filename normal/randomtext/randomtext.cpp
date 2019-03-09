#include<bits/stdc++.h>
#include<windows.h>
using namespace std;
using ull=uint64_t;
using uch=unsigned char;
using um=unordered_map<int,int>;
uniform_real_distribution<double> u(0,1);
default_random_engine e;
const int k=8;
char s[1<<24];int n,t[1<<24],m;
unordered_map<ull,um> mp;
ull hsh(int l,int r){
	ull re=0;
	for(int i=l;i<=r;i++)re=re*1234567+t[i]+2333;
	return re;
}
int getop(const um&x){
	int tot=0;
	for(auto&pa:x)tot+=pa.second;
	double v=u(e),now=0;
	for(auto&pa:x)if((now+=pa.second*1./tot)>=v)
		return pa.first;
}
int main(){
	freopen("1.txt","r",stdin);
	e.seed(GetTickCount());
	for(char c;~(c=getchar());)
		s[++n]=c;
	for(int i=1;i<=n;)
		if(s[i]<0)
			t[++m]=(uch)s[i]<<16|(uch)s[i+1],i+=2;
		else t[++m]=(uch)s[i++];
	for(int i=k+1;i<=m;i++)
		mp[hsh(i-k,i-1)][t[i]]++;
	for(int i=k+1;i<=10000;i++)
		assert(mp.count(hsh(i-k,i-1))),t[i]=getop(mp[hsh(i-k,i-1)]);
	for(int i=1;i<=10000;i++){
		if(t[i]>>16)printf("%c%c",t[i]>>16,t[i]&65535);
		else printf("%c",t[i]);
	}
	puts("");
	return 0;
}
