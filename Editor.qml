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
        Component.onCompleted: { mainWindow.minimumWidth = 800; mainWindow.minimumHeight = 350}

        GridLayout {
            columns: 3
            Layout.columnSpan: 2
            //Layout.minimumWidth: 400
            Layout.preferredWidth: 400
            Layout.minimumHeight: 150

            RComboBox {
                id: type_combo
                Layout.preferredWidth : 135
                //Layout.maximumWidth: 135
                model: type_list
                onCurrentIndexChanged: scenelistmodel.set(tableview.currentRow, {"type": type_combo.currentText })
            }


            //RLabel{ Layout.columnSpan: 1; text: qsTr("Discriminación") }
            RSlider{ id: severity; Layout.columnSpan: 2; Layout.fillWidth: true; maximumValue: 4; value: 0; onValueChanged: scenelistmodel.set(tableview.currentRow, {"severity": value + 1 } ) }
            RCheckBox { id: race; text: qsTr("Raza"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Race", checked ) }
            RCheckBox { id: nati; text: qsTr("Nacionalidad"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Nationality", checked ) }
            RCheckBox { id: sexdisc;  text: qsTr("Machismo"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Machismo", checked ) }
            RCheckBox { id: homo;  text: qsTr("Homofobia"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Homofobic", checked ) }
            RCheckBox { id: rel; text: qsTr("Religión"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Religion", checked ) }
            RCheckBox { id: ideo; text: qsTr("Ideología"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Ideology", checked ) }

            //RLabel { Layout.columnSpan: 1; text: qsTr("Violencia") }
            //RSlider{ id: s_vio; Layout.columnSpan: 2; maximumValue: 4; value: 0; }
            CheckBox { id: phy; text: qsTr("Física"); visible: type_combo.currentIndex == 1; onClicked: add_tag("Physical", checked ) }
            CheckBox { id: psico; text: qsTr("Psicológica"); visible: type_combo.currentIndex == 1; onClicked: add_tag("Psicological", checked ) }
            CheckBox { id: animal;  text: qsTr("Animal"); visible: type_combo.currentIndex == 1; onClicked: add_tag("Animal", checked ) }
            CheckBox { id: sad;  text: qsTr("Sadismo"); visible: type_combo.currentIndex == 1; onClicked: add_tag("Sadism", checked ) }
            CheckBox { id: blo;  text: qsTr("Sangre"); visible: type_combo.currentIndex == 1; onClicked: add_tag("Blood", checked ) }
            CheckBox { id: suf;  text: qsTr("Tortura"); visible: type_combo.currentIndex == 1; onClicked: add_tag("Torture", checked ) }

            //RLabel{ Layout.columnSpan: 1; text: qsTr("Sexo") }
            /* https://orbitadiversa.wordpress.com/2013/01/28/cosificacion-sexual/
                    reducción (
                        1. parte
                        5. disponibilidad
                        7. lienzo
                        2. soporte
                    intercambio
                        3. intercambiable
                    humillación
                        4. vejación
                    mercancía
                        6. mercancia
            */
            //RSlider{ id: s_sex; Layout.columnSpan: 2; maximumValue: 4; value: 0; }
            CheckBox { id: nud; text: qsTr("Desnudo"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Nudity", checked ) }
            CheckBox { id: sen; text: qsTr("Sensualidad"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Sensuality", checked ) }
            CheckBox { id: por; text: qsTr("Pornografía"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Porn", checked ) }
            CheckBox { id: see; text: qsTr("Sexo explicito"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Explicit sex", checked ) }
            CheckBox { id: obj; text: qsTr("Cosificación"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Objetivation", checked ) }
            CheckBox { id: inf; text: qsTr("Intercambiable"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Interchangeable", checked ) }
            CheckBox { id: hum; text: qsTr("Humillación"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Humiliation", checked ) }
            CheckBox { id: mer; text: qsTr("Mercancía"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Commodity", checked ) }
            CheckBox { id: red; text: qsTr("Reducción"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Reduction", checked ) }

            //RLabel{ Layout.columnSpan: 1; text: qsTr("Drogas") }
            //RSlider  { id: s_drugs; Layout.columnSpan: 2; maximumValue: 4; value: 0; }
            CheckBox { id: tob;  text: qsTr("Tabaco"); visible: type_combo.currentIndex == 3; onClicked: add_tag("Tobaco", checked ) }
            CheckBox { id: alc;  text: qsTr("Alcohol"); visible: type_combo.currentIndex == 3; onClicked: add_tag("Alcohol", checked ) }
            CheckBox { id: her;  text: qsTr("Heroina"); visible: type_combo.currentIndex == 3; onClicked: add_tag("Heroine", checked ) }
            CheckBox { id: weed; text: qsTr("Porros"); visible: type_combo.currentIndex == 3; onClicked: add_tag("Weed", checked ) }
            CheckBox { id: coc;  text: qsTr("Cocaína"); visible: type_combo.currentIndex == 3; onClicked: add_tag("Cocaine", checked ) }
            CheckBox { id: oth;  text: qsTr("Otras"); visible: type_combo.currentIndex == 3; onClicked: add_tag("Others", checked ) }
            //CheckBox { id: con;  text: qsTr("Cocaína"); visible: type_combo.currentIndex == 3; onClicked: add_tag("Ideology", checked ) }

            TextField {
                Layout.columnSpan: 3
                Layout.fillWidth: true
                id: description_input
                placeholderText: qsTr("Comentarios")
                onTextChanged: scenelistmodel.set(tableview.currentRow, {"description": description_input.text })
            }

            RLabel{ Layout.columnSpan: 3; text: qsTr("Global") }
            CheckBox { id: plot; text: qsTr("Trama"); checked: false; onClicked: add_tag("Plot", checked ) }
//            CheckBox { id: grap; text: qsTr("Gráfica"); checked: true; onClicked: add_tag("Graphic", checked ) }
            CheckBox { id: mut;  text: qsTr("Mute"); checked: false; onClicked: define_action( checked) }
            CheckBox { id: cri;  text: qsTr("Crítica"); checked: false; onClicked: add_tag("Critic", checked ) }
            /*RComboBox {
                Layout.minimumWidth : 50
                id: action_combo
                model: action_list
                onCurrentIndexChanged: scenelistmodel.set(tableview.currentRow, {"action": action_list.get(currentIndex).text })
            }*/
        }

        TableView {
           id: tableview
           sortIndicatorOrder: 1
           sortIndicatorColumn: 1
           Layout.preferredWidth: 385
           Layout.preferredHeight: 290
           Layout.columnSpan : 6
           Layout.rowSpan: 6

           TableViewColumn{ role: "type"  ; title: qsTr("Type") ; width: 90 }
           TableViewColumn{ role: "severity"; title: qsTr("Level"); width: 70 }
           TableViewColumn{ role: "tags" ; title: qsTr("Tags") ; width: 120 }
           TableViewColumn{ role: "action"; title: qsTr("Action"); width: 70 }
           TableViewColumn{ role: "start" ; title: qsTr("Start") ; width: 70 }
           TableViewColumn{ role: "stop" ; title: qsTr("Stop") ; width: 70 }
           TableViewColumn{ role: "description" ; title: qsTr("Comments") ; width: 190 }
           model: scenelistmodel
           selectionMode: SelectionMode.SingleSelection
           sortIndicatorVisible: true
           onCurrentRowChanged: {
               var current_scene = scenelistmodel.get(tableview.currentRow)
               type_combo.currentIndex     = type_combo.find( current_scene.type )
               mut.checked                = current_scene.action === "Mute"
               severity.value              = current_scene.severity - 1
               start_input.text            = current_scene.start
               stop_input.text             = current_scene.stop
               description_input.text      = current_scene.description

               // Tags
               race.checked     = current_scene.tags.match("Race")
               nati.checked     = current_scene.tags.match("Nationality")
               sexdisc.checked  = current_scene.tags.match("Porn")
               homo.checked     = current_scene.tags.match("Homofobic")
               rel.checked      = current_scene.tags.match("Religion")
               ideo.checked     = current_scene.tags.match("Ideology")

               phy.checked      = current_scene.tags.match("Physical")
               psico.checked    = current_scene.tags.match("Psicological")
               animal.checked   = current_scene.tags.match("Animal")
               sad.checked      = current_scene.tags.match("Sadism")
               blo.checked      = current_scene.tags.match("Blood")
               suf.checked      = current_scene.tags.match("Torture")

               nud.checked      = current_scene.tags.match("Nudity")
               sen.checked      = current_scene.tags.match("Sensuality")
               por.checked      = current_scene.tags.match("Porn")
               see.checked      = current_scene.tags.match("Explicit sex")
               obj.checked      = current_scene.tags.match("Objetivation")
               inf.checked      = current_scene.tags.match("Interchangeable")
               hum.checked      = current_scene.tags.match("Humiliation")
               mer.checked      = current_scene.tags.match("Commodity")
               red.checked      = current_scene.tags.match("Reduction")

               tob.checked      = current_scene.tags.match("Tobaco")
               alc.checked      = current_scene.tags.match("Alcohol")
               her.checked      = current_scene.tags.match("Heroine")
               weed.checked     = current_scene.tags.match("Weed")
               coc.checked      = current_scene.tags.match("Cocaine")
               oth.checked      = current_scene.tags.match("Others")

               plot.checked     = current_scene.tags.match("Plot")
               //grap.checked     = current_scene.tags.match("Graphic")
               cri.checked      = current_scene.tags.match("Critic")
           }

        }

        GridLayout {
            columns: 4
            Layout.columnSpan: 2
            Layout.minimumWidth: 400

            TextField {
                id: start_input
                Layout.fillWidth: true;
                Layout.maximumWidth: 100
                placeholderText: qsTr("Empieza")
                onEditingFinished: scenelistmodel.set(tableview.currentRow, {"start": parseFloat( start_input.text ) })
                onAccepted: start_input.text = get_time()
            }

            RButton {
                Layout.fillWidth: true
                text: qsTr("Ahora")
                onClicked: {
                    start_input.text = get_time()
                    scenelistmodel.set(tableview.currentRow, {"start": parseFloat( start_input.text ) })
                }
            }

            TextField {
                id: stop_input
                Layout.fillWidth: true;
                Layout.maximumWidth: 100
                placeholderText: qsTr("Termina")
                onEditingFinished: scenelistmodel.set(tableview.currentRow, {"stop": parseFloat( stop_input.text ) })
                onAccepted: stop_input.text = get_time()
            }

            RButton {
                Layout.fillWidth: true
                text: qsTr("Ahora")
                onClicked: {
                    stop_input.text = get_time()
                    scenelistmodel.set(tableview.currentRow, {"stop": parseFloat( stop_input.text ) })
                }
            }
        }

        GridLayout {
            columns: 7
            Layout.columnSpan: 2
            Layout.minimumWidth: 400

            RButton {
                Layout.fillWidth: true
                text: qsTr("slower")
                onClicked: player.execute.slower()
            }

            RButton {
                Layout.fillWidth: true
                text: qsTr("<<")
                onClicked: set_time( get_time() - 5 )
            }

            RButton {
                Layout.fillWidth: true
                text: qsTr("<")
                onClicked: set_time( get_time() - 0.5 )
            }

            RButton {
                Layout.fillWidth: true
                text: qsTr("play")
                //onClicked: player.execute.frame()
                onClicked: player.execute.play()
            }

            RButton {
                Layout.fillWidth: true
                text: qsTr(">")
                onClicked: set_time( get_time() + 0.5 )
            }

            RButton {
                Layout.fillWidth: true
                text: qsTr(">>")
                onClicked: set_time( get_time() + 5 )
            }

            RButton {
                Layout.fillWidth: true
                text: qsTr("faster")
                onClicked: player.execute.faster()
            }

        }

        GridLayout {
            columns: 4
            Layout.columnSpan: 2
            Layout.minimumWidth: 400


            RButton {
                id: b_preview
                Layout.fillWidth: true
                text: qsTr("Preview")
                onClicked: preview_scene( parseFloat( start_input.text ), parseFloat( stop_input.text ) )
            }

            RButton {
                id: b_add
                text: qsTr("Añadir escena")
                Layout.fillWidth: true
                onClicked: {
                    scenelistmodel.append({
                        "type":type_list.get(type_combo.currentIndex).text,
                        "tags":"",
                        "severity": severity.value+1,//severity_list.get(severity_combo.currentIndex).text,
                        "start": parseFloat( start_input.text ),
                        "duration": parseFloat( stop_input.text ) - parseFloat( start_input.text ),
                        "description": description_input.text,
                        "stop": parseFloat( stop_input.text ),
                        "action": mut.checked? "Mute":"Skip",
                        "skip": "No"
                    })
                    app.ask_before_close = true
                    tableview.selection.deselect(0, tableview.rowCount - 1)
                    tableview.selection.select( tableview.rowCount - 1 )
                    tableview.currentRow = tableview.rowCount - 1
                }
            }


            RButton {
                id: remove
                text: qsTr("Eliminar escena")
                Layout.fillWidth: true
                onClicked: {
                    scenelistmodel.remove(tableview.currentRow);
                    app.ask_before_close = true
                    tableview.selection.deselect( 0, tableview.rowCount - 1)
                    tableview.selection.select( tableview.rowCount - 1 )
                    tableview.currentRow = tableview.rowCount - 1
                }

            }


            RButton {
                id: b_share
                text: qsTr("Compartir")
                Layout.fillWidth: true
                onClicked: requestPass.visible = true
            }
        }
    }



/*------------------- FUNCTIONS -------------------------*/
    function add_tag( tag, add ){
        if( tableview.currentRow == -1 ) return;
        var ctag = scenelistmodel.get(tableview.currentRow).tags
        if( add ) {
            scenelistmodel.set(tableview.currentRow, {"tags": "#"+tag+" "+ctag } )
        }else{
            scenelistmodel.set(tableview.currentRow, {"tags": ctag.replace("#"+tag,'').replace(/ +/g,' ') } )
        }
    }

    function define_action( action ){
        if( tableview.currentRow == -1 ) return;
        if( action ) {
            scenelistmodel.set(tableview.currentRow, {"action": "Mute" } )
        }else{
            scenelistmodel.set(tableview.currentRow, {"action": "Skip" } )
        }
    }
}
