import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1


Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 3
        Component.onCompleted: { mainWindow.minimumWidth = 750; mainWindow.minimumHeight = 425; say_to_user("")}


        ScrollView {
            Layout.minimumWidth: 745
            Layout.minimumHeight: 425
            //color: true ? "#aa84b2":"#380c47"
            //radius: 10


            Text{
                x: 15
                Layout.maximumWidth: 720
                horizontalAlignment: Text.AlignJustify
                wrapMode: "WordWrap"
                //font.bold: false
                text: "";/*<html><head><title>fcinema</title><meta content='text/html; charset=UTF-8' http-equiv='content-type'><style type='text/css'> .lst-kix_7ruwlbme1azc-1>li:before{content:'\0025cb  '}.lst-kix_7ruwlbme1azc-4>li:before{content:'\0025cb  '}ul.lst-kix_7ruwlbme1azc-6{list-style-type:none}ul.lst-kix_7ruwlbme1azc-5{list-style-type:none}ul.lst-kix_7ruwlbme1azc-8{list-style-type:none}.lst-kix_7ruwlbme1azc-8>li:before{content:'\0025a0  '}ul.lst-kix_7ruwlbme1azc-7{list-style-type:none}.lst-kix_7ruwlbme1azc-7>li:before{content:'\0025cb  '}ul.lst-kix_7ruwlbme1azc-2{list-style-type:none}ul.lst-kix_7ruwlbme1azc-1{list-style-type:none}ul.lst-kix_7ruwlbme1azc-4{list-style-type:none}ul.lst-kix_7ruwlbme1azc-3{list-style-type:none}.lst-kix_7ruwlbme1azc-5>li:before{content:'\0025a0  '}.lst-kix_7ruwlbme1azc-6>li:before{content:'\0025cf  '}ul.lst-kix_7ruwlbme1azc-0{list-style-type:none}.lst-kix_7ruwlbme1azc-3>li:before{content:'\0025cf  '}.lst-kix_7ruwlbme1azc-2>li:before{content:'\0025a0  '}.lst-kix_7ruwlbme1azc-0>li:before{content:'\0025cf  '}ol{margin:0;padding:0}.c1{padding-left:0pt;widows:2;orphans:2;text-align:justify;direction:ltr;margin-left:36pt}.c2{line-height:1.38;widows:2;orphans:2;height:11pt;text-align:justify;direction:ltr}.c5{line-height:1.656;widows:2;orphans:2;text-align:justify;direction:ltr}.c3{widows:2;orphans:2;height:11pt;direction:ltr}.c15{max-width:468pt;background-color:#ffffff;padding:72pt 72pt 72pt 72pt}.c9{color:#666666;font-size:12pt;font-family:'Trebuchet MS'}.c7{widows:2;orphans:2;direction:ltr}.c12{text-align:center;page-break-after:avoid}.c10{line-height:1.656;text-align:center}.c13{margin:0;padding:0}.c0{font-size:18pt}.c14{height:11pt}.c4{font-weight:bold}.c11{line-height:1.656}.c8{line-height:1.38}.c16{text-align:center}.c6{text-align:justify}.title{widows:2;padding-top:0pt;line-height:1.15;orphans:2;text-align:left;color:#000000;font-size:21pt;font-family:'Trebuchet MS';padding-bottom:0pt;page-break-after:avoid}.subtitle{widows:2;padding-top:0pt;line-height:1.15;orphans:2;text-align:left;color:#666666;font-style:italic;font-size:13pt;font-family:'Trebuchet MS';padding-bottom:10pt;page-break-after:avoid}li{color:#000000;font-size:11pt;font-family:'Arial'}p{color:#000000;font-size:11pt;margin:0;font-family:'Arial'}h1{widows:2;padding-top:10pt;line-height:1.15;orphans:2;text-align:left;color:#000000;font-size:16pt;font-family:'Trebuchet MS';padding-bottom:0pt;page-break-after:avoid}h2{widows:2;padding-top:10pt;line-height:1.15;orphans:2;text-align:left;color:#000000;font-size:13pt;font-family:'Trebuchet MS';font-weight:bold;padding-bottom:0pt;page-break-after:avoid}h3{widows:2;padding-top:8pt;line-height:1.15;orphans:2;text-align:left;color:#666666;font-size:12pt;font-family:'Trebuchet MS';font-weight:bold;padding-bottom:0pt;page-break-after:avoid}h4{widows:2;padding-top:8pt;line-height:1.15;orphans:2;text-align:left;color:#666666;font-size:11pt;text-decoration:underline;font-family:'Trebuchet MS';padding-bottom:0pt;page-break-after:avoid}h5{widows:2;padding-top:8pt;line-height:1.15;orphans:2;text-align:left;color:#666666;font-size:11pt;font-family:'Trebuchet MS';padding-bottom:0pt;page-break-after:avoid}h6{widows:2;padding-top:8pt;line-height:1.15;orphans:2;text-align:left;color:#666666;font-style:italic;font-size:11pt;font-family:'Trebuchet MS';padding-bottom:0pt;page-break-after:avoid}</style></head><body class='c15'><h2 class='c7 c10'><a name='h.q7f3kacerq4f'></a><span class='c0'>Como funciona para un usuario</span></h2><h3 class='c7 c11'><a name='h.95r6o7lf41e6'></a><span>Conseguir la pel&iacute;cula</span></h3><p class='c5'><span>El usuario compra/alquila/descarga la pel&iacute;cula original de forma normal. La pel&iacute;cula aqu&iacute; no esta editada. Da igual el origen de la pel&iacute;cula. El programa gestiona las posibles diferencias de tiempos entre distintas versiones de una misma pel&iacute;cula.</span></p><p class='c3'><span></span></p><p class='c7 c11'><span class='c9 c4'>Abrir la pel&iacute;cula con el reproductor.</span></p><p class='c7 c8 c6'><span>Se abre como con cualquier otro reproductor (haciendo doble click en el fichero, o abriendo el reproductor y seleccionando el fichero)</span></p><p class='c3'><span></span></p><h3 class='c7 c11'><a name='h.21paxq60lof9'></a><span>Identificar la pel&iacute;cula</span></h3><p class='c5'><span>En la amplia mayor&iacute;a de los casos el reproductor detecta autom&aacute;ticamente de que pel&iacute;cula se trata. En caso de haber alguna duda, se pide al usuario que elija la pel&iacute;cula de entre una lista.</span></p><p class='c7 c10'><span style='overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 510.50px; height: 232.00px;'><img alt='open_explorer.png' src='images/image04.png' style='width: 624.00px; height: 473.00px; margin-left: -52.50px; margin-top: -31.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);' title=''></span></p><p class='c3 c11'><span></span></p><p class='c7 c8'><span class='c4 c9'>Definir sensibilidad</span></p><p class='c7 c8 c6'><span>Dado que est&aacute; destinado a un p&uacute;blico amplio y diverso, los usuarios pueden definir su sensibilidad antes de ver la pel&iacute;cula.</span><span style='overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 417.50px; height: 71.98px;'><img alt='sensibilidad.png' src='images/image03.png' style='width: 417.50px; height: 71.98px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);' title=''></span></p><p class='c2'><span></span></p><p class='c7 c6 c8'><span style='overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 457.00px; height: 165.00px;'><img alt='detalle.png' src='images/image02.png' style='width: 457.00px; height: 165.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);' title=''></span></p><p class='c7 c8 c6'><span>El sistema indica que escenas van a ser saltadas. Es tambi&eacute;n posible seleccionar que escenas concretas ver y cuales saltar haciendo doble click en ellas.</span></p><p class='c2'><span></span></p><p class='c2'><span></span></p><p class='c3 c8'><span class='c9 c4'></span></p><p class='c7 c8'><span class='c9 c4'>Disfrutar de la pel&iacute;cula</span></p><p class='c7 c8 c6'><span>Al darle a &ldquo;Ver pel&iacute;cula&rdquo; se reproduce la pel&iacute;cula en VLC (o el reproductor que el usuario defina como predeterminado). El fichero de la pel&iacute;cula no se modifica (no hace falta esperar a que se copie la pel&iacute;cula...). Cuando llegamos a una escena suprimida (o si el usuario por error intenta ir manualmente a ella) el reproductor &ldquo;salta&rdquo; al final de la escena.</span></p><p class='c3 c8 c16'><span></span></p><p class='c7'><span style='overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 378.67px;'><img alt='homeland.png' src='images/image00.png' style='width: 624.00px; height: 378.67px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);' title=''></span></p><p class='c3'><span></span></p><hr style='page-break-before:always;display:none;'><p class='c3'><span></span></p><h2 class='c7 c10'><a name='h.d4900wjl8bfv'></a><span class='c0'>Como funciona para un editor</span></h2><h3 class='c7 c11'><a name='h.muetuio1cx26'></a><span>&iquest;C&uacute;al es el papel de los editores?</span></h3><p class='c7 c6'><span>Para que los usuarios puedan disfrutar de la pel&iacute;cula sin preocuparse es necesario que alguien haya etiquetado el contenido de la pel&iacute;cula. Una vez un editor autorizado etiqueta el contenido de una pel&iacute;cula (indicando los tiempos y el tipo y gravedad de escena) todos los usuarios ven en la lista de escenas de esa pel&iacute;cula las escenas etiquetas por el editor.</span></p><p class='c3 c6'><span></span></p><h3 class='c7 c11'><a name='h.yi4arro39s1l'></a><span>Conseguir pel&iacute;cula y reproducir</span></h3><p class='c5'><span>Exactamente igual que har&iacute;a un usuario normal (no habr&aacute; escenas en la lista y aparece un aviso de que se va ver la pel&iacute;cula sin cortes)</span></p><p class='c5 c14'><span></span></p><h3 class='c7 c11'><a name='h.6jzhz4rvk9f'></a><span>Marcado r&aacute;pido de escenas</span></h3><p class='c5'><span>Mientras se ve la pel&iacute;cula, se puede marcar r&aacute;pidamente la presencia de una escena inconveniente pulsando la tecla &ldquo;+&rdquo;. Esto adem&aacute;s quitar&aacute; el sonido y pasar&aacute; la escena a velocidad r&aacute;pida.</span></p><h3 class='c7 c11'><a name='h.63x7r24wfb2o'></a><span>Etiquetado de escenas</span></h3><p class='c5'><span>Una vez se ha marcado r&aacute;pidamente la ubicaci&oacute;n de las escenas se procede a etiquetar su contenido y a ajustar los tiempos de inicio y fin de las escenas.</span></p><p class='c5'><span style='overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 359.00px; height: 153.00px;'><img alt='drugs.png' src='images/image05.png' style='width: 359.00px; height: 153.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);' title=''></span></p><p class='c5'><span>Las escenas estan clasificadas en cuatro tipos &ldquo;Violencia&rdquo;, &ldquo;Sexo&rdquo;, &ldquo;Drogas&rdquo; y &ldquo;Discriminaci&oacute;n&rdquo;. Dentro de cada tipo, se indica la severidad de la escena (utilizando la barra horizontal). Se pueden tambi&eacute;n a&ntilde;adir etiquetas, indicando por ejemplo el tipo de droga consumida o si el contenido de la escena es importante para la trama de la pel&iacute;cula. Es posible adem&aacute;s, si se ve necesario, a&ntilde;adir comentarios sobre la escena.</span></p><p class='c5'><span>Para editar los tiempos de inicio y fin de la escena el sistema permite &ldquo;Ir&rdquo; al inicio o al final de las escenas. Avanzar &ldquo;&gt;&gt;&rdquo; o retroceder &ldquo;&lt;&lt;&rdquo; a lo largo de la pel&iacute;cula. El bot&oacute;n de &ldquo;Play&rdquo; permite pausar o empezar el video. El boton de &ldquo;Ahora&rdquo; captura el tiempo actual.</span><span style='overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 294.00px; height: 105.00px;'><img alt='editor.png' src='images/image01.png' style='width: 624.00px; height: 379.00px; margin-left: -8.00px; margin-top: -190.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);' title=''></span></p><p class='c5'><span style='overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 294.00px; height: 61.00px;'><img alt='editor.png' src='images/image01.png' style='width: 624.00px; height: 379.00px; margin-left: -7.00px; margin-top: -291.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);' title=''></span></p><p class='c5'><span>Una vez indicados los tiempos, se puede previsualizar el resultado del corte y/o a&ntilde;adir una escena nueva.</span></p><p class='c5'><span style='overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 222.00px; height: 30.00px;'><img alt='editor.png' src='images/image01.png' style='width: 624.00px; height: 379.00px; margin-left: -390.00px; margin-top: -308.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);' title=''></span></p><p class='c5'><span>Una vez finalizada la edici&oacute;n de una pel&iacute;cula es posible compartir el contenido etiquetado pulsando en &ldquo;Compartir online&rdquo;. Si algo surge durante la edici&oacute;n o por cualquier otro motivo es posible guardar localmente el contenido pulsando en &ldquo;Guardar&rdquo;. Es posible tambi&eacute;n &ldquo;Importar/Exportar&rdquo; el contenido a otros formatos (para importar cortes generados con un editor de video por ejemplo)</span></p><p class='c5'><span style='overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 551.50px; height: 334.60px;'><img alt='editor.png' src='images/image01.png' style='width: 551.50px; height: 334.60px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);' title=''></span></p><hr style='page-break-before:always;display:none;'><p class='c5 c14'><span></span></p><h2 class='c7 c12'><a name='h.i6lya7mjk7pp'></a><span class='c0'>Limitaciones de la versi&oacute;n beta</span></h2><p class='c3'><span></span></p><p class='c7 c6'><span>Algunas funcionalidades que la versi&oacute;n actual no incluye y que se quiere incluir en pr&oacute;ximas ediciones.</span></p><p class='c3 c6'><span></span></p><ul class='c13 lst-kix_7ruwlbme1azc-0 start'><li class='c1'><span class='c4'>Multiplataforma.</span><span>&nbsp;Actualmente el reproductor s&oacute;lo est&aacute; disponible para Windows. En breves se planea lanzar versiones para Mac y Linux. El software a sido dise&ntilde;ado para que en un futuro sea tambi&eacute;n ampliable a Android y iOS (smart TV, telef&oacute;nos m&oacute;viles&hellip;)</span></li><li class='c1'><span class='c4'>Reproductores compatibles. </span><span>Actualmente &uacute;nicamente VLC. El soporte para otros reproductores se a&ntilde;adir&aacute; seg&uacute;n demanda.</span></li><li class='c1'><span class='c4'>Gesti&oacute;n de diferencias entre versiones. </span><span>El sistema actual es ligeramente lento (tarda unos 20-30 segundos en calcular las diferencias la primera vez) y en algunas ocasiones puede generar un error. Se est&aacute; trabajando en ello.</span></li><li class='c1'><span class='c4'>Interfaz. </span><span>Como puede verse hay algunas partes incompletas. Se planea adem&aacute;s a&ntilde;adir otros idiomas.</span></li><li class='c1'><span class='c4'>Y una larga lista</span><span class='c4'>...</span></li></ul><p class='c3'><span></span></p><p class='c3'><span></span></p><p class='c3'><span></span></p><h2 class='c7 c12'><a name='h.ongw3w69n38y'></a><span class='c0'>Internamente</span></h2><p class='c3'><span></span></p><p class='c7 c6'><span>El autoreconocimiento de la pel&iacute;cula se realiza gracias a la base de datos de opensubtitles.org. Calculando el &ldquo;hash&rdquo; y el &ldquo;bytesize&rdquo; de la pel&iacute;cula.</span></p><p class='c3 c6'><span></span></p><p class='c6 c7'><span>La gesti&oacute;n de versi&oacute;n de realiza mediante autoreconocimiento de cambios de escena. Los cambios de escena se calculan para los cinco primeros y &uacute;ltimos minutos de cada versi&oacute;n. Una vez hecho esto, se comparando los segundos en los que ocurren los saltos se obtiene la diferencia de tiempos entre versiones.</span></p><p class='c3 c6'><span></span></p><p class='c7 c6'><span>El control de VLC se realiza mediante la interfaz &ldquo;http&rdquo; disponible en el reproductor</span></p><p class='c3 c6'><span></span></p><p class='c7 c6'><span>Toda la interfaz est&aacute; programada en Qt 5.4 ampliado con QML (Qt.Quick 2.0)</span></p><p class='c3 c6'><span></span></p><p class='c7 c6'><span>Los datos se comparten entre usuarios mediante la API ubicada en fcinema.org/api. La api es un proyecto de open data.</span></p><p class='c3 c6'><span></span></p><p class='c7 c6'><span>Los datos sobre las pel&iacute;culas se obtienen mediante APIs de terceros sobre el contenido de IMDB.</span></p></body></html>";/*"<h1>Como funciona para un usuario</h1>
<h2>Conseguir la película</h2>
<p>El usuario compra/alquila/descarga la película original de forma normal. La película aquí no esta editada. Da igual el origen de la película. El programa gestiona las posibles diferencias de tiempos entre distintas versiones de una misma película.</p>


Abrir la película con el reproductor.
Se abre como con cualquier otro reproductor (haciendo doble click en el fichero, o abriendo el reproductor y seleccionando el fichero)


Identificar la película
En la amplia mayoría de los casos el reproductor detecta automáticamente de que película se trata. En caso de haber alguna duda, se pide al usuario que elija la película de entre una lista.
 open_explorer.png



Definir sensibilidad
Dado que está destinado a un público amplio y diverso, los usuarios pueden definir su sensibilidad antes de ver la película. sensibilidad.png


 detalle.png

El sistema indica que escenas van a ser saltadas. Es también posible seleccionar que escenas concretas ver y cuales saltar haciendo doble click en ellas.






Disfrutar de la película
Al darle a “Ver película” se reproduce la película en VLC (o el reproductor que el usuario defina como predeterminado). El fichero de la película no se modifica (no hace falta esperar a que se copie la película...). Cuando llegamos a una escena suprimida (o si el usuario por error intenta ir manualmente a ella) el reproductor “salta” al final de la escena.


 homeland.png



________________


Como funciona para un editor
¿Cúal es el papel de los editores?
Para que los usuarios puedan disfrutar de la película sin preocuparse es necesario que alguien haya etiquetado el contenido de la película. Una vez un editor autorizado etiqueta el contenido de una película (indicando los tiempos y el tipo y gravedad de escena) todos los usuarios ven en la lista de escenas de esa película las escenas etiquetas por el editor.


Conseguir película y reproducir
Exactamente igual que haría un usuario normal (no habrá escenas en la lista y aparece un aviso de que se va ver la película sin cortes)


Marcado rápido de escenas
Mientras se ve la película, se puede marcar rápidamente la presencia de una escena inconveniente pulsando la tecla “+”. Esto además quitará el sonido y pasará la escena a velocidad rápida.
Etiquetado de escenas
Una vez se ha marcado rápidamente la ubicación de las escenas se procede a etiquetar su contenido y a ajustar los tiempos de inicio y fin de las escenas.
 drugs.png

Las escenas estan clasificadas en cuatro tipos “Violencia”, “Sexo”, “Drogas” y “Discriminación”. Dentro de cada tipo, se indica la severidad de la escena (utilizando la barra horizontal). Se pueden también añadir etiquetas, indicando por ejemplo el tipo de droga consumida o si el contenido de la escena es importante para la trama de la película. Es posible además, si se ve necesario, añadir comentarios sobre la escena.
Para editar los tiempos de inicio y fin de la escena el sistema permite “Ir” al inicio o al final de las escenas. Avanzar “>>” o retroceder “<<” a lo largo de la película. El botón de “Play” permite pausar o empezar el video. El boton de “Ahora” captura el tiempo actual. editor.png
 editor.png

Una vez indicados los tiempos, se puede previsualizar el resultado del corte y/o añadir una escena nueva.
 editor.png

Una vez finalizada la edición de una película es posible compartir el contenido etiquetado pulsando en “Compartir online”. Si algo surge durante la edición o por cualquier otro motivo es posible guardar localmente el contenido pulsando en “Guardar”. Es posible también “Importar/Exportar” el contenido a otros formatos (para importar cortes generados con un editor de video por ejemplo)
 editor.png

________________


Limitaciones de la versión beta


Algunas funcionalidades que la versión actual no incluye y que se quiere incluir en próximas ediciones.


* Multiplataforma. Actualmente el reproductor sólo está disponible para Windows. En breves se planea lanzar versiones para Mac y Linux. El software a sido diseñado para que en un futuro sea también ampliable a Android y iOS (smart TV, telefónos móviles…)
* Reproductores compatibles. Actualmente únicamente VLC. El soporte para otros reproductores se añadirá según demanda.
* Gestión de diferencias entre versiones. El sistema actual es ligeramente lento (tarda unos 20-30 segundos en calcular las diferencias la primera vez) y en algunas ocasiones puede generar un error. Se está trabajando en ello.
* Interfaz. Como puede verse hay algunas partes incompletas. Se planea además añadir otros idiomas.
* Y una larga lista...






Internamente


El autoreconocimiento de la película se realiza gracias a la base de datos de opensubtitles.org. Calculando el “hash” y el “bytesize” de la película.


La gestión de versión de realiza mediante autoreconocimiento de cambios de escena. Los cambios de escena se calculan para los cinco primeros y últimos minutos de cada versión. Una vez hecho esto, se comparando los segundos en los que ocurren los saltos se obtiene la diferencia de tiempos entre versiones.


El control de VLC se realiza mediante la interfaz “http” disponible en el reproductor


Toda la interfaz está programada en Qt 5.4 ampliado con QML (Qt.Quick 2.0)


Los datos se comparten entre usuarios mediante la API ubicada en fcinema.org/api. La api es un proyecto de open data.


Los datos sobre las películas se obtienen mediante APIs de terceros sobre el contenido de IMDB.";

/*
<ul>
  <li>Raza: Discriminación debida al origen étnico </li>
  <li>Nationalidad: </li>
  <li>Homofobia: </li>
  <li>Religión</li>
  <li>Ideología</li>
</ul>

<ul>
  <li>Física: </li>
  <li>Psicologica</li>
  <li>Animal</li>
  <li>Sadismo</li>
  <li>Sanger</li>
  <li>Tortura</li>
</ul>
1) Commodity: Does the image show a sexualized person as a commodity, for example, as something that can be bought and sold?

2) Harmed: Does the image show a sexualized person being harmed, for example, being violated or unable to give consent?

3) Interchangeable: Does the image show a sexualized person as interchangeable, for example, a collection of similar bodies?

4) Parts: Does the image show a sexualized person as body parts, for example, a human reduced to breasts or buttocks?

5) Stand-In: Does the image present a sexualized person as a stand-in for an object, for example, a human body used as a chair or a table?
<ul>
  <li>Desnudo</li>
  <li>Sensualidad</li>
  <li>Pornografía<b></li>
  <li><b>Sexo explicito</b></li>
  <li><b>Cosificación</b></li>
  <li><b>Intercambiabilidad</b> Muestra la imagen a una persona sexualizada que puede ser intercambiada o renovada en cualquier momento</li>
  <li>Humillación</li>
  <li><b>Mercancía:</b> Se presenta la imagen sexualizada de una persona como una mercancía, algo que puede ser vendido o comprado, una moneda de cambio.</li>
  <li>Reducción</li>
</ul>

<ul>
  <li>Tabaco</li>
  <li>Alcohol</li>
  <li>Porros</li>
  <li>Cocaína</li>
  <li>Heroína</li>
  <li>Otras</li>
</ul>


<ul>
  <li>Trama</li>
  <li>Gráfica</li>
  <li>Crítia</li>
</ul>

")//*/
            }
        }
    }
}
