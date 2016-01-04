import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Particles 2.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0


ApplicationWindow {
    id: mainWindow
    visible: true
    //minimumWidth: 485//gridLayout.implicitWidth
    //minimumHeight: 380//gridLayout.implicitHeight
    title: qsTr("Family Cinema")



//-------------------------------- GLOBAL VARIABLES ---------------------------------//

// Variables about the current media file
    Item {
        id: media
        property string url
        property string hash
        property double bytesize
        property bool ignore_hash_on_search : false
    }

// Variables about the scene preview
    Item {
        id: preview_data
        property double start
        property double stop
        property int last_skipped : -1
        property int times_failed : 0
        property bool preview_active : false
        property bool watch_active : false
    }

// Variables about the media player
    Item {
        id: player
        property variant execute: VLC_TCP
        property bool autoskip_pressed : false
        property double autoskip_start : 0
    }

// Variables about the current movie
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
        property string our_srt
        property string ref_srt
        property int    violence_filter_status : 0
        property int    sex_filter_status : 0
        property int    drugs_filter_status : 0
        property string msg_to_user
        property string msg_color : "red"
        property string poster_url
    }

    Item {
        id: sync
        property double applied_speed: 1
        property double applied_offset: 0
        property int confidence: 0
        property double stimated_error: 0
        property bool play_after_sync: false
        property bool shot_sync_failed: false
        property bool sub_sync_failed: false
        property int current_version : 0
        property int current_lang : 0
    }

// Settings variables (this variables are stored between sessions!)
    Settings {
        id: settings
        property string user
        property string password
        property double time_margin: 0.3
        property bool start_fullscreen: true
        property int sn: 6
        property int v: 6
        property int d: 6
        property int pro: 6
        property bool ask: true
        property bool autoshare: true
        property bool ask_to_update: true
        property string default_player: "VLC"
        property string vlc_path : ""
    }

    Item {
        id: app
        property bool ask_before_close: false
        property bool new_version_available: false
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
        ListElement {  text: qsTr("5 (muy impactante)") }
        ListElement {  text: qsTr("4") }
        ListElement {  text: qsTr("3") }
        ListElement {  text: qsTr("2") }
        ListElement {  text: qsTr("1") }
        ListElement {  text: qsTr("0 (nada impactante)") }
    }

    ListModel {
        id: type_list
        ListElement {  text: "Violence" }
        ListElement {  text: "Sex" }
        ListElement {  text: "Drugs" }
    }

    ListModel {
        id: native_type_list
        ListElement {  text: qsTr("Violencia") }
        ListElement {  text: qsTr("Sexo") }
        ListElement {  text: qsTr("Drogas") }
    }

    ListModel {
        id: players_list
        ListElement {  text: "VLC" }
        ListElement {  text: "BSPlayer" }
        ListElement {  text: "MPlayer" }
        ListElement {  text: "XBMC" }
        ListElement {  text: "WMP" }
    }

    ListModel {
       id: scenelistmodel
    }

    ListModel {
       id: syncscenelistmodel
    }

    ListModel{
        id: skiplist
    }

//------------------------------------ DIALOGS ---------------------------------//

// This loads the dialogs! Set loader.source: "Play.qml" to launch the GUI described at Play.qml
    Loader {
        id:loader
        source: "Open.qml"
    }


// The upper toolbar
    toolBar: ToolBar {
        id: toolbar
        RowLayout {
            id: toolbarLayout
            spacing: 20
            width: parent.width
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
                iconSource: "images/play.png"
                onClicked: {
                    loader.source = "Play.qml"
                }
                Accessible.name: "Play"
                tooltip: "Enjoy your film"
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
                iconSource: "images/collaborate.png"
                onClicked: loader.source = "Collab.qml"
                Accessible.name: "Collaborate"
                tooltip: "Build up by volunteers"
            }

            Item { Layout.fillWidth: true }
        }
    }


