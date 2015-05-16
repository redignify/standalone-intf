#ifndef VLC_CONSOLE_H
#define VLC_CONSOLE_H

#include <QObject>
#include <QProcess>

class VLC : public QObject
{
    Q_OBJECT

public:
    explicit VLC(QObject *parent = 0);
    Q_INVOKABLE bool launch(QString );
    Q_INVOKABLE bool set_path(QString);
    Q_INVOKABLE bool connect( QString );
    Q_INVOKABLE void kill( );
    Q_INVOKABLE void seek(int );
    Q_INVOKABLE void set_rate( int );
    Q_INVOKABLE float get_time( );
    Q_INVOKABLE int mute( );
    Q_INVOKABLE void unmute( );
    Q_INVOKABLE void toggle_fullscreen( );
    Q_INVOKABLE bool is_playing( );
    Q_INVOKABLE bool is_autoskiping( );
    Q_INVOKABLE QString name();

private:
    QProcess *m_process;
    QString path;
    int tuned_cli;
    int volume;
    Q_INVOKABLE bool autoskip_pressed;
};

#endif // VLC_CONSOLE_H
