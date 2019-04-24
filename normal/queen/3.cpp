#include<stdio.h>
int n,cnt,a[30],b[30],c[30];
void dfs(int d){
	if(d>n){
		cnt++;
		return;
	}
	for(int i=1;i<=n;i++){
		if(a[i]==0 && 
			b[i+d]==0 && 
			c[i+n-d]==0){
			a[i]=b[i+d]=c[i+n-d]=1;
			dfs(d+1);
			a[i]=b[i+d]=c[i+n-d]=0;
		}
	}
}
int main(){
	scanf("%d",&n);
	dfs(1);
	printf("%d\n",cnt);
	return 0;
}
