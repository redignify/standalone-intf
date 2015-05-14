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

        RLabel{
            text: "Time offset"
        }
        TextField {
            id:offset
            text: sync.applied_offset
            onEditingFinished: apply_sync( parseFloat(offset.text), parseFloat(speed.text), 1 )
        }
        RLabel{
            text: "Speed factor"
        }
        TextField {
            id:speed
            text: sync.applied_speed
            onEditingFinished: apply_sync( parseFloat(offset.text), parseFloat(speed.text), 1 )
        }
        RLabel{
            text: "Guided calibration"
        }
        RButton {
            id: b_calibrate
            text: "Calibrate"
            //tooltip:"This is an interesting tool tip"
//            Layout.fillWidth: true
            onClicked: manual_calibration()
        }
        RLabel{
            text: "Security margin"
        }
        TextField {
            id:margin
            text: configuration.time_margin
            onEditingFinished: configuration.time_margin = parseFloat(margin.text)
        }

    }
}


