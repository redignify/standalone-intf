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
            //mainWindow.minimumWidth = 750; mainWindow.minimumHeight = 425;
            mainWindow.minimumWidth = 505;mainWindow.minimumHeight = 355;
            say_to_user("")
            //if(movie.imdbcode){bad_movie.visible = true}
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

        Button {
            id: open
            text: qsTr( "Archivo" )
            onClicked: fileDialog.open()
        }

        TextField {
            id: title
            Layout.preferredWidth: 360
            placeholderText: qsTr( "Título de la película" )
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

        Button {
            id: search
            text: qsTr( "Buscar" )
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
                text: qsTr( "Ir" )
                onClicked: get_movie_data( movielist.currentRow )
            }

            Button {
                id: b_not_this_movie
                Layout.minimumWidth: 150
                visible: movie.imdbcode? true : false
                text: qsTr("Película erronea")
                onClicked: {
                    bad_movie.visible = true
                }
            }

            Label{
                Layout.columnSpan : 1
                color: "red"
                text: movie.msg_to_user
                font.bold : true
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: qsTr( "Elige el fichero a reproducir" )
        selectExisting: true
        //selectFolder: true
        //nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]
        //selectedNameFilter: "All files (*)"
        onAccepted: {
            console.log("User selected input file: "+fileUrl)
            media.url = fileUrl;
            title.text =  clean_title( fileUrl )
            parse_input_file()
        }
        onRejected: { console.log("Rejected") }
    }




//------------------------- FUNCTIONS -----------------------------//

// Ask server for content of a specific movie (selected from the list)
    function get_movie_data( index )
    {
    // Get what we already know about the movie (hash, bytesize, imdbid...)
        var data = JSON.parse( movie.list )
        if ( !data ) return;
        var imdbid = data["IDs"][index]? data["IDs"][index] : imdb_input.text
        if( !isNaN(parseFloat(imdbid)) && isFinite(imdbid) ) imdbid = 'tt'+imdbid
        var hash = media.hash
        var bytesize = media.bytesize
        if( media.ignore_hash_on_search === true ){
            hash = 0
            bytesize = 0
        }

    // Ask the server for the content, "show_list" of movies when the server responds
        if( settings.user && settings.password ){
            post( "action=search&filename="+ title.text + "&imdb_code=" + imdbid + "&hash=" + hash + "&bytesize=" + bytesize + "&username="+settings.user+"&password="+settings.password, show_list )
        }else{
            post( "action=search&filename="+ title.text + "&imdb_code=" + imdbid + "&hash=" + hash + "&bytesize=" + bytesize, show_list )
        }
    }




// A new input file has being selected, get hash and try to identify
    function parse_input_file()
    {
    // Get movie hash and bytesize
        movie.imdbcode = ""
        media.hash     = Utils.get_hash( media.url )
        media.bytesize = Utils.get_size( media.url )
        // Perform some checks...
        if( media.hash === 'Error' ){ return }
        media.hash = pad(media.hash,16)
        console.log( "Computed hash is "+media.hash+" and bytesize is "+media.bytesize )

    // Ask the server about the movie
        search_movie()

    // Start computing sync information about the movie
        Utils.get_shots( media.url, settings.vlc_path )
    }



// Horrible but cost effective solution for hash formating
    function pad(n, width, z) {
      z = z || '0';
      n = n + '';
      return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
    }



// Ask server for movie information
    function search_movie()
    {
    // Get what we already know
        var hash = media.hash
        var bytesize = media.bytesize
        var imdbid = imdb_input.text
        if( !isNaN(parseFloat(imdbid)) && isFinite(imdbid) ) imdbid = 'tt'+imdbid

    // Ask local cache and server about the movie
        if( search_cached_index( hash ) ){
            loader.source = "Play.qml"
            load_movie()
        } else if( media.ignore_hash_on_search === true ){
            post( "action=search&filename="+ title.text + "&imdb_code=" + imdbid, show_list )
        } else{
            post( "action=search&filename="+ title.text + "&imdb_code=" + imdbid + "&hash=" + hash + "&bytesize=" + bytesize, show_list )
        }
    }




// Great! We have the content of the current movie. Now load the data.
    function load_movie()
    {
        console.log( "Loading movie..." )
    // Read data
        if( movie.data === "" ) return;
        var data = JSON.parse( movie.data )

    // Update movie data
        movie.filter_status = data["FilterStatus"]? data["FilterStatus"] : 0
        movie.poster_url = data["Poster"]? data["Poster"] : ""
        movie.director = data["Director"]? data["Director"]: ""
        movie.pgcode = data["PGCode"]? "PG-Code: "+data["PGCode"]: ""
        movie.imdbrating = data["ImdbRating"]? "Imdb Rating: " + data["ImdbRating"] : ""
        movie.imdbcode = data["ImdbCode"]? data["ImdbCode"] : ""
        movie.title = data["Title"]? data["Title"] : ""
        media.ignore_hash_on_search = false
        // Sync info
        sync.applied_offset = 0
        sync.applied_speed = 1
        sync.confidence = 0
        sync.stimated_error = 0
        sync.play_after_sync = false
        sync.shot_sync_failed = false
        sync.sub_sync_failed = false

    // Parse scenes
        scenelistmodel.clear()
        var Scenes = data["Scenes"]
        for ( var i = 0; i < Scenes.length; ++i ) {
            var start  = hmsToSec(Scenes[i]["Start"])
            var stop   = hmsToSec(Scenes[i]["End"])
            var tags   = Scenes[i]["Tags"]? Scenes[i]["Tags"] : Scenes[i]["SubCategory"]
            var item = {
                "type": Scenes[i]["Category"],
                "tags": tags? tags : "",
                "severity": Scenes[i]["Severity"],
                "start": secToStr(start),
                "duration":  secToStr( stop - start ),
                "description": Scenes[i]["AdditionalInfo"],
                "stop": secToStr(stop),
                "action": Scenes[i]["Action"],
                "skip": "Yes",
                "id": Scenes[i]["id"]
            }
            //console.log( item.start, item.stop )
            scenelistmodel.append( item )
            //console.log( scenelistmodel.get(scenelistmodel.count-1).start )
        }

    // Sync, or at least try to
        var index = sync_info_hash_index(data,media.hash)        
        apply_sync(data["SyncInfo"][index]["TimeOffset"],data["SyncInfo"][index]["SpeedFactor"],data["SyncInfo"][index]["Confidence"])
        start_guessing_sync_from_subs()

    // Apply filters
        loader.item.apply_all_filters()
    }




// Fill the list of movies matching last search or load movie if only one result
    function show_list( str )
    {
    // Check if 'str' input is valid json
        try {
            if( str === '' ) return;
            var jsonObject = JSON.parse( str );
            if ( !jsonObject ) return;
        }catch(e){
            console.log(e)
            return
        }

    // Check if there is a new version
        if( jsonObject["Message"] && jsonObject["Message"] === "New version" ){
            delete jsonObject["Message"];
            app.new_version_available = true;
        }

    // Only one search result, load that movie
        if ( jsonObject['ImdbCode'] && !jsonObject["IDs"] ){
            loader.source = "Play.qml"
            //DBG
            try {   // Check if we already have a cached version of that movie
                var cached_movie = read_from_file( jsonObject["ImdbCode"] )
                var subtitles = jsonObject["Subtitles"]? jsonObject["Subtitles"] : ''
                jsonObject = JSON.parse( cached_movie )
                if(subtitles) jsonObject['Subtitles'] = subtitles;
                movie.data = cached_movie
            } catch(e){
                movie.data = str
                save_to_file( str, jsonObject["ImdbCode"] )
            }
            load_movie()
            add_to_index( jsonObject["ImdbCode"], media.hash )

    // We are dealing with a TV series
        }else if ( jsonObject['Season'] ){
            movie.list = str
            movielistmodel.clear()
            dir.title = qsTr( "Capítulo" )
            yea.title = qsTr( "Temporada" )
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

    // We are dealing with a list of movies
        } else if ( jsonObject['IDs'] ){
            movie.list = str
            movielistmodel.clear()
            dir.title = qsTr( "Director" )
            yea.title = qsTr( "Año" )
            dir.width = 165
            for ( i = 0; i < jsonObject["Titles"].length; ++i) {
                var year_director = jsonObject["Directors"][i].toString().split(",")
                item = {
                    "title": jsonObject["Titles"][i],
                    "year": parseFloat(year_director[0]),
                    "director": year_director[1]? year_director[1]: ""
                }
                movielistmodel.append( item )
            }
        } else{
            console.log( "Unable to show list of movies" )
        }
    }

}
