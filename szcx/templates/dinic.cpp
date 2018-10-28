struct edge{int u,v,cap;};
struct Dinic{
	vector<edge> e;
	vector<int> v[maxn];
	int s,t,dis[maxn],que[maxn],cur[maxn];
	void AddEdge(int x,int y,int cap=1){
		e.push_back(edge{x,y,cap});
		e.push_back(edge{y,x,0});
		v[x].push_back(e.size()-2);
		v[y].push_back(e.size()-1);
	}
	int bfs(){
		memset(dis,0x3f,sizeof dis);
		int l=1,r=1;que[1]=s;dis[s]=0;
		while(l<=r){
			int now=que[l++],to;
			for(int i:v[now])if(e[i].cap && dis[to=e[i].v]>1e9)
				dis[to]=dis[now]+1,que[++r]=to;
		}
		return dis[t]<1e9;
	}
	int dfs(int p,int a){
		if(p==t || !a)return a;
		int fl=0,f;
		for(int &i=cur[p],to;i<(int)v[p].size();i++){
			edge &E=e[v[p][i]];
			if(dis[to=E.v]==dis[p]+1 && (f=dfs(to,min(a,E.cap)))){
				E.cap-=f,e[v[p][i]^1].cap+=f;a-=f,fl+=f;
				if(!a)break;
			}
		}
		return fl;
	}
	int dinic(int s,int t){
		this->s=s,this->t=t;
		int f=0;
		while(bfs())
			memset(cur,0,sizeof cur),
			f+=dfs(s,1e9);
		return f;
	}
}sol;
