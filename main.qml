import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Particles 2.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0

//import "js/OpenSubtitlesHash.js" as OpenSubtitlesHash

ApplicationWindow {
    id: mainWindow
    visible: true
    //minimumWidth: 485//gridLayout.implicitWidth
    //minimumHeight: 380//gridLayout.implicitHeight
    title: qsTr("Redignify")



//------------------------------------ VARIABLES ---------------------------------//

    Item {
        id: media
        property string url
        property string hash
        property double bytesize
    }

    Item {
        id: preview_data
        property double start
        property double stop
        property int last_skipped
        property int times_failed
    }

    Item {
        id: player
        property variant execute: VLC_TCP
        property bool autoskip_pressed : false
        property double autoskip_start : 0
        property bool autoskip_if_fast : true
    }

    Item {
        id: movie
        property string title
        property string director
        property string pgcode
        property string imdbrating
        property string imdbcode
        property string scenes
        property string data
        property string list
        property var    subtitles
        property var    subref
        property string subtitles_srt
        property string subref_srt
        property int    filter_status : 0
        property string msg_to_user
        property string poster_url
    }

    Item {
        id: sync
        property double applied_speed: 1
        property double applied_offset: 0
        property int confidence: 0
    }

    Settings {
        id: settings
        property string user
        property string password
        property double time_margin: 0.3
        property bool start_fullscreen: true
        property int sn: 3
        property int v: 2
        property int d: 1
        property int pro: 1
        property bool ask: true
        property bool autoshare: true
        property string default_player: "VLC_HTTP"
        property string vlc_path : ""
    }

    Item {
        id: app
        property bool ask_before_close: false
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

    ListModel {
        id: status_list
        ListElement {  text: "Incomplete" }
        ListElement {  text: "On going" }
        ListElement {  text: "Finished" }
    }

    ListModel {
        id: status_list_pro
        ListElement {  text: "None" }
        ListElement {  text: "All level 5" }
        ListElement {  text: "All level 4+" }
        ListElement {  text: "All level 3+" }
        ListElement {  text: "All level 2+" }
        ListElement {  text: "All scenes" }
    }

    ListModel {
        id: type_list
        ListElement {  text: "Discrimination" }
        ListElement {  text: "Violence" }
        ListElement {  text: "Sex" }
        ListElement {  text: "Drugs" }
        ListElement {  text: "Sync" }
    }

    ListModel {
        id: players_list
        ListElement {  text: "VLC_HTTP" }
        ListElement {  text: "VLC_TCP" }
        ListElement {  text: "VLC_HTTP" }
        //ListElement {  text: "VLC_CONSOLE" }
    }

    ListModel {
       id: scenelistmodel
    }

    ListModel {
       id: syncscenelistmodel
    }

//------------------------------------ DIALOGS ---------------------------------//

// This loads the dialogs! Set loader.source to "Play.qml" to launch that dialog
    Loader {
        id:loader
        source: "Open.qml"
    }


// The upper toolbar
    toolBar: ToolBar {
        id: toolbar
        RowLayout {
            id: toolbarLayout
            //spacing: 0
            width: parent.width
            ToolButton {
                iconSource: "images/play.png"
                onClicked: {
                    //mainWindow.minimumWidth = 800
                    //mainWindow.minimumHeight = 510
                    loader.source = "Play.qml"
                }
                Accessible.name: "Play"
                tooltip: "Enjoy your film"
            }
            ToolButton {
                iconSource: "images/document-open.png"
                onClicked: {
                    //mainWindow.minimumWidth = 505
                    //mainWindow.minimumHeight = 355
                    loader.source = "Open.qml"
                }
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
            ToolButton {
                iconSource: "images/feedback.png"
                onClicked: loader.source = "Feedback.qml"
                Accessible.name: "Feedback"
                tooltip: "Send Feedback"
            }

            Item { Layout.fillWidth: true }
        }
    }


// Ask user before closing
    onClosing: {
        console.log("Closing")
        if( app.ask_before_close ){
            before_closing.visible = true
            close.accepted = false
        }
    }


// The first console argument when opening can be use to define input file
    Component.onCompleted: {
        if( media.url == "" && Qt.application.arguments[1] )
        {
            media.url = "file:///"+ Qt.application.arguments[1].toString();
            movie.title = clean_title( media.url );
            loader.item.parse_input_file()
        }
        if( settings.vlc_path === "" ) settings.vlc_path = Utils.get_vlc_path()
        VLC_CONSOLE.set_path( settings.vlc_path )
        VLC_TCP.set_path( settings.vlc_path )
        VLC_HTTP.set_path( settings.vlc_path )
        set_player( settings.default_player )
    }


// Timer for forced EDL
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


// Ask user what to do before closing
    Dialog {
        id: before_closing
        width: 275
        //height: 100
        standardButtons: StandardButton.NoButton
        title: "Wait!"
        GridLayout {
            columns: 4
            RLabel{
                Layout.columnSpan: 4
                text: qsTr( "Has hecho algunos cambios... ¿que quieres hacer?" )
            }
            RButton {
                text: qsTr( "Guardar" )
                onClicked: {
                    save_work()
                    app.ask_before_close = false
                    before_closing.visible = false
                    close()
                }
            }
            RButton {
                text: qsTr( "Compartir" )
                onClicked: {
                    before_closing.visible = false
                    requestPass.visible = true
                    app.ask_before_close = false
                    close()
                }
            }
            RButton {
                text: qsTr( "Cerrar" )
                onClicked: {
                    app.ask_before_close = false
                    before_closing.visible = false
                    close()
                }
            }
            RButton {
                text: qsTr( "Cancelar" )
                onClicked: {
                    before_closing.visible = false
                }
            }

        }

    }


    Dialog {
        id: bad_movie
        width: 310
        //height: 100
        standardButtons: StandardButton.NoButton
        //title: "Identification required"
        GridLayout {
            columns: 2
            RLabel{
                Layout.columnSpan: 2
                text: qsTr("Perdón, intentaremos corregir el error.")
            }
            TextField {
                id: movie_name
                Layout.minimumWidth: 200
                placeholderText: qsTr("Título real")
                onAccepted: {
                    loader.source = "Open.qml"
                    post( "action=badhash&username="+settings.user+"&password="+settings.password+"&filename="+ movie.title + "&hash=" + media.hash + "&bytesize=" + media.bytesize, function(){} )
                    movie.title = movie_name.text
                    loader.source = "Open.qml"
                    media.hash = "";
                    media.bytesize = -1;
                    post( "action=search&filename="+ movie_name.text, loader.item.show_list )
                    bad_movie.visible = false
                }
            }
            RButton {
                text: qsTr("Volver a buscar")
                onClicked: {
                    loader.source = "Open.qml"
                    post( "action=badhash&username="+settings.user+"&password="+settings.password+"&filename="+ movie.title + "&hash=" + media.hash + "&bytesize=" + media.bytesize, function(){} )
                    movie.title = movie_name.text
                    loader.source = "Open.qml"
                    media.hash = "";
                    media.bytesize = -1;
                    post( "action=search&filename="+ movie_name.text, loader.item.show_list )
                    bad_movie.visible = false
                }
            }
        }

    }

    Dialog {
        id: dialog_import
        width: 310
        //height: 100
        standardButtons: StandardButton.NoButton
        //title: "Identification required"
        GridLayout {
            columns: 2
            RLabel{
                Layout.columnSpan: 2
                text: qsTr("Perdón, intentaremos corregir el error.")
            }

            TextField {
                Layout.minimumWidth: 200
                placeholderText: qsTr("Filter file")
            }
            Button {
                text: "Browse"
                onClicked: filterDialog.visible = true
            }
        }

    }

    FileDialog {
        id: filterDialog
        title: "Choose a filer"
        selectExisting: true //fileDialogSelectExisting.checked
        onAccepted: {
            console.log(fileUrl)
            import_from_file(fileUrl)
        }
        onRejected: { console.log("Rejected") }
    }


// Survey about quality...
        Dialog {
            id: survey
            width: 250
            height: 350
            standardButtons: StandardButton.Ok | StandardButton.Cancel
            title: qsTr("¿tú que opinas?")
            GridLayout {
                columns: 1
                Label{
                    text: qsTr("¿hemos filtrado bien?")
                    font.family: "Helvetica"
                    font.pointSize: 16
                    font.bold: true
                }
//                RLabel{ text: qsTr("Violencia") }
                GroupBox {
                    title: "Violence"
                    Layout.fillWidth: true
                    RowLayout {
                        anchors.fill: parent
                        ExclusiveGroup { id: vioGroup }
                        RadioButton { text: "Genial"; exclusiveGroup: vioGroup; checked: true }
                        RadioButton { text: "Justo"; exclusiveGroup: vioGroup }
                        RadioButton { text: "Horrible"; exclusiveGroup: vioGroup }
                    }
                }
                GroupBox {
                    title: "Sex"
                    Layout.fillWidth: true
                    RowLayout {
                        anchors.fill: parent
                        ExclusiveGroup { id: sexGroup }
                        RadioButton { text: "Genial"; exclusiveGroup: sexGroup; checked: true }
                        RadioButton { text: "Justo"; exclusiveGroup: sexGroup }
                        RadioButton { text: "Horrible"; exclusiveGroup: sexGroup }
                    }
                }
                GroupBox {
                    title: "Drogas"
                    Layout.fillWidth: true
                    RowLayout {
                        anchors.fill: parent
                        ExclusiveGroup { id: drugsGroup }
                        RadioButton { text: "Genial"; exclusiveGroup: drugsGroup; checked: true }
                        RadioButton { text: "Justo"; exclusiveGroup: drugsGroup }
                        RadioButton { text: "Horrible"; exclusiveGroup: drugsGroup }
                    }
                }
                GroupBox {
                    title: "Discriminación"
                    Layout.fillWidth: true
                    RowLayout {
                        anchors.fill: parent
                        ExclusiveGroup { id: discGroup }
                        RadioButton { text: "Genial"; exclusiveGroup: discGroup; checked: true  }
                        RadioButton { text: "Justo"; exclusiveGroup: discGroup }
                        RadioButton { text: "Horrible"; exclusiveGroup: discGroup; id: discBad }
                    }
                }
                TextField {
                    Layout.fillWidth: true
                    placeholderText: qsTr("¿En que podemos mejorar?")
                    visible: discBad.checked
                }

                GroupBox {
                    title: "Calidad cortes"
                    Layout.fillWidth: true
                    RowLayout {
                        anchors.fill: parent
                        ExclusiveGroup { id: calGroup }
                        RadioButton { text: "No se nota"; exclusiveGroup: calGroup; checked: true  }
                        RadioButton { text: "No molesta"; exclusiveGroup: calGroup }
                        RadioButton { text: "Estropan"; exclusiveGroup: calGroup; id:calBad }
                    }
                }
                TextField {
                    Layout.fillWidth: true
                    placeholderText: qsTr("¿En que podemos mejorar?")
                    visible: calBad.checked
                }
            }
            onAccepted: {
                requestPass.visible = true
                if( c_new_user.checked ){
                    if( pass.text !== pass2.text ){
                        say_to_user("Password must be the same");
                        pass.text = ""
                        pass2.text = ""
                        return
                    }
                    post( "action=newuser&username="+name.text+"&password="+pass.text+"&email="+email.text, new_user )
                }else{
                    settings.password = pass.text
                    settings.user = name.text
                    share( name.text, pass.text )
                }
            }
            onRejected: {
                requestPass.visible = false
            }
        }


// Request user password before sharing
    Dialog {
        id: requestPass
        width: 250
        //height: 200
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        title: "Identification required"
        GridLayout {
            columns: 2
            RLabel{
                text: qsTr("Usuario")
            }
            TextField {
                id:name
                text: settings.user
                width: 100
            }
            RLabel{
                text: qsTr("Contraseña")
            }
            TextField {
                width: 100
                id:pass
                text: settings.password
                echoMode: TextInput.Password
                //placeholderText: "Password"
            }

            RLabel{
                text: qsTr("Confirmar")
                visible: c_new_user.checked
            }
            TextField {
                width: 100
                id:pass2
                visible: c_new_user.checked
                text: settings.password
                echoMode: TextInput.Password
                //placeholderText: "Password"
            }

            RLabel{
                text: qsTr("Email")
                visible: c_new_user.checked
            }
            TextField {
                width: 100
                id: email
                visible: c_new_user.checked
                placeholderText: "Optional"
            }

            RLabel{ text: qsTr("Violencia etiquetada") }
            RComboBox {
                Layout.fillWidth: true
                id: status_combo_violence
                model: status_list_pro
                currentIndex: settings.v
            }

            Label{ text: qsTr("Sexo etiquetada") }
            ComboBox {
                Layout.fillWidth: true
                id: status_combo_sn
                model: status_list_pro
                currentIndex: settings.sn
            }

            Label{ text: qsTr("Discrimi. etiquetada") }
            RComboBox {
                Layout.fillWidth: true
                id: status_combo_pro
                model: status_list_pro
                currentIndex: settings.pro
            }

            RLabel{ text: qsTr("Drogas etiquetada") }
            RComboBox {
                Layout.fillWidth: true
                id: status_combo_dro
                model: status_list_pro
                currentIndex: settings.d
            }
            CheckBox {
                id: c_new_user
                text: qsTr("New user");
                onClicked: checked? requestPass.height = 250 : requestPass.height = 200
            }
        }
        onAccepted: {
            requestPass.visible = true
            if( c_new_user.checked ){
                if( pass.text !== pass2.text ){
                    say_to_user("Password must be the same");
                    pass.text = ""
                    pass2.text = ""
                    return
                }
                post( "action=newuser&username="+name.text+"&password="+pass.text+"&email="+email.text, new_user )
            }else{
                settings.password = pass.text
                settings.user = name.text
                share( name.text, pass.text )
            }
        }
        onRejected: {
            requestPass.visible = false
        }
    }

// Help the user a bit with the calibration process
    Dialog {
        id: calibrate
        width: 500
        height: 200
        title: qsTr("Calibración guiada")
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        GridLayout {
            columns: 1
            RLabel{
                id: user_instructions
                text: qsTr( "Haz click cuando oigas" ) // + scenelistmodel.get(get_sync_scene_index).description + " ends"
            }
            RButton {
                text: qsTr("Velocidad x3")
                tooltip: "Play at 3x speed"
                id: b_rate
                onClicked: player.execute.set_rate( 3 )
            }
            RButton {
                text: "Normal rate"
                tooltip: "Play at 1x speed"
                id: b_rate_normal
                onClicked: player.execute.set_rate( 1 )
            }
            RButton {
                text: "Now it ends"
                id: b_nowends
                onClicked: {
                    user_instructions.text = "Can you see the begining or the ending of the scene?"
                    b_beg.visible = true
                    b_end.visible = true
                    visible = false
                    player.execute.set_rate( 1 )
                    var current_time = get_time()
                    var i = get_sync_scene_index()
                    var original_start = scenelistmodel.get(i).start
                    apply_sync( current_time - original_start, sync.applied_speed, 0 )
                }
            }
            RButton {
                id: b_beg
                visible: false
                text: "Begining"
                onClicked: {
                    apply_sync( sync.applied_offset + 0.1, sync.applied_speed, 0 )
                    var i = get_sync_scene_index()
                    preview_scene( scenelistmodel.get(i).start, scenelistmodel.get(i).stop )
                }
            }
            RButton {
                id: b_end
                visible: false
                text: "Ending visible"
                onClicked: {
                    apply_sync( sync.applied_offset - 0.1, sync.applied_speed, 0 )
                    var i = get_sync_scene_index()
                    preview_scene( scenelistmodel.get(i).start, scenelistmodel.get(i).stop )
                }
            }
        }
        onAccepted: {
            calibrate.visible = false
            sync.confidence   = 2
        }
        onRejected: {
            calibrate.visible = false
        }
    }


/*-----------------------------------------------------------------------------------------*/
/*---------------------------------FUNCTIONS-----------------------------------------------*/
/*-----------------------------------------------------------------------------------------*/

// Create new user on the db
    function new_user( str )
    {
        try {
            var jo = JSON.parse( str )
        } catch(e){
            say_to_user( qsTr( "Error en el servidor") )
            return
        }
        if( jo && jo["Status"] && jo["Status"] === "Ok" ){
            settings.password = pass.text
            settings.user = name.text
            share( name.text, pass.text )
        }else{
            say_to_user("Some extrange error just happen")
        }
    }

// Share movie scene with other users
    function share( user, pass)
    {
        requestPass.visible = true
        try{
            var jsonObject = JSON.parse( movie.data );
        }catch(e){
            say_to_user( "No movie ID")
            return
        }
        var str = pack_data()
        post( "action=modify&data="+str+"&username="+user+"&password="+pass, thanks_for_sharing )
        //save_to_file( str, jsonObject["ImdbCode"] ) autosave to disk when sharing
    }

    function thanks_for_sharing( str ){
        try {
            var jo = JSON.parse( str )
        } catch(e){
            say_to_user( qsTr( "Error en el servidor") )
            return
        }

        if( jo && jo["Status"] && jo["Status"] === "Ok" ){
            app.ask_before_close = false
            requestPass.visible = false
            say_to_user( qsTr( "En nombre de todos los usuarios, ¡gracias por ayudar!") )
        }else{
            say_to_user( qsTr( "Imposible compartir. Ha ocurrido un error") )
        }

    }

    function save_work()
    {
        var jsonObject = {}
        try{
            jsonObject = JSON.parse( movie.data );
        } catch(e){
            if( !media.hash || media.hash == "Error" || media.hash == "" ){
                say_to_user("No pienso guardar esto (No hay ninguna película asociada)")
                return
            }
            jsonObject["ImdbCode"] = media.hash;
            movie.data = JSON.stringify( jsonObject )
            add_to_index( media.hash, media.hash)
        }
        var str = pack_data()
        save_to_file( str, jsonObject["ImdbCode"] )
        say_to_user("Guardado!")
    }


    //function import
    function pack_data(){
    // Recover original file
        try{
            var jsonObject = JSON.parse( movie.data );
        }catch(e){
            say_to_user( "No movie ID")
            var jsonObject = {};
        }

    // Update filter status
        jsonObject["FilterStatus"] = movie.filter_status

    // Update scenes data
        jsonObject['Scenes'] = [];
        for( var i = 0; i < scenelistmodel.count; ++i){
            jsonObject['Scenes'][i] = {}
            var scene = scenelistmodel.get(i)
            jsonObject['Scenes'][i]["Category"] = scene.type
            jsonObject['Scenes'][i]["Tags"] = scene.tags
            jsonObject['Scenes'][i]["Severity"] = scene.severity
            jsonObject['Scenes'][i]["Start"] = (scene.start - sync.applied_offset)/sync.applied_speed
            jsonObject['Scenes'][i]["End"] = (scene.stop - sync.applied_offset)/sync.applied_speed
            jsonObject['Scenes'][i]["Action"] = scene.action
            jsonObject['Scenes'][i]["AdditionalInfo"] = scene.description
            jsonObject['Scenes'][i]["id"] = scene.id
        }

        if( media.hash ){
    // Update sync data
            if( !jsonObject["SyncInfo"] ) jsonObject["SyncInfo"] = []

            var sync_updated_flag = 0
            for( i=0; i<jsonObject["SyncInfo"].length; ++i ){
                if( jsonObject["SyncInfo"][i]["Hash"] == media.hash ){
                    jsonObject["SyncInfo"][i]["SpeedFactor"] = sync.applied_speed
                    jsonObject["SyncInfo"][i]["TimeOffset"] = sync.applied_offset
                    jsonObject["SyncInfo"][i]["Confidence"] = sync.confidence
                    sync_updated_flag = 1
                }
            }
            if (sync_updated_flag == 0) {
                i = jsonObject["SyncInfo"].length
                jsonObject["SyncInfo"][i] = {}
                jsonObject["SyncInfo"][i]["Hash"] = media.hash
                jsonObject["SyncInfo"][i]["SpeedFactor"] = sync.applied_speed
                jsonObject["SyncInfo"][i]["TimeOffset"] = sync.applied_offset
                jsonObject["SyncInfo"][i]["Confidence"] = sync.confidence
            }
        }

    // Format and share
        var str = JSON.stringify( jsonObject, "", 2 );
        console.log( str )
        return str
    }


// Get title from file name
    function clean_title( str )
    {
        var tit = str.toString().split("/").pop();
        tit = tit.replace(/mp4|avi|\[.*\]|\(.*\).*|1080p.*|xvid.*|mkv.*|720p.*|web-dl.*|dvdscr.*|dvdrip.*|brrip.*|bdrip.*|hdrip.*|x264.*|bluray.*|hdtv.*|yify.*|eztv.*|480p.*/gi,'');
        tit = tit.replace(/\.|_/g,' ').replace(/ +/g,' ');
        return tit
    }

// Get the index of the sync scene
    function get_sync_scene_index() {
        if( !scenelistmodel.get(0) ) return -1
        for( var i = 0; i < scenelistmodel.count; ++i){
            if( scenelistmodel.get(i).type === "Sync" ) {
                return i
            }
        }
        return -1
    }


    function import_from_file( url )
    {
        var str = Utils.read_external_data( url )
        console.log("here we are 2")
        if( !str ) return
        console.log("here we are")
        console.log(str)
        var data = str.split(/\r?\n/);

        for(var i = 0; i < data.length; i++){
            console.log(data[i])
            var line = data[i].split(',')
            console.log(line[1] )
            console.log( line[2] )
            scenelistmodel.append({
                "type": "",
                "tags": "",
                "severity": 0,
                "start": line[1]/1000,
                "duration": (line[2]-line[1])/1000,
                "description": "",
                "stop": line[2]/1000,
                "action": line[0] == 0? "Mute":"Skip",
                "skip": "Yes",
                "id": Math.random().toString()
            })
        }
        app.ask_before_close = true
        dialog_import.visible = false
        loader.source = "Editor.qml"
        say_to_user("Imported!");
    }

// Read content of local file
    function read_from_file( name )
    {
        return Utils.read_data( name + ".json")
    }


// Write data to local file
    function save_to_file( data, name )
    {
        Utils.write_data( data, name + ".json")
    }

//
    function search_cached_index( hash )
    {
        var str_o = read_from_file( "index" )

        console.log( str_o )
        if( !str_o ) { console.log("Searching but no index!"); return}
        var index = JSON.parse( str_o )
        if( !index ) { console.log("Searching but index is corrupted"); return}
        if( index[hash] ){
            var str = read_from_file( index[hash] )
            if( !str ) return
            movie.data = str
            return true
        }
        return
    }

    function add_to_index( code, hash )
    {
        if( hash === "Error" || hash === "" ) return
        var str_o = read_from_file( "index" )
        if( !str_o ) { console.log("Adding to index, no file found"); str_o = "{}"};
        var index = JSON.parse( str_o )
        if( !index ) { console.log("Adding to index, corrupted file"); return;}
        index[hash] = code
        var str = JSON.stringify( index );
        console.log( str )
        save_to_file( str, "index" );
    }

// Post params to fcinema.org/api. Call callback when data is ready
    function post(  params, callback, url )
    {
    // Preapare everything
        var http = new XMLHttpRequest()
        url = url || "http://www.fcinema.org/api";
        console.log( params, callback, url )
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
                            console.log( http.responseText )
                            callback( http.responseText )
                        } else {
                            say_to_user( qsTr("Comprueba tu conexión a internet") )
                            console.log("Network error: " + http.status)
                        }
                    }
                }
    // Send the http request
        http.send(params);
    }


