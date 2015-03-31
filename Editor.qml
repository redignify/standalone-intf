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
import QtQuick.Dialogs 1.2


Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 8
        Component.onCompleted: { mainWindow.minimumWidth = 620;mainWindow.minimumHeight = 350}

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

        TableView {
           id: tableview
           sortIndicatorOrder: 1
           sortIndicatorColumn: 1
           Layout.preferredWidth: 450
           Layout.preferredHeight: 250
           Layout.columnSpan : 7
           Layout.rowSpan: 7
           //TableViewColumn{ role: "skip"; title: "Skip"; width: 40; delegate: checkBoxDelegate}
           /*TableViewColumn {
               role:"type_drop"
               title:"Type"
               width: 120
               delegate: Item {
                   ComboBox {
                       anchors.verticalCenter: parent.verticalCenter
                       width: 120
                       currentIndex: 1
                       model: ListModel {
                           id: type_list
                           ListElement {  text: "Violence" }
                           ListElement {  text: "Sex" }
                           ListElement {  text: "Profanity"  }
                       }
                       onCurrentIndexChanged: scenelistmodel.set(styleData.row, {"type": type_list.get(currentIndex).text })
                   }
               }
           }/*
           TableViewColumn {
               role:"subtype_drop"
               title:"Subtype"
               width: 120
               delegate: Item {
                   ComboBox {
                       anchors.verticalCenter: parent.verticalCenter
                       width: 120
                       currentIndex: 1
                       model: ListModel {
                           id: subtype_list
                           ListElement {  text: "Violence" }
                           ListElement {  text: "Sex" }
                           ListElement {  text: "Profanity"  }
                       }
                   }
               }
           }
           TableViewColumn {
               role:"severity_drop"
               title:"Severity"
               width: 80
               delegate: Item {
                   ComboBox {
                       anchors.verticalCenter: parent.verticalCenter
                       width: 80
                       currentIndex: 1
                       model: ListModel {
                           id: severity_list
                           ListElement {  text: "Low" }
                           ListElement {  text: "Medium" }
                           ListElement {  text: "High"  }
                       }
                       onCurrentIndexChanged: scenelistmodel.set(styleData.row, {"severity": severity_list.get(currentIndex).text })
                   }
               }
           }
           TableViewColumn {
               role:"action_drop"
               title:"Action"
               width: 80
               delegate: Item {
                   ComboBox {
                       anchors.verticalCenter: parent.verticalCenter
                       width: 80
                       currentIndex: 1
                       model: ListModel {
                           id: action_list
                           ListElement {  text: "Skip" }
                           ListElement {  text: "Mute" }
                       }
                       onCurrentIndexChanged: scenelistmodel.set(styleData.row, {"action": action_list.get(currentIndex).text })
                   }
               }
           }*/
           TableViewColumn{ role: "type"  ; title: "Type" ; width: 90 }
           TableViewColumn{ role: "subtype" ; title: "Subtype" ; width: 100 }
           TableViewColumn{ role: "severity"; title: "Severity"; width: 80 }
           TableViewColumn{ role: "action"; title: "Action"; width: 60; }
           TableViewColumn{ role: "start" ; title: "Start" ; width: 60 }
           TableViewColumn{ role: "stop" ; title: "Stop" ; width: 60 }
           TableViewColumn{ role: "description" ; title: "Why?" ; width: 189 }
           model: scenelistmodel
           selectionMode: SelectionMode.SingleSelection
           sortIndicatorVisible: true
           onClicked : {
               var current_scene = scenelistmodel.get(tableview.currentRow)
               type_combo.currentIndex     = type_combo.find( current_scene.type )
               subtype_combo.currentIndex  = subtype_combo.find( current_scene.subtype )
               action_combo.currentIndex   = action_combo.find( current_scene.action )
               severity_combo.currentIndex = severity_combo.find( current_scene.severity.toString() )
               start_input.text            = current_scene.start
               stop_input.text             = current_scene.stop
               description_input.text      = current_scene.description
           }

           /*itemDelegate: {
               return editableDelegate;
           }*/
        }

        ComboBox {
            id: type_combo
            width: 150
            model: ListModel {
                id: type_list
                ListElement {  text: "Violence" }
                ListElement {  text: "Sex" }
                ListElement {  text: "Profanity"  }
            }
            onCurrentIndexChanged: scenelistmodel.set(tableview.currentRow, {"type": type_list.get(currentIndex).text })
        }

        ComboBox {
            id: subtype_combo
            width: 150
            model: ListModel {
                id: subtype_list
                ListElement {  text: "Explicit" }
                ListElement {  text: "Implicit" }
            }
            onCurrentIndexChanged: scenelistmodel.set(tableview.currentRow, {"subtype": subtype_list.get(currentIndex).text })
        }
        ComboBox {
            width: 150
            id: severity_combo
            model: severity_list
            onCurrentIndexChanged: scenelistmodel.set(tableview.currentRow, {"severity": severity_list.get(currentIndex).text })
        }
        ComboBox {
            width: 150
            id: action_combo
            model: action_list
            onCurrentIndexChanged: scenelistmodel.set(tableview.currentRow, {"action": action_list.get(currentIndex).text })
        }

        TextField {
            id: start_input
            Layout.preferredWidth: 150
            placeholderText: "Start time"
            onEditingFinished: scenelistmodel.set(tableview.currentRow, {"start": parseFloat( start_input.text ) })
            onAccepted: start_input.text = get_time()
        }
        TextField {
            id: stop_input
            Layout.preferredWidth: 150
            placeholderText: "Stop time"
            onEditingFinished: scenelistmodel.set(tableview.currentRow, {"stop": parseFloat( stop_input.text ) })
            onAccepted: stop_input.text = get_time()
        }

        TextField {
            id: description_input
            Layout.preferredWidth: 150
            placeholderText: "Why inadecuate?"
            onTextChanged: scenelistmodel.set(tableview.currentRow, {"description": description_input.text })
        }


        Button {
            id: b_preview
            text: "Preview"
            //tooltip:"This is an interesting tool tip"
            //Layout.fillWidth: true
            onClicked: preview_scene( parseFloat( start_input.text ), parseFloat( stop_input.text ) )
        }

        Button {
            id: b_add
            text: "Add scene"
            //tooltip:"This is an interesting tool tip"
            Layout.fillWidth: true
            onClicked: {
                scenelistmodel.append({
                    "type":type_list.get(type_combo.currentIndex).text,
                    "subtype":subtype_list.get(subtype_combo.currentIndex).text,
                    "severity":severity_list.get(severity_combo.currentIndex).text,
                    "start": parseFloat( start_input.text ),
                    "duration": parseFloat( stop_input.text ) - parseFloat( start_input.text ),
                    "description": description_input.text,
                    "stop": parseFloat( stop_input.text ),
                    "action":action_list.get(action_combo.currentIndex).text,
                    "skip": "No"
                })
                tableview.selection.deselect(0, tableview.rowCount - 1)
                tableview.selection.select( tableview.rowCount - 1 )
            }
        }

        Button {
            id: remove
            text: "Remove scene"
            //tooltip:"This is an interesting tool tip"
            Layout.fillWidth: true
            onClicked: {
                scenelistmodel.remove(tableview.currentRow);
                tableview.selection.deselect( 0, tableview.rowCount - 1)
                tableview.selection.select( tableview.rowCount - 1 )
            }

        }

        Button {
            id: b_share
            text: "Share"
            //tooltip:"This is an interesting tool tip"
            Layout.fillWidth: true
            onClicked: requestPass.visible = true
        }
    }

    Dialog {
        id: requestPass
        width: 200
        height: 100
        //title: "Identification required"
        GridLayout {
            columns: 2
            Label{
                text: "Username"
            }
            TextField {
                id:name
                //placeholderText: "Username"
            }
            Label{
                text: "Password"
            }
            TextField {
                id:pass
                echoMode: TextInput.Password
                //placeholderText: "Password"
            }
            Button {
                text: "Share"
                //tooltip:"This is an interesting tool tip"
                onClicked: {
                    share( name.text, pass.text )
                    requestPass.visible = false
                }
            }
            Button {
                text: "Cancel"
                //tooltip:"This is an interesting tool tip"
                onClicked: requestPass.visible = false
            }
        }
        onAccepted: {
            share( name.text, pass.text )
            requestPass.visible = false
        }
    }

    function share( user, pass)
    {
        // Recover original file
        var jsonObject = JSON.parse( movie.data );
        if ( !jsonObject ) { return }

        // Update scenes data
        jsonObject['Scenes'] = [];
        for( var i = 0; i < scenelistmodel.count; ++i){
            jsonObject['Scenes'][i] = {}
            var scene = scenelistmodel.get(i)
            jsonObject['Scenes'][i]["Category"] = scene.type
            jsonObject['Scenes'][i]["SubCategory"] = scene.subtype
            jsonObject['Scenes'][i]["Severity"] = scene.severity
            jsonObject['Scenes'][i]["Start"] = (scene.start - sync.applied_offset)/sync.applied_speed
            jsonObject['Scenes'][i]["End"] = (scene.stop - sync.applied_offset)/sync.applied_speed
            jsonObject['Scenes'][i]["Action"] = scene.action
            jsonObject['Scenes'][i]["AdditionalInfo"] = scene.description
        }

        if( media.hash ){
            // Update sync data
            if( !jsonObject["SyncInfo"] ) jsonObject["SyncInfo"] = []

            var sync_updated_flag = 0
            for( i=0; i<jsonObject["SyncInfo"].length; ++i ){
                if( jsonObject["SyncInfo"][i]["Hash"] == media.hash ){
                    jsonObject["SyncInfo"][i]["SpeedFactor"] = sync.applied_speed
                    jsonObject["SyncInfo"][i]["TimeOffset"] = sync.applied_offset
                    jsonObject["SyncInfo"][i]["Confidence"] = sync.confidence
                    sync_updated_flag = 1
                }
            }
            if (sync_updated_flag == 0) {
                i = jsonObject["SyncInfo"].length
                jsonObject["SyncInfo"][i] = {}
                jsonObject["SyncInfo"][i]["Hash"] = media.hash
                jsonObject["SyncInfo"][i]["SpeedFactor"] = sync.applied_speed
                jsonObject["SyncInfo"][i]["TimeOffset"] = sync.applied_offset
                jsonObject["SyncInfo"][i]["Confidence"] = sync.confidence
            }
        }

        // Format and share
        var str = JSON.stringify( jsonObject, "", 2 );
        console.log( str )
        post( "action=modify&data="+str+"&username="+user+"&password="+pass, function(){} )
    }

}
