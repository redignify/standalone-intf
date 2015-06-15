#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QDebug>
#include <QByteArray>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>


class Utils: public QObject
{
    Q_OBJECT
public:
    explicit Utils();
    Q_INVOKABLE QString get_hash( QString );
    Q_INVOKABLE double get_size( QString );
    Q_INVOKABLE bool write_data( QString, QString );
    Q_INVOKABLE bool update( QString );
    Q_INVOKABLE QString read_data(QString );
    Q_INVOKABLE QString read_external_data(QString );
    Q_INVOKABLE QString get_vlc_path( );
    QNetworkAccessManager *manager;

public slots:
    void ready(QNetworkReply *reply);

};

void delay( int millisecondsToWait );
float getNumberFromQString(const QString &xString);

#endif // UTILS_H
