import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Particles 2.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

//import "js/OpenSubtitlesHash.js" as OpenSubtitlesHash

ApplicationWindow {
    id: mainWindow
    visible: true
    minimumWidth: 485//gridLayout.implicitWidth
    minimumHeight: 380//gridLayout.implicitHeight
    title: qsTr("Family Cinema")

    Item {
        id: media
        property string url
        property string hash
        property string bytesize
    }

    Item {
        id: preview_data
        property double start
        property double stop
    }

    Item {
        id: movie
        property string title
        property string scenes
        property string data
        property string list       
    }

    Item {
        id: sync
        property double applied_speed: 1
        property double applied_offset: 0
        property int confidence: 0
    }

    ListModel {
        id: severity_list
        ListElement {  text: 1 }
        ListElement {  text: 2 }
        ListElement {  text: 3 }
        ListElement {  text: 4 }
        ListElement {  text: 5 }
    }

    ListModel {
        id: action_list
        ListElement {  text: "Skip" }
        ListElement {  text: "Mute" }
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

    Loader {
        id:loader
        source: "Open.qml"
    }

    ListModel {
       id: scenelistmodel
    }
    ListModel {
       id: syncscenelistmodel
    }

    /*
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
    */
    Dialog {
        id: calibrate
        width: 500
        height: 200
        title: "Guided calibration"
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        GridLayout {
            columns: 1
            Label{
                id: user_instructions
                text: "Click the button when the scene ends"
            }
            Button {
                text: "Now it ends"
                id: b_nowends
                onClicked: {
                    user_instructions.text = "Now click if ..."
                    b_beg.visible = true
                    b_end.visible = true
                    visible = false
                }
            }
            Button {
                id: b_beg
                visible: false
                text: "Beginning"
                //tooltip:"This is an interesting tool tip"
                //onClicked: calibrate.visible = false
            }
            Button {
                id: b_end
                visible: false
                text: "ending"
                //tooltip:"This is an interesting tool tip"
                //onClicked: calibrate.visible = false
            }
        }
        Component.onCompleted: {
            user_instructions.text = "working"
        }

        onAccepted: {
            calibrate.visible = false
        }
        onRejected: {
            calibrate.visible = false
        }
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

    function read_file( path, callback )
    {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", path);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                var a = JSON.parse(xhr.responseText);
                console.log(a)
                callback( xhr.responseText );
            }
        }
        xhr.send();
    }

    function save_to_file( path, data )
    {
        console.log( path, data)
        var xhr = new XMLHttpRequest;
        xhr.open("POST", path);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                console.log( xhr.responseText )
                var a = JSON.parse(xhr.responseText);
                console.log(a)
            }
        }
        xhr.send(data);
    }

    function post(  params, callback )
    {
    // Preapare everything
        var http = new XMLHttpRequest()
        var url = "http://www.fcinema.org/api";
        console.log( params )
        http.open("POST", url, true);

    // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");

    // Define function to run when the aswer is recived
        http.onreadystatechange = function() {
                    if (http.readyState == 4) {
                        if (http.status == 200) {
                            console.log("Ok");
                            console.log( http.responseText );
                            callback( http.responseText );
                        } else {
                            console.log("error: " + http.status)
                        }
                    }
                }
    // Send the http request
        http.send(params);
    }

    Component.onCompleted: {
    // The first console argument when opening can be use to define input file
        if( media.url == "" && Qt.application.arguments[1] )
        {
            media.url = Qt.application.arguments[1]
            movie.title = media.url.split("/").pop().split(".").shift();
        }
    }

    Timer {
        id: timer
        interval: 250; running: false; repeat: true
        onTriggered: edl_check()
    }

    Timer {
        id: preview_timer
        interval: 250; running: false; repeat: true
        onTriggered: preview_check()
    }

    function edl_check()
    {
    // If the player selected by user doesn't support EDL we have to do it "manually".
    // Just check frequently if the player is playing an unwanted second, if so, tell it to jump to next "friendly" time

    // Get current time and prepare
        if( !scenelistmodel.get(0) ) return
        var time = get_time()
        console.log( "Checking ", time)
        var start, stop
    // Check current time against all unwanted scenes
        for( var i = 0; i < scenelistmodel.count; ++i){
            if( scenelistmodel.get(i).skip == "Yes" )
                start = parseFloat( scenelistmodel.get(i).start );
                stop  = parseFloat( scenelistmodel.get(i).stop );
                if( time > start - 0.3 & time < stop ) {
                    set_time( stop + 0.1 )
                }
        }
    }

    function preview_check()
    {
    // Same but just one time for preview
        var time = get_time()
        console.log( "Checking ", time, " vs ", preview_data.start, preview_data.stop )
        if ( time > preview_data.start - 0.3 )
        {
            set_time( preview_data.stop + 0.1 )
            preview_timer.stop()
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
        var re = /(\d+.?\d*)/i;
        var found = time.match(re);
        if ( found === null){
            console.log("Unable to read time. Killing player")
            //Player.kill() //TODO this also kills fcinema
            timer.stop()
        }

        return Math.round( parseFloat(found[0])*1000 ) / 1000
    }

    function set_time( time )
    {
        console.log( "Jumping to ", time)
        Player.seek( time)
    }

    function preview_scene( start, stop )
    {
        preview_data.start = start
        preview_data.stop  = stop
        Player.seek( preview_data.start - 5)
        timer.stop()
        preview_timer.start()
    }

    function apply_sync( offset, speed, confidence )
    {
    // Prepare variables
        console.log( "Applying sync: ", offset, speed, confidence )
        offset = parseFloat(offset)
        speed = parseFloat(speed)
        var applied_offset = parseFloat( sync.applied_offset )
        var applied_speed  = parseFloat( sync.applied_speed  )
        if ( typeof offset !== 'number' || typeof speed !== 'number' ) return;
        var raw_start, raw_end, scene;
    // Loop over scenes unsyncing and applying new sync
        for( var i = 0; i < scenelistmodel.count; ++i){
            scene = scenelistmodel.get(i)
            raw_start = (scene.start - applied_offset) / applied_speed
            raw_end   = (scene.stop  - applied_offset) / applied_speed
            scene.start = raw_start*speed + offset
            scene.stop  = raw_end  *speed + offset
        }
    // Update applied values (needed for resync and sharing)
        sync.applied_offset = offset
        sync.applied_speed  = speed
        sync.confidence     = confidence
    }
}
