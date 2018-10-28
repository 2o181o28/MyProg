struct st{
    int a,b,c,id;
}que[100010],tmp[100010];
bool operator <= (st a,st b){return a.b<b.b||a.b==b.b&&a.c<=b.c;}
bool operator != (st a,st b){return a.b!=b.b||a.a!=b.a||a.c!=b.c;}
int n,x,ans[100010],i,num[100010],p[100010],c[200010];
void ins(int p,int v){while(p<=x)c[p]+=v,p+=p&-p;}
int qry(int p){int r=0;while(p)r+=c[p],p&=p-1;return r;}
void clear(int p){for(;p<=x&&c[p];c[p]=0,p+=p&-p);}
void Merge(int l,int r){
    if(l==r)return;
    int mid=(l+r)/2;
    Merge(l,mid),Merge(mid+1,r);
    int i=l,j=mid+1,k=0;
    while(i<=mid && j<=r)if(que[i]<=que[j])
        ins(que[i].c,num[que[i].id]),
        tmp[k++]=que[i++]; 
    else
    	ans[que[j].id]+=qry(que[j].c),
        tmp[k++]=que[j++];
    while(i<=mid)tmp[k++]=que[i++];
    while(j<=r)
        ans[que[j].id]+=qry(que[j].c),
        tmp[k++]=que[j++];
    for(i=0;i<k;i++)que[i+l]=tmp[i];
    for(i=l;i<=r;i++)
        clear(que[i].c);
}

