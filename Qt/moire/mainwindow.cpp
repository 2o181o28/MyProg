#include "mainwindow.h"
#include "ui_mainwindow.h"
#include<QPainter>
#include<QKeyEvent>
#include<bits/stdc++.h>
using namespace std;

const double sc=2;

MainWindow::MainWindow(QWidget *parent) :
	QMainWindow(parent),
	ui(new Ui::MainWindow)
{
	ui->setupUi(this);
	
	int m=width(),n=height();
	pix=QPixmap(m,n);
	QPainter p(&pix);
	p.setRenderHint(QPainter::Antialiasing);
	p.fillRect(pix.rect(),{{255,255,255,0}}); // Neccessary
	p.setPen(QColor(Qt::white)); // Important
	for(double i=1;i<=n;i+=sqrt(3)*sc)
		p.drawLine(QPointF{0,i},{m,i});
	for(double i=1-n/sqrt(3);i<=m+n/sqrt(3);i+=2*sc)
		p.drawLine(QPointF{i,0},{i-n/sqrt(3),n}),
		p.drawLine(QPointF{i,0},{i+n/sqrt(3),n});
}

void MainWindow::paintEvent(QPaintEvent*){
	QPainter p(this);
	QMatrix ma;ma.rotate(ang);
	int m=width(),n=height();
	p.drawPixmap(rect(),pix); // must be here; weird arguments
	auto x=n*(cos(ang/180*M_PI)+sin(ang/180*M_PI))/2;
	p.drawPixmap(QRect(n/2-x,n/2-x,2*x,2*x),
				 pix.transformed(ma,Qt::SmoothTransformation));
}

void MainWindow::keyPressEvent(QKeyEvent *event){
	if(event->key()==Qt::Key_Space){
		ang++;if(ang>90)ang-=90;
		repaint();
	}else QWidget::keyPressEvent(event);
}

MainWindow::~MainWindow()
{
	delete ui;
}
