import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1


Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 3
        Component.onCompleted: { mainWindow.minimumWidth = 485;mainWindow.minimumHeight = 300}

        TextField {
            id: fileurl
            Layout.preferredWidth: 400
            placeholderText: "Filename/url"
            Layout.columnSpan : 2
            text: media.url
            onTextChanged: load_file()
            onAccepted: load_file()
        }

        Button {
            id: open
            text: "Browse"
            //tooltip:"This is an interesting tool tip"
//            Layout.fillWidth: true
            onClicked: fileDialog.open()
        }

        TextField {
            id: title
            Layout.preferredWidth: 400
            placeholderText: "Title"
            Layout.columnSpan : 2
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
           onDoubleClicked: load_movie( movielist.currentRow )
        }

        ListModel {
            id: movielistmodel
        }

        Button {
            id: select
            Layout.row: 3
            text: "Select"
            onClicked: load_movie( movielist.currentRow )
        }
    }

    function load_movie( id )
    {
        var data = JSON.parse( movie.list )
        if ( !data ) return;
        var imdbid = data["IDs"][id]
        post( "action=search&filename="+ title.text + "&imdb_code=" + imdbid, show_list )
    }

    function load_file()
    {
        media.hash  = Utils.get_hash( fileDialog.fileUrl )
        if( media.hash == 'Error' ){ return }
        search_movie()
    }

    function search_movie()
    {
        post( "action=search&filename="+ title.text + "&hash=" + media.hash, show_list )
    }

    function show_list( str )
    {
        var jsonObject = JSON.parse( str );
        if ( !jsonObject ) {
            return
        } else if ( jsonObject['ImdbCode'] ){
            movie.data = str
            loader.source = "Play.qml"
        } else if ( jsonObject['IDs'] ){
            movie.list = str
            movielistmodel.clear()
            for ( var i = 0; i < jsonObject["Titles"].length; ++i) {
                var item = {"title": jsonObject["Titles"][i], "director": jsonObject["Directors"][i] }
                movielistmodel.append( item )
            }
        }
    }
}
