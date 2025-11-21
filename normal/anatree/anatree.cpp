// Anatree的实现，用于查询anagram中可能出现的单词
// 可以比较各种字母排列顺序的效率差别
// 为了清华的计算思维课程project编写的
#include<bits/stdc++.h>
using namespace std;
using ll=long long;

const char* freq_str="ETAONRISHDLFCMUGYPWBVKJXZQ";
int freq_rnk[26];

char s[1010];
int cnt[26],nod;

struct trie{
	struct node{
		int ch[30];
		vector<string> v;
	}a[1<<20];
	int rt,tot;
	void ins(string_view s,int *cnt,int pos,int &p){
		if(!p)p=++tot;
		if(pos==26){
			a[p].v.push_back(string{s});
			return;
		}
		ins(s,cnt+1,pos+1,a[p].ch[*cnt]);
	}
	void ins(string_view s,int *cnt){ins(s,cnt,0,rt);}
	void qry(int *cnt,int pos,int p){
		if(!p)return;
		nod++;
		if(pos==26){
			for(auto&s:a[p].v) cout<<s<<"\n";
			return;
		}
		for(int k=0;k<=*cnt;k++)qry(cnt+1,pos+1,a[p].ch[k]);
	}
	void qry(int *cnt){qry(cnt,0,rt);}
}tr;

int main(){
	for(int i=0;freq_str[i];i++)freq_rnk[freq_str[i]-'A']=25-i;

	freopen("/usr/share/dict/american-english","r",stdin);
	while(fgets(s,1000,stdin)){
		for(int n=strlen(s);n&&s[n-1]<32;s[--n]=0);
		memset(cnt,0,sizeof cnt);
		for(int i=0;s[i];i++){
			if(!isalpha(s[i]))goto fail;
			cnt[freq_rnk[tolower(s[i])-'a']]++;
		}
		tr.ins(s,cnt);
		fail:;
	}
	memset(cnt,0,sizeof cnt);
	for(char c:"implementation")c&&cnt[freq_rnk[c-'a']]++;
	tr.qry(cnt);
	printf("%d\n",nod);
	return 0;
}
