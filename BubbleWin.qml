import QtQuick 2.10
import QtQuick.Controls 2.3

Item {
    id: bubbleWin

    property alias fontSize: label.font.pointSize

    signal clicked

    signal widthChanged

    Rectangle {
        id: rectWin
        anchors.fill: parent
        radius: width
        color: "green"

        onWidthChanged: bubbleWin.widthChanged()
    }

    RoundMouseArea {
        id: rMouseAreaWin
        anchors.fill: parent
        cursorShape: rMouseAreaWin.noMouse ? Qt.ArrowCursor : Qt.PointingHandCursor

        onClicked: bubbleWin.clicked()
    }

    Label {
        id: label
        text: qsTr("Congrats!" + "\nYou won!")
        font.weight: rMouseAreaWin.noMouse ? Font.Medium : Font.Black
        color: "white"
        anchors.centerIn: parent
    }
}
