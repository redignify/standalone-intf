import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
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
                model: native_type_list
                onCurrentIndexChanged: {
                    try{
                        if( tableview.currentRow == -1 ){ add_blank_scene() }//say_to_user("Please select or add a scene"); return }
                        scenelistmodel.set(tableview.currentRow, {"type": type_list.get(currentIndex).text })
                    }catch(e){
                        // tableview migth not exits (just avoid error messages)
                    }
                }
            }

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

        // Violence labels
            CheckBox { id: phy;  text: qsTr("Física"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Physical", checked ) }
            CheckBox { id: psi;  text: qsTr("Psicológica"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Psicological", checked ) }
            CheckBox { id: disc; text: qsTr("Discriminación"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Discrimination", checked ) }
            CheckBox { id: sad;  text: qsTr("Sadismo"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Sadism", checked, 4 ) }
            CheckBox { id: bel;  text: qsTr("Bélico");  visible: type_combo.currentIndex == 0; onClicked: add_tag("War", checked ) }
            CheckBox { id: tor;  text: qsTr("Tortura"); visible: type_combo.currentIndex == 0; onClicked: add_tag("Torture", checked ) }

        // Sex labels
            CheckBox { id: nud;  text: qsTr("Desnudo");      visible: type_combo.currentIndex == 1;  onClicked: add_tag("Nudity", checked ) }
            CheckBox { id: sen;  text: qsTr("Sensualidad");  visible: type_combo.currentIndex == 1;  onClicked: add_tag("Sensuality", checked ) }
            CheckBox { id: see;  text: qsTr("Sexo explicito"); visible: type_combo.currentIndex == 1;onClicked: add_tag("Explicit sex", checked, 5 ) }
            CheckBox { id: sei;  text: qsTr("Se intuye sexo");  visible: type_combo.currentIndex == 1;  onClicked: add_tag("Implicit sex", checked ) }
            CheckBox { id: inf;  text: qsTr("Sin amor");  visible: type_combo.currentIndex == 1;  onClicked: add_tag("No love", checked ) }
            CheckBox { id: vio;  text: qsTr("Violación");    visible: type_combo.currentIndex == 1;  onClicked: add_tag("Rape", checked, 5 ) }

        // Drugs labels
            CheckBox { id: tob;  text: qsTr("Tabaco/Alcohol"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Tobaco/Alcohol", checked ) }
            CheckBox { id: weed; text: qsTr("Porros"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Weed", checked ) }
            CheckBox { id: coc;  text: qsTr("Cocaína/Heroina"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Cocaine/Heroine", checked ) }
            CheckBox { id: med;  text: qsTr("Abuso medicamentos"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Medicine misuse", checked ) }
            CheckBox { id: ove;  text: qsTr("Sobredosis"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Overdose", checked, 3 ) }
            CheckBox { id: tra;  text: qsTr("Tráfico"); visible: type_combo.currentIndex == 2; onClicked: add_tag("Trade", checked ) }

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

               TableViewColumn{ role: "type"  ; title: qsTr("Tipo") ; width: 90 }
               TableViewColumn{ role: "severity"; title: qsTr("Nivel"); width: 50 }
               TableViewColumn{ role: "start" ; title: qsTr("Empieza") ; width: 70 }
               TableViewColumn{ role: "stop" ; title: qsTr("Termina") ; width: 70 }
               TableViewColumn{ role: "tags" ; title: qsTr("Etiquetas") ; width: 120 }
               TableViewColumn{ role: "action"; title: qsTr("Acción"); width: 60 }
               TableViewColumn{ role: "description" ; title: qsTr("Comentarios") ; width: 190 }
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
               phy.checked    = current_scene.tags.match("Physical")
               psi.checked    = current_scene.tags.match("Psicological")
               disc.checked   = current_scene.tags.match("Discrimination")
               sad.checked    = current_scene.tags.match("Sadism")
               bel.checked    = current_scene.tags.match("War")
               tor.checked    = current_scene.tags.match("Torture")

               nud.checked    = current_scene.tags.match("Nudity")
               sen.checked    = current_scene.tags.match("Sensuality")
               see.checked    = current_scene.tags.match("Explicit sex")
               sei.checked    = current_scene.tags.match("Implicit sex")
               inf.checked    = current_scene.tags.match("No love")
               vio.checked    = current_scene.tags.match("Rape")

               tob.checked    = current_scene.tags.match("Tobaco/Alcohol")
               weed.checked   = current_scene.tags.match("Weed")
               coc.checked    = current_scene.tags.match("Cocaine/Heroine")
               med.checked    = current_scene.tags.match("Medicine misuse")
               ove.checked    = current_scene.tags.match("Overdose")
               tra.checked    = current_scene.tags.match("Trade")

               plot.checked   = current_scene.tags.match("Plot")
               //grap.checked = current_scene.tags.match("Graphic")
               //cri.checked  = current_scene.tags.match("Critic")
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
                color: movie.msg_color
                text: movie.msg_to_user
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
                font.bold : true
            }
        }

    }



/*------------------- FUNCTIONS -------------------------*/
    function add_tag( tag, add, min ){
        if( tableview.currentRow == -1 ){ add_blank_scene() }
        var ctag = scenelistmodel.get(tableview.currentRow).tags
        if( add ) {
            scenelistmodel.set(tableview.currentRow, {"tags": "#"+tag+" "+ctag } )
        }else{
            scenelistmodel.set(tableview.currentRow, {"tags": ctag.replace("#"+tag,'').replace(/ +/g,' ') } )
        }
        if( min && severity.value < min ) severity.value = min
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
