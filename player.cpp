#include "player.h"
#include <QDebug>

Player::Player(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this))
{
}

void Player::launch( QString file )
{
    QString program = "vlc";
    QStringList arguments;
    //vlc --intf qt --extraintf rc
    arguments << "--intf" << "qt" << "--extraintf" << "rc" << "--rc-fake-tty"<< file;
    m_process->start(program, arguments);
}

void Player::seek( int sec )
{
    QString output = m_process->readAllStandardOutput();

    qDebug() << output;

    m_process->write( "seek 20\n" );
}

QString Player::get_time()
{
    m_process->readAllStandardOutput(); // Clean console output

    m_process->write( "get_time\n" );

    m_process->waitForReadyRead(3000);

    QString output = m_process->readAllStandardOutput();

    qDebug() << output;

    return output;
}
