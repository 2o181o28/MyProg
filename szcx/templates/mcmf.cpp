#define pa pair<int,int>
#define maxn 50010
#define inf 1e9
using namespace std;
struct edge{int v,cap,w;};
struct MCMF{
	int n,s,t,p[maxn],dis[maxn],inq[maxn],que[maxn*30];
	vector<int> v[maxn];
	vector<edge> e;
	void Init(int n){
		this->n=n;e.clear();
		for(int i=0;i<n;i++)v[i].clear();
	}
	void addEdge(int x,int y,int cap,int cost){
		e.insert(e.end(),{{y,cap,cost},{x,0,-cost}});
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
		for(int x=t;~p[x];x=e[p[x]^1].v)flw=min(flw,e[p[x]].cap);
		for(int x=t;~p[x];x=e[p[x]^1].v)e[p[x]].cap-=flw,e[p[x]^1].cap+=flw;
		return make_pair(flw,flw*dis[t]);
	}
	pa minCost(int s,int t){
		this->s=s;this->t=t;
		int flw=0,cst=0;pa p;
		while((p=SSSP()).first)
			flw+=p.first,cst+=p.second;
		return make_pair(flw,cst);
	}
}sol;

//dijkstra
struct MCMF{
	struct edge{int v,cap;ll w;};
	vector<edge> e;vector<int> v[maxn];
	ll dis[maxn],h[maxn];
	__gnu_pbds::priority_queue<pa,greater<pa>> pq;
	int inq[maxn],p[maxn],que[1<<20],vis[maxn],s,t;
	void addEdge(int x,int y,int cap,ll w=0){
		e.insert(e.end(),{{y,cap,w},{x,0,-w}});
		v[x].push_back(e.size()-2);
		v[y].push_back(e.size()-1);
	}
	void spfa(){
		memset(h,0x3f,sizeof h);
		int l=1,r=1;que[1]=s;h[s]=0;
		while(l<=r){
			int now=que[l++];inq[now]=0;
			for(int i:v[now])if(e[i].cap&&h[now]+e[i].w<h[e[i].v]){
				h[e[i].v]=h[now]+e[i].w;
				if(!inq[e[i].v])inq[e[i].v]=1,que[++r]=e[i].v;
			}
		}
	}
	pa dij(){
		memset(dis,0x3f,sizeof dis);
		memset(vis,0,sizeof vis);
		memset(p,-1,sizeof p);
		dis[s]=0;pq.push({0,s});
		while(pq.size()){
			auto[d,now]=pq.top();pq.pop();
			if(vis[now])continue;vis[now]=1;
			for(int i:v[now])if(e[i].cap&&d+e[i].w+h[now]-h[e[i].v]<dis[e[i].v])
				p[e[i].v]=i,pq.push({dis[e[i].v]=d+e[i].w+h[now]-h[e[i].v],e[i].v});
		}
		if(dis[t]>1e18)return{};
		int f=1e9,cst=dis[t]+h[t];
		for(int x=t;~p[x];x=e[p[x]^1].v)f=min(f,e[p[x]].cap);
		for(int x=t;~p[x];x=e[p[x]^1].v)e[p[x]].cap-=f,e[p[x]^1].cap+=f;
		for(int i=0;i<maxn;i++)h[i]=min(1ll<<60,h[i]+dis[i]);
		return {f,cst*f};
	}
	ll minCost(int s,int t){
		this->s=s,this->t=t;
		pa p;ll sm=0,mn=0;spfa();
		while((p=dij()).first)if((sm+=p.second)<=mn)mn=sm;else break;
		return mn;
	}
}sol;
