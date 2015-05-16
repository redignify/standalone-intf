#include "vlc_tcp.h"
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include "utils.h"

VLC_TCP::VLC_TCP(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this))
{
    lock = false;
    tuned_cli = 0;
}

bool VLC_TCP::connect( QString file )
{
    if(lock) return false;
    lock = true;
    tcpSocket = new QTcpSocket(this);
    //connect(tcpSocket, SIGNAL(readyRead()), this, SLOT(ready()));
    //connect(tcpSocket, SIGNAL(error(QAbstractSocket::SocketError));
    blockSize = 0;
    tcpSocket->abort();
    tcpSocket->connectToHost("localhost", 4212 );
    for (int i=1;i<10;i++) {
        qDebug() << tcpSocket->state();
        if( get_time() != -1 ){
            lock = false;
            return true;
        }
        delay(500);
        //tcpSocket->abort();
        //tcpSocket->connectToHost("localhost", 4212 );
    }
    tcpSocket->abort();
    lock = false;
    return false;
}


bool VLC_TCP::set_path(QString program_path)
{
    path = program_path;
    return true;
}

bool VLC_TCP::launch( QString file )
{
    qDebug("Trying to launch VLC TCP");
    if( !file.isEmpty() ){
        QString program = path;
        QStringList arguments;
        //vlc --intf qt --extraintf cli --lua-config "cli={host='localhost:4212'}" file
        arguments << "--intf" << "qt" << "--extraintf" << "cli" << file;//"--lua-config" <<"'cli={host=\"localhost:4212\"}'"<< file;
        m_process->start(program, arguments);
        for (int i=1;i<10;i++){
            qDebug() << m_process->state();
            if( m_process->state() != 0 ) break;
            delay(500);
        }
    }
    return connect("");

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
    tcpSocket->waitForReadyRead(2000);
    char data[1000];
    tcpSocket->read(data,1000);
    QString output = QString("%1").arg(data);
    return output;
}

void VLC_TCP::ready()
{

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

void VLC_TCP::clean()
{
    if( tcpSocket->state() < 2 ) return;
    // Clean socket
    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out << tcpSocket->readAll();
}

float VLC_TCP::get_time( )
{
    if( tcpSocket->state() < 3 ) return -1;
    clean();

// Ask for data
    if( tuned_cli != 1 ) {
        tcpSocket->write( "get_ms\n" );
    }else{
        tcpSocket->write( "get_time\n" );
    }
    tcpSocket->waitForReadyRead(2000);
    char data[1000];
    tcpSocket->read(data,1000);
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
    tcpSocket->waitForReadyRead(2000);
    char data[1000];
    tcpSocket->read(data,1000);
    QRegularExpression re("(\\d+.?\\d*)");
    QRegularExpressionMatch found;
    if( QString("%1").arg(data).contains(re,&found) )
    {
        volume = found.captured().toInt();
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

