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
};

#endif // UTILS_H
