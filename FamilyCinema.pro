TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp \
    utils.cpp \
    vlc_tcp.cpp \
    vlc_console.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    utils.h \
    vlc_tcp.h \
    vlc_console.h

OTHER_FILES +=
