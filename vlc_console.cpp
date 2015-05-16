#include "vlc_console.h"
#include "utils.h"
#include <QDebug>
#include <QRegularExpression>
#include <QRegularExpressionMatch>


VLC::VLC(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this))
{
    tuned_cli = 0;
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
        for (int i=1;i<10;i++) {
            if( get_time() != -1 ) return true;
            delay(500);
        }
        return false;
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
    return m_process->state(); // TODO: this is not exactly a bool
}

void VLC::set_rate( int rate )
{
    QString cmd = QString("rate %1\n").arg(rate);
    m_process->write( cmd.toStdString().c_str() );
}

QString VLC::name( )
{
    return "VLC_CONSOLE";
}

bool VLC::is_autoskiping()
{
    return autoskip_pressed;
}

float VLC::get_time()
{
    m_process->readAllStandardOutput(); // Clean console output

    // Ask for data
        if( tuned_cli != 1 ) {
            m_process->write( "get_ms\n" );
        }else{
            m_process->write( "get_time\n" );
        }
        m_process->waitForReadyRead(2000);
        char data[1000];
        m_process->read(data,1000);
        QString output = QString("%1").arg(data);

    // Is the cli interface tuned? 0-Unkown, 1-No, 2-Yes
        if( tuned_cli != 1 ) {
            QRegExp reg_fast("fast");
            if( reg_fast.indexIn(output) == -1 ){
                autoskip_pressed = false;
            } else {
                autoskip_pressed = true;
                qDebug("Autoskiping");
            }

            QRegExp reg_unknown("Unknown command");
            if( reg_unknown.indexIn(output) == -1 ){
                if( getNumberFromQString( output ) != -1 ){
                    tuned_cli = 2;
                }else{
                    tuned_cli = 0;
                }
            } else {
                tuned_cli = 1;
                qDebug("CLI is not tuned");
            }
        }
        return getNumberFromQString( output );
}

void VLC::toggle_fullscreen( void )
{
    m_process->write( "f \n" );
}

int VLC::mute( )
{
    if( !is_playing() ) return -1;
    m_process->readAllStandardOutput(); // Clean console output
    // Ask for data
    m_process->write( "volume\n" );
    m_process->waitForReadyRead(2000);
    char data[1000];
    m_process->read(data,1000);
    QRegularExpression re("(\\d+.?\\d*)");
    QRegularExpressionMatch found;
    if( QString("%1").arg(data).contains(re,&found) ) {
        volume = found.captured().toInt();
    }else {
        volume = 100;
    }
    m_process->write( "volume 0\n" );
    return volume;
}

void VLC::unmute( )
{
    if( !is_playing() ) return;
    qDebug() << volume;
    QString cmd = QString("volume %1\n").arg( volume );
    m_process->write( cmd.toStdString().c_str() );
}
