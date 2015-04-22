#include "vlc_tcp.h"
#include <QRegularExpression>
#include <QRegularExpressionMatch>


VLC_TCP::VLC_TCP(QObject *parent)
{

}


void VLC_TCP::launch( QString file )
{
    tcpSocket = new QTcpSocket(this);
    //connect(tcpSocket, SIGNAL(readyRead()), this, SLOT(ready()));
    //connect(tcpSocket, SIGNAL(error(QAbstractSocket::SocketError));
    blockSize = 0;
    tcpSocket->abort();
    tcpSocket->connectToHost("localhost", 4212 );

}

void VLC_TCP::ready()
{

}

void VLC_TCP::kill()
{

}

void VLC_TCP::seek( int sec )
{
    QString cmd = QString("seek %1\n").arg( sec );
    tcpSocket->write( cmd.toStdString().c_str() );
}

void VLC_TCP::set_rate( int rate )
{
    QString cmd = QString("rate %1\n").arg( rate );
    tcpSocket->write( cmd.toStdString().c_str() );
}

void VLC_TCP::clean()
{
    // Clean socket
    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out << tcpSocket->readAll();
}

QString VLC_TCP::get_ms( )
{
    clean();
    // Ask for data
    tcpSocket->write( "get_ms\n" );
    tcpSocket->waitForReadyRead(2000);
    char data[1000];
    tcpSocket->read(data,1000);
    QString output = QString("%1").arg(data);

    return output;
}

QString VLC_TCP::get_time()
{
    return "output";
}

int VLC_TCP::mute( )
{
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

}

void VLC_TCP::unmute( )
{
    qDebug() << volume;
    QString cmd = QString("volume %1\n").arg( volume );
    tcpSocket->write( cmd.toStdString().c_str() );
}

