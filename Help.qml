import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1


Item {

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5
        columns: 3
        Component.onCompleted: { mainWindow.minimumWidth = 485;mainWindow.minimumHeight = 350}


        Rectangle{
            width: 480
            color: true ? "#aa84b2":"#380c47"
            radius: 10

            RText{
                width: 475
                horizontalAlignment: Text.AlignJustify
                wrapMode: "WordWrap"
                font.bold: false
                text: qsTr("


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

")
            }
        }
    }
}
