#ifndef VLC_TCP_H
#define VLC_TCP_H

#include <QObject>
#include <QDebug>
#include <QTcpSocket>
#include <QString>
#include <QProcess>
#include <QTimer>

class VLC_TCP: public QObject
{
    Q_OBJECT
public:
    explicit VLC_TCP(QObject *parent = 0);
    Q_INVOKABLE bool connect_to_player( bool );
    Q_INVOKABLE bool launch(QString );
    Q_INVOKABLE bool set_path(QString);
    Q_INVOKABLE void kill( );
    Q_INVOKABLE void seek(int );
    Q_INVOKABLE void toggle_fullscreen( void );
    Q_INVOKABLE void set_rate( int );
    Q_INVOKABLE float get_time( );
    Q_INVOKABLE QString get_title( );
    Q_INVOKABLE int mute( );
    Q_INVOKABLE void unmute( );
    Q_INVOKABLE bool is_playing( );
    Q_INVOKABLE bool is_autoskiping( );
    Q_INVOKABLE void slower( );
    Q_INVOKABLE void faster( );
    Q_INVOKABLE void frame( );

    Q_INVOKABLE QString name();

private:
    QProcess *m_process;
    int volume;
    float time;
    QString path;
    bool lock;
    int rate;
    Q_INVOKABLE bool autoskip_pressed;
    QTcpSocket *tcpSocket;
    QString currentData;
    quint16 blockSize;
    QTimer* timer;
    int tuned_cli;
    void clean( );

public slots:
    void ask_time();
    void ready();


};

#endif // VLC_TCP_H
