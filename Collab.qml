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


    // Panel: Feedback
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

                TextArea {
                    id: feedback
                    Layout.minimumWidth: 200
                    Layout.maximumHeight: 65
                    Layout.fillWidth: true
                }

                Button {
                    text: qsTr( "Enviar feedback" )
                    onClicked: post( "action=feedback&idea= Hola! soy "+settings.user+" quería decirte que "+feedback.text, function(){
                        feedback.text = qsTr("Recibido, gracias!")
                        say_to_user( qsTr( "Gracias por tu opinión") )
                    } )
                }
            }
        }


    // Panel: Donate (please ^_^)
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
                    text: qsTr( "Donar" )
                    onClicked: Qt.openUrlExternally("http://fcinema.org/collaborate.html#donate")
                }
            }
        }


    // Panel: Add content to db!
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


    // Panel: Help coding!
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


    // Panel: Like fcinema? share it!
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
