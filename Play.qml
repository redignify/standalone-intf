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
                font.pointSize: movie.title.length > 20? 16 : 24
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
                        text: "Indica tu sensibilidad"
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Label{
                        text: "(?)"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                l_sensibiltiy.text = (l_sensibiltiy.text=="Llena las barras para un filtrado severo")? "" : "Llena las barras para un filtrado severo"
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

                Label{ text: qsTr("Discriminación") }
                RSlider {
                    id: slider_pro
                    value: settings.pro
                    onValueChanged: apply_filter( "Discrimination", value )
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
                   TableViewColumn{ role: "skip"; title: "Skip"; width: 40; horizontalAlignment: Text.AlignLeft }
                   TableViewColumn{ role: "type"  ; title: "Type" ; width: 90; horizontalAlignment: Text.AlignLeft }
                   TableViewColumn{ role: "severity"; title: "Level"; width: 45; horizontalAlignment: Text.AlignLeft }
                   TableViewColumn{ role: "duration" ; title: "Length" ; width: 60; horizontalAlignment: Text.AlignLeft }
                   TableViewColumn{ role: "tags" ; title: "Tags" ; width: 100; horizontalAlignment: Text.AlignLeft }
                   TableViewColumn{ role: "description" ; title: "Comments" ; width: 215; horizontalAlignment: Text.AlignLeft }
                   //TableViewColumn{ role: "start" ; title: "Start" ; width: 70; horizontalAlignment: Text.AlignLeft }
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

                Label{
                    Layout.columnSpan: 2
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
                    color: "red"
                    text: movie.msg_to_user
                    font.bold : true
                    onTextChanged: l_help_play.text = ""
                }


                Button {
                    id: watch
                    tooltip: "Click to redignify and watch film"
                    /*style: ButtonStyle {
                      label: RText {
                        //renderType: Text.NativeRendering
                        //verticalAlignment: Text.AlignVCenter
                        //horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 10
                        //font.bold: true
                        color: "green"
                        text: "Ver película sin escenas"
                      }
                    }*/
                    text: "Ver película sin escenas"
                    onClicked: sync_and_play()
                }


            }
        }
    }


/******************************* FUNCTIONS ***********************************/

    function random_poster()
    {
        var array = ["UnknownMovie1.png","UnknownMovie2.jpg","UnknownMovie3.jpg","UnknownMovie4.jpg","UnknownMovie5.png","UnknownMovie6.jpg"];
        return array[Math.floor(Math.random() * array.length)];
    }

    function sort( column, order )
    {
        var columnname = playtableview.getColumn(column)[0]
        for( var i = 0; i < scenelistmodel.count; ++i){
            var value = scenelistmodel.get(i).start
            for( var j = i; j < scenelistmodel.count; ++j){
                var value2 = scenelistmodel.get(i).skip
                if( value > value2 ) scenelistmodel.move(i,j,1)
            }
        }
    }


    function sync_and_play(){
        if( sync.confidence === 0 ){
            watch_movie()
            if( settings.start_fullscreen ) player.execute.toggle_fullscreen()
        }else{
            watch_movie()
            if( settings.start_fullscreen ) player.execute.toggle_fullscreen()
        }
    }

    function toogle_selection()
    {
        if (scenelistmodel.get( playtableview.currentRow ).skip == "No" )
        {
            scenelistmodel.get( playtableview.currentRow ).skip = "Yes"
            if( l_detail.text !== "" ) l_detail.text = "La escena será cortada"
        }else{
            scenelistmodel.get( playtableview.currentRow ).skip = "No"
            if( l_detail.text !== "" ) l_detail.text = "La escena se verá normalmente"
        }

    }

    function apply_filter( typ, val )
    {
        for( var i = 0; i < scenelistmodel.count; ++i){
            if( typ === scenelistmodel.get(i).type )
            {
                if( scenelistmodel.get(i).severity > 5 - val  ){
                    scenelistmodel.get(i).skip = "Yes"
                }else{
                    scenelistmodel.get(i).skip = "No"
                }
            }
        }
        if( typ == "Sex"){
            settings.sn = slider_sn.value
        }else if( typ == "Violence"){
            settings.v = slider_v.value
        }else if( typ == "Drugs"){
            settings.d = slider_d.value
        }else if( typ == "Discrimination"){
            settings.pro = slider_pro.value
        }
        if( slider_sn.value > 4 || slider_v.value > 3 || slider_d.value > 3 || slider_pro.value > 2 ){
            l_sensibiltiy.text = "Puede que alguna escena no sea filtrada"
            l_sensibiltiy.color = "red"
        }else{
            l_sensibiltiy.text = ""
        }

    }
    function apply_filters( )
    {
        if( !scenelistmodel.get(0) ) return
        var type, severity, selected_severity
        for( var i = 0; i < scenelistmodel.count; ++i){
            type = scenelistmodel.get(i).type;
            severity = scenelistmodel.get(i).severity;
            if( type == "Sex"){
                selected_severity = slider_sn.value
            }else if( type == "Violence"){
                selected_severity = slider_v.value
            }else if( type == "Drugs"){
                selected_severity = slider_d.value
            }else if( type == "Discrimination"){
                selected_severity = slider_pro.value
            }else if( type == "Sync"){
                scenelistmodel.get(i).skip = "No"
                continue
            } else { continue; }

            if( severity > 5 - selected_severity  ){
                scenelistmodel.get(i).skip = "Yes"
            }else{
                scenelistmodel.get(i).skip = "No"
            }
            //console.log( type, severity, selected_severity)
        }
    }
}
