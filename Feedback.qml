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
            //Layout.columnSpan: 2
            text: qsTr("Perdón, intentaremos corregir el error.")
        }
        TextField {
            id: movie_name
            Layout.minimumHeight: 200
            Layout.fillWidth: true
            //placeholderText: qsTr("Título real")
        }
        RButton {
            text: "Enviar feedback"
            onClicked: {
                loader.source = "Open.qml"
                post( "action=badhash&username="+settings.user+"&password="+settings.password+"&filename="+ movie.title + "&hash=" + media.hash + "&bytesize=" + media.bytesize, function(){} )
                movie.title = movie_name.text
                loader.source = "Open.qml"
                media.hash = "";
                media.bytesize = -1;
                post( "action=search&filename="+ movie_name.text, loader.item.show_list )
                bad_movie.visible = false
            }
        }


    }
}
