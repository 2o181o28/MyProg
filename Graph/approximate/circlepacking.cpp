#include<bits/stdc++.h>
using namespace std;
const int N=10,scale=300;
struct point{
    double x,y;
    point(double x=0,double y=0):x(x),y(y){}
}p[N],q[N];
int gr[scale][scale];
point operator + (point a,point b){return point(a.x+b.x,a.y+b.y);}
double dis(point a,point b){return hypot(a.x-b.x,a.y-b.y);}
double sqr(double x){return x*x;}
double ftns(point *p){
    double ret=0;
    for(int i=0;i<N;i++){
        double mn=1e9;
        for(int j=0;j<N;j++)if(j!=i)mn=min(mn,dis(p[i],p[j]));
        ret+=sqr(mn-1);
    }
    return ret;
}
double nm(double x){return x>0?x<1?x:1:0;}
point nm(point x){return point(nm(x.x),nm(x.y));}
void show(){
    system("killall display");
    memset(gr,0,sizeof gr);
    for(int i=0;i<N;i++){
        int x=p[i].x*scale,y=p[i].y*scale;
        for(int j=x-1;j<x+2;j++)
            for(int k=y-1;k<y+2;k++)if(j>=0 && k>=0 && j<scale && k<scale)
                gr[j][k]=1;
    }
    FILE *f=fopen("1.ppm","wb");
    fprintf(f,"P6\n%d %d\n255\n",scale,scale);
    for(int i=0;i<scale;i++)
        for(int j=0;j<scale;j++){
            unsigned char c[3];
            c[0]=c[1]=c[2]=255-gr[i][j]*255;
            fwrite(c,1,3,f);
        }
    fclose(f);
    system("nohup display ./1.ppm &");
    system("sleep 1");
}
int main(){
    uniform_real_distribution<double> u(0,1),v(-1,1);
    default_random_engine e;
    e.seed(clock());
    for(int i=0;i<N;i++)p[i]=point(u(e),u(e));
    int cnt=0;
    for(double T=1;T>0.001;T*=0.999){
        for(int i=0;i<N;i++)q[i]=nm(p[i]+point(v(e)*T,v(e)*T));
        if(exp((ftns(p)-ftns(q))/T)>u(e))
            memcpy(p,q,sizeof p);
        if(++cnt%500==0)show();
    }
    return 0;
}
