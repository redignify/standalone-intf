#include "vlc_http.h"
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include "utils.h"
#include <QTimer>
#include <QTime>
#include <QCoreApplication>
#include <QDebug>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QUrlQuery>
#include <QAuthenticator>


VLC_HTTP::VLC_HTTP(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this))
{
    lock = false;
    is_connected = false;
    rate = 1;
    time = -1;
    title = "Title ;)";
    autoskip_pressed = false;

    // Special thanks to http://www.tizenexperts.com/2011/09/add-http-authentication-support-qt-applications-nokia-developer-wiki/
    manager = new QNetworkAccessManager();
    timer = new QTimer(this);

    connect(manager, SIGNAL(authenticationRequired(QNetworkReply*,QAuthenticator*)),
                SLOT(provideAuthenication(QNetworkReply*,QAuthenticator*)));
    connect(manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(ready(QNetworkReply*)));
    connect(timer, SIGNAL(timeout()), this, SLOT(ask_time()));
}

bool VLC_HTTP::connect_to_player( bool fast )
{
    if(lock) return false;
    lock = true;
    timer->start(250);
    int max = fast==true? 2 : 20;
    for (int i=1;i<max;i++) {
        if( get_time() != -1 ){
            qDebug() << "Connected";
            if( !fast ) delay(500); // Wait a few ms, otherwise is to early for sending commands (eg. fullscreen...)
            lock = false;
            return true;
        }
        qDebug() << "Waiting to connect...";
        delay(500);
    }
    qDebug("Aborting!");
    timer->stop();
    lock = false;
    return false;
}

void VLC_HTTP::ask_time()
{
    QNetworkRequest req(QUrl("http://localhost:8080/requests/status.xml"));
    manager->get(req);
}

void VLC_HTTP::provideAuthenication(QNetworkReply *reply, QAuthenticator *ator )
{
    qDebug() << "Authentication needed" << reply->readAll();
    ator->setUser(QString(""));
    ator->setPassword(QString("pass"));
}

bool VLC_HTTP::set_path(QString program_path)
{
    path = program_path;
    return true;
}

bool VLC_HTTP::launch( QString file, bool preview )
{
    if(lock) return false;
    lock = true;
    m_process->close();
    qDebug("Checking if VLC is listining over HTTP");
    if( connect_to_player( true ) ) return true;

    if( !file.isEmpty() ){
        qDebug() << "Starting VLC with " << file;
        QString program = path;
        QStringList arguments;

        #ifdef Q_OS_WIN
            // Code for Windows command line
            if( preview ){
                arguments <<"--no-autoscale"<<"--width"<<"300"<<"--height"<<"250";//--canvas-width=250";
            }
            arguments << "--intf=qt"<<"--extraintf=http"<<"--http-host=localhost:8080"<<"--http-password=pass" << file;
            qDebug() << arguments;
            qDebug() << program;
            m_process->start(program, arguments);
        #else
            // Code for OSX and Linux command line
            if( preview ){
                program += " --no-autoscale --width 300 --height 250";//--canvas-width=250";
            }
            file.append('"');
            file.prepend('"');
            program += " --extraintf http --http-host localhost --http-port 8080 --http-password pass " + file;
            qDebug() << program;
            m_process->start(program);
        #endif

        for (int i=1;i<10;i++){
            qDebug() << "Waiting for VLC to start" << m_process->state();
            if( m_process->state() != 0 ) break;
            delay(500);
        }
        lock = false;
        if( m_process->state() == 0 ) return false;
        return connect_to_player( false );
    }
}

bool VLC_HTTP::is_playing()
{
    return true;//( m_process->state() == 2 );
}


QString VLC_HTTP::name( )
{
    return "VLC"; // It should be VLC_HTTP, but we are not using any other interface
}

QString VLC_HTTP::get_title()
{
    return title;
}

