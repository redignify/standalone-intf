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
        Component.onCompleted: { mainWindow.minimumWidth = 505;mainWindow.minimumHeight = 355}

        TextField {
            id: fileurl
            Layout.preferredWidth: 400
            placeholderText: "Filename/url"
            Layout.columnSpan : 2
            text: media.url
            onEditingFinished: parse_input_file()
            onAccepted: parse_input_file()
        }

        RButton {
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

        RButton {
            id: search
            text: "Search"
            onClicked: search_movie()
        }

        TableView {
           id: movielist
           visible: true
           Layout.minimumHeight: 200
           Layout.minimumWidth: 490
           Layout.columnSpan: 3
           TableViewColumn{ role: "title"  ; title: "Title" ; width: 250 }
           TableViewColumn{ id: dir; role: "director" ; title: "Director" ; width: 165 }
           TableViewColumn{ id: yea; role: "year" ; title: "Year" ; width: 70 }
           model: movielistmodel
           sortIndicatorVisible: true
           onDoubleClicked: get_movie_data( movielist.currentRow )
           onActivated: get_movie_data( movielist.currentRow )
        }

        ListModel {
            id: movielistmodel
        }

        RButton {
            id: select
            Layout.row: 3
            text: "Select"
            onClicked: get_movie_data( movielist.currentRow )
        }

        RButton {
            id: testing
            text: "test"
            onClicked: {
                get_subs()
                //media.url = fileurl.text.toString()
                //parse_input_file()
                //calibrate_from_subtitles()
                //console.log(JSON.stringify(a))
                //console.log( seconds_to_time(65) )
            }
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
            title.text =  clean_title( fileUrl)
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
        post( "action=search&filename="+ title.text + "&imdb_code=" + imdbid + "&hash=" + media.hash + "&bytesize=" + media.bytesize, show_list )
    }

// A new input file has being selected, get hash and try to identify
    function parse_input_file()
    {
        media.hash     = Utils.get_hash( media.url )
        media.bytesize = Utils.get_size( media.url )
        if( media.hash === 'Error' ){ return }

        media.hash = pad(media.hash,16)
        console.log( media.hash )
        console.log( media.bytesize )
        search_movie()
    }

// Horrible but cost effective solution to hash formating
    function pad(n, width, z) {
      z = z || '0';
      n = n + '';
      return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
    }

// Ask server for movie information
    function search_movie()
    {
        post( "action=search&filename="+ title.text + "&hash=" + media.hash + "&bytesize=" + media.bytesize, show_list )
    }

// Great! We have the content of the current movie. Load the data.
    function load_movie()
    {
    //
        //save_to_file( imdb_code , movie.data)
    // Read data
        if( movie.data === "" ) return;
        console.log( movie.data )
        var data = JSON.parse( movie.data )

    // Update filter status
        if( data["FilterStatus"]){
            movie.filter_status = data["FilterStatus"]
            if( movie.filter_status < 2){
                say_to_user("Movie information might be incomplete")
            }
        }
        if( data["Poster"] ) movie.poster_url = data["Poster"]
        if( data["Director"] ) movie.director = data["Director"]
        if( data["PGCode"] ) movie.pgcode = data["PGCode"]
        if( data["ImdbRating"] ) movie.imdbrating = data["ImdbRating"]
        if( data["SubLink"] ){
            for( var i=0; i < data["SubLink"].length; ++i ){
                if( data["SubLink"][i]["Hash"] === media.hash ){
                    movie.subtitles = data["SubLink"][i]["Link"]
                }else{
                    movie.subref = data["SubLink"][i]["Link"]
                }
            }
        }

    // Parse scenes
        scenelistmodel.clear()
        movie.title = data["Title"]
        var Scenes = data["Scenes"]
        for ( var i = 0; i < Scenes.length; ++i ) {
            var item = {
                "type": Scenes[i]["Category"],
                "tags": Scenes[i]["Tags"]? Scenes[i]["Tags"] : Scenes[i]["SubCategory"],
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
                    "tags": SyncScenes[i]["Tags"]? SyncScenes[i]["Tags"] : SyncScenes[i]["SubCategory"],
                    "severity": SyncScenes[i]["Severity"],
                    "start": SyncScenes[i]["Start"],
                    "duration": SyncScenes[i]["End"] - Scenes[i]["Start"],
                    "description": SyncScenes[i]["AdditionalInfo"],
                    "stop": SyncScenes[i]["End"],
                    "action": SyncScenes[i]["Action"],
                    "skip": "No"
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
                if( data["SyncInfo"][i]["Hash"] === media.hash ){
                    apply_sync(data["SyncInfo"][i]["TimeOffset"],data["SyncInfo"][i]["SpeedFactor"],data["SyncInfo"][i]["Confidence"])
                    break
                }
            }
        }else{
            sync.confidence = 2;
        }

    // Apply filters
        loader.item.apply_filters()
    }

    function show_list( str )
    {
    // Fill list of movies matching search or load movie if only one result
        var jsonObject = JSON.parse( str );
        if ( !jsonObject ) {
            return
        } else if ( jsonObject['ImdbCode'] && !jsonObject["IDs"] ){
            movie.data = str
            loader.source = "Play.qml"
            load_movie()
        }else if ( jsonObject['Season'] ){
            movie.list = str
            movielistmodel.clear()
            dir.title = "Chapter"
            yea.title = "Season"
            dir.width = 90
            for ( var i = 0; i < jsonObject["Titles"].length; ++i) {
                if( jsonObject["Chapter"][i] === null ) continue
                var item = {
                    "title": jsonObject["Titles"][i],
                    "year": jsonObject["Season"][i],
                    "director": jsonObject["Chapter"][i]? jsonObject["Chapter"][i].toString() : "?"
                }
                movielistmodel.append( item )
            }
        } else if ( jsonObject['IDs'] ){
            movie.list = str
            movielistmodel.clear()
            dir.title = "Director"
            yea.title = "Year"
            dir.width = 165
            for ( var i = 0; i < jsonObject["Titles"].length; ++i) {
                var year_director = jsonObject["Directors"][i].toString().split(",")
                var item = {
                    "title": jsonObject["Titles"][i],
                    "year": parseFloat(year_director[0]),
                    "director": year_director[1]? year_director[1]: ""
                }
                movielistmodel.append( item )
            }
        }
    }

}
