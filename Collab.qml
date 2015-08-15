import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls 1.3


Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 2
        Component.onCompleted: { mainWindow.minimumWidth = 750; mainWindow.minimumHeight = 425; say_to_user("")}


        GroupBox {

            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                anchors.margins: 5
                columns: 2

                Label{
                    Layout.columnSpan: 2
                    color: "Green"
                    font.pointSize: 10
                    font.bold: true
                    text: qsTr("Feedback")
                    horizontalAlignment: Text.AlignHCenter
                }

                Label{
                    Layout.columnSpan: 2
                    text: qsTr("Muchas gracias por tu opinión")
                }
                /*TextField {
                    id: feedback
                    Layout.minimumWidth: 200
                    Layout.fillWidth: true
                    onAccepted: {
                        post( "action=feedback&idea="+feedback.text, function(){
                            feedback.text = qsTr("Recibido, gracias!")
                            say_to_user("Gracias por tu opinión")
                        } )
                    }
                }*/

                TextArea {
                    id: feedback
                    Layout.minimumWidth: 200
                    Layout.maximumHeight: 65
                    Layout.fillWidth: true
                }

                Button {
                    text: "Enviar feedback"
                    onClicked: post( "action=feedback&idea= Hola! soy "+settings.user+" quería decirte que "+feedback.text, function(){
                        feedback.text = qsTr("Recibido, gracias!")
                        say_to_user("Gracias por tu opinión")
                    } )
                }
            }
        }


        GroupBox {

            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                anchors.margins: 5
                columns: 2

                Label{
                    Layout.columnSpan: 2
                    color: "Green"
                    font.pointSize: 10
                    font.bold: true
                    text: qsTr("Donar")
                    horizontalAlignment: Text.AlignHCenter
                }

                Label{
                    Layout.columnSpan: 2
                    text: qsTr("Fcinema es gratuito, los gastos se cubren con donativos...")
                }
                Button {
                    text: "Donar"
                    onClicked: Qt.openUrlExternally("http://fcinema.org/collaborate.html#donate")
                }
            }
        }

        GroupBox {

            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                anchors.margins: 5
                columns: 2

                Label{
                    Layout.columnSpan: 2
                    color: "Green"
                    font.pointSize: 10
                    font.bold: true
                    text: qsTr("Añadir contenido")
                    horizontalAlignment: Text.AlignHCenter
                }

                Label{
                    Layout.columnSpan: 2
                    text: qsTr("Fcinema no sería posible sin la base de datos. Si crees que falta contenido...")
                }
            }
        }

        GroupBox {

            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                anchors.margins: 5
                columns: 2

                Label{
                    Layout.columnSpan: 2
                    color: "Green"
                    font.pointSize: 10
                    font.bold: true
                    text: qsTr("Desarrollar")
                    horizontalAlignment: Text.AlignHCenter
                }

                Label{
                    Layout.columnSpan: 2
                    text: qsTr("Si sabes de programación o ...")
                }
            }
        }

        GroupBox {

            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                anchors.margins: 5
                columns: 2

                Label{
                    Layout.columnSpan: 2
                    color: "Green"
                    font.pointSize: 10
                    font.bold: true
                    text: qsTr("Difundir")
                    horizontalAlignment: Text.AlignHCenter
                }

                Label{
                    Layout.columnSpan: 2
                    text: qsTr("¿Te gusta fcinema? Ayuda a otros a descubrirlo...")
                }
            }
        }

    }
}
