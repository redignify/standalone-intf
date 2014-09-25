import QtQuick 2.2
import QtQuick.Layouts 1.1


Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 3
        Component.onCompleted: { mainWindow.minimumWidth = 485;mainWindow.minimumHeight = 350}

    }
}