void VLC_HTTP::ready( QNetworkReply* reply )
{
    if (reply->error() == QNetworkReply::NoError) {
        //qDebug() << "New data! " << QTime::currentTime();
        QString output = reply->readAll();
        QRegularExpressionMatch found;

        QRegularExpression re_vol("<volume>(.+)</volume>");
        QRegularExpression re_len("<length>(.+)</length>");
        QRegularExpression re_pos("<position>(.+)</position>");
        QRegularExpression re_rate("<rate>(.+)</rate>");

        if( output.contains(re_vol,&found) ){
            int vol = found.capturedTexts()[1].toFloat();
            volume = vol == 0? volume : vol; // Avoid capturing volume when muted
            //qDebug() << "Volume is: " << volume;
        }
        if( output.contains(re_len,&found) ){
            length = found.capturedTexts()[1].toFloat();
            //qDebug() << "Length is: " << length;
        }
        if( output.contains(re_pos,&found) ){
            position = found.capturedTexts()[1].toFloat();
            if( time != length*position ){
                time = length*position;
                emit timeChanged(time);
            }
            //qDebug() << "Time is: " << time;
        }
        if( output.contains(re_rate,&found) ){
            rate = found.capturedTexts()[1].toFloat();
            //qDebug() << "Rate is: " << rate;
            autoskip_pressed = rate > 1.1;
        }
        is_connected = true;
        delete reply;
    }
    else {
        //failure
        qDebug() << "Failure" <<reply->errorString();
        if( is_connected ){
            is_connected = false;
            emit playerLost();
        }
        time = -1;
        delete reply;
    }

}

void VLC_HTTP::kill()
{
  // Elegant solution
    QNetworkRequest req(QUrl( "http://localhost:8080/requests/status.xml?command=shutdown" ));
    manager->get(req);

  // Stop timer
    timer->stop();
    qDebug() << "killing timer";

  // Hardcore solution
    m_process->close();
}


void VLC_HTTP::seek( float sec )
{
    QNetworkRequest req(QUrl( QString("http://localhost:8080/requests/status.xml?command=seek&val=%1\%").arg( sec/length*100 ) ));
    manager->get(req);
}
/*

void VLC_HTTP::seek( float sec )
{
    int vol = volume/2;
    QNetworkRequest req(QUrl( QString("http://localhost:8080/requests/status.xml?command=volume&val=%1").arg( vol ) ));
    manager->get(req);

    vol/=2;
    QNetworkRequest req2(QUrl( QString("http://localhost:8080/requests/status.xml?command=volume&val=%1").arg( vol ) ));
    manager->get(req2);

    QNetworkRequest req3(QUrl( QString("http://localhost:8080/requests/status.xml?command=seek&val=%1\%").arg( sec/length*100 ) ));
    manager->get(req3);

    vol*=2;
    QNetworkRequest req4(QUrl( QString("http://localhost:8080/requests/status.xml?command=volume&val=%1").arg( vol ) ));
    manager->get(req4);

    vol*=2;
    QNetworkRequest req5(QUrl( QString("http://localhost:8080/requests/status.xml?command=volume&val=%1").arg( vol ) ));
    manager->get(req5);
}

*/
void VLC_HTTP::toggle_fullscreen( void )
{
    qDebug() << "Going to fullscreen";
    QNetworkRequest req(QUrl( "http://localhost:8080/requests/status.xml?command=fullscreen" ));
    manager->get(req);
}

void VLC_HTTP::play( void )
{
    QNetworkRequest req(QUrl( "http://localhost:8080/requests/status.xml?command=pl_pause" ));
    manager->get(req);
}

void VLC_HTTP::set_rate( float rate )
{
    QNetworkRequest req(QUrl( QString("http://localhost:8080/requests/status.xml?command=seek&val=%1").arg( rate ) ));
    manager->get(req);
}

void VLC_HTTP::slower()
{
    QNetworkRequest req(QUrl( QString("http://localhost:8080/requests/status.xml?command=rate&val=%1").arg( rate/2 ) ));
    manager->get(req);
}

void VLC_HTTP::faster( )
{
    QNetworkRequest req(QUrl( QString("http://localhost:8080/requests/status.xml?command=rate&val=%1").arg( rate*2 ) ));
    manager->get(req);
}

void VLC_HTTP::frame( )
{
    QNetworkRequest req(QUrl( "http://localhost:8080/requests/status.xml?command=frame" ));
    manager->get(req);
}

void VLC_HTTP::clean()
{
    //qDebug() << "Cleaning" <<reply->readAll();
}

float VLC_HTTP::get_time( )
{
    return time;
}

bool VLC_HTTP::is_autoskiping()
{
    return autoskip_pressed;
}


int VLC_HTTP::mute( )
{
    QNetworkRequest req(QUrl( "http://localhost:8080/requests/status.xml?command=volume&val=0" ));
    manager->get(req);
    return volume;
}

void VLC_HTTP::unmute( )
{
    QNetworkRequest req(QUrl( QString("http://localhost:8080/requests/status.xml?command=volume&val=%1").arg( volume ) ));
    manager->get(req);
}

