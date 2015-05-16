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
    minimumWidth: 485//gridLayout.implicitWidth
    minimumHeight: 380//gridLayout.implicitHeight
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
    }

    Item {
        id: movie
        property string title
        property string director
        property string pgcode
        property string imdbrating
        property string scenes
        property string data
        property string list
        property var    subtitles
        property var    subref
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
        property string name
        property string password
        property double time_margin: 0.3
        property bool start_fullscreen: true
        property int sn: 3
        property int v: 2
        property int d: 1
        property int pro: 1
        property bool ask: true
        property string vlc_path : "C:\\Program Files (x86)\\VideoLAN\\VLC\\vlc.exe"
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
        id: type_list
        ListElement {  text: "Discrimination" }
        ListElement {  text: "Violence" }
        ListElement {  text: "Sex" }
        ListElement {  text: "Drugs" }
        ListElement {  text: "Sync" }
    }

    ListModel {
        id: players_list
        ListElement {  text: "VLC_TCP" }
        ListElement {  text: "VLC_CONSOLE" }
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
            media.url = "file://"+ Qt.application.arguments[1].toString();
            movie.title = media.url.split("/").pop().split(".").shift();
            loader.item.parse_input_file()
        }
        VLC_CONSOLE.set_path( settings.vlc_path )
        VLC_TCP.set_path( settings.vlc_path )
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
        width: 600
        //height: 100
        standardButtons: StandardButton.NoButton
        //title: "Identification required"
        GridLayout {
            columns: 4
            RLabel{
                Layout.columnSpan: 4
                text: "Want to do something before closing?"
            }
            RButton {
                text: "Nop, discard"
                onClicked: {
                    app.ask_before_close = false
                    before_closing.visible = false
                    close()
                }
            }
            RButton {
                text: "Save changes"
                onClicked: {
                    app.ask_before_close = false
                    before_closing.visible = false
                    close()
                }
            }
            RButton {
                text: "Share improvements"
                onClicked: {
                    before_closing.visible = false
                    requestPass.visible = true
                    app.ask_before_close = false
                    close()
                }
            }
            RButton {
                text: "Don't close"
                onClicked: {
                    before_closing.visible = false
                }
            }

        }

    }


    Dialog {
        id: bad_movie
        width: 400
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
                    post( "action=badhash&filename="+ movie.title + "&hash=" + media.hash + "&bytesize=" + media.bytesize, function(){} )
                    movie.title = movie_name.text
                    loader.source = "Open.qml"
                    media.hash = "";
                    media.bytesize = -1;
                    post( "action=search&filename="+ movie_name.text, loader.item.show_list )
                    bad_movie.visible = false
                }
            }
            RButton {
                text: "Volver a buscar"
                onClicked: {
                    post( "action=badhash&filename="+ movie.title + "&hash=" + media.hash + "&bytesize=" + media.bytesize, function(){} )
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


// Request user password before sharing
    Dialog {
        id: requestPass
        width: 300
        height: 100
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        title: "Identification required"
        GridLayout {
            columns: 2
            RLabel{
                text: qsTr("Usuario")
            }
            TextField {
                id:name
                width: 100
            }
            RLabel{
                text: qsTr("Contraseña")
            }
            TextField {
                width: 100
                id:pass
                echoMode: TextInput.Password
                //placeholderText: "Password"
            }
            RLabel{
                text: qsTr("Estado del filtro")
            }
            RComboBox {
                Layout.minimumWidth: 100
                id: status_combo
                model: status_list
                currentIndex: movie.filter_status
                onCurrentIndexChanged: movie.filter_status =  currentIndex
            }
        }
        onAccepted: {
            share( name.text, pass.text )
            requestPass.visible = false
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
                text: "Click the button when the scene ends"// + scenelistmodel.get(get_sync_scene_index).description + " ends"
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
                onClicked: player.execute.set_rate( 0 )
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


// Share movie scene with other users
    function share( user, pass)
    {
    // Recover original file
        var jsonObject = JSON.parse( movie.data );
        if ( !jsonObject ) { return }

    // Update filter status
        jsonObject["FilterStatus"] = movie.filter_status

    // Update scenes data
        jsonObject['Scenes'] = [];
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
        post( "action=modify&data="+str+"&username="+user+"&password="+pass, function(){} )
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


// Read content of local file
    function read_file( path )
    {

    }


// Write data to local file
    function save_to_file( path, data )
    {

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
                            //console.log( http.responseText )
                            callback( http.responseText )
                        } else {
                            console.log("error: " + http.status)
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
            console.log("Times failed", preview_data.times_failed )
        }
    }


// Display message to user. Normally important warnings she/he must take care of
    function say_to_user( msg ){
        console.log("This is a message to the user: ", msg )
        movie.msg_to_user = msg
    }

// Launch or connect to the user selected player.
    function watch_movie()
    {
        say_to_user("Connecting with player")
    // Try to launch selected player
        if( player.execute.launch( media.url ) ) {
            timer.start()
            say_to_user("Connected to " +  player.execute.name() )
            return true
        }
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
        }
        say_to_user("Oops. We are unable to start/connect with player")
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
            say_to_user("Reconecting with player")
            if( !player.execute.connect("") ){
                say_to_user("Warning: unable to reach player!")
                raise()
                timer.stop()
                return
            }
        }
        time = Math.round( parseFloat(time)*1000 ) / 1000

    // Autoskip is presed
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
                "subtype":"?",
                "severity":0,
                "start": player.autoskip_start - 3,
                "duration": time-player.autoskip_start + 2,
                "description": "",
                "stop": time-1,
                "action": "Skip",
                "skip": "Yes"
            })
            app.ask_before_close = true
            player.autoskip_start = 0
            loader.source = "Editor.qml"
            if( settings.ask ) raise()
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
        if( !watch_movie() ) return
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
        if( pl === "VLC_TCP" ) {
            player.execute = VLC_TCP
            console.log("Setting VLC TCP as player")
        }else if( pl === "VLC_CONSOLE" ) {
            player.execute = VLC_CONSOLE
            console.log("Setting VLC console as player")
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

    function calibrate_from_subtitles( str )
    {
        //console.log( str )
        if( movie.subref.length < 50 ) {
            movie.subref = str;
            console.log( "subref")
            return
        }
        var ref = parseSrt( movie.subref )
        var subs = parseSrt( str )
        var offset = []
        var rmax = Math.min(900,ref.length);
        var dist = 0, sum = 0, num = 1, off;
        for( var j = 5; j < rmax; ++j){
            var str_ref = clean( ref[j].text )
            for( var i = Math.max(0,j-dist-25), m = Math.min(subs.length,j-dist+25); i < m; ++i){
                var str_subs = clean(subs[i].text)
                if( str_ref === str_subs ) {
                    off = subs[i].start-ref[j].start;
                    if( num < 8 || Math.abs( sum/num - off ) < 5 ){ // Skip those that have crazy time offset
                        offset.push( off )
                        dist = j - i
                        console.log( off, i, dist, str_subs, str_ref )
                        sum += off
                        num++
                        break;

                    }else{ console.log("WTF: ", off, i, j-i, str_subs, str_ref) }
                }
            }
        }

        for( var i = 0, sum = 0; i < offset.length; i++ ) sum += offset[i];
        var avg = sum/offset.length;



        var max_err = Math.max( offset )
        var min_err = Math.min( offset )

        console.log( offset.length, avg, max_err, min_err )

    }

    function clean(str){
        return str.replace(/<i>|<\/i>|<b>|<\/b>|\.|,|;|/g,'').toLowerCase();
    }

    function get_subs( ) {
        post("",calibrate_from_subtitles,"http://dl.opensubtitles.org/en/download/filead/"+movie.subref ); //+".gz"
        post("",calibrate_from_subtitles,"http://dl.opensubtitles.org/en/download/filead/"+movie.subtitles ); //+".gz"

    }

// Thats all folks
}
