// "stage" lock layout: the clip sits centre stage in a framed window, everything else around it.
// Same login plumbing as the default (wuwa) layout; colours and texts come from theme.conf.
import QtQuick
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import QtMultimedia
import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width; height: Screen.height
    color: config.bg || "#0e1120"
    readonly property real s: Screen.height / 1080

    readonly property color cAccent: config.accent || "#5fcde0"
    readonly property color cGlow:   config.accent_glow || "#c8f4fb"
    readonly property color cText:   config.silver || "#dde6f5"
    readonly property color cDim:    config.ghost || "#8796b8"
    readonly property color cPanel:  config.panel || "#1b2138"
    readonly property color cAlert:  config.alert || "#ff5f5f"
    readonly property color cWhite:  config.white || "#f5f8fd"
    readonly property string uiFont: config.font || "Noto Sans"

    // video plays 20 loops, then holds its last frame; any input resumes it.
    // Decorations only animate while it plays, so an idle lock costs ~0% CPU.
    readonly property bool imageMode: config.type === "image"
    property bool recent: true
    property bool live: imageMode ? recent : clipPlayer.playbackState === MediaPlayer.PlayingState
    function poke() {
        if (imageMode) { recent = true; idleTimer.restart() }
        else if (clipPlayer.playbackState !== MediaPlayer.PlayingState) clipPlayer.play()
    }
    Timer { id: idleTimer; interval: 60000; running: root.imageMode; onTriggered: root.recent = false }

    property int sessionIndex: (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
    property int userIndex: (typeof userModel !== "undefined" && userModel.lastIndex >= 0) ? userModel.lastIndex : 0
    readonly property string userName: (typeof userModel !== "undefined")
        ? (userModel.data(userModel.index(userIndex, 0), Qt.UserRole + 1) || userModel.lastUser || "User") : "User"

    TextConstants { id: textConstants }
    ListView {   // only used to read the current session's name
        id: sessionHelper
        model: typeof sessionModel !== "undefined" ? sessionModel : null; currentIndex: root.sessionIndex
        opacity: 0; width: 1; height: 1; z: -100
        delegate: Item { property string sName: model.name || "" }
    }

    MouseArea { anchors.fill: parent; z: -1; hoverEnabled: true; cursorShape: Qt.ArrowCursor; onPositionChanged: root.poke() }

    // ---- backdrop: a blurred still of the clip (backdrop.jpg), else the theme colour ----
    Image {
        anchors.fill: parent
        source: "backdrop.jpg"
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.25) }
            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.55) }
        }
    }

    // ---- twinkling four-point stars ----
    Repeater {
        model: [[0.12, 0.18, 26, 0], [0.86, 0.14, 18, 900], [0.07, 0.72, 16, 1700], [0.92, 0.66, 28, 400],
                [0.24, 0.88, 14, 2300], [0.78, 0.9, 20, 1300], [0.5, 0.05, 12, 2900]]
        Text {
            required property var modelData
            x: root.width * modelData[0]; y: root.height * modelData[1]
            text: "✦"; font.pixelSize: modelData[2] * s; color: root.cGlow
            opacity: 0.2
            SequentialAnimation on opacity {
                loops: Animation.Infinite; running: root.live
                PauseAnimation { duration: modelData[3] }
                NumberAnimation { to: 0.85; duration: 1400; easing.type: Easing.InOutSine }
                NumberAnimation { to: 0.2; duration: 1400; easing.type: Easing.InOutSine }
            }
        }
    }

    // ---- centre column ----
    Column {
        anchors.centerIn: parent
        spacing: 22 * s

        Column {   // clock
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2 * s
            Text {
                id: clock
                anchors.horizontalCenter: parent.horizontalCenter
                font { family: root.uiFont; pixelSize: 64 * s; weight: Font.Light; letterSpacing: 4 * s }
                color: root.cWhite
            }
            Text {
                id: date
                anchors.horizontalCenter: parent.horizontalCenter
                font { family: root.uiFont; pixelSize: 16 * s; letterSpacing: 3 * s }
                color: root.cDim
            }
            Timer {
                interval: 1000; running: true; repeat: true; triggeredOnStart: true
                onTriggered: { const d = new Date(); clock.text = Qt.formatTime(d, "HH:mm"); date.text = Qt.formatDate(d, "dddd, d MMMM").toUpperCase() }
            }
        }

        Item {   // the stage: framed clip
            id: stage
            anchors.horizontalCenter: parent.horizontalCenter
            width: 1080 * s; height: 608 * s
            Rectangle {
                id: frame
                anchors.fill: parent
                radius: 18 * s
                color: root.cPanel
                border.width: 2 * s
                border.color: Qt.rgba(root.cAccent.r, root.cAccent.g, root.cAccent.b, 0.7)
                layer.enabled: true
                layer.effect: DropShadow { radius: 40; samples: 41; color: Qt.rgba(root.cAccent.r, root.cAccent.g, root.cAccent.b, 0.35) }
            }
            Rectangle { id: clipMask; anchors.fill: parent; anchors.margins: 2 * s; radius: 16 * s; visible: false }
            Item {
                anchors.fill: parent; anchors.margins: 2 * s
                layer.enabled: true
                layer.effect: OpacityMask { maskSource: clipMask }
                MediaPlayer { id: clipPlayer; source: root.imageMode ? "" : "bg.mp4"; loops: 20; autoPlay: !root.imageMode; videoOutput: clipOut }
                VideoOutput { id: clipOut; anchors.fill: parent; fillMode: VideoOutput.PreserveAspectCrop; endOfStreamPolicy: VideoOutput.KeepLastFrame; visible: !root.imageMode }
                Image { anchors.fill: parent; visible: root.imageMode; source: root.imageMode ? "bg.jpg" : ""; fillMode: Image.PreserveAspectCrop; asynchronous: true }
            }
        }

        Text {   // tagline
            anchors.horizontalCenter: parent.horizontalCenter
            width: stage.width * 0.8
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: config.tagline || ""
            font { family: root.uiFont; pixelSize: 17 * s; italic: true }
            color: root.cText
        }

        Column {   // login
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8 * s
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.userName
                font { family: root.uiFont; pixelSize: 14 * s; letterSpacing: 2 * s }
                color: root.cDim
                MouseArea {   // click the name to cycle users
                    anchors.fill: parent
                    onClicked: if (typeof userModel !== "undefined" && userModel.count > 0) root.userIndex = (root.userIndex + 1) % userModel.count
                }
            }
            Rectangle {
                id: passRect
                width: 360 * s; height: 46 * s; radius: 23 * s
                color: Qt.rgba(0, 0, 0, 0.45)
                border.width: 1.5 * s
                border.color: passIn.activeFocus ? root.cAccent : Qt.rgba(1, 1, 1, 0.25)
                Behavior on border.color { ColorAnimation { duration: 250 } }
                TextInput {
                    id: passIn
                    anchors.fill: parent; anchors.leftMargin: 20 * s; anchors.rightMargin: 20 * s
                    verticalAlignment: TextInput.AlignVCenter; horizontalAlignment: TextInput.AlignHCenter
                    echoMode: TextInput.Password; passwordCharacter: "✦"
                    font { family: root.uiFont; pixelSize: 16 * s; letterSpacing: 4 * s }
                    color: root.cWhite; selectionColor: root.cAccent
                    focus: true
                    onAccepted: root.doLogin()
                    onTextChanged: root.poke()
                    Text {
                        anchors.centerIn: parent
                        text: "password"
                        font { family: root.uiFont; pixelSize: 14 * s; letterSpacing: 2 * s }
                        color: Qt.rgba(1, 1, 1, 0.35)
                        visible: passIn.text.length === 0
                    }
                }
            }
            Text {
                id: errText
                anchors.horizontalCenter: parent.horizontalCenter
                height: 18 * s
                text: ""
                font { family: root.uiFont; pixelSize: 14 * s; italic: true }
                color: root.cAlert
            }
        }
    }

    // ---- corners: session (click to cycle), power ----
    Text {
        anchors { left: parent.left; bottom: parent.bottom; margins: 28 * s }
        text: sessionHelper.currentItem ? sessionHelper.currentItem.sName : ""
        font { family: root.uiFont; pixelSize: 13 * s; letterSpacing: 1 * s }
        color: root.cDim
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
                font { family: root.uiFont; pixelSize: 13 * s; letterSpacing: 1 * s }
                color: pm.containsMouse ? root.cAccent : root.cDim
                MouseArea { id: pm; anchors.fill: parent; hoverEnabled: true; onClicked: if (typeof sddm !== "undefined") sddm[parent.modelData[1]]() }
            }
        }
    }
    Text {
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 28 * s }
        text: config.footer || ""
        font { family: root.uiFont; pixelSize: 11 * s; letterSpacing: 2 * s }
        color: Qt.rgba(1, 1, 1, 0.3)
    }

    function doLogin() {
        if (typeof sddm !== "undefined") sddm.login(root.userName, passIn.text, root.sessionIndex)
    }
    Connections {
        target: typeof sddm !== "undefined" ? sddm : null
        function onLoginFailed() { errText.text = config.failtext || "Wrong password"; passIn.text = ""; passIn.forceActiveFocus(); failAnim.start() }
    }
    SequentialAnimation {
        id: failAnim
        ColorAnimation { target: passRect; property: "border.color"; to: root.cAlert; duration: 200 }
        PauseAnimation { duration: 1000 }
        ColorAnimation { target: passRect; property: "border.color"; to: root.cAccent; duration: 400 }
    }
    Timer { interval: 300; running: true; onTriggered: passIn.forceActiveFocus() }
    Component.onCompleted: if (typeof keyboard !== "undefined") keyboard.numLock = true
}
