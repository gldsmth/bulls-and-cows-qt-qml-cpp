import QtQuick 2.10

Item {
    id: roundMouseArea

    property alias mouseX: mouseArea.mouseX
    property alias mouseY: mouseArea.mouseY
    property alias cursorShape: mouseArea.cursorShape

    property bool noMouse: true

    signal clicked

    QtObject {
        id: internal

        property bool containsMouse: {

            var x1 = width / 2

            var y1 = height / 2

            var x2 = mouseX

            var y2 = mouseY

            var distanceFromCenter = Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2)

            var radiusSquared = Math.pow(Math.min(width, height) / 2, 2)

            return distanceFromCenter < radiusSquared
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton

        onClicked: if (internal.containsMouse)
                       roundMouseArea.clicked()

        onPositionChanged: {
            if (internal.containsMouse)

                roundMouseArea.noMouse = false
            else

                roundMouseArea.noMouse = true
        }

        onExited: roundMouseArea.noMouse = true
    }
}
