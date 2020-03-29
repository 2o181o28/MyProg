#include<cstdlib>
#include<cstdio>
#define C(x,v) tr[x].c[v]
#define E(x) tr[++tt]=tr[x],x=tt
struct{int v,s,c[2];}tr[200010];
int tt,l,r;
int ud(int v){tr[v].s=1+tr[C(v,0)].s+tr[C(v,1)].s;}
int mg(int x,int y){return !x|!y?x?x:y:
rand()%(tr[x].s+tr[y].s)<tr[x].s?E(x),
C(x,1)=mg(C(x,1),y),ud(x),x:(
E(y),y=tt,C(y,0)=mg(x,C(y,0)),ud(y),y);}
void sp(int x,int e){!x?l=r=0:(E(x),
tr[C(x,0)].s>=e?sp(C(x,0),e),C(x,0)=r,r=x:
(sp(C(x,1),e-tr[C(x,0)].s-1),C(x,1)=l,l=x),
ud(x));}
int main(){
	return 0;
}
