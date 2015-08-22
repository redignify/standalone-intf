

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
        Component.onCompleted: { mainWindow.minimumWidth = 750; mainWindow.minimumHeight = 425; say_to_user("")}


        GroupBox {
            Layout.minimumWidth: 350


            GridLayout {
            columns: 3
            //Layout.minimumWidth: 400
            //Layout.preferredWidth: 400
            //Layout.preferredHeight: 130

            Label{
                Layout.columnSpan: 3
                //font.family: "Helvetica"
                color: "Green"
                font.pointSize: 10
                font.bold: true
                text: "Contenido de la escena"
                horizontalAlignment: Text.AlignHCenter
            }

            ComboBox {
                id: type_combo
                Layout.preferredWidth : 120
                currentIndex: 1
                model: type_list
                onCurrentIndexChanged: {
                    try{
                        if( tableview.currentRow == -1 ){ add_blank_scene() }//say_to_user("Please select or add a scene"); return }
                        scenelistmodel.set(tableview.currentRow, {"type": type_combo.currentText })
                    }catch(e){
                        // tableview migth not exits (just avoid error messages
                    }
                }
            }


            //Label{ Layout.columnSpan: 1; text: qsTr("Discriminación") }
            RSlider{
                id: severity;
                Layout.columnSpan: 2;
                Layout.preferredWidth: 210
                maximumValue: 4;
                value: 0;
                onValueChanged: {
                    if( tableview.currentRow == -1 ){ add_blank_scene() }//say_to_user("Please select or add a scene"); return }
                    scenelistmodel.set(tableview.currentRow, {"severity": value + 1 } )
                }
            }

        // Discrimination labels
            RCheckBox { id: race; text: qsTr("Raza"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Race", checked ) }
            RCheckBox { id: nati; text: qsTr("Nacionalidad"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Nationality", checked ) }
            RCheckBox { id: sexdisc;  text: qsTr("Machismo"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Machismo", checked ) }
            RCheckBox { id: homo;  text: qsTr("Homofobia"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Homofobic", checked ) }
            RCheckBox { id: rel; text: qsTr("Religión"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Religion", checked ) }
            RCheckBox { id: ideo; text: qsTr("Ideología"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Ideology", checked ) }

        // Violence labels
            CheckBox { id: phy; text: qsTr("Física"); visible: type_combo.currentIndex == 1; onClicked: add_tag("Physical", checked ) }
            CheckBox { id: psico; text: qsTr("Psicológica"); visible: type_combo.currentIndex == 1; onClicked: add_tag("Psicological", checked ) }
            CheckBox { id: animal;  text: qsTr("Animal"); visible: type_combo.currentIndex == 1; onClicked: add_tag("Animal", checked ) }
            CheckBox { id: sad;  text: qsTr("Sadismo"); visible: type_combo.currentIndex == 1; onClicked: add_tag("Sadism", checked ) }
            CheckBox { id: blo;  text: qsTr("Sangre"); visible: type_combo.currentIndex == 1; onClicked: add_tag("Blood", checked ) }
            CheckBox { id: suf;  text: qsTr("Tortura"); visible: type_combo.currentIndex == 1; onClicked: add_tag("Torture", checked ) }

        // Sex labels
            /* https://orbitadiversa.wordpress.com/2013/01/28/cosificacion-sexual/ */
            // animalismo, sadomasoquismo,
            CheckBox { id: nud; text: qsTr("Desnudo"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Nudity", checked ) }
            CheckBox { id: sen; text: qsTr("Sensualidad"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Sensuality", checked ) }
            //CheckBox { id: por; text: qsTr("Pornografía"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Porn", checked ) }
            CheckBox { id: see; text: qsTr("Sexo explicito"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Explicit sex", checked ) }
            //CheckBox { id: obj; text: qsTr("Cosificación"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Objetivation", checked ) }
            CheckBox { id: inf; text: qsTr("Intercambiable"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Interchangeable", checked ) }
            CheckBox { id: hum; text: qsTr("Humillación"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Humiliation", checked ) }
            CheckBox { id: mer; text: qsTr("Mercancía"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Commodity", checked ) }
            //CheckBox { id: red; text: qsTr("Reducción"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Reduction", checked ) }

        // Drugs labels
            CheckBox { id: tob;  text: qsTr("Tabaco"); visible: type_combo.currentIndex == 3; onClicked: add_tag("Tobaco", checked ) }
            CheckBox { id: alc;  text: qsTr("Alcohol"); visible: type_combo.currentIndex == 3; onClicked: add_tag("Alcohol", checked ) }
            CheckBox { id: her;  text: qsTr("Heroina"); visible: type_combo.currentIndex == 3; onClicked: add_tag("Heroine", checked ) }
            CheckBox { id: weed; text: qsTr("Porros"); visible: type_combo.currentIndex == 3; onClicked: add_tag("Weed", checked ) }
            CheckBox { id: coc;  text: qsTr("Cocaína"); visible: type_combo.currentIndex == 3; onClicked: add_tag("Cocaine", checked ) }
            CheckBox { id: oth;  text: qsTr("Otras"); visible: type_combo.currentIndex == 3; onClicked: add_tag("Others", checked ) }

        // Generic labels
            CheckBox { id: plot; text: qsTr("Afecta a la trama"); checked: false; onClicked: add_tag("Plot", checked ) }
            CheckBox { id: mut;  text: qsTr("Sólo quitar sonido"); checked: false; onClicked: define_action( checked) }
            //CheckBox { id: cri;  text: qsTr("Crítica"); checked: false; onClicked: add_tag("Critic", checked ) }

        // Comments
            TextField {
                Layout.columnSpan: 3
                Layout.fillWidth: true
                id: description_input
                placeholderText: qsTr("Comentarios")
                onTextChanged:{
                    if( tableview.currentRow == -1 ){ add_blank_scene() }
                    scenelistmodel.set(tableview.currentRow, {"description": description_input.text })
                }
            }
        }
        }

        GroupBox{
            Layout.rowSpan: 3
            //Layout.preferredWidth: 385
            //Layout.preferredHeight: 250

        GridLayout{
            columns: 1
            Layout.rowSpan: 5

            Label{
                color: "Green"
                font.pointSize: 10
                font.bold: true
                text: qsTr("Lista de escenas")
                horizontalAlignment: Text.AlignHCenter
            }

            TableView {
               id: tableview
               sortIndicatorOrder: 1
               sortIndicatorColumn: 1
               Layout.preferredWidth: 365
               Layout.preferredHeight: 250

               TableViewColumn{ role: "type"  ; title: qsTr("Type") ; width: 90 }
               TableViewColumn{ role: "severity"; title: qsTr("Level"); width: 50 }
               TableViewColumn{ role: "start" ; title: qsTr("Start") ; width: 70 }
               TableViewColumn{ role: "stop" ; title: qsTr("Stop") ; width: 70 }
               TableViewColumn{ role: "tags" ; title: qsTr("Tags") ; width: 120 }
               TableViewColumn{ role: "action"; title: qsTr("Action"); width: 60 }
               TableViewColumn{ role: "description" ; title: qsTr("Comments") ; width: 190 }
               model: scenelistmodel
               selectionMode: SelectionMode.SingleSelection
               sortIndicatorVisible: true
               onCurrentRowChanged: {
               say_to_user("");
               var current_scene = scenelistmodel.get(tableview.currentRow)
               if( current_scene ){
                   type_combo.currentIndex     = type_combo.find( current_scene.type )
                   mut.checked                 = current_scene.action === "Mute"
                   severity.value              = current_scene.severity - 1
                   console.log( current_scene.start, current_scene.stop )
                   start_input.text            = secToStr( current_scene.start )
                   stop_input.text             = secToStr( current_scene.stop )//isNaN(current_scene.stop)? "":
                   description_input.text      = current_scene.description
               }else{
                   current_scene = {};
                   current_scene.tags = "q";
                   mut.checked = false
                   description_input.text = ""
                   start_input.text = ""
                   stop_input.text = ""
               }

            // Update tags (check/uncheck according to current text)
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
               //por.checked      = current_scene.tags.match("Porn")
               see.checked      = current_scene.tags.match("Explicit sex")
               //obj.checked      = current_scene.tags.match("Objetivation")
               inf.checked      = current_scene.tags.match("Interchangeable")
               hum.checked      = current_scene.tags.match("Humiliation")
               mer.checked      = current_scene.tags.match("Commodity")
               //red.checked      = current_scene.tags.match("Reduction")

               tob.checked      = current_scene.tags.match("Tobaco")
               alc.checked      = current_scene.tags.match("Alcohol")
               her.checked      = current_scene.tags.match("Heroine")
               weed.checked     = current_scene.tags.match("Weed")
               coc.checked      = current_scene.tags.match("Cocaine")
               oth.checked      = current_scene.tags.match("Others")

               plot.checked     = current_scene.tags.match("Plot")
               //grap.checked     = current_scene.tags.match("Graphic")
               //cri.checked      = current_scene.tags.match("Critic")
           }

            }
            RowLayout{

            // Remove scene from the list
                Button {
                    text: qsTr("Quitar de la lista")
                    Layout.fillWidth: true
                    onClicked: {
                        if( tableview.currentRow == -1 ){ say_to_user("Please select a scene"); return }
                        scenelistmodel.remove(tableview.currentRow);
                        app.ask_before_close = true
                        tableview.selection.deselect( 0, tableview.rowCount - 1)
                        tableview.selection.select( tableview.rowCount - 1 )
                        tableview.currentRow = 0
                        tableview.currentRow = tableview.rowCount - 1
                    }
                }

            // Share scenes online
                Button {
                    text: qsTr("Compartir online")
                    Layout.fillWidth: true
                    onClicked: d_requestPass.visible = true
                }

            // Locally save work
                Button {
                    text: qsTr("Guardar")
                    Layout.fillWidth: true
                    onClicked: save_work( false )
                }

            // Import or export data from other EDL formats
                Button {
                    text: qsTr( "Importar/Exportar" )
                    Layout.fillWidth: true
                    onClicked: dialog_import.visible = true
                }
            }
            }
        }

        GroupBox {
            Layout.minimumWidth: 350
            GridLayout {
                columns: 4

                Label{
                    Layout.columnSpan: 4
                    //font.family: "Helvetica"
                    color: "Green"
                    font.pointSize: 10
                    font.bold: true
                    text: qsTr("Inicio y fin de la escena")
                    horizontalAlignment: Text.AlignHCenter
                }

                RowLayout {
                    Layout.columnSpan: 4

                    /*Button {
                        Layout.fillWidth: true
                        text: qsTr("slower")
                        onClicked: player.execute.slower()
                    }*/

                    Button {
                        Layout.fillWidth: true
                        text: qsTr("<<")
                        onClicked: set_time( get_time() - 3 )
                    }

                    Button {
                        Layout.fillWidth: true
                        text: qsTr("<")
                        onClicked: set_time( get_time() - 0.5 )
                    }

                    Button {
                        Layout.fillWidth: true
                        text: qsTr("Play")
                        //onClicked: player.execute.frame()
                        onClicked: player.execute.play()
                    }

                    Button {
                        Layout.fillWidth: true
                        text: qsTr(">")
                        onClicked: set_time( get_time() + 0.5 )
                    }

                    Button {
                        Layout.fillWidth: true
                        text: qsTr(">>")
                        onClicked: set_time( get_time() + 3 )
                    }

                   /* Button {
                        Layout.fillWidth: true
                        text: qsTr("faster")
                        onClicked: player.execute.faster()
                    }*/

                }

                //Label{ text: "Empieza"; }

                TextField {
                    id: start_input
                    Layout.fillWidth: true;
                    Layout.maximumWidth: 100
                    placeholderText: qsTr("Empieza")
                    onEditingFinished:{
                        if( tableview.currentRow == -1 ){ add_blank_scene() }
                        scenelistmodel.set(tableview.currentRow, {"start": secToStr(start_input.text), "duration": secToStr( hmsToSec( stop_input.text ) - hmsToSec( start_input.text )) })
                    }
                    onAccepted: start_input.text = secToStr( get_time() )
                }

                Button {
                    Layout.fillWidth: true
                    text: qsTr("Ahora")
                    onClicked: {
                        if( tableview.currentRow == -1 ){ add_blank_scene() }//say_to_user("Please select or add a scene"); return }
                        start_input.text = secToStr( get_time() )
                        scenelistmodel.set(tableview.currentRow, {"start": secToStr(start_input.text), "duration": secToStr( hmsToSec(stop_input.text) - hmsToSec(start_input.text) ) })
                    }
                }

                Button {
                    Layout.fillWidth: true
                    text: qsTr("Ir")
                    onClicked: set_time( hmsToSec( start_input.text ) )
                }

                Label{ Layout.minimumWidth: 100}

                //Label{  text: "Termina"; }
                TextField {
                    id: stop_input
                    Layout.fillWidth: true;
                    Layout.maximumWidth: 100
                    placeholderText: qsTr("Termina")
                    onEditingFinished: {
                        if( tableview.currentRow == -1 ){ add_blank_scene() }//say_to_user("Please select or add a scene"); return }
                        scenelistmodel.set(tableview.currentRow, {"stop": secToStr(stop_input.text), "duration": secToStr( hmsToSec(stop_input.text) - hmsToSec(start_input.text) ) })
                    }
                    onAccepted: stop_input.text = secToStr( get_time() )
                }

                Button {
                    Layout.fillWidth: true
                    text: qsTr("Ahora")
                    onClicked: {
                        if( tableview.currentRow == -1 ){ add_blank_scene() }//say_to_user("Please select or add a scene"); return }
                        stop_input.text = secToStr( get_time() )
                        scenelistmodel.set(tableview.currentRow, {"stop": secToStr(stop_input.text), "duration": secToStr( hmsToSec(stop_input.text) - hmsToSec(start_input.text) ) })
                    }
                }

                Button {
                    Layout.fillWidth: true
                    text: qsTr("Ir")
                    onClicked: set_time( hmsToSec( stop_input.text ) )
                }


            }



        }

        GroupBox {
            //title: qsTr("Navega e inicio y fin")
            Layout.minimumWidth: 350
            GridLayout {
                columns: 4


                Label{
                    Layout.columnSpan: 4
                    //font.family: "Helvetica"
                    color: "Green"
                    font.pointSize: 10
                    font.bold: true
                    text: qsTr("Comprobar y finalizar")
                    horizontalAlignment: Text.AlignHCenter
                }


                CheckBox {
                    Layout.minimumWidth: 75
                    text: qsTr("Previsualizar");
                    onClicked:{
                        if(checked){
                            preview_scene( hmsToSec( start_input.text ), hmsToSec( stop_input.text ) )
                        }else{
                            preview_data.watch_active = true
                            preview_data.preview_active = false
                        }
                    }
                }

                Button {
                    id: b_add
                    Layout.minimumWidth: 250
                    text: qsTr("Finalizar edición y añadir nueva")
                    Layout.fillWidth: true
                    Layout.columnSpan: 3
                    onClicked: add_blank_scene()
                }
           }
        }

        RowLayout{
            Label{
                id: l_msg
                color: "red"
                text: movie.msg_to_user
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
                font.bold : true
            }
        }

    }



/*------------------- FUNCTIONS -------------------------*/
    function add_tag( tag, add ){
        if( tableview.currentRow == -1 ){ add_blank_scene() }
        var ctag = scenelistmodel.get(tableview.currentRow).tags
        if( add ) {
            scenelistmodel.set(tableview.currentRow, {"tags": "#"+tag+" "+ctag } )
        }else{
            scenelistmodel.set(tableview.currentRow, {"tags": ctag.replace("#"+tag,'').replace(/ +/g,' ') } )
        }
        tableview.currentRow = tableview.currentRow-1
        tableview.currentRow = tableview.currentRow+1
    }

    function define_action( action ){
        if( tableview.currentRow == -1 ){ add_blank_scene() }//say_to_user("Please select or add a scene"); return }
        if( action ) {
            scenelistmodel.set(tableview.currentRow, {"action": "Mute" } )
        }else{
            scenelistmodel.set(tableview.currentRow, {"action": "Skip" } )
        }
    }

    function add_blank_scene(){
        scenelistmodel.append({
            "type": type_list.get(type_combo.currentIndex).text,
            "tags":"",
            "severity": 0,//severity.value+1,//severity_list.get(severity_combo.currentIndex).text,
            "start": "",//start_input.text ),
            "duration": "",//parseFloat( stop_input.text ) - parseFloat( start_input.text ),
            "description": "",//description_input.text,
            "stop": "",//parseFloat( stop_input.text ),
            "action": "Skip",//mut.checked? "Mute":"Skip",
            "skip": "No",
            "id": Math.random().toString()
        })
        app.ask_before_close = true
        tableview.selection.deselect(0, tableview.rowCount - 1)
        tableview.selection.select( tableview.rowCount - 1 )
        tableview.currentRow = tableview.rowCount - 1
        say_to_user("");
    }
}
