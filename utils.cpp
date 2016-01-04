
#include "utils.h"

#include <stdio.h>
#include <stdlib.h>
#include <QtCore/QFileInfo>
#include <QDir>
#include <QFile>
#include <QQmlFile>
#include <inttypes.h>
#include <QStandardPaths>
#include <fstream>
#include <QCoreApplication>
#include <QTime>
#include <QByteArray>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QProcess>
#include <QApplication>
#include <QRegularExpression>
#include <QRegularExpressionMatch>

#ifdef Q_OS_WIN  // Implement genWin32ShellExecute() especially for UAC
    #include "qt_windows.h"
    #include "qwindowdefs_win.h"
    #include <shellapi.h>

int genWin32ShellExecute(QString AppFullPath,
                         QString Verb,
                         QString Params,
                         bool ShowAppWindow,
                         bool WaitToFinish);
#endif


// Execute/Open the specified Application/Document with the given command
// line Parameters
// (if WaitToFinish == true, wait for the spawn process to finish)
//
// Verb parameter values:
// ""           The degault verb for the associated AppFullPath
// "edit"       Launches an editor and opens the document for editing.
// "find"       Initiates a search starting from the specified directory.
// "open"       Launches an application. If this file is not an executable file, its associated application is launched.
// "print"      Prints the document file.
// "properties" Displays the object's properties.
//
// Ret: 0 = success
//     <0 = error
#ifdef Q_OS_WIN
int genWin32ShellExecute(QString AppFullPath,
                         QString Verb,
                         QString Params,
                         bool ShowAppWindow,
                         bool WaitToFinish)
{
    int Result = 0;

    // Setup the required structure
    SHELLEXECUTEINFO ShExecInfo;
    memset(&ShExecInfo, 0, sizeof(SHELLEXECUTEINFO));
    ShExecInfo.cbSize = sizeof(SHELLEXECUTEINFO);
    ShExecInfo.fMask = SEE_MASK_NOCLOSEPROCESS;
    ShExecInfo.hwnd = NULL;
    ShExecInfo.lpVerb = NULL;
    if (Verb.length() > 0)
        ShExecInfo.lpVerb = reinterpret_cast<const WCHAR *>(Verb.utf16());
    ShExecInfo.lpFile = NULL;
    if (AppFullPath.length() > 0)
        ShExecInfo.lpFile = reinterpret_cast<const WCHAR *>(AppFullPath.utf16());
    ShExecInfo.lpParameters = NULL;
    if (Params.length() > 0)
        ShExecInfo.lpParameters = reinterpret_cast<const WCHAR *>(Params.utf16());
    ShExecInfo.lpDirectory = NULL;
    ShExecInfo.nShow = (ShowAppWindow ? SW_SHOW : SW_HIDE);
    ShExecInfo.hInstApp = NULL;

    // Spawn the process
    if (ShellExecuteEx(&ShExecInfo) == FALSE)
    {
        Result = -1; // Failed to execute process
    } else if (WaitToFinish)
    {
        WaitForSingleObject(ShExecInfo.hProcess, INFINITE);
    }

    return Result;
}
#endif





void delay( int millisecondsToWait )
{
    QTime dieTime = QTime::currentTime().addMSecs( millisecondsToWait );
    while( QTime::currentTime() < dieTime )
    {
        QCoreApplication::processEvents( QEventLoop::AllEvents, 100 );
    }
}

float getNumberFromQString(const QString &xString)
{
  QRegExp xRegExp("(-?\\d+(?:[\\.,]\\d+(?:e\\d+)?)?)");
  xRegExp.indexIn(xString);
  QStringList xList = xRegExp.capturedTexts();

  if (true == xList.empty()) return -1.0;

  return xList.begin()->toFloat();
}


#define MAX(x,y) (((x) > (y)) ? (x) : (y))
#ifndef uint64_t
#define uint64_t unsigned long long
#endif

uint64_t compute_hash(FILE * handle)
{
        uint64_t hash, fsize;

        fseek(handle, 0, SEEK_END);
        fsize = ftell(handle);
        fseek(handle, 0, SEEK_SET);

        hash = fsize;

        for(uint64_t tmp = 0, i = 0; i < 65536/sizeof(tmp) && fread((char*)&tmp, sizeof(tmp), 1, handle); hash += tmp, i++);
        fseek(handle, (long)MAX(0, fsize - 65536), SEEK_SET);
        for(uint64_t tmp = 0, i = 0; i < 65536/sizeof(tmp) && fread((char*)&tmp, sizeof(tmp), 1, handle); hash += tmp, i++);

        return hash;
}

Utils::Utils(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this)),
    m_process2(new QProcess(this))
{
    translator = new QTranslator(this);
    selectLanguage(111); // 111 always spanish, -1 system default language
}

// Get the size of a file
double Utils::get_size( QString filename ){
    filename = QQmlFile::urlToLocalFileOrQrc(filename);
    std::ifstream in(filename.toStdString().c_str(), std::ifstream::ate | std::ifstream::binary);
    return in.tellg();
}

