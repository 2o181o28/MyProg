#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <thread.h>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
	Q_OBJECT

public:
	explicit MainWindow(QWidget *parent = 0);
	~MainWindow();
	void paintEvent(QPaintEvent*);

public slots:
	void accept();

private:
	Ui::MainWindow *ui;
	Thread thread;
};

#endif // MAINWINDOW_H
