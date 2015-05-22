import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1

Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 2
        Component.onCompleted: { mainWindow.minimumWidth = 800; mainWindow.minimumHeight = 510}

        Image {
            Layout.columnSpan: 1
            Layout.rowSpan: 8
            Layout.maximumWidth: 300; //height: 445
            fillMode: Image.PreserveAspectFit
            source: movie.poster_url? movie.poster_url : "images/" + random_poster()
        }


        GridLayout {
            columns: 4
            RLabel{
                Layout.columnSpan: 4
                font.family: "Helvetica"
                font.pointSize: 24
                font.bold: true
                text: movie.title? movie.title : "Unknow title"
                horizontalAlignment: Text.AlignHCenter
            }

            RLabel{
                Layout.columnSpan: 2
                text: movie.director
                horizontalAlignment: Text.AlignHCenter
            }

            RLabel{
                text: movie.imdbrating? "IMBD " + movie.imdbrating : ""
                horizontalAlignment: Text.AlignHCenter
            }

            RLabel{
                text: movie.pgcode
                horizontalAlignment: Text.AlignHCenter
            }
        }
        GridLayout {
            columns: 4


            RLabel{ text: qsTr("Discriminación") }
            RSlider {
                id: slider_pro
                value: settings.pro
                onValueChanged: apply_filter( "Discrimination", value )
            }


            RLabel{ text: qsTr("Violencia") }
            RSlider {
                id: slider_v
                value: settings.v
                onValueChanged: apply_filter( "Violence", value )
            }


            RLabel{ text: qsTr("Sexo") }
            RSlider {
                id: slider_sn
                value: settings.sn
                onValueChanged: apply_filter( "Sex", value )
            }


            RLabel{ text: qsTr("Drogas") }
            RSlider {
                id: slider_d
                value: settings.d
                onValueChanged: apply_filter( "Drugs", value )
            }

        }

        GridLayout {
            TableView {
               id: playtableview
               visible: true
               Layout.minimumWidth: 480
               Layout.minimumHeight: 250
               Layout.columnSpan : 4
               //TableViewColumn{ role: "skip"; title: "Skip"; width: 40; delegate: checkBoxDelegate}
               TableViewColumn{ role: "skip"; title: "Skip"; width: 50; horizontalAlignment: Text.AlignLeft }
               TableViewColumn{ role: "type"  ; title: "Type" ; width: 90; horizontalAlignment: Text.AlignLeft }
               TableViewColumn{ role: "severity"; title: "Level"; width: 60; horizontalAlignment: Text.AlignLeft }
               TableViewColumn{ role: "tags" ; title: "Tags" ; width: 100; horizontalAlignment: Text.AlignLeft }
               TableViewColumn{ role: "description" ; title: "Comments" ; width: 215; horizontalAlignment: Text.AlignLeft }
               //TableViewColumn{ role: "start" ; title: "Start" ; width: 70; horizontalAlignment: Text.AlignLeft }
               //TableViewColumn{ role: "duration" ; title: "Length" ; width: 70; horizontalAlignment: Text.AlignLeft }
               model: scenelistmodel
               sortIndicatorVisible: true
               onSortIndicatorColumnChanged: sort(sortIndicatorColumn, sortIndicatorOrder)
               onSortIndicatorOrderChanged: sort(sortIndicatorColumn, sortIndicatorOrder)
               onDoubleClicked: toogle_selection()
            }
        }

        GridLayout {
            columns: 4
            RComboBox {
                id: player_combo
                Layout.minimumWidth : 150
                model: players_list
                //currentIndex: player.execute.name()
                onActivated: set_player( players_list.get(currentIndex).text )
            }

            RButton {
                id: watch
                tooltip: "Click to redignify and watch film"
                text: "redignify"
                onClicked: sync_and_play()
            }

            RButton {
                id: b_advanded
                tooltip: "Advanced filters"
                text: qsTr("Advanzado")
                onClicked: playtableview.visible? playtableview.visible=false : playtableview.visible=true
            }

            RButton {
                id: b_not_this_movie
                tooltip: "Advanced filters"
                text: qsTr("Película erronea")
                onClicked: {
                    bad_movie.visible = true
                }
            }

            RLabel{
                Layout.columnSpan : 4
                id: l_msg
                color: "red"
                text: movie.msg_to_user
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
        }else{
            scenelistmodel.get( playtableview.currentRow ).skip = "No"
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
            }else if( type == "Profanity"){
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
