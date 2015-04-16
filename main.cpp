#include <QApplication>
#include <QQmlApplicationEngine>
#include <QObject>
//#include <QtDeclarative/QDeclarativeContext>

#include <QString>

// include QtQml to be able call qmlRegisterType()
#include <QtQml>

// include our new type
#include "VLC.h"
#include "utils.h"


int main(int argc, char *argv[])
{

    /*QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    //QQmlContext *context = new QQmlContext(engine.rootContext());
    //QQmlContext *context = engine.rootContext();

    engine.rootContext()->setContextProperty("runplayer", &run_player);

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));
    return app.exec();*/

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();

    VLC o_vlc;
    context->setContextProperty("VLC", &o_vlc);

    Utils o_utils;
    context->setContextProperty("Utils", &o_utils);

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();

}