// If the player selected by user doesn't support EDL we have to do it "manually".
// Just check frequently if the player is playing an unwanted second, if so, tell it to jump to next "friendly" time
    function edl_check()
    {
    // Get current time and prepare
        var time = get_time()
        if( !scenelistmodel.get(0) ) return
        console.log( "Checking ", time)
        var start, stop
    // Check current time against all unwanted scenes
        for( var i = 0; i < scenelistmodel.count; ++i){
            if( scenelistmodel.get(i).skip === "Yes" && scenelistmodel.get(i).type !== "Sync" )
                start = parseFloat( scenelistmodel.get(i).start );
                stop  = parseFloat( scenelistmodel.get(i).stop );
                if( time > start - settings.time_margin & time + 1 < stop ) {
                    if( preview_data.last_skipped == i){
                        preview_data.times_failed = preview_data.times_failed + 1
                        set_time( stop + 0.1 + 5*preview_data.times_failed )
                        console.log("Times failed", preview_data.times_failed )
                    }else{
                        preview_data.times_failed = 0;
                        set_time( stop + 0.1 )
                        console.log("Times failed", preview_data.times_failed )
                    }
                    time = stop // When several scenes overlap, jump to the end of the last one
                    preview_data.last_skipped = i
                }
        }
    }

    function preview_check()
    {
    // Same but just one time for preview
        var time = get_time()
        console.log( "Checking ", time, " vs ", preview_data.start, preview_data.stop )

        var start = preview_data.start
        var stop  = preview_data.stop
        if( time > start - settings.time_margin & time + 1 < stop ) {
            set_time( stop + 0.1 + 5*preview_data.times_failed )
            preview_data.times_failed = preview_data.times_failed + 1
            preview_timer.stop()
            console.log("Times failed", preview_data.times_failed )
        }
    }


