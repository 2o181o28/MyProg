#include<bits/stdc++.h>
using namespace std;
using ll=long long;
int n=1e6,m=3e6,bs=100;
int rnd(int x=1e9){return rand()%x+1;}
int main(){
	srand(clock()+time(0));
	printf("%d %d\n",n,m);
	for(int i=2;i<=n;i++)printf("%d %d\n",i%bs?i-1:((i/bs+1)/2-1)*bs+bs-1,i);
	while(m--)if(rand()&1){
		printf("1 %d %d\n",rnd(n),rnd(n));
	}else printf("0 %d %d %d\n",rnd(n),rnd(n),rnd(1e3));
	return 0;
}
