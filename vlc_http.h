#ifndef VLC_HTTP_H
#define VLC_HTTP_H

#include <QObject>
#include <QDebug>
#include <QTcpSocket>
#include <QString>
#include <QProcess>
#include <QTimer>
#include <QTimer>
#include <QCoreApplication>
#include <QDebug>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QUrlQuery>

class VLC_HTTP: public QObject
{
    Q_OBJECT
public:
    explicit VLC_HTTP(QObject *parent = 0);
    Q_INVOKABLE bool connect_to_vlc( bool );
    Q_INVOKABLE bool launch(QString );
    Q_INVOKABLE bool set_path(QString);
    Q_INVOKABLE void kill( );
    Q_INVOKABLE void seek( float );
    Q_INVOKABLE void toggle_fullscreen( void );
    Q_INVOKABLE void play( void );
    Q_INVOKABLE void set_rate( float );
    Q_INVOKABLE float get_time( );
    Q_INVOKABLE QString get_title( );
    Q_INVOKABLE int mute( );
    Q_INVOKABLE void unmute( );
    Q_INVOKABLE bool is_playing( );
    Q_INVOKABLE bool is_autoskiping( );
    Q_INVOKABLE bool is_connected;
    Q_INVOKABLE void slower( );
    Q_INVOKABLE void faster( );
    Q_INVOKABLE void frame( );
    Q_INVOKABLE QString name();

private:
    int volume;
    float time;
    float position;
    float length;
    float rate;
    bool autoskip_pressed;
    QString title;

    QString path;
    bool lock;
    QTimer* timer;
    QProcess *m_process;
    QNetworkAccessManager *manager;
    void clean( );


public slots:
    void ask_time();
    void ready(QNetworkReply *reply);
    void provideAuthenication(QNetworkReply *reply, QAuthenticator *ator );

};

#endif // VLC_HTTP_H
