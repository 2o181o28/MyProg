#ifndef THREAD_H
#define THREAD_H
#include <QThread>
#include <QString>
#include <var.h>
class Thread : public QThread{
	Q_OBJECT
public:
	Thread();
	virtual void run();
signals:
	void send();
};

#endif // THREAD_H
