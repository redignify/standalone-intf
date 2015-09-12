import QtQuick 2.0
import QtQuick.Controls 1.0
import QtWebKit 3.0
//import QtWebKit.experimental 1.0

ScrollView {
    width: 750
    height: 425
    WebView {
        id: webview
        url: Qt.resolvedUrl( "discover/fcinema.html" )
        anchors.fill: parent
        //experimental.preferences.developerExtrasEnabled: true
    }

}