// Search for vlc executable
QString Utils::get_vlc_path()
{
    qDebug() << "Searching vlc executable";
    QString x86 = "C:\\Program Files (x86)\\VideoLAN\\VLC\\vlc.exe";
    QFile file( x86 ); if( file.exists() ) return x86;

    QString x64 = "C:\\Program Files\\VideoLAN\\VLC\\vlc.exe";
    QFile file64( x64 ); if( file64.exists() ) return x64;

    QString MacOS = "/Applications/VLC.app/Contents/MacOS/VLC";
    QFile fileMacOS( MacOS ); if( fileMacOS.exists() ) return MacOS;

    return "vlc";

}


// Download the updater
bool Utils::update( QString url )
{
    #ifdef Q_OS_WIN
        manager = new QNetworkAccessManager();
        connect(manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(updater_ready(QNetworkReply*)));
        QNetworkRequest req(QUrl("http://fcinema.org/updater2.exe"));
        manager->get(req);
        return true;
    #else
        return false;
    #endif

}

// Run the updater
void Utils::updater_ready( QNetworkReply* reply )
{
    if (reply->error() == QNetworkReply::NoError) {
    // Save updater data to disk
        QString tempPath =  QStandardPaths::writableLocation( QStandardPaths::TempLocation );
        QString updater = tempPath + "\\updater.exe";
        qDebug() << "Updater path: " << updater;
        QByteArray data =  reply->readAll();
        QFile file( updater );
        if( file.exists() ) file.remove();
        if(!file.open(QIODevice::WriteOnly )) {
            qDebug() << file.errorString();
            delete reply;
            return;
        }
        qDebug() << file.write( data );
        file.close();
    // Run updater
        #ifdef Q_OS_WIN
            if (0 != genWin32ShellExecute( updater, "", "", false, false) ) qDebug() << "Error";
        #endif
        QApplication::quit();
        delete reply;
    }
    else {
        qDebug() << "Failure" <<reply->errorString();
        delete reply;
    }

}

// Compute the hash of a media file
QString Utils::get_hash( QString filename)
{
    FILE * handle;
    uint64_t myhash;
    filename = QQmlFile::urlToLocalFileOrQrc(filename);
    qDebug() << "Computing hash on file: " << filename;
    handle = fopen( filename.toStdString().c_str(), "rb");
    if (!handle) { return "Error"; }
    myhash = compute_hash(handle);
    char temp[32]; // its 16, but just in case
    #ifdef Q_OS_WIN
        sprintf(temp, "%I64x", myhash);
    #else
        sprintf(temp, "%" PRIx64, myhash);
    #endif
    QString hash = "";
    hash.prepend( temp );
    fclose(handle);
    return hash;
}


// Write string "data" to a file with filename "filename" inside the system default folder for fcinema
bool Utils::write_data(QString data, QString filename )
{
    QString path = QStandardPaths::writableLocation( QStandardPaths::AppDataLocation );
    qDebug()<< "Writting data to " << path << "/"<< filename;
    if( !QDir( path ).exists() ){
        QDir().mkpath( path );
        qDebug() << "Creating dir...";
        //QDir().mkdir( path );
    }
    QFile file( path + "//" + filename );
    if(!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << file.errorString();
    }else{
        //qDebug() << 
        file.write(data.toStdString().c_str() );
        file.close();
        if( file.exists() ) return true;
    }
    qDebug() << "Unable to write data";
    return false;
}

// Read a string of data from the file with filename "filename" inside the fcinema's default OS folder
QString Utils::read_data(QString filename)
{
    QString path = QStandardPaths::writableLocation( QStandardPaths::AppDataLocation );
    qDebug()<< "Reading data from " << filename;

    QFile file( path + "//" + filename );
    if( !file.exists() ){
        qDebug() << "No file "<< filename << "!";
        return QString();
    }
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text )) {
        qDebug() << "Reading file error " << file.errorString();
    }else{
        QString output = file.readAll();
        file.close();
        return output;
    }
    return QString();
}


QString Utils::read_external_data(QString filename)
{
    filename = QQmlFile::urlToLocalFileOrQrc(filename);
    QFile file( filename );
    qDebug() << "Reading data from " << filename;

    if( !file.exists() ){
        qDebug() << "No file!";
        return QString();
    }

    if(!file.open(QIODevice::ReadOnly | QIODevice::Text )) {
        qDebug() << "Error:" << file.errorString();
        return QString();
    }

    QString output = file.readAll();
    file.close();
    return output;
}


// Set fcinema language to...
bool Utils::selectLanguage(int language) {
// If no language specified, use system language
    if( language == -1 ){
        language = QLocale::system().language();
    }

// Load language
    if( language == 111 ){
        qDebug() << "Loading spanish";
    }else{
        qDebug() << "Loading english: ";
        qDebug() << translator->load("en",QCoreApplication::applicationDirPath());
        qDebug() << qApp->installTranslator(translator);
    }
}
