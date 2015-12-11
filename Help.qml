import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

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
<p><b>Escoge la película: </b>Escoge la película de que quieres disfrutar. La película aquí no esta editada y Family Cinema gestiona por tí las posibles diferencias entre versiones.</p>

<p><b>Abrir la película: </b> Se abre como con cualquier otro reproductor (haciendo doble click en el fichero, o abriendo el reproductor y seleccionando el fichero)</p>

<p><b>Identificar la película: </b>En la amplia mayoría de los casos Family Cinema detecta automáticamente que película has abierto. En caso de no estar seguros, te mostraremos una lista desde donde elegir. Si las opciones mostradas no concuerdan con la película seleccionada, escribe correctamente el título (en ingles) de la película.</p>

<p><img src="discover/images/image00.png"></p>

<p><b>Definir sensibilidad: </b>Desde Family Cinema no queremos decirete lo que esta bien y lo que esta mal. Eres tú el que decide que quiere ver y que no. Utiliza las barras para definir tu sensibilidad. Barras vacias indica que no habrá ningún contenido de ese tipo.</p>

<p><img src="discover/images/image02.png"></p>

<p>Si prefieres personalizar más, haz doble click en cualquiera de las escenas de la lista para decidir si saltarlas o no.</p>

<p><img src="discover/images/image05.png"></p>

<p><b>Disfrutar de la película</b> Tan fácil como pulsar &ldquo;Ver película&rdquo; para disfrutar de la película en modo familiar desde tu reproductor multimedia favorito (puedes cambiar tu reproductor favorito desde la pestaña configuración).</p>

<p><img src="discover/images/image04.png"></p>


<hr style="page-break-before:always;display:none;">
<h2>¿Cómo añadir nuevas escenas?</h2>
<p><b>¿Para que añadir escenas?: </b>Antes de que todo el mundo pueda disfrutar de una película en familia es necesario que alguien haya etiquetado el contenido de la película. Una vez un editor autorizado etiqueta el contenido de una película (indicando los tiempos y el tipo y gravedad de escena) todos los usuarios ven en la lista de escenas de esa película las escenas etiquetas por el editor.</p>

<p><b>Abrir la película: </b>Exactamente igual que haría un usuario normal (no habrá escenas en la lista y aparece un aviso de que se va ver la película sin cortes)</p>

<p><b>Marcado rápido de escenas: </b>Mientras se ve la película, se puede marcar rápidamente la presencia de una escena inconveniente pulsando la tecla "+". Esto además quitará el sonido y pasará la escena a velocidad rápida.</p>

<p><b>Etiquetado de escenas</b> Una vez se ha marcado rápidamente la ubicación de las escenas se procede a etiquetar su contenido y a ajustar los tiempos de inicio y fin de las escenas.</p>

<p><img src="discover/images/editor_etiquetas.png"></p>

<p>Las escenas estan clasificadas en tres tipos &ldquo;Violencia&rdquo;, &ldquo;Sexo&rdquo; y &ldquo;Drogas&rdquo;. Dentro de cada tipo, se indica la severidad de la escena (utilizando la barra horizontal). Se pueden también añadir etiquetas, indicando por ejemplo el tipo de droga consumida o si el contenido de la escena es importante para la trama de la película. Es posible además, si se ve necesario, añadir comentarios sobre la escena.</p>

<p>Para editar los tiempos de inicio y fin de la escena el sistema permite &ldquo;Ir&rdquo; al inicio o al final de las escenas. Avanzar &ldquo;&gt;&gt;&rdquo; o retroceder &ldquo;&lt;&lt;&rdquo; a lo largo de la película. El botón de &ldquo;Play&rdquo; permite pausar o empezar el video. El boton de &ldquo;Ahora&rdquo; captura el tiempo actual.</p>

<p><img src="discover/images/editor_tiempos.png"></p>

<p>Una vez indicados los tiempos, se puede previsualizar el resultado del corte y/o añadir una escena nueva.</p>

<p><img src="discover/images/editor_comprobar.png"></p>

<p>Una vez finalizada la edición de una película es posible compartir el contenido etiquetado pulsando en &ldquo;Compartir online&rdquo;. Si algo surge durante la edición o por cualquier otro motivo es posible guardar localmente el contenido pulsando en &ldquo;Guardar&rdquo;. Es posible tambi&eacute;n &ldquo;Importar/Exportar&rdquo; el contenido a otros formatos (para importar cortes generados con un editor de video por ejemplo)</p>

<p><img src="discover/images/editor_guardar.png"></p>


<hr style="page-break-before:always;display:none;">
<h2>Limitaciones de la versión beta</h2>
<p>Algunas funcionalidades que la versión actual no incluye y que se quiere incluir en próximas ediciones.</p>
<ul>
    <li>Multiplataforma.&nbsp;Actualmente el reproductor sólo está disponible para Windows y Mac. Se plane lanzar versiones para Linux, Android y iOS (smart TV, telefónos móviles&hellip;)</li>
    <li>Reproductores compatibles. Actualmente únicamente VLC. El soporte para otros reproductores se a&ntilde;adirá según demanda.</li>
    <li>Gestión de diferencias entre versiones. El sistema actual es ligeramente lento (tarda unos 20-30 segundos en calcular las diferencias la primera vez) y en algunas ocasiones puede generar un error. Se está trabajando en ello.</li>
    <li>Interfaz. Estamos trabajando para hacer la interfaz más intuitiva y estéticamente atráctiva. Algunas partes estan incompletas.</li>
    <li>Estamos añadiendo traducciones de la interfaz a nuevos idiomas.</li>
    <li>Y una larga lista...</li>
    <li>Todo este trabajo es realizado por voluntarios, toda ayuda es bienvenida. Echale un vistazo a la pestaña de "Colaboración" o a <a href="http://fcinema.org/collaborate.html" title="Collab">fcinema.org/collaborate.html</a> si quieres ayudarnos a sacar esto adelante.</li>
</ul>


<h2>Internamente</h2>
<p>El autoreconocimiento de la película se realiza gracias a la base de datos de opensubtitles.org. Calculando el &ldquo;hash&rdquo; y el &ldquo;bytesize&rdquo; de la película.</p>
<p>La gestión de versión de realiza mediante autoreconocimiento de cambios de escena y comparando los subtítulos entre versiones. Los cambios de escena se calculan para los cinco primeros y últimos minutos de cada versión. Una vez hecho esto, comparando los segundos en los que ocurren los saltos se obtiene la diferencia de tiempos entre versiones.</p>
<p>El control de VLC se realiza mediante la interfaz &ldquo;http&rdquo; disponible en el reproductor</p>
<p>Toda la interfaz está programada en Qt 5.5 ampliado con QML (Qt.Quick 2.0)</p>
<p>Los datos se comparten entre usuarios mediante la API ubicada en fcinema.org/api. La api es un proyecto de open data.</p>
<p>Los datos sobre las películas se obtienen mediante APIs de terceros sobre el contenido de IMDB.</p>')
    }
}
