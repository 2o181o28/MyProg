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

void MainWindow::paintEvent([[maybe_unused]] QPaintEvent *event){
	QPainter painter(this);
	QPointF v(50,-50),s(0,250);
	const double dt=1e-4;
	const auto g=QPointF(0,10);
	for(int t=0;t<3e6 && s.y()<=500 && s.x()<=500;t++){
		painter.drawPoint(s);
		auto get_a=[&](auto v){
			return g-hypot(v.x(),v.y())*v;
		};
		auto nv=v+get_a(v)*dt;
		v+=(get_a(v)+get_a(nv))/2*dt;s+=v*dt*100;
//		qDebug()<<s.x()<<" "<<s.y()<<"\n";
	}
}

MainWindow::~MainWindow()
{
	delete ui;
}
