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

        Label{
            text: "Time offset"
        }
        TextField {
            id:offset
            text: sync.applied_offset
            onEditingFinished: apply_sync( parseFloat(offset.text), parseFloat(speed.text), 1 )
        }
        Label{
            text: "Speed factor"
        }
        TextField {
            id:speed
            text: sync.applied_speed
            onEditingFinished: apply_sync( parseFloat(offset.text), parseFloat(speed.text), 1 )
        }
        Button {
            id: b_calibrate
            text: "Guided calibration"
            //tooltip:"This is an interesting tool tip"
//            Layout.fillWidth: true
            onClicked: {
                calibrate.visible = true
                watch_movie()
                var i = get_sync_scene_index()
                var start_search = Math.max( 1, scenelistmodel.get(i).start - 30 )
                preview_scene( 0, start_search ) // just a trick to "wait" until movie is loaded before jump
                player.execute.set_rate( 2 )
            }
        }

    }
}


