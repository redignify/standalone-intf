#ifndef VLC_TCP_H
#define VLC_TCP_H

#include <QObject>
#include <QDebug>
#include <QTcpSocket>
#include <QString>
#include <QProcess>

class VLC_TCP: public QObject
{
    Q_OBJECT
public:
    explicit VLC_TCP(QObject *parent = 0);
    Q_INVOKABLE bool connect( QString );
    Q_INVOKABLE bool launch(QString );
    Q_INVOKABLE bool set_path(QString);
    Q_INVOKABLE void kill( );
    Q_INVOKABLE void seek(int );
    Q_INVOKABLE void toggle_fullscreen( void );
    Q_INVOKABLE void set_rate( int );
    Q_INVOKABLE QString get_time( );
    Q_INVOKABLE float get_ms();
    Q_INVOKABLE QString get_title( );
    Q_INVOKABLE int mute( );
    Q_INVOKABLE void unmute( );
    Q_INVOKABLE bool is_playing( );
    Q_INVOKABLE bool is_autoskiping( );
    Q_INVOKABLE QString name();

private:
    QProcess *m_process;
    int volume;
    QString path;
    bool lock;
    Q_INVOKABLE bool autoskip_pressed;
    QTcpSocket *tcpSocket;
    QString currentData;
    quint16 blockSize;
    void ready();
    void clean( );
};

#endif // VLC_TCP_H
