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

Utils::Utils()
{
}

double Utils::get_size( QString filename ){
    filename = QQmlFile::urlToLocalFileOrQrc(filename);
    std::ifstream in(filename.toStdString().c_str(), std::ifstream::ate | std::ifstream::binary);
    return in.tellg();
}



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
    #ifdef WIN32
        sprintf(temp, "%I64x", myhash);
    #else
        sprintf(temp, "%" PRIx64, myhash);
    #endif
    QString hash = "";
    hash.prepend( temp );
    fclose(handle);
    return hash;
}

bool Utils::write_data(QString data, QString file)
{
    qDebug()<< QStandardPaths::writableLocation( QStandardPaths::AppDataLocation );
}

QString Utils::read_data(QString file)
{

}
