import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1


Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 1
        Component.onCompleted: { mainWindow.minimumWidth = 485;mainWindow.minimumHeight = 350}


        RLabel{
            text: qsTr("Perdón, intentaremos corregir el error.")
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
