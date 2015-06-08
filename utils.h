#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QDebug>


class Utils: public QObject
{
    Q_OBJECT
public:
    explicit Utils();
    Q_INVOKABLE QString get_hash( QString );
    Q_INVOKABLE double get_size( QString );
    Q_INVOKABLE bool write_data( QString, QString );
    Q_INVOKABLE QString read_data(QString );
};

void delay( int millisecondsToWait );
float getNumberFromQString(const QString &xString);

#endif // UTILS_H