// Ask user before closing
    onClosing: {
        console.log("Closing")
        if( app.ask_before_close ){
            d_before_closing.visible = true
            close.accepted = false
        }
        if( app.new_version_available && settings.ask_to_update){
            d_update.visible = true
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


// Timers for forced EDL
    Timer {
        id: timer
        interval: 250; running: false; repeat: true
        onTriggered: console.log("timer?")//edl_check( get_time() )
    }

    Timer {
        id: preview_timer
        interval: 250; running: false; repeat: true
        onTriggered: console.log("timer?")//preview_check( get_time() )
    }


    // New version available, ask user wath to do
        Dialog {
            id: d_update
            width: 240
            standardButtons: StandardButton.NoButton
            title: qsTr( "¡Nueva vesión!" )
            GridLayout {
                columns: 4
                Label{
                    Layout.columnSpan: 4
                    text: qsTr( "Hemos mejorado fcinema ¿que quieres hacer?" )
                }
                Button {
                    text: qsTr( "Actualizar" )
                    onClicked: {
                        Utils.update("")
                        say_to_user("Descargando actualización, puede llevar unos segundos", "blue")
                    }
                }
                Button {
                    text: qsTr( "Nunca preguntar" )
                    onClicked: {
                        d_update.visible = false
                        settings.ask_to_update = false
                        close()
                    }
                }
                Button {
                    text: qsTr( "Cerrar" )
                    onClicked: {
                        app.new_version_available = false // This is not exactly true, but avoid repromting
                        d_update.visible = false
                        close()
                    }
                }
            }

        }


// Ask user what to do before closing
    Dialog {
        id: d_before_closing
        width: 290
        //height: 100
        standardButtons: StandardButton.NoButton
        title: qsTr( "¡Espera!" )
        GridLayout {
            columns: 4
            Label{
                Layout.columnSpan: 4
                text: qsTr( "Has hecho algunos cambios... ¿que quieres hacer?" )
            }
            Button {
                text: qsTr( "Guardar" )
                onClicked: {
                    save_work( false )
                    app.ask_before_close = false
                    d_before_closing.visible = false
                    close()
                }
            }
            Button {
                text: qsTr( "Compartir" )
                onClicked: {
                    d_before_closing.visible = false
                    d_requestPass.visible = true
                    app.ask_before_close = false
                    close()
                }
            }
            Button {
                text: qsTr( "Cerrar" )
                onClicked: {
                    app.ask_before_close = false
                    d_before_closing.visible = false
                    close()
                }
            }
            Button {
                text: qsTr( "Cancelar" )
                onClicked: {
                    d_before_closing.visible = false
                }
            }

        }

    }


    Dialog {
        id: bad_movie
        width: 290
        //height: 100
        standardButtons: StandardButton.NoButton
        //title: "Identification required"
        GridLayout {
            columns: 3
            Label{
                Layout.columnSpan: 3
                color: "Green"
                font.pointSize: 10
                font.bold: true
                text: qsTr("¿No es esta la película que estas viendo?")
            }
            TextField {
                id: movie_name
                Layout.minimumWidth: 260
                Layout.columnSpan: 3
                placeholderText: qsTr("Título real")
                onAccepted: {
                    loader.source = "Open.qml"
                    post( "action=badhash&username="+settings.user+"&password="+settings.password+"&filename="+ movie.title + "&hash=" + media.hash + "&bytesize=" + media.bytesize, function(){} )
                    movie.title = movie_name.text
                    loader.source = "Open.qml"
                    media.ignore_hash_on_search = true
                    post( "action=search&filename="+ movie_name.text, loader.item.show_list )
                    bad_movie.visible = false
                    movie.imdbcode = ""
                }
            }
            Button{
                text: qsTr("Sí, sí es")
                onClicked: {
                    bad_movie.visible = false
                }
            }
            Label{ Layout.minimumWidth: 100 }

            Button {
                text: qsTr("Volver a buscar")
                onClicked: {
                    loader.source = "Open.qml"
                    post( "action=badhash&username="+settings.user+"&password="+settings.password+"&filename="+ movie.title + "&hash=" + media.hash + "&bytesize=" + media.bytesize, function(){} )
                    movie.title = movie_name.text
                    loader.source = "Open.qml"
                    media.ignore_hash_on_search = true
                    post( "action=search&filename="+ movie_name.text, loader.item.show_list )
                    bad_movie.visible = false
                    movie.imdbcode = ""
                }
            }
        }

    }

    Dialog {
        id: dialog_import
        width: 310
        //height: 100
        standardButtons: StandardButton.NoButton
        //title: qsTr("Importar o exportar")
        GridLayout {
            columns: 2
            Label{
                Layout.columnSpan: 2
                text: qsTr("Seleccione el fichero a importar")
            }

            TextField {
                Layout.minimumWidth: 200
                placeholderText: qsTr("Filter file")
            }
            Button {
                text: qsTr( "Archivo" )
                onClicked: filterDialog.visible = true
            }
        }

    }

    FileDialog {
        id: filterDialog
        title: qsTr( "Choose a filer" )
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
//                Label{ text: qsTr("Violencia") }
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
                        RadioButton { text: "Molestanq"; exclusiveGroup: calGroup; id:calBad }
                    }
                }
                TextField {
                    Layout.fillWidth: true
                    placeholderText: qsTr("¿En que podemos mejorar?")
                    visible: calBad.checked
                }
            }
            onAccepted: {
                /*requestPass.visible = true
                if( c_
.checked ){
                    if( pass.text !== pass2.text ){
                        say_to_user("Las contraseñas deben coincidir");
                        pass.text = ""
                        pass2.text = ""
                        return
                    }
                    post( "action=newuser&username="+name.text+"&password="+pass.text+"&email="+email.text, new_user )
                }else{
                    settings.password = pass.text
                    settings.user = name.text
                    share( name.text, pass.text )
                }*/
            }
            onRejected: {
                survey.visible = false
            }
        }


