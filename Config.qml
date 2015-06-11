import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.2


Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 2
        Component.onCompleted: { mainWindow.minimumWidth = 485; mainWindow.minimumHeight = 350 }


        RLabel{ text: qsTr("Diferencia tiempo") }
        TextField {
            Layout.preferredWidth: 100
            id:offset
            text: sync.applied_offset
            onEditingFinished: apply_sync( parseFloat(offset.text), parseFloat(speed.text), 1 )
        }


        RLabel{ text: qsTr("Diferencia velocidad") }
        TextField {
            Layout.preferredWidth: 100
            id:speed
            text: sync.applied_speed
            onEditingFinished: apply_sync( parseFloat(offset.text), parseFloat(speed.text), 1 )
        }


        RLabel{ text: qsTr("Calibración guiada") }
        RButton {
            text: qsTr("Calibrar")
            Layout.preferredWidth: 100
            onClicked: manual_calibration()
        }


        RLabel{ text: qsTr("Margen de seguridad") }
        TextField {
            text: settings.time_margin
            onEditingFinished: settings.time_margin = parseFloat(text)
        }


        RLabel{ text: qsTr("Ejecutable VLC") }
        TextField {
            text: settings.vlc_path
            Layout.minimumWidth: 250
            onEditingFinished: {
                settings.vlc_path = text
                VLC_CONSOLE.set_path( settings.vlc_path )
                VLC_TCP.set_path( settings.vlc_path )
            }
        }


        RLabel{ text: qsTr("Preguntar al añadir escena") }
        CheckBox {
            text: qsTr("")
            checked: settings.ask
            onClicked: settings.ask = checked
        }


        RLabel{ text: qsTr("Lanzar en pantalla completa") }
        CheckBox {
            text: qsTr("")
            checked: settings.start_fullscreen
            onClicked: settings.start_fullscreen = checked
        }


        RLabel{ text: qsTr("Compartir información automáticamente") }
        CheckBox {
            text: qsTr("")
            checked: settings.autoshare
            onClicked: settings.autoshare = checked
        }

        Button {
            text: "Import/Export"
            onClicked: dialog_import.visible = true
        }

        RButton {
            id: testing
            text: "test"
            onClicked: {
                survey.visible = true
                //get_subs()
                //media.url = fileurl.text.toString()
                //parse_input_file()
                //calibrate_from_subtitles()
                //console.log(JSON.stringify(a))
                //console.log( seconds_to_time(65) )
            }
        }

    }
}


