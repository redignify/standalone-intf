#include "utils.h"

#include <stdio.h>
#include <stdlib.h>
#include <QtCore/QFileInfo>
#include <QDir>
#include <QFile>
#include <QQmlFile>
#include <inttypes.h>

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
    sprintf(temp, "%" PRIx64 "\n", myhash);
    QString hash = "";
    hash.prepend( temp );
    fclose(handle);
    return hash;
}