// Request user password before sharing
    Dialog {
        id: d_requestPass
        standardButtons: StandardButton.NoButton
        title: qsTr( "Gracias!" )
        GridLayout {
            columns: 2
            Layout.minimumWidth: 180
            Text{
                Layout.columnSpan: 2
                Layout.maximumWidth: 190
//                horizontalAlignment: Text.AlignHCenter
                color: "Green"
                wrapMode: "WordWrap"
                text: qsTr("De 0 a 5, ¿cúal es la escena más impactante que queda por etiquetar?")
            }

            Label{
                Layout.minimumWidth: 80
                text: qsTr("Violencia") }
            RComboBox {
                Layout.fillWidth: true
                id: status_combo_violence
                model: status_list_pro
                currentIndex: 5-settings.v
            }

            Label{ text: qsTr("Sexo") }
            ComboBox {
                Layout.fillWidth: true
                id: status_combo_sex
                model: status_list_pro
                currentIndex: 5-settings.sn
            }

            Label{ text: qsTr("Drogas") }
            RComboBox {
                Layout.fillWidth: true
                id: status_combo_drugs
                model: status_list_pro
                currentIndex: 5-settings.d
            }

            Text{
                Layout.columnSpan: 2
                Layout.maximumWidth: 190
                horizontalAlignment: Text.AlignHCenter
                color: "Green"
                wrapMode: "WordWrap"
                text: qsTr("Tus datos")
            }

            Label{ text: qsTr("Usuario") }
            TextField {
                id: name
                text: settings.user
                width: 100
            }

            Label{ text: qsTr("Contraseña") }
            TextField {
                width: 100
                id:pass
                text: settings.password
                echoMode: TextInput.Password
                //placeholderText: "Password"
            }

            Label{
                text: qsTr("Confirmar")
                visible: c_new_user.checked
            }
            TextField {
                width: 100
                id: pass2
                visible: c_new_user.checked
                text: settings.password
                echoMode: TextInput.Password
                //placeholderText: "Password"
            }

            Label{
                text: qsTr("Email")
                visible: c_new_user.checked
            }
            TextField {
                width: 100
                id: email
                visible: c_new_user.checked
                placeholderText: qsTr("Opcional")
            }

            CheckBox {
                Layout.columnSpan: 2
                id: c_new_user
                text: qsTr("Nuevo usuario");
                //onClicked: checked? d_requestPass.height = 200 : d_requestPass.height = 150
            }

            Button {
                Layout.fillWidth: true
                text: qsTr( "Compartir" )
                onClicked: {
                    movie.violence_filter_status = status_combo_violence.currentIndex
                    movie.sex_filter_status = status_combo_sex.currentIndex
                    movie.drugs_filter_status = status_combo_drugs.currentIndex
                    if( c_new_user.checked ){
                        if( pass.text !== pass2.text ){
                            say_to_user( qsTr("Las contraseñas deben coincidir") );
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
            }

            Button {
                Layout.fillWidth: true
                text: qsTr( "Cancelar" )
                onClicked: {
                    d_requestPass.visible = false
                }
            }
        }
    }



/*-----------------------------------------------------------------------------------------*/
/*---------------------------------FUNCTIONS-----------------------------------------------*/
/*-----------------------------------------------------------------------------------------*/
    Connections{
        target: VLC_HTTP
        onTimeChanged:{
            if( preview_data.watch_active ){
                edl_check( time )
            }else if( preview_data.preview_active ){
                preview_check( time )
            }
        }
    }
    Connections{
        target: VLC_HTTP
        onPlayerLost:{
            player.execute.kill()
            say_to_user("Conexión con el reproductor perdida")
        }
    }

    Connections {
        target: xcorr
        //void corrResult(int status, float offset, float speed );
        onCorrResult:{
            if( status >= 1 ){
                console.log("Xcorr calib ready")
                apply_sync( offset, speed, status, 0.1 )
            }else{
                console.log("Xcorr calib is NOT ready ", status )
            }
        }
    }

    Connections {
        target: xcorr
        //void videoDataReady(QString timestamp, QString mean );
        onVideoDataReady:{
            addVideoDataToSyncInfo(timestamp,mean)
        }
    }


    function addVideoDataToSyncInfo(s_time,s_mean){
        console.log( "Adding video data to sync info" )
        var time = JSON.parse(s_time)
        var mean = JSON.parse(s_mean)

        if( time[5] < 50e3 ){
            var s_mean_index = "Mean1"
            var s_time_index = "Time1"
        }else{
            s_mean_index = "Mean2"
            s_time_index = "Time2"
        }

    // Get data
        try {
            var data = JSON.parse( movie.data )
        } catch(e){
            // The data about the current movie is not ready
            return
        }

        var index = sync_info_hash_index(data,media.hash)

    // If there is no shot info, add it
        if( !data["SyncInfo"][index][s_mean_index] || !data["SyncInfo"][index][s_time_index] ){
            data["SyncInfo"][index][s_time_index]        = time
            data["SyncInfo"][index][s_mean_index]    = mean
            movie.data = JSON.stringify(data);
            save_work( true )
        }
    }


    function start_sync_process(data,hash){
        console.log( "Starting sync process" )
        // Get sync info index from data
        var index = sync_info_hash_index(data,hash)

        if( data["SyncInfo"][index]["Confidence"] >= 2 ) {
            apply_sync(data["SyncInfo"][index]["TimeOffset"],data["SyncInfo"][index]["SpeedFactor"],data["SyncInfo"][index]["Confidence"])
        }else{
        // Give xcorr to parser
            for( var i=0; i<data["SyncInfo"].length; ++i ){
                if( data["SyncInfo"][i]["Confidence"] < 3 ) continue;
                if( !data["SyncInfo"][i]["Mean1"] ) continue;
                var ref_index = i
                break
            }
            console.log( ref_index, index )
            var mean = data["SyncInfo"][ref_index]["Mean1"]
            var time = data["SyncInfo"][ref_index]["Time1"]
            xcorr.setRef(mean,time)
        }
        //start_guessing_sync_from_subs()
    }

    function sync_info_hash_index( data, hash )
    {
        var index = -1
        if( !data["SyncInfo"] || data["SyncInfo"] === undefined ){
            data["SyncInfo"] = [];
        }else{
            for( var i=0; i<data["SyncInfo"].length; ++i ){
                if( data["SyncInfo"][i]["Hash"] === hash ){
                    index = i
                    break
                }
            }
        }
    // There is no sync info about this movie, create it!
        if( index == -1 ){
            index = data["SyncInfo"].length
            data["SyncInfo"][index] = {}
            data["SyncInfo"][index]["Hash"] = hash
            data["SyncInfo"][index]["TimeOffset"] = 0
            data["SyncInfo"][index]["SpeedFactor"] = 1
            if( index == 0){
                console.log("No other sync references, set ourself as reference")
                data["SyncInfo"][index]["Confidence"] = 3
            }else{
                data["SyncInfo"][index]["Confidence"] = 0
            }
        }
        return index;
    }




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
            say_to_user( qsTr("Ha ocurrido un error al crear el usuario") )
        }
    }



// Share movie scenes with other users
    function share( user, pass)
    {
        d_requestPass.visible = true
        try{
            var jsonObject = JSON.parse( movie.data );
        }catch(e){
            say_to_user( qsTr( "No hay ninguna película seleccionada") )
            return
        }
        var str = pack_data()
        post( "action=modify&data="+str+"&username="+user+"&password="+pass, thanks_for_sharing )
        save_to_file( str, jsonObject["ImdbCode"] ) // autosave to disk when sharing
    }

    function thanks_for_sharing( str ){
        try {
            var jo = JSON.parse( str )
        } catch(e){
            say_to_user( qsTr( "Error en el servidor") )
            return
        }

        if( jo && jo["Status"] ){
            if( jo["Status"] === "Ok"  ){
                app.ask_before_close = false
                d_requestPass.visible = false
                say_to_user( qsTr( "En nombre de todos los usuarios, ¡gracias por ayudar!" , "blue") )
            }else if(jo["Status"] === "Bad password"){
                say_to_user( qsTr( "Nombre de usuario o contraseña invalidos" ) )
            }else{
                say_to_user( qsTr( "Imposible compartir. Ha ocurrido un error") )
            }
        }else{
            say_to_user( qsTr( "Imposible compartir. Ha ocurrido un error") )
        }

    }

    function save_work( silent )
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
        if( !silent ) say_to_user("Guardado!", "blue" )
        app.ask_before_close = false
    }




