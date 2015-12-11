import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

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
                    text: qsTr("Queremos ofrecerte lo mejor, ¿en qué podemos mejorar?")
                }

                TextArea {
                    id: feedback
                    Layout.minimumWidth: 200
                    Layout.maximumHeight: 65
                    Layout.fillWidth: true
                }

                Button {
                    text: qsTr( "Enviar feedback" )
                    onClicked: post( "action=feedback&idea="+feedback.text+"&user="+settings.user , function(){
                        feedback.text = qsTr("Recibido, ¡gracias!")
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

                Text{
                    Layout.columnSpan: 2
                    Layout.maximumWidth: 330
                    horizontalAlignment: Text.AlignJustify
                    wrapMode: "WordWrap"
                    text: qsTr("Fcinema es gratuito, y queremos que siga siendolo para que todo el mundo pueda disfrutar de una buena película en familia. Si te gusta fcinema y puedes permitirtelo ayuda a mantener fcinema en marcha!")
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
                    Layout.maximumWidth: 350
                    wrapMode: "WordWrap"
                    textFormat: Text.RichText
                    horizontalAlignment: Text.AlignJustify
                    text: qsTr("Fcinema no sería posible sin la base de datos. Una de las mejores y más divertidas formas de colaborar es coger un buen montón de palomitas y elegir una buena película. Si mientras disfrutas la película aparece una escena que consideras inconviente, pulsa '+' para marcar la escena, unos click al terminar y todo el mundo podra disfrutar de cine familiar ;). Para más detalle, puedes consultar la ayuda desde la barra superior.")
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
                    Layout.maximumWidth: 330
                    wrapMode: "WordWrap"
                    textFormat: Text.RichText
                    horizontalAlignment: Text.AlignJustify
                    text: qsTr("Si sabes de programación o te gusta el diseño este es tú sitio. Entre todos podemos hacer de fcinema un producto aún mejor. Puedes descargar el código desde <a href=\"https://github.com/fcinema\">github.com/fcinema</a>. ¡Ah!, y no dudes en ponerte en contacto con nosotros si tienes cualquier duda!")
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
                    Layout.maximumWidth: 350
                    wrapMode: "WordWrap"
                    horizontalAlignment: Text.AlignJustify
                    text: qsTr("¿Te gusta fcinema? ¡Ayuda a otros a descubrirlo!")
                }
            }
        }

    }
}
