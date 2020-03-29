#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <cmath>
#include <QPainter>
#include <QPointF>
#include <QDebug>

MainWindow::MainWindow(QWidget *parent) :
	QMainWindow(parent),
	ui(new Ui::MainWindow)
{
	ui->setupUi(this);
}

void MainWindow::paintEvent(QPaintEvent *event){
	QPainter painter(this);
	QPointF a,v(10,-10),s(0,250);
	double dt=1e-5;
	for(int t=0;t<3e6 && s.y()<=500 && s.x()<=500;t++){
		painter.drawPoint(s);
		a=QPointF(0,10)-hypot(v.x(),v.y())*v;
		v+=a*dt;s+=v*dt*100;
//		qDebug()<<s.x()<<" "<<s.y()<<"\n";
	}
}

MainWindow::~MainWindow()
{
	delete ui;
}
