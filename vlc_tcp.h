#ifndef VLC_TCP_H
#define VLC_TCP_H

#include <QObject>
#include <QDebug>
#include <QTcpSocket>
#include <QString>

class VLC_TCP: public QObject
{
    Q_OBJECT
public:
    explicit VLC_TCP(QObject *parent = 0);
    Q_INVOKABLE void launch( QString );
    Q_INVOKABLE void kill( );
    Q_INVOKABLE void seek( int );
    Q_INVOKABLE void set_rate( int );
    Q_INVOKABLE QString get_time( );
    Q_INVOKABLE QString get_ms( );
    Q_INVOKABLE int mute( );
    Q_INVOKABLE void unmute( );

private:
    int volume;
    QTcpSocket *tcpSocket;
    QString currentData;
    quint16 blockSize;
    void ready();
    void clean( );
};

#endif // VLC_TCP_H
