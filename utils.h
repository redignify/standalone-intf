#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QDebug>
#include <QByteArray>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QProcess>
#include <QTimer>
#include <QtGui>

class Utils : public QObject
{
    Q_OBJECT
public:
    explicit Utils(QObject *parent = 0);
    Q_INVOKABLE QString get_hash( QString );
    Q_INVOKABLE double get_size( QString );
    Q_INVOKABLE bool write_data( QString, QString );
    Q_INVOKABLE bool update( QString );
    Q_INVOKABLE QString read_data( QString );
    Q_INVOKABLE QString read_external_data( QString );
    Q_INVOKABLE QString get_vlc_path();
    Q_INVOKABLE bool selectLanguage( int language );

private:
    QNetworkAccessManager *manager;
    QProcess *m_process;
    QProcess *m_process2;
    QTranslator *translator;
    QTimer *timer;

public slots:
    void updater_ready(QNetworkReply *reply);


};

void delay( int millisecondsToWait );
float getNumberFromQString(const QString &xString);

#endif // UTILS_H
