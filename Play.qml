import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1

Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 4
        Component.onCompleted: { mainWindow.minimumWidth = 580;mainWindow.minimumHeight = 320}

        TableView {
           id: playtableview
           Layout.preferredWidth: 540
           Layout.preferredHeight: 150
           Layout.columnSpan : 4
           //TableViewColumn{ role: "skip"; title: "Skip"; width: 40; delegate: checkBoxDelegate}
           TableViewColumn{ role: "skip"; title: "Skip"; width: 50; horizontalAlignment: Text.AlignLeft }
           TableViewColumn{ role: "start" ; title: "Start" ; width: 70; horizontalAlignment: Text.AlignLeft }
           TableViewColumn{ role: "duration" ; title: "Length" ; width: 70; horizontalAlignment: Text.AlignLeft }
           TableViewColumn{ role: "type"  ; title: "Type" ; width: 90; horizontalAlignment: Text.AlignLeft }
           TableViewColumn{ role: "subtype" ; title: "Subtype" ; width: 100; horizontalAlignment: Text.AlignLeft }
           TableViewColumn{ role: "severity" ; title: "Severity" ; width: 80; horizontalAlignment: Text.AlignLeft }
           TableViewColumn{ role: "description" ; title: "Why?" ; width: 300; horizontalAlignment: Text.AlignLeft }
           model: scenelistmodel
           sortIndicatorVisible: true
           //onSortIndicatorColumnChanged: scenelistmodelsort(sortIndicatorColumn, sortIndicatorOrder)
           //onSortIndicatorOrderChanged: scenelistmodel.sort(sortIndicatorColumn, sortIndicatorOrder)
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
            onValueChanged: apply_filter( "Sex", value )
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
            onValueChanged: apply_filter( "Violence", value )
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
            onValueChanged: apply_filter( "Drugs", value )
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
            onValueChanged: apply_filter( "Profanity", value )
        }

        Button {
            id: watch
            tooltip: "Click to redignify and watch film"
            text: "redignify"
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

    function apply_filter( typ, val )
    {
        for( var i = 0; i < scenelistmodel.count; ++i){
            if( typ === scenelistmodel.get(i).type )
            {
                if( scenelistmodel.get(i).severity > 4 - val  ){
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

            if( severity > 4 - selected_severity  ){
                scenelistmodel.get(i).skip = "Yes"
            }else{
                scenelistmodel.get(i).skip = "No"
            }
            //console.log( type, severity, selected_severity)
        }
    }
}
