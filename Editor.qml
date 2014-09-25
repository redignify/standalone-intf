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
        columns: 5
        Component.onCompleted: { mainWindow.minimumWidth = 485;mainWindow.minimumHeight = 350}

        Button {
            id: watch
            text: "Watch"
            //tooltip:"This is an interesting tool tip"
            //Layout.fillWidth: true
            onClicked: Player.launch( media.url )
        }

        Button {
            id: seek
            text: "Seek"
            //tooltip:"This is an interesting tool tip"
            Layout.fillWidth: true
            onClicked: Player.seek( 20 )
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


        TableView {
           id: tableview
           width: 480
           height: 200
           sortIndicatorOrder: 1
           sortIndicatorColumn: 1
           Layout.preferredWidth: 540
           Layout.preferredHeight: 150
           Layout.columnSpan : 5
           //TableViewColumn{ role: "skip"; title: "Skip"; width: 40; delegate: checkBoxDelegate}
           TableViewColumn{ role: "action"; title: "Action"; width: 50; }
           TableViewColumn{ role: "type"  ; title: "Type" ; width: 60 }
           TableViewColumn{ role: "subtype" ; title: "Subtype" ; width: 80 }
           TableViewColumn{ role: "severity" ; title: "Severity" ; width: 80 }
           TableViewColumn{ role: "start" ; title: "Start" ; width: 60 }
           TableViewColumn{ role: "stop" ; title: "Stop" ; width: 60 }
           TableViewColumn{ role: "description" ; title: "Description" ; width: 100 }
           model: scenelistmodel
           sortIndicatorVisible: true
           Component.onCompleted: show_scenes()
           onCurrentRowChanged : update_values()
        }

        ComboBox {
            id: action_combo
            width: 100
            activeFocusOnPress: true
            onCurrentIndexChanged: editor_end.focus = true
            model: ["Skip", "Mute" ]
        }

        ComboBox {
            id: type_combo
            Layout.preferredWidth: 125
            activeFocusOnPress: true
            onCurrentIndexChanged: editor_end.focus = true
            model: ["Sex & Nudity", "Violence & Gore", "Profanity", "Drugs"]
        }

        ComboBox {
            id: subtype_combo
            Layout.preferredWidth: 125
            activeFocusOnPress: true
            onCurrentIndexChanged: editor_end.focus = true
            model: ["Sex & Nudity", "Violence & Gore", "Profanity", "Drugs"]
        }

        ComboBox {
            id: severity_combo
            width: 100
            activeFocusOnPress: true
            onCurrentIndexChanged: editor_end.focus = true
            model: ["1", "2","3","4","5"]
        }

        TextField {
            id: editor_start
            placeholderText: "Start"
            onTextChanged: scenelistmodel.set( tableview.currentRow, {"start": text } )
        }

        TextField {
            id: editor_end
            placeholderText: "End"
            onTextChanged: scenelistmodel.set( tableview.currentRow, {"stop": text } )
        }

        TextField {
            id: editor_description
            placeholderText: "Description"
            onTextChanged: scenelistmodel.set( tableview.currentRow, { "description": text })
        }

    }

    function update_list()
    {
        var item = scenelistmodel.get( tableview.currentRow )
        item.description = editor_description.text
        item.start = editor_start.text
        item.stop = editor_end.text
        //item.severity = severity_combo.currentText
    }

    function update_values()
    {
        var item = scenelistmodel.get( tableview.currentRow )
        editor_description.text = item.description
        editor_start.text = item.start
        editor_end.text = item.stop
        //severity_combo.currentText = item.severity
    }

    function show_scenes()
    {
        if( movie.data == "" )
        {
            //loader.source = "Open.qml"
            return
        }
        console.log( movie.data )
        var data = JSON.parse( movie.data )
        scenelistmodel.clear()
        var Scenes = data["Scenes"]
        for ( var i = 0; i < Scenes.length; ++i) {
            var item = {
                "type": Scenes[i]["Category"],
                "subtype": Scenes[i]["SubCategory"],
                "severity": Scenes[i]["Severity"],
                "start": Scenes[i]["Start"],
                "stop": Scenes[i]["End"],
                "description": Scenes[i]["AdditionalInfo"],
            }
            scenelistmodel.append( item )
        }
    }

}
