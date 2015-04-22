#ifndef VLC_CONSOLE_H
#define VLC_CONSOLE_H

#include <QObject>
#include <QProcess>

class VLC : public QObject
{
    Q_OBJECT

public:
    explicit VLC(QObject *parent = 0);
    Q_INVOKABLE void launch( QString );
    Q_INVOKABLE void kill( );
    Q_INVOKABLE void seek( int );
    Q_INVOKABLE void set_rate( int );
    Q_INVOKABLE QString get_time( );
    Q_INVOKABLE QString get_ms( );
    Q_INVOKABLE void toggle_mute( );

private:
    QProcess *m_process;
};

#endif // VLC_CONSOLE_H
