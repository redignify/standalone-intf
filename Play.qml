import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1

Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 4
        Component.onCompleted: { mainWindow.minimumWidth = 550;mainWindow.minimumHeight = 300}

        TableView {
           id: playtableview
           Layout.preferredWidth: 540
           Layout.preferredHeight: 150
           Layout.columnSpan : 4
           //TableViewColumn{ role: "skip"; title: "Skip"; width: 40; delegate: checkBoxDelegate}
           TableViewColumn{ role: "skip"; title: "Skip"; width: 50; }
           TableViewColumn{ role: "type"  ; title: "Type" ; width: 60 }
           TableViewColumn{ role: "subtype" ; title: "Subtype" ; width: 80 }
           TableViewColumn{ role: "severity" ; title: "Severity" ; width: 80 }
           TableViewColumn{ role: "start" ; title: "Position" ; width: 70 }
           TableViewColumn{ role: "len" ; title: "Duration" ; width: 80 }
           TableViewColumn{ role: "description" ; title: "Description" ; width: 118 }
           model: scenelistmodel
           sortIndicatorVisible: true
           Component.onCompleted: show_scenes()
           onDoubleClicked: toogle_selection()
        }

        Label{
            text: "Sex & Nudity"
        }

        Slider {
            id: slider_sn
            maximumValue: 4
            Layout.preferredWidth: 150
            value: 2
            tickmarksEnabled: true
            stepSize: 1
            onValueChanged: apply_filters()
        }

        Label{
            text: "Violence"
        }

        Slider {
            id: slider_v
            maximumValue: 4
            Layout.preferredWidth: 150
            value: 2
            tickmarksEnabled: true
            stepSize: 1
            onValueChanged: apply_filters()
        }

        Label{
            text: "Drugs"
        }

        Slider {
            id: slider_d
            maximumValue: 4
            Layout.preferredWidth: 150
            value: 2
            tickmarksEnabled: true
            stepSize: 1
            onValueChanged: apply_filters()
        }

        Label{
            text: "Profanity"
        }

        Slider {
            id: slider_pro
            maximumValue: 4
            Layout.preferredWidth: 150
            value: 2
            tickmarksEnabled: true
            stepSize: 1
            onValueChanged: apply_filters()
        }

        Button {
            id: watch
            text: "Watch clean movie"
            onClicked: watch_movie()
        }
    }


/******************************* FUNCTIONS ***********************************/

    function toogle_selection()
    {
        if (scenelistmodel.get( playtableview.currentRow ).skip == "No" )
        {
            scenelistmodel.get( playtableview.currentRow ).skip = "Yes"
        }else{
            scenelistmodel.get( playtableview.currentRow ).skip = "No"
        }
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
            if( Scenes[i]["Category"] == "syn" ){continue;}
            var item = {
                "type": Scenes[i]["Category"],
                "subtype": Scenes[i]["SubCategory"],
                "severity": Scenes[i]["Severity"],
                "start": Scenes[i]["Start"],
                "duration": Scenes[i]["End"],
                "description": Scenes[i]["AdditionalInfo"],
                "skip": "Yes"
            }
            scenelistmodel.append( item )
            apply_filters()
        }
    }

    function apply_filters()
    {
        if( !scenelistmodel.get(0) ) return
        var type, severity, selected_severity
        for( var i = 0; i < scenelistmodel.count; ++i){
            type = scenelistmodel.get(i).type;
            severity = scenelistmodel.get(i).severity;
            if( type == "s"){
                selected_severity = slider_sn.value
            }else if( type == "v"){
                selected_severity = slider_v.value
            }else if( type == "d"){
                selected_severity = slider_d.value
            }else if( type == "p"){
                selected_severity = slider_pro.value
            } else { continue; }

            if( severity > 4 - selected_severity  ){
                scenelistmodel.get(i).skip = "Yes"
            }else{
                scenelistmodel.get(i).skip = "No"
            }
            //console.log( type, severity, selected_severity)
        }
    }
}
