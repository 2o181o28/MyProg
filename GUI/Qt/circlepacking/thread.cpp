#include<bits/stdc++.h>
#include<thread.h>
#include<QDebug>
using namespace std;
extern const int N;
QPointF p[],q[N];
double dis(QPointF a,QPointF b){return hypot(a.x()-b.x(),a.y()-b.y());}
double sqr(double x){return x*x;}
double ftns(QPointF *p){
	double ret=0;
	for(int i=0;i<N;i++){
		double mn=1e9;
		for(int j=0;j<N;j++)if(j!=i)mn=min(mn,dis(p[i],p[j]));
		ret+=sqr(mn-1);
	}
	return ret;
}
double nm(double x){return x>0?x<1?x:1:0;}
QPointF nm(QPointF x){return QPointF(nm(x.x()),nm(x.y()));}

Thread::Thread(){}

void Thread::run(){
	uniform_real_distribution<double> u(0,1),v(-1,1);
	default_random_engine e;
	e.seed(clock());
	for(int i=0;i<N;i++)p[i]=QPointF(u(e),u(e));
	int cnt=0;
	for(double T=1;T>0.0001;T*=0.9999){
		for(int i=0;i<N;i++)q[i]=nm(p[i]+QPointF(v(e)*T,v(e)*T));
		if(exp((ftns(p)-ftns(q))/T)>u(e))
			memcpy(p,q,sizeof q);
		if(++cnt%500==0)emit send();
	}
}