// Display message to user. Normally important warnings she/he must take care of
    function say_to_user( msg ){
        console.log("This is a message to the user: ", msg )
        if( msg !=="" && movie.msg_to_user === msg ) msg = msg+"!! Hey, I'm here!!"
        movie.msg_to_user = msg
    }

// Launch or connect to the user selected player.
    function watch_movie()
    {
        if( player.execute.get_time() != -1 ) return;
        player.autoskip_if_fast = true
        say_to_user("Connecting with player")
    // Try to launch selected player
        if( player.execute.launch( media.url ) ) {
            timer.start()
            say_to_user("Connected to " +  player.execute.name() )
            return true
        }/* // DEBUG
    // If not possible to launch on selected player, try other players
        else{
            say_to_user("Seems it's not working. Trying other players")
            for( var i = 0; i < players_list.count; ++i){
                set_player( players_list.get(i).text )
                if( player.execute.launch( media.url ) ) {
                    timer.start()
                    say_to_user("Connected to " + player.execute.name() )
                    return true
                }
            }
        }*/
        if( !media.url ){
            say_to_user("Oops, unable to reach player! (No input file selected)")
        }else{
            say_to_user("Oops, unable to reach player!")
        }
        return false
    }


// Start procces of manual calibration
    function manual_calibration(){
        calibrate.visible = true
        watch_movie()
        var i = get_sync_scene_index()
        var start_search = Math.max( 1, scenelistmodel.get(i).start - 30 )
        preview_scene( 0, start_search ) // just a trick to "wait" until movie is loaded before jump
        player.execute.set_rate( 2 )
    }


