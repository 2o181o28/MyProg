#include<QPainter>
#include<QKeyEvent>
#include<bits/stdc++.h>
using namespace std;

#include "mainwindow.h"
#include "ui_mainwindow.h"

const int n=500;
const double v=3.3,R=25,A=180/180.*M_PI,B=17/180.*M_PI;
struct st{
	double x,y,t;
}a[510];

void initA(){
	uniform_real_distribution<double> u(-150,150),t(-M_PI,M_PI);
	default_random_engine e;
	e.seed(clock());
	for(int i=0;i<n;i++)
		a[i].x=u(e),a[i].y=u(e),a[i].t=t(e);
}

void Next(){
	for(int i=0;i<n;i++){
		int cnt=0,s=0;
		for(int j=0;j<n;j++)if(j!=i){
			double dx=a[j].x-a[i].x,dy=a[j].y-a[i].y;
			if(hypot(dx,dy)<=R){
				cnt++;s+=cos(a[i].t)*dy-sin(a[i].t)*dx>=0?1:-1;
			}
		}
		a[i].t+=A+B*cnt*(s>0?1:-1);
		if(a[i].t>M_PI)a[i].t-=2*M_PI;
		if(a[i].t<-M_PI)a[i].t+=2*M_PI;
	}
	for(int i=0;i<n;i++)
		a[i].x+=cos(a[i].t)*v,a[i].y+=sin(a[i].t)*v;
}

MainWindow::MainWindow(QWidget *parent) :
	QMainWindow(parent),
	ui(new Ui::MainWindow)
{
	ui->setupUi(this);
	setMinimumSize(400,400);
	initA();
}

void MainWindow::paintEvent(QPaintEvent *event){
	QPainter p(this);Q_UNUSED(event);
	p.setRenderHint(QPainter::Antialiasing);
	p.setBrush(Qt::black);
	p.drawRect(rect());
	int hw=width()/2,hh=height()/2;
	for(int i=0;i<n;i++){
		int cnt=0;
			for(int j=0;j<n;j++)
				cnt+=10*(j!=i && hypot(a[j].x-a[i].x,a[j].y-a[i].y)<=R);
		cnt=min(cnt,255);
		p.setPen(Qt::white);
		p.setBrush(QColor(cnt,cnt,cnt));
		if(abs(a[i].x)>=hw || abs(a[i].y)>=hh)continue;
		p.drawEllipse({(int)a[i].x+hw,(int)a[i].y+hh},5,5);
	}
}

void MainWindow::keyPressEvent(QKeyEvent *event){
	if(event->key()==Qt::Key_Space){
		for(int t=0;t<10;t++)
			Next();
		repaint();
	}else QWidget::keyPressEvent(event);
}

MainWindow::~MainWindow()
{
	delete ui;
}