// Pack all available data about the current movie in a sharable json format
    function pack_data(){
    // Recover original file
        try{
            var jsonObject = JSON.parse( movie.data );
        }catch(e){
            say_to_user( "No movie ID")
            jsonObject = {};
        }

    // Update filter status
        jsonObject["FilterStatus"] = {}
        jsonObject["FilterStatus"]["Violence"] = movie.violence_filter_status
        jsonObject["FilterStatus"]["Sex"] = movie.sex_filter_status
        jsonObject["FilterStatus"]["Drugs"] = movie.drugs_filter_status

    // Update scenes data
        jsonObject['Scenes'] = [];
        for( var i = 0; i < scenelistmodel.count; ++i){
            jsonObject['Scenes'][i] = {}
            var scene = scenelistmodel.get(i)
            jsonObject['Scenes'][i]["Category"] = scene.type
            jsonObject['Scenes'][i]["Tags"] = scene.tags
            jsonObject['Scenes'][i]["Severity"] = scene.severity
            jsonObject['Scenes'][i]["Start"] = secToStr( ( hmsToSec( scene.start ) - sync.applied_offset)/sync.applied_speed )
            jsonObject['Scenes'][i]["End"] = secToStr( ( hmsToSec( scene.stop ) - sync.applied_offset)/sync.applied_speed )
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
                    break
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
        //var str = JSON.stringify( jsonObject, "", 2 );
        var str = JSON.stringify( jsonObject );
        return str
    }




// Get title from file name
    function clean_title( str )
    {
        //console.log("Cleaning: " + str )
        var tit = str.toString().replace(/\\/g,'/').split("/").pop();
        tit = tit.replace(/mp4|avi|\[.*\]|\(.*\).*|1080p.*|xvid.*|mkv.*|720p.*|web-dl.*|dvdscr.*|dvdrip.*|brrip.*|bdrip.*|hdrip.*|x264.*|bluray.*|hdtv.*|yify.*|eztv.*|480p.*/gi,'');
        tit = tit.replace(/\.|_/g,' ').replace(/ +/g,' ');
        console.log("Auto cleaned title: " + tit )
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
        console.log("Importing scenes from " + url)
        var str = Utils.read_external_data( url )
        if( !str ) return
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
                "start": secToStr(line[1]/1000),
                "duration": secToStr( (line[2]-line[1])/1000 ),
                "description": "",
                "stop": secToStr(line[2]/1000),
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



// Look if hash is in local cache
    function search_cached_index( hash )
    {
        console.log( "Looking for movie on local index..." )
        var str_o = read_from_file( "index" )
        if( !str_o ) { console.log("No index!"); return}
        var index = JSON.parse( str_o )
        if( !index ) { console.log("Corrupted index"); return}
        if( index[hash] ){
            console.log( "Movie is in local index!" )
            var str = read_from_file( index[hash] )
            if( !str ) return
            movie.data = str
            return true
        }
        console.log( "Movie is not at local index :(" )
        return
    }




// Add hash-imdbcode pair to local cache
    function add_to_index( code, hash )
    {
        if( hash === "Error" || hash === "" ) return
        var str_o = read_from_file( "index" )
        if( !str_o ) { console.log("Adding to index, no file found"); str_o = "{}"};
        var index = JSON.parse( str_o )
        if( !index ) { console.log("Adding to index, corrupted file"); return;}
        index[hash] = code
        var str = JSON.stringify( index, "", 2 );
        //console.log( str )
        save_to_file( str, "index" );
    }




// Post params to fcinema.org/api. Call callback when data is ready
    function post(  params, callback, url, callbackparams )
    {
    // Preapare everything
        var http = new XMLHttpRequest()
        if( !url ){
            url = "http://www.fcinema.org/api";
            params += "&version=0.91";
        }
        console.log( params, callback, url )
        http.open("POST", url, true);

    // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");

    // Define function to run when the aswer is recived
        http.onreadystatechange = function() {
                    if (http.readyState == 4) {
                        if (http.status == 200) {
                            console.log("Server response: " + http.responseText )
                            if( callbackparams){
                                callback( http.responseText, callbackparams )
                            }else{
                                callback( http.responseText )
                                console.log( http.responseText )
                            }

                        } else {
                            say_to_user( qsTr("Comprueba tu conexión a internet") )
                            console.log("Network error: " + http.status)
                        }
                    }
                }
    // Send the http request
        http.send(params);
    }



// Create a list of unwanted scenes
    function fillSkipList(){
        skiplist.clear()
        if( !scenelistmodel.get(0) ) return -1
        for( var i = 0; i < scenelistmodel.count; ++i){
            if( scenelistmodel.get(i).skip === "Yes" && scenelistmodel.get(i).type !== "Sync" ){
                var item = {
                    "start": hmsToSec( scenelistmodel.get(i).start ) - sync.stimated_error/2 - settings.time_margin,
                    "stop": hmsToSec( scenelistmodel.get(i).stop  ) + sync.stimated_error/2,
                    "action": scenelistmodel.get(i).action,
                }
                skiplist.append( item )
            }
        }
        return skiplist.count;
    }


// If the player selected by user doesn't support EDL we have to do it "manually".
// Just check frequently if the player is playing an unwanted second, if so, tell it to jump to next "friendly" time
    function edl_check( time )
    {
    // Get current time and prepare
        //if( !skiplist.get(0) ) return
        console.log( "Checking ", time)
        var start, stop
    // Check current time against all unwanted scenes
        for( var i = 0; i < skiplist.count; ++i){
            start = skiplist.get(i).start;
            stop  = skiplist.get(i).stop;
            if( time > start & time + 1 < stop ) {
                set_time( stop + 0.1 + 5*preview_data.times_failed )
                time = stop // Update time, just in case scenes overlap

            // In some formats like mkv, VLC jumps before the selected time
                if( preview_data.last_skipped == i){
                    preview_data.times_failed = preview_data.times_failed + 1
                    console.log("Times failed ", preview_data.times_failed )
                }else{
                    preview_data.times_failed = 0;
                    preview_data.last_skipped = i
                }
            }
        }

    // Check autoskip
        check_autoskip(time)
    }

    function preview_check( time )
    {
    // Same but just one time for preview
        console.log( "Checking ", time, " vs ", preview_data.start, preview_data.stop )

        var start = preview_data.start
        var stop  = preview_data.stop
        if( time > start - settings.time_margin & time + 1 < stop ) {
            set_time( stop + 0.1 + 5*preview_data.times_failed )
            preview_data.times_failed = preview_data.times_failed + 1
            preview_data.preview_active = false
            console.log("Times failed ", preview_data.times_failed )
        }
    }


// Display message to user. Normally important warnings she/he must take care of
    function say_to_user( msg, color ){
        if( msg !=="" ){
            console.log("This is a message to the user: ", msg )
            if( movie.msg_to_user === msg ) msg = msg+"!! Estoy aquí!!"
            movie.msg_color = color || "red"
        }
        movie.msg_to_user = msg
    }

// Launch or connect to the user selected player.
    function watch_movie( preview )
    {
    // No matter what, activate watching mode
        preview_data.watch_active = true

    // Fill skip list
        fillSkipList()

    // Make sure we are on sync
        if( sync.confidence < 1 && scenelistmodel.count > 0 ){
            if( sync.shot_sync_failed && sync.shot_sync_failed ){
                say_to_user("La pelicula no esta sincronizada")
            }else{
                say_to_user("Analizando película... solo unos segundos")
            }
            sync.play_after_sync = true
            return
        }

    // Avoid relaunching player
        if( player.execute.get_time() != -1 ) return;

    // Try to launch selected player
        say_to_user("Conectando con el reproductor", "blue" )
        if( player.execute.launch( media.url, preview ) ) {
            say_to_user("Conectado con " +  player.execute.name(), "blue" )
            return true
        }else if( !media.url ){
            say_to_user("Antes debes seleccionar una película")
        }else{
            say_to_user("Oops, fallo técnico. VLC no encontrado?")
        }
        return false
    }



// Start procces of manual calibration
    function manual_calibration(){
        calibrate.visible = true
        watch_movie(true)
        var i = get_sync_scene_index()
        var start_search = Math.max( 1, scenelistmodel.get(i).start - 30 )
        preview_scene( 0, start_search ) // just a trick to "wait" until movie is loaded before jump
        player.execute.set_rate( 2 )
    }



// Ask player for the current time
    function get_time()
    {
        var time = player.execute.get_time()
        if ( time == -1) {// @disable-check M126
            say_to_user( qsTr( "Imposible leer tiempos") )
            return -1
        }
        time = Math.round( parseFloat(time)*1000 ) / 1000
        return time
    }



//
    function check_autoskip( time ){

        // Autoskip is presed
        if ( preview_data.preview_active && !preview_data.watch_active ) return
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
                "start": secToStr( player.autoskip_start - 3 ),
                "duration": secToStr( time-player.autoskip_start + 2 ),
                "description": "",
                "stop": secToStr( time-1 ),
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
            if( !watch_movie( true ) ) return
        }
        set_time( preview_data.start - 3 )
        preview_data.times_failed = 0
        preview_data.preview_active = true
        preview_data.watch_active = false
    }



// Modify scenes start and end times to match the current movie.
    function apply_sync( offset, speed, confidence, stimated_error )
    {
    // Prepare variables
        offset = parseFloat(offset)
        speed = parseFloat(speed)
        stimated_error = stimated_error? stimated_error : 0
        console.log( "Applying sync: ", offset, speed, confidence, stimated_error )
        var applied_offset = parseFloat( sync.applied_offset )
        var applied_speed  = parseFloat( sync.applied_speed  )
        if ( typeof offset !== 'number' || typeof speed !== 'number' ) return;
        var raw_start, raw_end, scene;
    // Loop over scenes unsyncing and applying new sync
        for( var i = 0; i < scenelistmodel.count; ++i){
            scene = scenelistmodel.get(i)
            raw_start = ( hmsToSec(scene.start) - applied_offset ) / applied_speed
            raw_end   = ( hmsToSec(scene.stop ) - applied_offset ) / applied_speed
            scene.start = secToStr( raw_start*speed + offset )
            scene.stop  = secToStr( raw_end  *speed + offset )
        }
    // Update applied values (needed for resync and sharing)
        sync.applied_offset = offset
        sync.applied_speed  = speed
        sync.confidence     = confidence
        sync.stimated_error = stimated_error

    // Play if user is waiting...
        if( sync.confidence >= 2 && sync.play_after_sync == true ){
            sync.play_after_sync = false
            watch_movie( false )
            if( settings.start_fullscreen ) player.execute.toggle_fullscreen()
        }
    }



// Set the default player
    function set_player( pl )
    {
        pl = "VLC";
        if( pl === "VLC_TCP" ) {
            player.execute = VLC_TCP
            settings.default_player = pl
            console.log("Setting VLC TCP as player")
        }else if( pl === "VLC_CONSOLE" ) {
            player.execute = VLC_CONSOLE
            console.log("Setting VLC console as player")
            settings.default_player = pl
        }else if( pl === "VLC" ) {
            player.execute = VLC_HTTP
            console.log("Setting VLC http as player")
            settings.default_player = pl
        }

    }


    function secToSimpleStr( time ){
        if( !time || time === -1) return ""
        if(typeof time == "string" && time.match(":")) return time
        var secs = "" + ~~time+'"';
        return secs;
    }

// Convert seconds to formated time string eg: 95 => "1:35"
    function secToStr( time ) {
    //http://stackoverflow.com/a/11486026/3766869
        // Minutes and seconds
        // var mins = ~~(time / 60);
        // var secs = time % 60;
        if( !time || time === -1) return ""
        if(typeof time == "string" && time.match(":")) return time

        // Hours, minutes and seconds
        var hrs = ~~(time / 3600);
        var mins = ~~((time % 3600) / 60);
        var secs = ~~((time % 60)*1000)/1000;

        // Output like "1:01" or "4:03:59" or "123:03:59"
        var ret = "";

        if (hrs > 0)
            ret += "" + hrs + ":" + (mins < 10 ? "0" : "");

        ret += "" + mins + ":" + (secs < 10 ? "0" : "");
        ret += "" + secs;
        //console.log( "secToStr " +  time +" => " + ret )
        return ret;
    }


// Convert formated time to seconds eg: "1:35" => 95
    function hmsToSec( str ){
    //http://stackoverflow.com/a/9640417/3766869
        if( !str ) return -1
        if( isNumber(str) ) return str

        var p = str.split(':'),
            s = 0, m = 1;

        while (p.length > 0) {
            s += m * parseFloat(p.pop(), 10);
            m *= 60;
        }
        //console.log( "hmsToSec " +  str +" => " + s )
        return s;
    }

// Is this value a number?
    function isNumber(n) {
      return !isNaN(parseFloat(n)) && isFinite(n);
    }


// Extract seconds from subtitle file format
    function srtTimeToSeconds(time) {
      var match = time.match(/(\d\d):(\d\d):(\d\d),(\d\d\d)/);
      var hours        = +match[1],
          minutes      = +match[2],
          seconds      = +match[3],
          milliseconds = +match[4];

      return (hours * 60 * 60) + (minutes * 60) + (seconds) + (milliseconds / 1000);
    }


// Parse one line (extracting start, end and text) from a subtitle file format
    function parseSrtLine(line) {
      var match = line.match(/(\d\d:\d\d:\d\d,\d\d\d) --> (\d\d:\d\d:\d\d,\d\d\d)\n+(.*)/m);

      if( !match ){
          console.log( "Error parsing subtitle line: "+line );
          return {
            start: -1,
            end:   -1,
            text:  ''
          };
      }

      return {
        start: srtTimeToSeconds(match[1]),
        end:   srtTimeToSeconds(match[2]),
        text:  match[3].trim()
      };
    }


// Parse a subtitle file
    function parseSrt(srt) {
      srt = srt.replace(/\r\n/g,'\n')
      var lines = srt.split(/(?:^|\n+)\d+\n+|\n+$/g ).slice(1, -2);
      var a = lines.map(parseSrtLine)
      return a
    }


//
    function get_subtitles_correlation( )
    {
        console.log( "Computing correlation between subtitles")
        var ref = parseSrt( movie.ref_srt )
        var subs = parseSrt( movie.our_srt )
        var offset = []
        var rmax = Math.min(900,ref.length);
        var dist = 0, sum = 0, num = 1, off, max = -50000, min = 50000;
        for( var j = 5; j < rmax; ++j){
            var str_ref = clean( ref[j].text )
            for( var i = Math.max(0,j-dist-25), m = Math.min(subs.length,j-dist+25); i < m; ++i){
                var str_subs = clean(subs[i].text)
                if( str_ref === str_subs && str_ref.length > 3 ) {
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

        //for( var i = 0, sum = 0; i < offset.length; i++ ) sum += offset[i];
        var avg = round( sum/offset.length, 1000 )
        var margin = round( (max - min)/2, 1000 )
        if( margin < 4 && num > 50 ){
            apply_sync(avg,1,2);
        }else{
            try_to_sync_from_next_sub_reference()
            apply_sync(avg,1,1);
            say_to_user("Calibration migth be wrong", "orange")
        }
        settings.time_margin = margin
        console.log( offset.length, avg, max-avg, min-avg )
        movie.our_srt = '';
        movie.ref_srt = '';

    }

    function round(num,dec){
        return Math.round( num * dec ) / dec
    }

    function clean(str){
        return str.replace(/<i>|<\/i>|<b>|<\/b>|\.|,|;|¡|¿/g,'').toLowerCase();
    }

    function fuzzy_compare( str1, str2 ){
        str1 = clean( str1 )
        if( str1.length < 2 ) return false;
        str2 = clean( str2 )
        if( str2 === str1 ) return true;
    }

    function subtitles_ready( str, id ){
        if( !str || str.length < 100 ){
            console.log("bad sub")
            try_to_sync_from_next_sub_reference();
        }else{
            console.log( str, str.length )
            if( id.match(/cl_(\d+)cv/)[1] != sync.current_lang ){
                console.log( id.match(/cl_(\d+)cv/) + " from "+id+" doesn't match "+sync.current_lang )
                return;
            }

            if( id.match("ours") ){
                movie.our_srt = str
            }else{
                if( id.match(/cv_(\d+)/)[1] != sync.current_version ){
                    console.log( id.match(/cv_(\d+)/) + " from "+id+" doesn't match "+sync.current_version )
                    return;
                }
                movie.ref_srt = str
            }

            if( movie.ref_srt.length > 100 && movie.our_srt.length ){
                get_subtitles_correlation()
            }else{
                console.log( "Waiting subs...")
            }
        }
    }


    function get_current_movie_subtitles()
    {
    // Get movie data
        try {
            var data = JSON.parse( movie.data )
            if( !data["Subtitles"] ) return;
            for( var i=0; i < data["Subtitles"].length; ++i ){
                if( data["Subtitles"][i]["Hash"] === media.hash ){
                    return i
                }
            }
        } catch(e){
            say_to_user( qsTr( "Esto no debería haber pasado") )
            return
        }
    }

    function start_guessing_sync_from_subs(){
        if( sync.confidence >= 3 ) return;
        console.log( "Start guessing sync form subs")
        movie.our_srt = '';
        movie.ref_srt = '';
        sync.current_lang = 0;
        sync.current_version = 0;
        try_to_sync_from_next_sub_reference()
    }

    function try_to_sync_from_next_sub_reference(){
    // Get movie data
        try {
            var data = JSON.parse( movie.data )
            var our_subtitles = get_current_movie_subtitles();
            if( !our_subtitles || !data || sync.sub_sync_failed ) return;
        } catch(e){
            say_to_user( qsTr( "Esto no debería haber pasado") )
            return
        }

        var all_langs = ['eng','spa','por','pol'];
    // Loop over items
        for( var cv = sync.current_version; cv < data["Subtitles"].length; ++cv ){
            if( data["Subtitles"][cv]["Hash"] === media.hash ) continue;
            for( var cl = sync.current_lang; cl < all_langs.length; ++cl ){
                console.log( "Current version: "+cv +". Current language: "+all_langs[cl])
                var ref = data["Subtitles"][cv]["Link"][all_langs[cl]];
                var ours = data["Subtitles"][our_subtitles]["Link"][all_langs[cl]];
                if( !ref || !ours ) continue
                cl+=1;
                sync.current_lang    = cl;
                sync.current_version = cv;
                post("",subtitles_ready,"http://dl.opensubtitles.org/en/download/filead/"+ref,  'cl_'+cl+'cv_'+cv );
                post("",subtitles_ready,"http://dl.opensubtitles.org/en/download/filead/"+ours, 'cl_'+cl+'cv_ours');
                return;
            }
            sync.current_lang = 0;
            sync.current_version+=1;
        }
        console.log("Unable to sync from subs :/")
        sync.sub_sync_failed = true;
    }


// That's all folks
}
