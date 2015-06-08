#include "vlc_tcp.h"
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include "utils.h"
#include <QTimer>

VLC_TCP::VLC_TCP(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this))
{
    lock = false;
    tuned_cli = 0;
    rate = 1;
    timer = new QTimer(this);
    time = -1;
    tcpSocket = new QTcpSocket(this);
    connect(tcpSocket, SIGNAL(readyRead()), this, SLOT(ready()));
    connect(timer, SIGNAL(timeout()), this, SLOT(ask_time()));
}

bool VLC_TCP::connect_to_vlc( bool fast )
{
    if(lock) return false;
    lock = true;
    //connect(tcpSocket, SIGNAL(error(QAbstractSocket::SocketError));
    blockSize = 0;
    tcpSocket->abort();
    tcpSocket->connectToHost("localhost", 4212 );
    timer->start(250);
    int max = fast? 2 : 10;
    for (int i=1;i<max;i++) {
        qDebug() << tcpSocket->state();
        if( get_time() != -1 ){
            qDebug() << "Connected";
            lock = false;
            return true;
        }
        delay(500);
    }
    qDebug("Aborting!");
    timer->stop();
    tcpSocket->abort();
    lock = false;
    return false;
}

void VLC_TCP::ask_time(){
    if( tcpSocket->state() < 3 ) return;
    clean();
    qDebug() << "Getting time";
// Ask for data
    if( tuned_cli != 1 ) {
        tcpSocket->write( "get_ms\n" );
    }else{
        tcpSocket->write( "get_time\n" );
    }
}


bool VLC_TCP::set_path(QString program_path)
{
    path = program_path;
    return true;
}

bool VLC_TCP::launch( QString file )
{
    qDebug("Checking if VLC is listining over TCP");
    if( connect_to_vlc( true ) ) return true;

    if( !file.isEmpty() ){
        qDebug() << "Starting VLC with " << file;
        QString program = path;
        QStringList arguments;
        //vlc --intf qt --extraintf cli --lua-config "cli={host='localhost:4212'}" file
        //arguments << "--intf" << "qt" << "--extraintf" << "cli" << file;//"--lua-config" <<"'cli={host=\"localhost:4212\"}'"<< file;
        arguments << file;
        m_process->start(program, arguments);
        for (int i=1;i<10;i++){
            qDebug() << "Waiting for VLC to start" << m_process->state();
            if( m_process->state() != 0 ) break;
            delay(500);
        }
        if( m_process->state() == 0 ) return false;
        return connect_to_vlc( false );
    }

}

bool VLC_TCP::is_playing()
{
    return ( m_process->state() == 2 );
}


QString VLC_TCP::name( )
{
    return "VLC_TCP";
}

QString VLC_TCP::get_title()
{
    if( tcpSocket->state() < 2 ) return "";
    clean();
    // Ask for data
    tcpSocket->write( "title\n" );
    tcpSocket->waitForReadyRead(1000);
    QString output = tcpSocket->readAll();
    qDebug() << output;
    return output;
}

void VLC_TCP::ready()
{
    QString output = tcpSocket->readAll();
    qDebug() << output ;

    if( tuned_cli != 1 ) {
    // Is the user pressing autoskip?
        QRegExp reg_fast("fast");
        if( reg_fast.indexIn(output) == -1 ){
            autoskip_pressed = false;
        } else {
            autoskip_pressed = true;
            qDebug("Autoskiping");
        }

    // Is the cli interface tuned? 0-Unkown, 1-No, 2-Yes
        QRegExp reg_unknown("help");
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
    }else{
    // Is the user pressing autoskip?
        QRegExp reg_new_rate("new rate:");
        QRegExp reg_normal_rate("new rate: 1.000");
        if( reg_new_rate.indexIn(output) != -1 ){
            if( reg_normal_rate.indexIn(output) == -1 ){
                autoskip_pressed = true;
                qDebug("Start autoskiping");
            } else {
                autoskip_pressed = false;
                qDebug("End autoskiping");
            }
        }
    }
    time = getNumberFromQString( output );
}

void VLC_TCP::kill()
{
    if( tcpSocket->state() < 2 ) return;
    tcpSocket->write( "shutdown\n" );
}

void VLC_TCP::seek( int sec )
{
    if( tcpSocket->state() < 2 ) return;
    QString cmd = QString("seek %1\n").arg( sec );
    tcpSocket->write( cmd.toStdString().c_str() );
}

void VLC_TCP::toggle_fullscreen( void )
{
    if( tcpSocket->state() < 2 ) return;
    tcpSocket->write( "f \n" );
}


void VLC_TCP::set_rate( int rate )
{
    if( tcpSocket->state() < 2 ) return;
    QString cmd = QString("rate %1\n").arg( rate );
    tcpSocket->write( cmd.toStdString().c_str() );
}

void VLC_TCP::slower()
{
    if( tcpSocket->state() < 2 ) return;
    //tcpSocket->write( "slower" );
    rate/=2;
    set_rate(rate);
}

void VLC_TCP::faster( )
{
    if( tcpSocket->state() < 2 ) return;
    //tcpSocket->write( "faster" );
    rate*=2;
    set_rate(rate);
}

void VLC_TCP::frame( )
{
    if( tcpSocket->state() < 2 ) return;
    tcpSocket->write( "frame" );
}

void VLC_TCP::clean()
{
    if( tcpSocket->state() < 2 ) return;
    // Clean socket
    QString output = tcpSocket->readAll();
    qDebug() << output;
}

float VLC_TCP::get_time( )
{
    return time;
   /* if( tcpSocket->state() < 3 ) return -1;
    clean();
    qDebug() << "Getting time";
// Ask for data
    if( tuned_cli != 1 ) {
        tcpSocket->write( "get_ms\n" );
    }else{
        tcpSocket->write( "get_time\n" );
    }
    tcpSocket->waitForReadyRead(1000);
    QString output = tcpSocket->readAll();
    qDebug() << output ;


    if( tuned_cli != 1 ) {
    // Is the user pressing autoskip?
        QRegExp reg_fast("fast");
        if( reg_fast.indexIn(output) == -1 ){
            autoskip_pressed = false;
        } else {
            autoskip_pressed = true;
            qDebug("Autoskiping");
        }

    // Is the cli interface tuned? 0-Unkown, 1-No, 2-Yes
        QRegExp reg_unknown("help");
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
*/}

bool VLC_TCP::is_autoskiping()
{
    return autoskip_pressed;
}


int VLC_TCP::mute( )
{
    if( tcpSocket->state() < 2 ) return -1;
    clean();
    // Ask for data
    tcpSocket->write( "volume\n" );
    tcpSocket->waitForReadyRead(1000);
    QString output = tcpSocket->readAll();
    qDebug() << output;
    QRegularExpression re("(\\d+.?\\d*)");
    QRegularExpressionMatch found;
    if( output.contains(re,&found) )
    {
        volume = found.captured().toFloat();
    }else
    {
        volume = 100;
    }
    tcpSocket->write( "volume 0\n" );
    return volume;
}

void VLC_TCP::unmute( )
{
    if( tcpSocket->state() < 2 ) return;
    qDebug() << volume;
    QString cmd = QString("volume %1\n").arg( volume );
    tcpSocket->write( cmd.toStdString().c_str() );
}

