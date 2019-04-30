#include<bits/stdc++.h>
using namespace std;
using ll=long long;
int n=1e7;
set<int> s;
int rnd(int x=1e9){return rand()%x+1;}
int getn(){
	auto it=s.lower_bound(rand()&(1<<24)-1);
	if(it!=s.end())return *it;
	return *s.begin();
}
int gtnm(){
	int t;do t=rand()&(1<<24)-1; while(s.count(t));return t;
}
int main(){
	srand(clock()+time(0));
	printf("%d\n",n);
	for(int i=1;i<=n;i++){
		int t;
		if(!s.size()||rnd(3)==1)printf("I %d\n",t=gtnm()),s.insert(t);else{
			int f=rnd(3);
			if(f==2)printf("%c %d\n",f==1?'P':'N',rand()&(1<<24)-1);
			if(f==3)printf("C %d\n",rand()&1?getn():rand()&(1<<24)-1);
			if(f==1)printf("D %d\n",t=getn()),s.erase(t);
		}
	}
	return 0;
}
