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
    m_process->waitForReadyRead();
}

void Player::kill()
{
    m_process->kill();
    m_process->waitForFinished();
    delete m_process;
}

void Player::seek( int sec )
{
    QString output = m_process->readAllStandardOutput();

    //qDebug() << output;
    QString cmd = QString("seek %1\n").arg(sec);
    m_process->write( cmd.toStdString().c_str() );
}

void Player::set_rate( int rate )
{
    QString output = m_process->readAllStandardOutput();

    //qDebug() << output;
    QString cmd = QString("rate %1\n").arg(rate);
    m_process->write( cmd.toStdString().c_str() );
}

QString Player::get_time()
{
    m_process->readAllStandardOutput(); // Clean console output

    m_process->write( "get_time\n" );

    m_process->waitForReadyRead(500);

    QString output = m_process->readAllStandardOutput();

    //qDebug() << output;

    return output;
}
