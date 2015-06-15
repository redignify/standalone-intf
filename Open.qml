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
        Component.onCompleted: {
            mainWindow.minimumWidth = 750; mainWindow.minimumHeight = 425;
            //mainWindow.minimumWidth = 505;mainWindow.minimumHeight = 355;
            if(movie.imdbcode){bad_movie.visible = true}
        }

        TextField {
            id: fileurl
            Layout.preferredWidth: 425
            placeholderText: "Ruta al fichero o url"
            Layout.columnSpan : 2
            text: media.url
            onEditingFinished: parse_input_file()
            onAccepted: parse_input_file()
        }

        RButton {
            id: open
            text: "Archivo"
            onClicked: fileDialog.open()
        }

        TextField {
            id: title
            Layout.preferredWidth: 360
            placeholderText: "Título de la película"
            Layout.columnSpan : 1
            text: movie.title
            onAccepted: {
                search_movie()
            }
        }

        TextField {
            id: imdb_input
            Layout.preferredWidth: 60
            placeholderText: "IMDB ID"
            Layout.columnSpan : 1
            text: movie.imdbcode
            onAccepted: {
                search_movie()
            }
        }

        RButton {
            id: search
            text: "Buscar"
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


        RowLayout {
            Layout.columnSpan: 3
            Button {
                id: select
                text: "Ir"
                onClicked: get_movie_data( movielist.currentRow )
            }

            Button {
                id: b_not_this_movie
                Layout.minimumWidth: 150
                visible: movie.imdbcode? true : false
                tooltip: "Advanced filters"
                text: qsTr("Película erronea")
                onClicked: {
                    bad_movie.visible = true
                }
            }

            RLabel{
                Layout.columnSpan : 1
                color: "red"
                text: movie.msg_to_user
                font.bold : true
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
            title.text =  clean_title( fileUrl )
            parse_input_file()
        }
        onRejected: { console.log("Rejected") }
    }




//------------------------- FUNCTIONS -----------------------------//

// Ask server for content of a specific movie
    function get_movie_data( id )
    {
        var data = JSON.parse( movie.list )
        if ( !data ) return;
        var imdbid = imdb_input.text? imdb_input.text : data["IDs"][id]
        if( !isNaN(parseFloat(imdbid)) && isFinite(imdbid) ) imdbid = 'tt'+imdbid
        if( settings.user && settings.password ){
            post( "action=search&filename="+ title.text + "&imdb_code=" + imdbid + "&hash=" + media.hash + "&bytesize=" + media.bytesize + "&username="+settings.user+"&password="+settings.password, show_list )
        }else{
            post( "action=search&filename="+ title.text + "&imdb_code=" + imdbid + "&hash=" + media.hash + "&bytesize=" + media.bytesize, show_list )
        }
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
        if( search_cached_index( media.hash ) ){
            loader.source = "Play.qml"
            load_movie()
        }else{
            var imdbid = imdb_input.text
            if( !isNaN(parseFloat(imdbid)) && isFinite(imdbid) ) imdbid = 'tt'+imdbid
            post( "action=search&filename="+ title.text + "&imdb_code=" + imdbid + "&hash=" + media.hash + "&bytesize=" + media.bytesize, show_list )
        }
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
        movie.filter_status = data["FilterStatus"]? data["FilterStatus"] : 0
        movie.poster_url = data["Poster"]? data["Poster"] : ""
        movie.director = data["Director"]? data["Director"]: ""
        movie.pgcode = data["PGCode"]? "PG-Code: "+data["PGCode"]: ""
        movie.imdbrating = data["ImdbRating"]? "Imdb Rating: " + data["ImdbRating"] : ""
        movie.imdbcode = data["ImdbCode"]? data["ImdbCode"] : ""

    // Parse scenes
        scenelistmodel.clear()
        movie.title = data["Title"]? data["Title"] : "Unkown"
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
                "skip": "Yes",
                "id": Scenes[i]["id"]
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
            if( Scenes.length == 0 ){
                sync.confidence = 2; // We are the first!
            }else{
                sync.confidence = 0; // This should never happen
                console.log("Empty SyncInfo received, but it was needed...")
            }
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
            console.log( str )
            movie.data = str
            loader.source = "Play.qml"
            load_movie()
            save_to_file( str, jsonObject["ImdbCode"] )
            add_to_index( jsonObject["ImdbCode"], media.hash )
        }else if ( jsonObject['Season'] ){
            movie.list = str
            movielistmodel.clear()
            dir.title = "Episode"
            yea.title = "Season"
            dir.width = 90
            for ( var i = 0; i < jsonObject["Titles"].length; ++i) {
                if( jsonObject["Episode"][i] === null ) continue
                var item = {
                    "title": jsonObject["Titles"][i],
                    "year": jsonObject["Season"][i],
                    "director": jsonObject["Episode"][i]? jsonObject["Episode"][i].toString() : "?"
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
