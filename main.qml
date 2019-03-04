import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import Analysis 1.0

Window {
    id: mainw
    visible: true
    minimumWidth: 400
    minimumHeight: 500
    title: qsTr("Bulls And Cows")

    onWidthChanged: {
        labelGuess.font.pointSize = rectButtonNewGame.width * 0.200

        labelResult.font.pointSize = rectButtonNewGame.width * 0.200
    }

    BubbleWin {
        id: bubbleWin
        enabled: false
        visible: false
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: parent.width / 2
        height: width
        fontSize: 12

        onWidthChanged: fontSize = width * 0.09

        onClicked: {
            scrollView.reset()

            for (var i = 0; i < mainw.data.length; ++i) {

                if (mainw.data[i].visible !== true) {

                    mainw.data[i].visible = true

                    mainw.data[i].enabled = true
                }
            }

            bubbleWin.visible = false

            bubbleWin.enabled = false

            responseText.rerunAnimation()
        }
    }

    Rectangle {
        id: rectButtonNewGame
        x: parent.x + 30
        y: parent.y + 15
        width: parent.width / 4.375
        height: width
        radius: width
        color: "#27ae60"

        onWidthChanged: new_game.font.pointSize = width * 0.180

        Label {
            id: new_game
            text: qsTr("New game")
            font.pointSize: 12
            font.weight: rMouseAreaNewGame.noMouse ? Font.Medium : Font.Black
            color: "white"
            anchors.centerIn: parent
        }

        RoundMouseArea {
            id: rMouseAreaNewGame
            anchors.fill: parent
            cursorShape: rMouseAreaNewGame.noMouse ? Qt.ArrowCursor : Qt.PointingHandCursor

            onClicked: {

                focus = true

                scrollView.reset()

                analyzer.reset()

                inputField.clear()

                responseText.rerunAnimation()
            }
        }
    }

    Rectangle {
        id: rectButtonQuit
        x: parent.width - width - 30
        y: parent.y + 15
        width: parent.width / 4.375
        height: width
        radius: width
        color: "#27ae60"

        onWidthChanged: quit.font.pointSize = width * 0.180

        Label {
            id: quit
            text: qsTr("Quit")
            font.pointSize: 12
            font.weight: rMouseAreaQuit.noMouse ? Font.Medium : Font.Black
            color: "white"
            anchors.centerIn: parent
        }

        RoundMouseArea {
            id: rMouseAreaQuit
            anchors.fill: parent
            cursorShape: rMouseAreaQuit.noMouse ? Qt.ArrowCursor : Qt.PointingHandCursor

            onClicked: Qt.quit()
        }
    }

    Text {
        id: responseText
        x: inputField.x
        y: inputField.y * 0.7
        width: inputField.width
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: qsTr("Game Started")
        font.pointSize: inputField.font.pointSize - 4
        color: "#d35400"

        ColorAnimation on color {
            id: responseAnimation
            running: true
            to: mainw.color
            duration: 2500
        }

        function rerunAnimation() {

            responseText.color = "#d35400"

            responseAnimation.restart()
        }
    }

    TextField {
        id: inputField
        x: (parent.width - width) / 2
        y: rectButtonNewGame.y + rectButtonNewGame.height + 10
        maximumLength: 4
        width: parent.width / 3.5
        height: rectButtonNewGame.height * 0.45
        leftPadding: 6
        rightPadding: 6
        topPadding: 6
        bottomPadding: 6
        placeholderText: "Input"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 11
        font.letterSpacing: width * 0.02
        color: "#131418"

        background: Rectangle {
            anchors.fill: parent
            border.color: "#3498db"
            border.width: 2
            radius: 6
        }

        validator: RegExpValidator {
            regExp: /^[0-9]{4}/
        }

        onHeightChanged: font.pointSize = height * 0.49

        onAccepted: {
            analyzer.input(inputField.text)

            if (textNumber.length != 0) {

                textNumber.text += "\n---\n" + textNumber.number

                textGuess.text += "\n------\n" + inputField.text
            } else {

                textNumber.text = "1"

                textGuess.text = inputField.text
            }

            inputField.clear()
        }
        Analyzer {
            id: analyzer

            onAnalyzed: {
                if (textNumber.length != 0)

                    textResult.text += "\n------\n" + analyzer.result
                else

                    textResult.text = analyzer.result
            }

            onGuessed: {
                for (var i = 0; i < mainw.data.length; ++i) {

                    if (mainw.data[i].visible === true) {

                        mainw.data[i].visible = false

                        mainw.data[i].enabled = false
                    }
                }
                bubbleWin.visible = true

                bubbleWin.enabled = true

                analyzer.reset()
            }
        }
    }

    Label {
        id: labelGuess
        x: (parent.width - width) / 2
        y: inputField.y + inputField.height + 35
        text: qsTr("Guess")
        font.pointSize: 15
        font.bold: true
    }

    Label {
        id: labelResult
        x: rectButtonQuit.x + rectButtonQuit.width / 6
        y: labelGuess.y
        text: qsTr("Result")
        font.pointSize: 11
        font.bold: true
    }

    ScrollView {
        id: scrollView
        x: (parent.width - width) / 2
        y: labelGuess.y + labelGuess.height
        width: parent.width - 59
        height: parent.height - y - 12
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        contentHeight: textNumber.height

        onContentHeightChanged: repeat(15, ScrollBar.vertical.increase)

        function reset() {
            textNumber.clear()
            textNumber.number = 1
            textGuess.clear()
            textResult.clear()
        }

        function repeat(num, operation) {
            for (var i = 0; i < num; i++)
                operation()
        }

        Item {
            anchors.fill: parent

            TextArea {
                id: textNumber
                x: textGuess.x * 0.20
                property int number: 1
                font.pointSize: labelGuess.font.pointSize

                onTextChanged: ++number
            }
            TextArea {
                id: textGuess
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: labelGuess.font.pointSize
            }
            TextArea {
                id: textResult
                x: textGuess.x * 1.89
                y: textGuess.y
                font.pointSize: labelGuess.font.pointSize
            }
        }
    }
}
