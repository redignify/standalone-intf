#ifndef VLC_H
#define VLC_H

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

private:
    QProcess *m_process;
};

#endif
