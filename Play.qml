import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1

Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 2
        //Component.onCompleted: { mainWindow.minimumWidth = 750; mainWindow.minimumHeight = 500; say_to_user("")}
        Component.onCompleted: { mainWindow.minimumWidth = 750; mainWindow.minimumHeight = 425; say_to_user("")}

        Image {
            Layout.columnSpan: 1
            Layout.rowSpan: 8
            //width: 50
            //height: 50
            Layout.maximumHeight: 360; //height: 445
            Layout.maximumWidth: 280;
            Layout.minimumWidth: 280;
            fillMode: Image.PreserveAspectFit
            source: movie.poster_url? movie.poster_url : "images/UnknownMovie1.png"
        }



        RowLayout {
            Layout.maximumWidth: 480
            Label{
                font.family: "Helvetica"
                Layout.minimumWidth: 480
                Layout.maximumWidth: 480
                font.pointSize: movie.title.length > 15? 16 : 18
                font.bold: true
                text: movie.title? movie.title : qsTr("Título desconocido")
                horizontalAlignment: Text.AlignHCenter
            }
        }
        RowLayout {
            Layout.maximumWidth: 480

            Label{
                //Layout.columnSpan: 2
                Layout.minimumWidth: 480
                text: movie.title? "Directed by: " + movie.director + "   -   " + movie.imdbrating + "   -   " + movie.pgcode : ""
                horizontalAlignment: Text.AlignHCenter
            }
        }

        GroupBox{
            Layout.preferredWidth: 450
            GridLayout {
                columns: 4

                RowLayout{
                    Layout.columnSpan: 4
                    Label{
                        //Layout.columnSpan: 4
                        //font.family: "Helvetica"
                        color: "Green"
                        font.pointSize: 10
                        font.bold: true
                        text: "Indica los niveles máximos"
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Label{
                        text: "(?)"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                l_sensibiltiy.text = (l_sensibiltiy.text=="Vacia las barras para un filtrado severo")? "" : "Vacia las barras para un filtrado severo"
                                l_sensibiltiy.color = "blue"
                            }
                        }
                    }

                    Label{
                        id: l_sensibiltiy
                        Layout.minimumWidth: 270
                        color: "red"
                        text: ""
                        font.bold : true
                    }
                }

                Label{ text: qsTr("Violencia") }
                RSlider {
                    id: slider_v
                    value: settings.v
                    onValueChanged: apply_filter( "Violence", value )
                }

                Label{ text: qsTr("Sexo") }
                RSlider {
                    id: slider_sn
                    value: settings.sn
                    onValueChanged: apply_filter( "Sex", value )
                }

                /*Label{ text: qsTr("Vocabulario") }
                RSlider {
                    id: slider_pro
                    value: settings.pro
                    //onValueChanged: apply_filter( "Discrimination", value )
                }*/

                Label{ text: qsTr("Drogas") }
                RSlider {
                    id: slider_d
                    value: settings.d
                    onValueChanged: apply_filter( "Drugs", value )
                }
            }
        }

        GroupBox{
            Layout.preferredWidth: 450
            GridLayout {
                columns: 1

                RowLayout{
                    Label{
                        //Layout.columnSpan: 4
                        //font.family: "Helvetica"
                        color: "Green"
                        font.pointSize: 10
                        font.bold: true
                        text: "Personaliza al detalle"
                        horizontalAlignment: Text.AlignHCenter
                        //onLinkHovered:
                    }
                    Label{
                        text: "(?)"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                l_detail.text = l_detail.text == ""? "Haz doble click en una escena para saltarla o no" : ""
                            }
                        }
                    }

                    Label{
                        id: l_detail
                        //Layout.columnSpan : 4
                        color: "blue"
                        text: ""
                        font.bold : true
                    }
                }

                TableView {
                   id: playtableview
                   visible: true
                   Layout.minimumWidth: 430
                   //Layout.minimumHeight: 80
                   Layout.preferredHeight: 125
                   //Layout.columnSpan : 4
                   //TableViewColumn{ role: "skip"; title: "Skip"; width: 40; delegate: checkBoxDelegate}
                   TableViewColumn{ role: "skip"; title: qsTr("Saltar"); width: 50; horizontalAlignment: Text.AlignLeft }
                   TableViewColumn{ role: "type"  ; title: qsTr("Tipo") ; width: 70; horizontalAlignment: Text.AlignLeft }
                   TableViewColumn{ role: "severity"; title: qsTr("Nivel"); width: 45; horizontalAlignment: Text.AlignLeft }
                   TableViewColumn{ role: "duration" ; title: qsTr("Duración") ; width: 60; horizontalAlignment: Text.AlignLeft }
                   TableViewColumn{ role: "tags" ; title: qsTr("Etiquetas") ; width: 100; horizontalAlignment: Text.AlignLeft }
                   TableViewColumn{ role: "description" ; title: qsTr("Comentarios") ; width: 215; horizontalAlignment: Text.AlignLeft }
                   model: scenelistmodel
                   sortIndicatorVisible: true
                   //onSortIndicatorColumnChanged: sort(sortIndicatorColumn, sortIndicatorOrder)
                   //onSortIndicatorOrderChanged: sort(sortIndicatorColumn, sortIndicatorOrder)
                   onDoubleClicked: toogle_selection()
                }
                //Label{ }
            }
        }

        GroupBox{
            Layout.preferredWidth: 450
            GridLayout {
                columns: 5

                RowLayout{
                    Layout.columnSpan: 5

                    Label{
                        //font.family: "Helvetica"
                        color: "Green"
                        font.pointSize: 10
                        font.bold: true
                        text: "Disfruta de la pelicula"
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Label{
                        text: "(?)"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var msg = "Haz click en el botón para ver la película cortada"
                                movie.msg_to_user = ""
                                l_help_play.text = l_help_play.text == msg? "" : msg
                                //l_msg.color = "blue"

                            }
                        }
                    }

                    Label{
                        id: l_help_play
                        text:""
                        font.bold: true
                        color: "blue"
                    }

                    Label{
                        //Layout.columnSpan : 2
                        id: l_msg
                        color: movie.msg_color
                        text: movie.msg_to_user
                        font.bold : true
                        onTextChanged: l_help_play.text = ""
                    }
                }

                RowLayout{
                    Layout.columnSpan: 5

                    Button {
                        id: watch
                        tooltip: qsTr( "Haz click para ver la película con las escenas inconvenientes eliminadas" )
                        text: qsTr( "Ver película personalizada" )
                        onClicked: {
                            watch_movie( false )
                            if( settings.start_fullscreen ) player.execute.toggle_fullscreen()
                        }
                    }

                    Button {
                        id: classic_watch
                        visible: sync.shot_sync_failed
                        text: qsTr( "Ver película SIN personalizar" )
                        onClicked: {
                            var confidence = sync.confidence
                            sync.confidence = 2
                            watch_movie( false )
                            sync.confidence = confidence
                            preview_data.watch_active = false
                            if( settings.start_fullscreen ) player.execute.toggle_fullscreen()
                        }
                    }

                    ProgressBar {
                        visible: sync.play_after_sync
                        indeterminate: false
                    }
                }
            }
        }
    }


