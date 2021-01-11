#pragma once

#include <QObject>
#include <QCursor>

class MyCursor : public QObject
{
	Q_OBJECT

public:
	explicit MyCursor(QObject *parent = 0) : QObject(parent) {}
	~MyCursor() = default;
signals:
public slots:
	void moveCursor();
private:
	QCursor cursor;
};
