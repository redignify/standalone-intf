#include <QApplication>
#include <QQmlApplicationEngine>
#include <QObject>
//#include <QtDeclarative/QDeclarativeContext>

#include <QString>

// include QtQml to be able call qmlRegisterType()
#include <QtQml>

// include our new type
#include "vlc_console.h"
#include "vlc_tcp.h"
#include "utils.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();

    VLC o_vlc_console;
    context->setContextProperty("VLC_CONSOLE", &o_vlc_console);

    VLC_TCP o_vlc_tcp;
    context->setContextProperty("VLC_TCP", &o_vlc_tcp);

    Utils o_utils;
    context->setContextProperty("Utils", &o_utils);

    app.setOrganizationName("redignify");
    app.setOrganizationDomain("redignify.org");
    app.setApplicationName("Redignify");

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();

}