/******************************* FUNCTIONS ***********************************/


// Sort list by column
    function sort( column, order )
    {
        console.log('Sorting')
        var columnname = playtableview.getColumn(column)[0]
        for( var i = 0; i < scenelistmodel.count; ++i){
            var value = scenelistmodel.get(i).start
            for( var j = i; j < scenelistmodel.count; ++j){
                var value2 = scenelistmodel.get(i).skip
                if( value > value2 ) scenelistmodel.move(i,j,1)
            }
        }
    }



// Modify skip "Yes/No" toogling the previous value
    function toogle_selection()
    {
        console.log('Toogling selection')
        if (scenelistmodel.get( playtableview.currentRow ).skip === "No" ) {
            scenelistmodel.get( playtableview.currentRow ).skip = "Yes"
            if( l_detail.text !== "" ) l_detail.text = qsTr( "La escena será cortada" )
        }else{
            scenelistmodel.get( playtableview.currentRow ).skip = "No"
            if( l_detail.text !== "" ) l_detail.text = qsTr( "La escena se verá normalmente" )
        }

    // This allow the user to change settings while playing the movie
        fillSkipList()

    }



// Modify skip "Yes/No" to match one of the severity sliders
    function apply_filter( typ, val )
    {
        console.log('Applying filter '+typ)
    // Apply filter to each scene
        for( var i = 0; i < scenelistmodel.count; ++i){
            if( typ !== scenelistmodel.get(i).type ) continue;
            if( scenelistmodel.get(i).severity > val  ){  // severity > 5 - val
                scenelistmodel.get(i).skip = "Yes"
            }else{
                scenelistmodel.get(i).skip = "No"
            }
        }

    // Update settings (to remember values next time)
        if( typ === "Sex"){
            settings.sn = slider_sn.value
        }else if( typ === "Violence"){
            settings.v = slider_v.value
        }else if( typ === "Drugs"){
            settings.d = slider_d.value
        }

    // Give a warning if the user wants to skip scenes we have not listed (movie information might be incomplete)
        if( movie.sex_filter_status === 7 ){
            l_sensibiltiy.text = "Pueden aparecer escenas inconvenientes"
            l_sensibiltiy.color = "red"
        }else if( movie.sex_filter_status > slider_sn.value ){
            l_sensibiltiy.text = "Alguna escena sexual no puede filtrarse"
            l_sensibiltiy.color = "red"
        }else if( movie.violence_filter_status > slider_v.value ){
            l_sensibiltiy.text = "Alguna escena violenta no puede filtrarse"
            l_sensibiltiy.color = "red"
        }else if( movie.drugs_filter_status > slider_d.value ){
            l_sensibiltiy.text = "Alguna escena con drogas no puede filtrarse"
            l_sensibiltiy.color = "red"
        }else{
            l_sensibiltiy.text = "Podemos limpiar la película"
            l_sensibiltiy.color = "blue"
        }

    // This allow the user to change settings while playing the movie
        fillSkipList()

    }




// Apply all filters
    function apply_all_filters( )
    {
        apply_filter( "Sex", slider_sn.value )
        apply_filter( "Violence", slider_v.value )
        apply_filter( "Drugs", slider_d.value )
    }
}
