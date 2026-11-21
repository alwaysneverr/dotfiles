// "novel" lock layout: the background fills the screen; clock, tagline and password sit in its centre
// like lines on a page. Ink colour and fonts come from theme.conf (ink=, serif=, sans=).
// Same login plumbing as the other layouts.
import QtQuick
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import QtMultimedia
import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width; height: Screen.height
    color: config.bg || "#17181c"
    readonly property real s: Screen.height / 1080

    readonly property color cInk:    config.ink || "#1a2440"
    readonly property color cAccent: config.accent || "#5b93e6"
    readonly property color cAlert:  config.alert || "#c0392b"
    readonly property color cLight:  config.white || "#f5f7fb"
    readonly property string serif:  config.serif || "Noto Serif"
    readonly property string sans:   config.sans || "Noto Sans"

    // background media: plays (video) or rests (image) the same way as the other layouts
    readonly property bool imageMode: config.type === "image"
    property bool recent: true
    property bool live: imageMode ? recent : bgPlayer.playbackState === MediaPlayer.PlayingState
    function poke() {
        if (imageMode) { recent = true; idleTimer.restart() }
        else if (bgPlayer.playbackState !== MediaPlayer.PlayingState) bgPlayer.play()
    }
    Timer { id: idleTimer; interval: 60000; running: root.imageMode; onTriggered: root.recent = false }

    property int sessionIndex: (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
    property int userIndex: (typeof userModel !== "undefined" && userModel.lastIndex >= 0) ? userModel.lastIndex : 0
    readonly property string userName: (typeof userModel !== "undefined")
        ? (userModel.data(userModel.index(userIndex, 0), Qt.UserRole + 1) || userModel.lastUser || "User") : "User"

    TextConstants { id: textConstants }
    ListView {
        id: sessionHelper
        model: typeof sessionModel !== "undefined" ? sessionModel : null; currentIndex: root.sessionIndex
        opacity: 0; width: 1; height: 1; z: -100
        delegate: Item { property string sName: model.name || "" }
    }
    MouseArea { anchors.fill: parent; z: -1; hoverEnabled: true; onPositionChanged: root.poke() }

    // ---- the page: full-screen background ----
    MediaPlayer { id: bgPlayer; source: root.imageMode ? "" : "bg.mp4"; loops: 20; autoPlay: !root.imageMode; videoOutput: bgOut }
    VideoOutput { id: bgOut; anchors.fill: parent; fillMode: VideoOutput.PreserveAspectCrop; endOfStreamPolicy: VideoOutput.KeepLastFrame; visible: !root.imageMode }
    Image {
        anchors.fill: parent; visible: root.imageMode
        source: root.imageMode ? "bg.jpg" : ""
        fillMode: Image.PreserveAspectCrop; asynchronous: true
        sourceSize.width: Screen.width * 1.1
        // a very slow breath of a zoom while awake; still once idle
        scale: 1.0
        SequentialAnimation on scale {
            loops: Animation.Infinite; running: root.live
            NumberAnimation { to: 1.025; duration: 14000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 1.0; duration: 14000; easing.type: Easing.InOutSine }
        }
    }

    // edges darken, the centre stays bright
    RadialGradient {
        anchors.fill: parent
        horizontalRadius: width * 0.72; verticalRadius: height * 0.8
        gradient: Gradient {
            GradientStop { position: 0.55; color: "transparent" }
            GradientStop { position: 1.0;  color: Qt.rgba(0, 0, 0, 0.62) }
        }
    }

    // a soft dark band along the bottom so the corner text reads on bright images
    Rectangle {
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: 150 * s
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.55) }
        }
    }

    // paper grain: drawn once, then static
    Canvas {
        anchors.fill: parent
        opacity: 0.07
        onPaint: {
            const ctx = getContext("2d"); let seed = 7
            const rnd = () => { seed = (seed * 16807) % 2147483647; return seed / 2147483647 }
            for (let i = 0; i < 9000; i++) {
                ctx.fillStyle = rnd() < 0.5 ? "#000000" : "#ffffff"
                ctx.fillRect(rnd() * width, rnd() * height, 1.5, 1.5)
            }
        }
    }

    // ---- the text, centred in the bright gap ----
    Item {
        id: page
        anchors.centerIn: parent
        width: 620 * s; height: col.implicitHeight
        // soft light halo so the ink stays readable on any part of the image
        RectangularGlow {
            anchors.fill: parent; anchors.margins: 30 * s
            glowRadius: 90 * s; spread: 0.1; cornerRadius: 120 * s
            color: Qt.rgba(1, 0.98, 0.94, 0.38)
        }
        Column {
            id: col
            width: parent.width
            spacing: 16 * s

            Text {
                id: clock
                anchors.horizontalCenter: parent.horizontalCenter
                font { family: root.serif; pixelSize: 96 * s; weight: Font.Light }
                color: root.cInk
            }
            Text {
                id: date
                anchors.horizontalCenter: parent.horizontalCenter
                font { family: root.sans; pixelSize: 15 * s; letterSpacing: 5 * s; capitalization: Font.AllUppercase }
                color: Qt.rgba(root.cInk.r, root.cInk.g, root.cInk.b, 0.75)
            }
            Timer {
                interval: 1000; running: true; repeat: true; triggeredOnStart: true
                onTriggered: { const d = new Date(); clock.text = Qt.formatTime(d, "HH:mm"); date.text = Qt.formatDate(d, "dddd · d MMMM") }
            }

            Item { width: 1; height: 10 * s }

            Text {   // tagline, like a line from the book
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap
                text: config.tagline ? "“" + config.tagline + "”" : ""
                visible: text !== ""
                font { family: root.serif; pixelSize: 21 * s; italic: true }
                color: root.cInk
            }

            Item { width: 1; height: 18 * s }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.userName
                font { family: root.sans; pixelSize: 13 * s; letterSpacing: 4 * s; capitalization: Font.AllUppercase }
                color: Qt.rgba(root.cInk.r, root.cInk.g, root.cInk.b, 0.6)
                MouseArea {
                    anchors.fill: parent
                    onClicked: if (typeof userModel !== "undefined" && userModel.count > 0) root.userIndex = (root.userIndex + 1) % userModel.count
                }
            }

            Item {   // the password: a single ruled manuscript line
                id: line
                anchors.horizontalCenter: parent.horizontalCenter
                width: 340 * s; height: 40 * s
                TextInput {
                    id: passIn
                    anchors { left: parent.left; right: parent.right; bottom: rule.top; bottomMargin: 4 * s }
                    horizontalAlignment: TextInput.AlignHCenter
                    echoMode: TextInput.Password; passwordCharacter: "•"
                    font { family: root.serif; pixelSize: 22 * s; letterSpacing: 6 * s }
                    color: root.cInk; selectionColor: root.cAccent
                    focus: true
                    onAccepted: root.doLogin()
                    onTextChanged: { root.poke(); if (text.length) failText.full = "" }
                    Text {
                        anchors.centerIn: parent
                        text: "password"
                        font { family: root.serif; pixelSize: 17 * s; italic: true }
                        color: Qt.rgba(root.cInk.r, root.cInk.g, root.cInk.b, 0.4)
                        visible: passIn.text.length === 0
                    }
                }
                Rectangle {
                    id: rule
                    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                    height: Math.max(1, 1.5 * s)
                    color: passIn.activeFocus ? root.cInk : Qt.rgba(root.cInk.r, root.cInk.g, root.cInk.b, 0.45)
                    Behavior on color { ColorAnimation { duration: 250 } }
                }
            }

            Text {   // fail text, typed out letter by letter
                id: failText
                property string full: ""
                property int shown: 0
                anchors.horizontalCenter: parent.horizontalCenter
                height: 22 * s
                text: full.substring(0, shown)
                font { family: root.serif; pixelSize: 16 * s; italic: true }
                color: root.cAlert
                onFullChanged: { shown = 0; if (full !== "") typer.start(); else typer.stop() }
                Timer { id: typer; interval: 45; repeat: true; onTriggered: if (failText.shown < failText.full.length) failText.shown++; else stop() }
            }
        }
    }

    // ---- corners (over the darkened edges, so light text) ----
    Text {
        anchors { left: parent.left; bottom: parent.bottom; margins: 28 * s }
        text: sessionHelper.currentItem ? sessionHelper.currentItem.sName : ""
        font { family: root.sans; pixelSize: 13 * s; letterSpacing: 1 * s }
        color: Qt.rgba(root.cLight.r, root.cLight.g, root.cLight.b, 0.7)
        MouseArea {
            anchors.fill: parent
            onClicked: if (typeof sessionModel !== "undefined" && sessionModel.count > 0) root.sessionIndex = (root.sessionIndex + 1) % sessionModel.count
        }
    }
    Row {
        anchors { right: parent.right; bottom: parent.bottom; margins: 28 * s }
        spacing: 22 * s
        Repeater {
            model: [["Restart", "reboot"], ["Shut down", "powerOff"]]
            Text {
                required property var modelData
                text: modelData[0]
                font { family: root.sans; pixelSize: 13 * s; letterSpacing: 1 * s }
                color: pm.containsMouse ? root.cAccent : Qt.rgba(root.cLight.r, root.cLight.g, root.cLight.b, 0.7)
                MouseArea { id: pm; anchors.fill: parent; hoverEnabled: true; onClicked: if (typeof sddm !== "undefined") sddm[parent.modelData[1]]() }
            }
        }
    }
    Text {
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 28 * s }
        text: config.footer || ""
        font { family: root.sans; pixelSize: 11 * s; letterSpacing: 2 * s }
        color: Qt.rgba(root.cLight.r, root.cLight.g, root.cLight.b, 0.55)
    }

    function doLogin() {
        if (typeof sddm !== "undefined") sddm.login(root.userName, passIn.text, root.sessionIndex)
    }
    Connections {
        target: typeof sddm !== "undefined" ? sddm : null
        function onLoginFailed() { passIn.text = ""; failText.full = config.failtext || "Wrong password."; passIn.forceActiveFocus() }
    }
    Timer { interval: 300; running: true; onTriggered: passIn.forceActiveFocus() }
    Component.onCompleted: if (typeof keyboard !== "undefined") keyboard.numLock = true
}
