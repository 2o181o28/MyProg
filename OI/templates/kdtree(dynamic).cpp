struct kdtree{
    struct po{
        int x[2];
    }b[maxn];
    struct node{
        int x[2],ch[2],sz,mn[2],mx[2];
    }a[maxn];
    int tot,rt,cc[maxn],top,_mn,x,y;
    kdtree(){a[0].mn[0]=a[0].mn[1]=5e8;}
    inline int alloc(){return top?cc[--top]:++tot;}
    inline void freenod(int p){cc[top++]=p;}
    inline int dis(int p){
        return abs(a[p].x[0]-x)+abs(a[p].x[1]-y);
    }
    inline int gdis(int p){
        return max(0,x-a[p].mx[0])+max(0,a[p].mn[0]-x)+
            max(0,y-a[p].mx[1])+max(0,a[p].mn[1]-y);
    }
    inline void up(int p){
        a[p].sz=a[L(p)].sz+a[R(p)].sz+1;
        for(int i=0;i<2;i++)
            a[p].mn[i]=min(min(a[L(p)].mn[i],a[R(p)].mn[i]),a[p].x[i]),
            a[p].mx[i]=max(max(a[L(p)].mx[i],a[R(p)].mx[i]),a[p].x[i]);
    }
    void rebuild(int l,int r,int f,int &p){
        if(l==r)return;
        int mid=l+r>>1;
        nth_element(b+l,b+mid,b+r,[f](po a,po b){return a.x[f]<b.x[f];});
        p=alloc();
        a[p].x[0]=b[mid].x[0],a[p].x[1]=b[mid].x[1];
        L(p)=R(p)=0;
        rebuild(l,mid,f^1,L(p));
        rebuild(mid+1,r,f^1,R(p));
        up(p);
    }
    void dfs(int p,int nm,int f){
        if(!p)return;
        dfs(L(p),nm,f^1);
        int l=a[L(p)].sz+nm;
        b[l].x[0]=a[p].x[0],b[l].x[1]=a[p].x[1];
        dfs(R(p),l+1,f^1);
        freenod(p);
    }
    void add(po t,int &p,int f=0){
        if(!p){
            p=alloc();L(p)=R(p)=0;
            a[p].x[0]=t.x[0],a[p].x[1]=t.x[1];
            up(p);return;
        }
        add(t,a[p].ch[t.x[f]>a[p].x[f]],f^1);
        up(p);
        if(max(a[L(p)].sz,a[R(p)].sz)>0.75*a[p].sz)
            dfs(p,0,f),rebuild(0,a[p].sz,f,p);
    }
    void qry(int p=1,int f=0){
        if(!p)return;
        _mn=min(_mn,dis(p));
        int d1=gdis(L(p)),d2=gdis(R(p));
        if(d1>d2){
            if(d2<_mn)qry(R(p),f^1);
            if(d1<_mn)qry(L(p),f^1);
        }else{
            if(d1<_mn)qry(L(p),f^1);
            if(d2<_mn)qry(R(p),f^1);
        }
    }
    int query(int a,int b){_mn=1e9,x=a,y=b;qry();return _mn;}
}tr;
