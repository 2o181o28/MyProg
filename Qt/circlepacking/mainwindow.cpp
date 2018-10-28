#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QPainter>
using namespace std;

extern const int N;
extern QPointF p[];

void MainWindow::paintEvent(QPaintEvent *){
	QPainter painter(this);
	painter.setRenderHint(QPainter::Antialiasing);
	painter.setBrush(Qt::white);
	painter.drawRect(rect());
	double md=1e9;
	for(int i=0;i<N;i++)
		for(int j=i+1;j<N;j++)
			md=min(md,dis(p[i],p[j])/2*width());
	painter.setBrush(QColor(128,128,255));
	painter.setPen(QPen(Qt::black,2));
	for(int i=0;i<N;i++)
		painter.drawEllipse(p[i]*width(),md,md),
		painter.drawPoint(p[i]*width());
}

void MainWindow::accept(){repaint();}

MainWindow::MainWindow(QWidget *parent) :
	QMainWindow(parent),
	ui(new Ui::MainWindow)
{
	ui->setupUi(this);
	connect(&thread,SIGNAL(send()),this,SLOT(accept()));
	thread.start();
}

MainWindow::~MainWindow()
{
	delete ui;
}
