#include<stdio.h>
int n,cnt,a,b,c;
void dfs(int d){
	if(d>n){
		cnt++;
		return;
	}
	for(int i=1;i<=n;i++){
		if(!(a>>i&1 |
			b>>i+d&1 |
			c>>i+n-d&1)){
			a|=1<<i,b|=1<<i+d,c|=1<<i+n-d;
			dfs(d+1);
			a^=1<<i,b^=1<<i+d,c^=1<<i+n-d;
		}
	}
}
int main(){
	scanf("%d",&n);
	dfs(1);
	printf("%d\n",cnt);
	return 0;
}
