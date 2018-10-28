vector<int> v[maxn];
int S,n,m,mn,rt,c[maxn],vis[maxn],dffa[maxn];
int R,siz[maxn],fa[maxn][20],dep[maxn];
void getroot(int p,int fa){
    siz[p]=1;int mx=-1;
    for(int i:v[p])if(!vis[i] && i!=fa)
        getroot(i,p),siz[p]+=siz[i],mx=max(mx,siz[i]);
    mx=max(mx,S-siz[p]);
    if(mx<mn)mn=mx,rt=p;
}
void buildtr(int p){
    vis[p]=1;getroot(p,-1);
    for(int i:v[p])if(!vis[i]){
        S=siz[i];mn=1e9;
        getroot(i,-1);
        dffa[rt]=p;
        buildtr(rt);
    }
}
