import QtQuick 2.0
import QtQuick.Controls 1.0
import QtWebKit 3.0

ScrollView {
    width: 750
    height: 425
    WebView {
        id: webview
        url: Qt.resolvedUrl( "help/fcinema.html" )
        anchors.fill: parent
    }
    Component.onCompleted: console.log(  Qt.resolvedUrl( "help/fcinema.html" ) )
}