// Ask player for the current time
    function get_time()
    {
        var time = player.execute.get_time()
        if ( time == -1){ // @disable-check M126
            //say_to_user("Reconecting with player")
            //if( !player.execute.connect_to_player( false ) ){
                player.execute.kill()
                say_to_user("Oops, unable to reach player!")
                raise()
                timer.stop()
                return -1
            //}
        }
        time = Math.round( parseFloat(time)*1000 ) / 1000

    // Autoskip is presed
        if ( player.autoskip_if_fast ){
            var autoskip = player.execute.is_autoskiping();
            if ( autoskip & !player.autoskip_pressed ){
                console.log("Autoskip start")
                player.autoskip_pressed = true
                player.autoskip_start = time
                player.execute.mute()
            } else if( !autoskip & player.autoskip_pressed ){
                console.log("Autoskip release")
                player.autoskip_pressed = false
                player.execute.unmute()
                scenelistmodel.append({
                    "type":"?",
                    "tags":"",
                    "severity":0,
                    "start": player.autoskip_start - 3,
                    "duration": time-player.autoskip_start + 2,
                    "description": "",
                    "stop": time-1,
                    "action": "Skip",
                    "skip": "Yes",
                    "id": Math.random().toString()
                })
                app.ask_before_close = true
                player.autoskip_start = 0
                loader.source = "Editor.qml"
                if( settings.ask ) raise()
            }
        }
        return time
    }


