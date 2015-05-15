#include "vlc_console.h"
#include "utils.h"
#include <QDebug>


VLC::VLC(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this))
{
}

bool VLC::set_path(QString program_path)
{
    path = program_path;
}

bool VLC::launch( QString file )
{
    qDebug("Trying to launch VLC CONSOLE");
    if( !file.isEmpty() ){
        QString program = path;
        QStringList arguments;
        //vlc --intf qt --extraintf rc
        arguments << "--intf" << "qt" << "--extraintf" << "rc" << "--rc-fake-tty"<< file;
        m_process->start(program, arguments);
        for (int i=1;i<10;i++){
            if( m_process->state() != 0 ) break;
            delay(500);
        }
        qDebug() << m_process->state();
        return true;
    }else{
        qDebug("Console player called without filename!");
        return false;
    }
}
bool VLC::connect( QString file )
{
    if( m_process->state() == 0 ){
        return false;
    } else {
        return true;
    }
}

void VLC::kill()
{
    m_process->write( "shutdown\n" );
    //m_process->kill();
    //m_process->waitForFinished();
    //delete m_process;
}

void VLC::seek( int sec )
{
    QString output = m_process->readAllStandardOutput();

    //qDebug() << output;
    QString cmd = QString("seek %1\n").arg(sec);
    m_process->write( cmd.toStdString().c_str() );
}

bool VLC::is_playing()
{
    return m_process->state();
}

void VLC::set_rate( int rate )
{
    QString cmd = QString("rate %1\n").arg(rate);
    m_process->write( cmd.toStdString().c_str() );
}

float VLC::get_ms( )
{
    m_process->readAllStandardOutput(); // Clean console output

    m_process->write( "get_ms\n" );

    m_process->waitForReadyRead(500);

    QString output = m_process->readAllStandardOutput();

    QRegExp xRegExp("fast");
    if( xRegExp.indexIn(output) == -1 ){
        autoskip_pressed = false;
    } else {
        autoskip_pressed = true;
    }

    return getNumberFromQString( output );
}

QString VLC::name( )
{
    return "VLC_CONSOLE";
}

bool VLC::is_autoskiping()
{
    return autoskip_pressed;
}

QString VLC::get_time()
{
    m_process->readAllStandardOutput(); // Clean console output

    m_process->write( "get_time\n" );

    m_process->waitForReadyRead(500);

    QString output = m_process->readAllStandardOutput();

    //qDebug() << output;

    return output;
}

void VLC::toggle_mute( )
{

}
