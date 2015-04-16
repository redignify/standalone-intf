import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.0


Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 3
        Component.onCompleted: { mainWindow.minimumWidth = 500;mainWindow.minimumHeight = 300}

        TextField {
            id: fileurl
            Layout.preferredWidth: 400
            placeholderText: "Filename/url"
            Layout.columnSpan : 2
            text: media.url
            onEditingFinished: parse_input_file()
            onAccepted: parse_input_file()
        }

        Button {
            id: open
            text: "Browse"
//            Layout.fillWidth: true
            onClicked: fileDialog.open()
        }

        TextField {
            id: title
            Layout.preferredWidth: 400
            placeholderText: "Title"
            Layout.columnSpan : 2
            text: movie.title
            onAccepted: search_movie()
            //onTextChanged: search_movie()
        }

        Button {
            id: search
            text: "Search"
            onClicked: search_movie()
        }

        TableView {
           id: movielist
           height: 200
           Layout.preferredWidth: 475
           Layout.columnSpan: 3
           TableViewColumn{ role: "title"  ; title: "Title" ; width: 250 }
           TableViewColumn{ role: "director" ; title: "Director" ; width: 150 }
           TableViewColumn{ role: "year" ; title: "Year" ; width: 70 }
           model: movielistmodel
           sortIndicatorVisible: true
           onDoubleClicked: get_movie_data( movielist.currentRow )
           onActivated: get_movie_data( movielist.currentRow )
        }

        ListModel {
            id: movielistmodel
        }

        Button {
            id: select
            Layout.row: 3
            text: "Select"
            onClicked: get_movie_data( movielist.currentRow )
        }
    }

    FileDialog {
        id: fileDialog
        title: "Choose a media"
        selectExisting: true //fileDialogSelectExisting.checked
        //selectFolder: true
        //nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]
        //selectedNameFilter: "All files (*)"
        onAccepted: {
            console.log(fileUrl)
            media.url = fileUrl;
            // TODO: regex might be better
            title.text = fileUrl.toString().split("/").pop().split(".").shift();
            parse_input_file()
        }
        onRejected: { console.log("Rejected") }
    }

// Ask server for content of a specific movie
    function get_movie_data( id )
    {
        var data = JSON.parse( movie.list )
        if ( !data ) return;
        var imdbid = data["IDs"][id]
        post( "action=search&filename="+ title.text + "&imdb_code=" + imdbid + "&hash=" + media.hash, show_list )
    }

// A new input file has being selected, get hash and try to identify
    function parse_input_file()
    {
        media.hash  = Utils.get_hash( fileDialog.fileUrl )
        console.log( media.hash )
        if( media.hash == 'Error' ){ return }
        search_movie()
    }

// Ask server for movie information
    function search_movie()
    {
        post( "action=search&filename="+ title.text + "&hash=" + media.hash, show_list )
    }

// Great! We have the content of the current movie. Load the data.
    function load_movie()
    {  
    //
        //save_to_file( "/home/miguel/probando.json" , movie.data)
    // Read data
        if( movie.data == "" ) return;
        console.log( movie.data )
        var data = JSON.parse( movie.data )

    // Parse scenes
        scenelistmodel.clear()
        movie.title = data["Title"]
        var Scenes = data["Scenes"]
        for ( var i = 0; i < Scenes.length; ++i ) {
            var item = {
                "type": Scenes[i]["Category"],
                "subtype": Scenes[i]["SubCategory"],
                "severity": Scenes[i]["Severity"],
                "start": Scenes[i]["Start"],
                "duration": Scenes[i]["End"] - Scenes[i]["Start"],
                "description": Scenes[i]["AdditionalInfo"],
                "stop": Scenes[i]["End"],
                "action": Scenes[i]["Action"],
                "skip": "Yes"
            }
            if( Scenes[i]["Category"] == "syn" ){
                //syncscenelistmodel.append( item )
                scenelistmodel.append( item )
            } else {
                scenelistmodel.append( item )
            }
        }
    // Not yet defined if sync scenes go in "Scenes" or in "SyncScenes", lets be compatible with both
        if ( data["SyncScenes"] )
        {
            var SyncScenes = data["SyncScenes"]
            for ( var i = 0; i < SyncScenes.length; ++i) {
                var item = {
                    "type": SyncScenes[i]["Category"],
                    "subtype": SyncScenes[i]["SubCategory"],
                    "severity": SyncScenes[i]["Severity"],
                    "start": SyncScenes[i]["Start"],
                    "duration": SyncScenes[i]["End"] - Scenes[i]["Start"],
                    "description": SyncScenes[i]["AdditionalInfo"],
                    "stop": SyncScenes[i]["End"],
                    "action": SyncScenes[i]["Action"],
                    "skip": "Yes"
                }
                //syncscenelistmodel.append( item )
                scenelistmodel.append( item )
            }
        }

    // Sync (or at least try to)
        if( data["SyncInfo"] ){
            console.log( "Looking for sync info")
            for( i=0; i<data["SyncInfo"].length; ++i ){
                console.log( "Checking ", i, data["SyncInfo"][i]["Hash"], media.hash)
                if( data["SyncInfo"][i]["Hash"] == media.hash ){
                    apply_sync(data["SyncInfo"][i]["TimeOffset"],data["SyncInfo"][i]["SpeedFactor"],data["SyncInfo"][i]["Confidence"])
                    break
                }
            }
        }
    }

    function show_list( str )
    {
    // Fill list of movies matching search or load movie if only one result
        var jsonObject = JSON.parse( str );
        if ( !jsonObject ) {
            return
        } else if ( jsonObject['ImdbCode'] ){
            movie.data = str
            loader.source = "Play.qml"
            load_movie()
        } else if ( jsonObject['IDs'] ){
            movie.list = str
            movielistmodel.clear()
            for ( var i = 0; i < jsonObject["Titles"].length; ++i) {
                var year_director = jsonObject["Directors"][i].toString().split(",")
                var item = {"title": jsonObject["Titles"][i], "year": year_director[0], "director": year_director[1] }
                movielistmodel.append( item )
            }
        }
    }
}
