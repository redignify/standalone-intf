TEMPLATE = app

QT += qml quick widgets
QT += core gui multimedia

SOURCES += main.cpp \
    utils.cpp \
    vlc_tcp.cpp \
    vlc_console.cpp \
    vlc_http.cpp \
    xcorr.cpp

RESOURCES += qml.qrc

TRANSLATIONS = en.ts

lupdate_only{
SOURCES += main.qml \
    Collab.qml \
    Config.qml \
    Editor.qml \
    Help.qml \
    Open.qml \
    Play.qml
}

RC_ICONS = logo.ico
# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    utils.h \
    vlc_tcp.h \
    vlc_console.h \
    vlc_http.h \
    xcorr.h

OTHER_FILES +=

DISTFILES +=

