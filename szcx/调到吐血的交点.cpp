#include<cstdio>
#include<cmath>
#include<vector>
#define min(a,b) ((a>b)?(b):(a))
using namespace std;
struct point{
	double x,y;
	point(double a=0,double b=0):x(a),y(b){}
}c1,c2;
point operator +(point a,point b){return point(a.x+b.x,a.y+b.y);}
point operator -(point a,point b){return point(a.x-b.x,a.y-b.y);}
point operator *(point a,double b){return point(a.x*b,a.y*b);}
point Point(double r,double theta){return point(r*cos(theta),r*sin(theta));}
vector<point> v;
double r1,r2,eps=1e-8;
inline double dis(point a,point b){
	return hypot(a.x-b.x,a.y-b.y);
}
inline double cross(point a,point b){
	return a.x*b.y-a.y*b.x;
}
int jd(point c1,double r1,point c2,double r2,vector<point> &v){
    point l=c1+(c2-c1)*(r1/dis(c2,c1));
	double ang1=atan2(l.y-c1.y,l.x-c1.x),ang2=ang1+acos(-1),angmid,tang=ang1;
	if(dis(c1,c2)>=r1+r2)return 0;
	if(dis(c1,c2)<=abs(r1-r2))return 1;
	while(abs(ang1-ang2)>eps){
		angmid=(ang1+ang2)/2;
		if(dis(Point(r1,angmid)+c1,c2)>r2)
			ang2=angmid;
			else ang1=angmid;
	}
	v.push_back(Point(r1,angmid)+c1);
	v.push_back(Point(r1,2*tang-angmid)+c1);
	return 2;
}
int main(){
	scanf("%lf%lf%lf%lf%lf%lf",&(c1.x),&(c1.y),&r1,&(c2.x),&(c2.y),&r2);
	switch(jd(c1,r1,c2,r2,v)){
		case 0:printf("0.000\n");break;
		case 1:printf("%.3lf",min(r1*r1*acos(-1),r2*r2*acos(-1)));break;
		case 2:
			point mid=(v[1]+v[0])*0.5;
			double h1=dis(mid,c1)*(cross(c1-v[1],c1-v[0])*cross(c1-v[1],c1-c2)<0?-1:1),h2=dis(mid,c2)*(cross(c2-v[1],c2-v[0])*cross(c2-v[1],c2-c1)<0?-1:1);
			printf("%.3lf\n",acos(h1/r1)*r1*r1-h1*sqrt(r1*r1-h1*h1)+r2*r2*acos(h2/r2)-h2*sqrt(r2*r2-h2*h2));
	}
	return 0;
}