// Order the player to go to a specefic time
    function set_time( time )
    {
        console.log( "Jumping to ", time )
        player.execute.seek( time )
    }


//
    function preview_scene( start, stop )
    {
        preview_data.start = start
        preview_data.stop  = stop
        if( player.execute.get_time() == -1 ){
            if( !watch_movie() ) return
        }
        player.autoskip_if_fast = false
        set_time( preview_data.start - 3 )
        timer.stop()
        preview_data.times_failed = 0
        preview_timer.stop()
        preview_timer.start()
    }


// Modify scenes start and end times to match the current movie.
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


// Set the default player
    function set_player( pl )
    {
        pl = "VLC_HTTP";
        if( pl === "VLC_TCP" ) {
            player.execute = VLC_TCP
            settings.default_player = pl
            console.log("Setting VLC TCP as player")
        }else if( pl === "VLC_CONSOLE" ) {
            player.execute = VLC_CONSOLE
            console.log("Setting VLC console as player")
            settings.default_player = pl
        }else if( pl === "VLC_HTTP" ) {
            player.execute = VLC_HTTP
            console.log("Setting VLC http as player")
            settings.default_player = pl
        }

    }

    function seconds_to_time( sec ) {
        var hours      = Math.floor( sec/60/60 )
        var minutes    = Math.floor( (sec - hours*60*60)/60 )
        var seconds    = Math.floor( sec%60 )
        var millis     = (sec*1000)%1000
        return hours+":"+minutes+":"+seconds+":"+millis
    }

    function srtTimeToSeconds(time) {
      var match = time.match(/(\d\d):(\d\d):(\d\d),(\d\d\d)/);
      var hours        = +match[1],
          minutes      = +match[2],
          seconds      = +match[3],
          milliseconds = +match[4];

      return (hours * 60 * 60) + (minutes * 60) + (seconds) + (milliseconds / 1000);
    }

    function parseSrtLine(line) {
      var match = line.match(/(\d\d:\d\d:\d\d,\d\d\d) --> (\d\d:\d\d:\d\d,\d\d\d)\n(.*)/m);

      return {
        start: srtTimeToSeconds(match[1]),
        end:   srtTimeToSeconds(match[2]),
        text:  match[3].trim()
      };
    }

    function parseSrt(srt) {
      /*srt = "1
00:00:54,999 --> 00:01:01,017
<b>EL HOBBIT</b>

2
00:01:13,725 --> 00:01:14,816
<i>Les advertí.</i>

3
00:01:14,851 --> 00:01:17,909
<i>¿No les advertí lo que pasaría al tratar con enanos?</i>

4
00:01:18,103 --> 00:01:19,278
<i>Fuimos obligados.</i>

5
00:01:19,313 --> 00:01:20,320
<i>Despertaron al dragón.</i>

        ";//*/
      //console.log(srt)
      srt = srt.replace(/\r\n/g,'\n')
      var lines = srt.split(/(?:^|\n\n)\d+\n|\n+$/g).slice(1, -2);

      var a = lines.map(parseSrtLine)
      /*  console.log(lines,a)
        console.log(JSON.stringify(lines))
        console.log(JSON.stringify(a))*/
      return a
    }

    function calibrate_from_subtitles( )
    {
        //console.log( str )
        if( movie.subref_srt.length < 50 || movie.subtitles_srt.length < 50 ){
            console.log("Waiting subs")
            return
        }

        var ref = parseSrt( movie.subref_srt )
        var subs = parseSrt( movie.subtitles_srt )
        var offset = []
        var rmax = Math.min(900,ref.length);
        var dist = 0, sum = 0, num = 1, off, max = -50000, min = 50000;
        for( var j = 5; j < rmax; ++j){
            var str_ref = clean( ref[j].text )
            for( var i = Math.max(0,j-dist-25), m = Math.min(subs.length,j-dist+25); i < m; ++i){
                var str_subs = clean(subs[i].text)
                if( str_ref === str_subs ) {
                    off = subs[i].start-ref[j].start;
                    if( num < 8 || Math.abs( sum/num - off ) < 5 ){ // Skip those having crazy time offset
                        offset.push( off )
                        dist = j - i
                        console.log( round(off,100), i, dist, str_subs, str_ref )
                        sum += off
                        max = Math.max( max, off )
                        min = Math.min( min, off )
                        num++
                        break;

                    }else{ console.log("WTF, extreme offset between subtitles: ", off, i, j-i, str_subs, str_ref) }
                }
            }
        }

        for( var i = 0, sum = 0; i < offset.length; i++ ) sum += offset[i];
        var avg = round( sum/offset.length, 1000 )
        var margin = round( (max - min)/2, 1000 )
        if( margin < 4 && num > 50 ){
            apply_sync(avg,1,2);
        }else{
            apply_sync(avg,1,1);
            say_to_user("Calibration migth be wrong")
        }
        settings.time_margin = margin
        console.log( offset.length, avg, max-avg, min-avg )

    }

    function round(num,dec){
        return Math.round( num * dec ) / dec
    }

    function clean(str){
        return str.replace(/<i>|<\/i>|<b>|<\/b>|\.|,|;|/g,'').toLowerCase();
    }

    function sub_ready( str ){
        movie.subtitles_srt = str
        calibrate_from_subtitles()
    }
    function ref_ready(str ){
        movie.subref_srt = str
        calibrate_from_subtitles()
    }
    function get_subs( ) {
        post("",ref_ready,"http://dl.opensubtitles.org/en/download/filead/"+movie.subref ); //+".gz"
        post("",sub_ready,"http://dl.opensubtitles.org/en/download/filead/"+movie.subtitles ); //+".gz"
    }

// Thats all folks
}
