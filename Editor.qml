/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/





import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1

Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 6
        Component.onCompleted: { mainWindow.minimumWidth = 600;mainWindow.minimumHeight = 330}

        Component {
            id: editableDelegate
            Item {
                Text {
                    width: parent.width
                    anchors.margins: 4
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    elide: styleData.elideMode
                    text: styleData.value !== undefined ? styleData.value : ""
                    color: styleData.textColor
                    visible: !styleData.selected
                }
                Loader {
                    id: loaderEditor
                    anchors.fill: parent
                    anchors.margins: 4
                    Connections {
                        target: loaderEditor.item
                        onEditingFinished: {
                            if (typeof styleData.value === 'number')
                                var num = parseFloat(loaderEditor.item.text)
                                if ( typeof num === 'number' && num > 0 ) {
                                    scenelistmodel.setProperty(styleData.row, styleData.role, Number(num) )
                                }
                            else
                                scenelistmodel.setProperty(styleData.row, styleData.role, loaderEditor.item.text)
                        }
                    }
                    sourceComponent: styleData.selected ? editor : null
                    Component {
                        id: editor
                        TextInput {
                            id: textinput
                            color: styleData.textColor
                            text: styleData.value
                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: textinput.forceActiveFocus()
                            }
                        }
                    }
                }
            }
        }


        //Item {
        //    id: optionlist
        //    ComboBox {
        //        anchors.verticalCenter: parent.verticalCenter
        //        model: ListModel {
        //            ListElement {  text: "Veggies" }
        //            ListElement {  text: "Fruits" }
        //            ListElement {  text: "Cars"  }
        //        }
        //    }
        //}

        TableView {
           id: tableview
           sortIndicatorOrder: 1
           sortIndicatorColumn: 1
           Layout.preferredWidth: 590
           Layout.preferredHeight: 250
           Layout.columnSpan : 6
           //TableViewColumn{ role: "skip"; title: "Skip"; width: 40; delegate: checkBoxDelegate}
           TableViewColumn{ role: "type"  ; title: "Type" ; width: 60 }
           TableViewColumn{ role: "subtype" ; title: "Subtype" ; width: 80 }
           TableViewColumn{ role: "severity"; title: "Severity"; width: 80 }
           TableViewColumn{ role: "action"; title: "Action"; width: 60; }
           TableViewColumn{ role: "start" ; title: "Start" ; width: 60 }
           TableViewColumn{ role: "stop" ; title: "Stop" ; width: 60 }
           TableViewColumn{ role: "description" ; title: "Description" ; width: 189 }
           model: scenelistmodel
           sortIndicatorVisible: true
           itemDelegate: {
               return editableDelegate;
           }
        }

        Button {
            id: preview
            text: "Preview"
            //tooltip:"This is an interesting tool tip"
            //Layout.fillWidth: true
            onClicked: preview_scene()
        }

        Button {
            id: seek
            text: "Seek"
            //tooltip:"This is an interesting tool tip"
            Layout.fillWidth: true
            onClicked: set_time()
        }

        Button {
            id: gettime
            text: "Get time"
            //tooltip:"This is an interesting tool tip"
            Layout.fillWidth: true
            onClicked: time.text = get_time()
        }

        Label {
            id: time
        }

        Button {
            id: add
            text: "Add scene"
            //tooltip:"This is an interesting tool tip"
            Layout.fillWidth: true
            onClicked: scenelistmodel.append({
                "type":"Unknown",
                "subtype":"Unknown",
                "severity":0,
                "start":0,
                "duration":0,
                "description":"",
                "stop":0,
                "action":"",
                "skip": "No"
            })
        }

        Button {
            id: remove
            text: "Remove scene"
            //tooltip:"This is an interesting tool tip"
            Layout.fillWidth: true
            onClicked: scenelistmodel.remove(tableview.currentRow);
        }
    }

}
