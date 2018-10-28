#define pa pair<int,int>
#define maxn 50010
#define inf 1e9
using namespace std;
struct edge{
	int u,v,cap,w;
};
struct MCMF{
	int n,s,t,p[maxn],dis[maxn],inq[maxn],que[maxn*30];
	vector<int> v[maxn];
	vector<edge> e;
	void Init(int n){
		this->n=n;e.clear();
		for(int i=0;i<n;i++)v[i].clear();
	}
	void AddEdge(int x,int y,int cap,int cost){
		e.push_back(edge{x,y,cap,cost});
		e.push_back(edge{y,x,0,-cost});
		v[x].push_back(e.size()-2);
		v[y].push_back(e.size()-1);
	}
	pa SSSP(){
		memset(dis,0x3f,sizeof dis);
		memset(inq,0,sizeof inq);
		memset(p,-1,sizeof p);
		dis[s]=0;que[1]=s;
		int l=1,r=1;
		while(l<=r){
			int to,now=que[l++];
			inq[now]=0;
			for(int i:v[now])if(e[i].cap && dis[now]+e[i].w<dis[to=e[i].v]){
				dis[to]=dis[now]+e[i].w;p[to]=i;
				if(!inq[to])inq[to]=1,que[++r]=to;
			}
		}
		if(dis[t]>inf)return make_pair(0,0);
		int flw=inf;
		for(int x=t;~p[x];x=e[p[x]].u)flw=min(flw,e[p[x]].cap);
		for(int x=t;~p[x];x=e[p[x]].u)e[p[x]].cap-=flw,e[p[x]^1].cap+=flw;
		return make_pair(flw,flw*dis[t]);
	}
	pa MinCost(int s,int t){
		this->s=s;this->t=t;
		int flw=0,cst=0;pa p;
		while((p=SSSP()).first)
			flw+=p.first,cst+=p.second;
		return make_pair(flw,cst);
	}
}sol;
