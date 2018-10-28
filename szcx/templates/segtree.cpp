struct SegmentTree{
    struct nod{
        int64 addv,mulv=1,sum;
    }a[400010];
    void pushdown(int p){
        if(a[p].addv==0 && a[p].mulv==1)return;
        a[L(p)].addv=(a[L(p)].addv*a[p].mulv%mod+a[p].addv)%mod;
        a[L(p)].mulv=a[L(p)].mulv*a[p].mulv%mod;
        a[R(p)].addv=(a[R(p)].addv*a[p].mulv%mod+a[p].addv)%mod;
        a[R(p)].mulv=a[R(p)].mulv*a[p].mulv%mod;
        a[p].mulv=1,a[p].addv=0;
    }
    inline void maintain(int p,int tl,int tr){
        a[p].sum=0;
        if(tl<tr)
            a[p].sum=a[L(p)].sum+a[R(p)].sum;
        a[p].sum=(a[p].sum*a[p].mulv%mod+a[p].addv*(tr-tl+1))%mod;
    }
    int64 qry(int l,int r,int64 k=1,int64 b=0,int p=1,int tl=1,int tr=n){
        if(l<=tl && tr<=r)return (a[p].sum*k%mod+b*(tr-tl+1))%mod;
        int64 ret=0,newk=k*a[p].mulv%mod,newb=(b+k*a[p].addv)%mod;
        int mid=tl+tr>>1;
        if(l<=mid)ret+=qry(l,r,newk,newb,L(p),tl,mid);
        if(r>mid)ret=(ret+qry(l,r,newk,newb,R(p),mid+1,tr))%mod;
        return ret;
    }
    void ins(int l,int r,int tp,int64 vl,int p=1,int tl=1,int tr=n){
        if(l<=tl && tr<=r){
            if(tp==1)a[p].mulv=(a[p].mulv*vl)%mod,a[p].addv=(a[p].addv*vl)%mod;
            else a[p].addv=(a[p].addv+vl)%mod;
        }else{
            pushdown(p);
            int mid=tl+tr>>1;
            if(l<=mid)ins(l,r,tp,vl,L(p),tl,mid);else maintain(L(p),tl,mid);
            if(r>mid)ins(l,r,tp,vl,R(p),mid+1,tr);else maintain(R(p),mid+1,tr);
        }
        maintain(p,tl,tr);
    }
}
