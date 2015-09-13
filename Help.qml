import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls 1.3


ScrollView {
    width: 750
    height: 425
    Text{
        x: 11
        y: 10
        width: 710
        horizontalAlignment: Text.AlignJustify
        Layout.maximumWidth: 730
        wrapMode: "WordWrap"
        text: qsTr('<h2 >¿Cómo puedo ver una película?</h2>
<p><b>Conseguir la película: </b>Consigue la película de forma normal, como siempre haces. La película aquí no esta editada y el fcinema gestiona por tí las posibles diferencias entre versiones.</p>

<p><b>Abrir la película</b> Se abre como con cualquier otro reproductor (haciendo doble click en el fichero, o abriendo el reproductor y seleccionando el fichero)</p>

<p><b>Identificar la película</b>En la amplia mayoría de los casos el fcinema detecta automáticamente de que película se trata. En caso de no estar seguros te mostraremos una lista desde donde elegir. Escribe correctamente el título (en ingles) de la película si las opciones no concuerdan con la película.</p>
<p><span style="overflow: hidden; display: inline-block; width: 510.50px; height: 232.00px;"><img alt="open_explorer.png" src="discover/images/image00.png" style="width: 624.00px; height: 473.00px; margin-left: -52.50px; margin-top: -31.00px; transform: rotate(0.00rad) translateZ(0px);" title=""></p>

<p><b>Definir sensibilidad</b>Desde fcinema no queremos decirete lo que esta bien o lo que esta mal. Eres tú el que decide que quiere ver y que no. Utiliza las barras para definir tu sensibilidad. Barras vacias indica que no habrá ningún contenido de ese tipo.</p>
<p><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); width: 417.50px; height: 71.98px;"><img alt="sensibilidad.png" src="discover/images/image02.png" style="width: 417.50px; height: 71.98px;></p>

<p>Si prefieres personalizar más, haz doble click en cualquiera de las escenas de la lista para decidir si saltarlas o no.</p>
<p><span style="overflow: hidden; display: inline-block; width: 457.00px; height: 165.00px;"><img alt="detalle.png" src="discover/images/image05.png" style="width: 457.00px; height: 165.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px);" title=""></p>

<p><b>Disfrutar de la película</b> Tan fácil como pulsar &ldquo;Ver película&rdquo; para disfrutar de la película en modo familiar desde tu reproductor favorito (puedes cambiar tu reproductor favorito desde la pestaña configuración).</p>
<p><span style="overflow: hidden; display: inline-block; width: 624.00px; height: 378.67px;"><img alt="homeland.png" src="discover/images/image04.png" style="width: 624.00px; height: 378.67px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px);" title=""></p>


<hr style="page-break-before:always;display:none;">
<h2>¿Cómo funciona para un editor?</h2>
<h3>&iquest;Cúal es el papel de los editores?</h3>
<p>Para que los usuarios puedan disfrutar de la película sin preocuparse es necesario que alguien haya etiquetado el contenido de la película. Una vez un editor autorizado etiqueta el contenido de una película (indicando los tiempos y el tipo y gravedad de escena) todos los usuarios ven en la lista de escenas de esa película las escenas etiquetas por el editor.</p>
<h3>Conseguir película y reproducir</h3>
<p>Exactamente igual que haría un usuario normal (no habrá escenas en la lista y aparece un aviso de que se va ver la película sin cortes)</p>
<h3><a></a>Marcado rápido de escenas</h3>
<p>Mientras se ve la película, se puede marcar rápidamente la presencia de una escena inconveniente pulsando la tecla &ldquo;+&rdquo;. Esto además quitará el sonido y pasará la escena a velocidad rápida.</p>
<h3>Etiquetado de escenas</h3>
<p>Una vez se ha marcado rápidamente la ubicación de las escenas se procede a etiquetar su contenido y a ajustar los tiempos de inicio y fin de las escenas.</p>
<p><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); width: 359.00px; height: 153.00px;"><img alt="drugs.png" src="discover/images/image03.png" style="width: 359.00px; height: 153.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px);" title=""></p>
<p>Las escenas estan clasificadas en cuatro tipos &ldquo;Violencia&rdquo;, &ldquo;Sexo&rdquo;, &ldquo;Drogas&rdquo; y &ldquo;Discriminación&rdquo;. Dentro de cada tipo, se indica la severidad de la escena (utilizando la barra horizontal). Se pueden tambi&eacute;n a&ntilde;adir etiquetas, indicando por ejemplo el tipo de droga consumida o si el contenido de la escena es importante para la trama de la película. Es posible además, si se ve necesario, a&ntilde;adir comentarios sobre la escena.</p>
<p>Para editar los tiempos de inicio y fin de la escena el sistema permite &ldquo;Ir&rdquo; al inicio o al final de las escenas. Avanzar &ldquo;&gt;&gt;&rdquo; o retroceder &ldquo;&lt;&lt;&rdquo; a lo largo de la película. El botón de &ldquo;Play&rdquo; permite pausar o empezar el video. El boton de &ldquo;Ahora&rdquo; captura el tiempo actual.<span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); width: 294.00px; height: 105.00px;"><img alt="editor.png" src="discover/images/image01.png" style="width: 624.00px; height: 379.00px; margin-left: -8.00px; margin-top: -190.00px; transform: rotate(0.00rad) translateZ(0px);" title=""></p>
<p><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); width: 294.00px; height: 61.00px;"><img alt="editor.png" src="discover/images/image01.png" style="width: 624.00px; height: 379.00px; margin-left: -7.00px; margin-top: -291.00px; transform: rotate(0.00rad) translateZ(0px);" title=""></p>
<p>Una vez indicados los tiempos, se puede previsualizar el resultado del corte y/o a&ntilde;adir una escena nueva.</p>
<p><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); width: 222.00px; height: 30.00px;"><img alt="editor.png" src="discover/images/image01.png" style="width: 624.00px; height: 379.00px; margin-left: -390.00px; margin-top: -308.00px; transform: rotate(0.00rad) translateZ(0px);" title=""></p>
<p>Una vez finalizada la edición de una película es posible compartir el contenido etiquetado pulsando en &ldquo;Compartir online&rdquo;. Si algo surge durante la edición o por cualquier otro motivo es posible guardar localmente el contenido pulsando en &ldquo;Guardar&rdquo;. Es posible tambi&eacute;n &ldquo;Importar/Exportar&rdquo; el contenido a otros formatos (para importar cortes generados con un editor de video por ejemplo)</p>
<p><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); width: 551.50px; height: 334.60px;"><img alt="editor.png" src="discover/images/image01.png" style="width: 551.50px; height: 334.60px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px);" title=""></p>
<hr style="page-break-before:always;display:none;">
<h2>Limitaciones de la versión beta</h2>
<p>Algunas funcionalidades que la versión actual no incluye y que se quiere incluir en próximas ediciones.</p>
<ul>
    <li>Multiplataforma.&nbsp;Actualmente el reproductor sólo está disponible para Windows. En breves se planea lanzar versiones para Mac y Linux. El software a sido dise&ntilde;ado para que en un futuro sea tambi&eacute;n ampliable a Android y iOS (smart TV, telefónos móviles&hellip;)</li>
    <li>Reproductores compatibles. Actualmente únicamente VLC. El soporte para otros reproductores se a&ntilde;adirá según demanda.</li>
    <li>Gestión de diferencias entre versiones. El sistema actual es ligeramente lento (tarda unos 20-30 segundos en calcular las diferencias la primera vez) y en algunas ocasiones puede generar un error. Se está trabajando en ello.</li>
    <li>Interfaz. Como puede verse hay algunas partes incompletas. Se planea además a&ntilde;adir otros idiomas.</li>
    <li>Y una larga lista...</li>
</ul>
<h2>Internamente</h2>
<p>El autoreconocimiento de la película se realiza gracias a la base de datos de opensubtitles.org. Calculando el &ldquo;hash&rdquo; y el &ldquo;bytesize&rdquo; de la película.</p>
<p>La gestión de versión de realiza mediante autoreconocimiento de cambios de escena. Los cambios de escena se calculan para los cinco primeros y últimos minutos de cada versión. Una vez hecho esto, comparando los segundos en los que ocurren los saltos se obtiene la diferencia de tiempos entre versiones.</p>
<p>El control de VLC se realiza mediante la interfaz &ldquo;http&rdquo; disponible en el reproductor</p>
<p>Toda la interfaz está programada en Qt 5.4 ampliado con QML (Qt.Quick 2.0)</p>
<p>Los datos se comparten entre usuarios mediante la API ubicada en fcinema.org/api. La api es un proyecto de open data.</p>
<p>Los datos sobre las películas se obtienen mediante APIs de terceros sobre el contenido de IMDB.</p>')
    }
}
