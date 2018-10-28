#include<bits/stdc++.h>
#define CHG(t) u[r[i][j]]^=(t),u[c[i][j]]^=(t),u[m[i][j]]^=(t)
using namespace std;
int i,j,r[10][10],c[10][10],m[10][10];
int u[30],cnt=0,a[10][10];
char s[100];
int Count(int s){
	int ret=0;
	while(s)ret++,s&=s-1;
	return ret;
}
void dfs(int now){
	int i,j;
	if(now==81){
		for(i=1;i<=9;i++)
			for(j=1;j<=9;j++)
				printf("%d%s",a[i][j],j==9?(i%3?"\n":"\n\n"):(j%3?"":" "));
		system("pause");exit(0);
	}
	int mn=20,mini,minj,mins;
	for(i=1;i<=9;i++)
		for(j=1;j<=9;j++)if(!a[i][j]){
			int s=511^(u[r[i][j]]|u[c[i][j]]|u[m[i][j]]);
			if(Count(s)<mn){
				mn=Count(s);
				if(!mn)return;
				mini=i,minj=j,mins=s;
			}
		}
	for(;mins;mins&=mins-1){
		int t=mins&-mins;
		a[i=mini][j=minj]=log2(t)+1;
		CHG(t);dfs(now+1);CHG(t);
		a[i][j]=0;
	}
}
int main(){
	for(i=1;i<=9;i++){
		gets(s);
		for(j=0;j<9;j++)a[i][j+1]=s[j]=='.'?0:s[j]-48;
	}
	for(i=1;i<=9;i++)
		for(j=1;j<=9;j++){
			r[i][j]=i,c[i][j]=j+9,m[i][j]=19+(i-1)/3*3+(j-1)/3;
			if(a[i][j])CHG(1<<a[i][j]-1),cnt++;
		}
	dfs(cnt);
	return 0;
}

