import QtQuick 2.2
import QtQuick.Controls 1.1


import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.Particles 2.0

//import "js/OpenSubtitlesHash.js" as OpenSubtitlesHash

ApplicationWindow {
    id: mainWindow
    visible: true
    minimumWidth: 485//gridLayout.implicitWidth
    minimumHeight: 350//gridLayout.implicitHeight
    title: qsTr("Family Cinema")

    Item {
        id: media
        property string url
        property string hash
        property string bytesize
    }

    Item {
        id: movie
        property string scenes
        property string data
        property string list
    }


    toolBar: ToolBar {
        id: toolbar
        RowLayout {
            id: toolbarLayout
            spacing: 0
            width: parent.width
            ToolButton {
                iconSource: "images/play.png"
                onClicked: loader.source = "Play.qml"
                Accessible.name: "Play"
                tooltip: "Enjoy your film"
            }
            ToolButton {
                iconSource: "images/document-open.png"
                onClicked: loader.source = "Open.qml"
                Accessible.name: "Open"
                tooltip: "Open new movie"
            }
            ToolButton {
                iconSource: "images/editcut.png"
                onClicked: loader.source = "Editor.qml"
                Accessible.name: "Editor"
                tooltip: "Create your own scenes"

            }
            ToolButton {
                iconSource: "images/preferences-system.png"
                onClicked: loader.source = "Config.qml"
                Accessible.name: "Config"
                tooltip: "Adjust preferences"
            }
            ToolButton {
                iconSource: "images/help.png"
                onClicked: loader.source = "Help.qml"
                Accessible.name: "Help"
                tooltip: "Find help"
            }

            Item { Layout.fillWidth: true }
        }
    }


    FileDialog {
        id: fileDialog
        //visible: fileDialogVisible.checked
        //modality: fileDialogModal.checked ? Qt.WindowModal : Qt.NonModal
        title: "Choose a media"
        selectExisting: true //fileDialogSelectExisting.checked
        //selectMultiple: fileDialogSelectMultiple.checked
        //selectFolder: true
        //nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]
        //selectedNameFilter: "All files (*)"
        onAccepted: {
            console.log(fileUrl)
            media.url = fileUrl
        }
        onRejected: { console.log("Rejected") }
    }


    Loader {
        id:loader
        source: "Open.qml"
    }

    ListModel {
       id: scenelistmodel
    }


    function load_movie( str )
    {
        var jsonObject = JSON.parse( str );
        if ( jsonObject ){
            movie.scenes = str
            var item = {"title": jsonObject["Titles"][1], "author": jsonObject["Directors"][1] }
            libraryModel.append( item )
        }

    }

    function post(  params, callback )
    {
        var http = new XMLHttpRequest()
        var url = "http://www.fcinema.org/api";
        //var params = "action=search&filename="+ movie.text;
        console.log( params )
        http.open("POST", url, true);

        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState == 4) {
                        if (http.status == 200) {
                            console.log("Ok");
                            console.log( http.responseText );
                            callback( http.responseText );
                            //return http.responseText
                            //load_movie( http.responseText )
                        } else {
                            console.log("error: " + http.status)
                        }
                    }
                }
        http.send(params);
    }

    Component.onCompleted: {
        if( media.url == "" && Qt.application.arguments[1] ){
            media.url = Qt.application.arguments[1]
        }
    }

    Timer {
        id: timer
        interval: 500; running: false; repeat: true
        onTriggered: edl_check()
    }

    function edl_check()
    {
        var time = get_time()
        console.log( time )
        if( !scenelistmodel.get(0) ) return
        var start, stop
        for( var i = 0; i < scenelistmodel.count; ++i){
            if( scenelistmodel.get(i).skip == "Yes" )
                start = scenelistmodel.get(i).start;
                stop = scenelistmodel.get(i).stop;
                console.log( "comparing", time, start, stop)
                if( time > start & time < stop ) {
                    console.log( "jumping")
                    set_time(stop)
                }
        }
    }

    function watch_movie()
    {
        Player.launch( media.url )
        timer.start()

    }

    function get_time()
    {
        var time = Player.get_time()
        var re = /(\d+)/i;
        var found = time.match(re);
        console.log( found )
        return found[0]
    }

    function set_time( time )
    {
        Player.seek( time + 1 )
    }


}
