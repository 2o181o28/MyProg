#include<bits/stdc++.h>
using namespace std;
char getc(){
    static char buf[1<<20],*p1=buf,*p2=buf;
    return p1==p2&&(p2=(p1=buf)+fread(buf,1,1<<20,stdin),p1==p2)?EOF:*p1++;
}
int read(){
	char ch;int r=0;
	do ch=getc();while(!isdigit(ch));
	do r=r*10+ch-48,ch=getc();while(isdigit(ch));
	return r;
}
template<int s> struct vEB{
	int mn=1e9,mx=-1e9;vEB<(s+1)/2> sm;vEB<s/2> cl[1<<(s+1)/2];
	constexpr int high(int x){return x>>s/2;}
	constexpr int low(int x){return x&(1<<s/2)-1;}
	int count(int x){return mn==x||cl[high(x)].count(low(x));}
	int next(int x){
		if(mn<1e9&&x<mn)return mn;
		int ml=cl[high(x)].mx;
		if(low(x)<ml)return high(x)<<s/2|cl[high(x)].next(low(x));
		int nc=sm.next(high(x));
		if(nc<0)return -1;
		return nc<<s/2|cl[nc].mn;
	}
	int prev(int x){
		if(mx>-1e9&&x>mx)return mx;
		int ml=cl[high(x)].mn;
		if(low(x)>ml)return high(x)<<s/2|cl[high(x)].prev(low(x));
		int pc=sm.prev(high(x));
		if(pc<0)return x>mn?mn:-1;
		return pc<<s/2|cl[pc].mx;
	}
	void ins(int x){
		if(mn==1e9){mn=mx=x;return;}
		if(x<mn)swap(x,mn);
		if(cl[high(x)].mn==1e9){
			sm.ins(high(x));cl[high(x)].mn=cl[high(x)].mx=low(x);
		}else cl[high(x)].ins(low(x));
		if(x>mx)mx=x;
	}
	void del(int x){
		if(mn==mx){mn=1e9,mx=-1e9;return;}
		if(x==mn)mn=x=sm.mn<<s/2|cl[sm.mn].mn;
		cl[high(x)].del(low(x));
		if(cl[high(x)].mn==1e9){
			sm.del(high(x));
			if(x==mx)mx=sm.mn==1e9?mn:sm.mx<<s/2|cl[sm.mx].mx;
		}else if(x==mx)mx=high(x)<<s/2|cl[high(x)].mx;
	}
};
template<> struct vEB<1>{
	int mn=1e9,mx=-1e9;
	int count(int x){return mn==x||mx==x;}
	int next(int x){return x<mx?mx:-1;}
	int prev(int x){return x>mn?mn:-1;}
	void ins(int x){mn=min(mn,x),mx=max(mx,x);}
	void del(int x){if(mn==mx)mn=1e9,mx=-1e9;else mn=mx=x^1;}
};
vEB<24> s;int n;string st;
int main(){
	scanf("%d",&n);
	for(int i=1;i<=n;i++){
		char op;int x;do op=getc();while(!isalpha(op));
		x=read();
		if(op=='I')s.ins(x);
		if(op=='D')s.del(x);
		if(op=='C')st+=to_string(s.count(x))+'\n';
		if(op=='P')st+=to_string(s.prev(x))+'\n';
		if(op=='N')st+=to_string(s.next(x))+'\n';
	}
	fputs(st.data(),stdout);
	return 0;
}
