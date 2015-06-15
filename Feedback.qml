import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1


Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 1
        Component.onCompleted: { mainWindow.minimumWidth = 750; mainWindow.minimumHeight = 425; say_to_user("")}


        RLabel{
            text: qsTr("Muchas gracias por tu opinión")
        }
        TextField {
            id: feedback
            //Layout.minimumHeight: 200
            Layout.fillWidth: true
            onAccepted: {
                post( "action=feedback&idea="+feedback.text, function(){} )
                loader.source = "Open.qml"
            }
        }
        RButton {
            text: "Enviar feedback"
            onClicked: {
                post( "action=feedback&idea="+feedback.text, function(){} )
                loader.source = "Open.qml"
            }
        }


    }
}
