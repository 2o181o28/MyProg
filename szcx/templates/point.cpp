struct point{
    double x,y;
    point(double x=0,double y=0):x(x),y(y){}
};
typedef point Vector;
double length(Vector b){return hypot(b.x,b.y);}
Vector operator - (point a,point b){return point(a.x-b.x,a.y-b.y);}
Vector operator * (Vector a,double b){return point(a.x*b,a.y*b);}
point operator + (point a,Vector b){return point(a.x+b.x,a.y+b.y);}
bool deq(double a,double b){return fabs(a-b)<eps;}
double dot(Vector A,Vector B){return A.x*B.x+A.y*B.y;}
double cross(Vector A,Vector B){return A.x*B.y-A.y*B.x;}
struct line{
    point p,v;
    double ang;
    line(){}
    line(point p,point q):p(p),v(q-p){ang=atan2(v.y,v.x);}
    bool operator<(const line &rhs)const{
        return ang<rhs.ang;
    }
};
point jd(line A,line B){
    return A.p+A.v*(cross(B.p-A.p,B.v)/cross(A.v,B.v));
}
bool left(line l,point p){return cross(l.v,p-l.p)>0;}
deque<line> HPI(vector<line> &v){
    sort(v.begin(),v.end(),[](line a,line b){return a.ang<b.ang;});
    deque<line> q;
    for(line&i:v){
        while(q.size()>1 && !left(i,jd(q.back(),q.end()[-2])))q.pop_back();
        while(q.size()>1 && !left(i,jd(q[0],q[1])))q.pop_front();
        q.push_back(i);
        if(q.size()>1 && fabs(cross(q.back().v,q.end()[-2].v))<1e-8){
            line a=q.back(),b=q.end()[-2];
            q.pop_back(),q.pop_back();
            q.push_back(left(a,b.p)?b:a);
        }
    }
    while(q.size()>1 && !left(q[0],jd(q.back(),q.end()[-2])))q.pop_back();
    return q;
}
void CH(point *a,int n,vector<point> &o){
    static vector<point> t;t.clear();
    sort(a,a+n,[](point a,point b){
        return a.x<b.x-eps || deq(a.x,b.x) && a.y<b.y;
    });
    o.push_back(a[0]);o.push_back(a[1]);
    for(int i=2;i<n;o.push_back(a[i++]))push(o,a[i]);
    t.push_back(a[n-1]);t.push_back(a[n-2]);
    for(int i=n-3;~i;t.push_back(a[i--]))push(t,a[i]);
    o.insert(o.end(),t.begin()+1,t.end()-1);
}
