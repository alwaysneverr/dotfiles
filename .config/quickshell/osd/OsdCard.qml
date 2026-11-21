// The OSD pill: icon, level bar, percentage.
import QtQuick

Rectangle {
    id: pill
    property var colors: ({})
    property string icon: "󰕾"
    property real level: 0.5          // 0..1 (can go above 1 for boosted volume)
    property bool muted: false
    property string label: ""         // replaces the percentage when set (e.g. "Muted")
    readonly property color cBg:     colors.bg || "#12131a"
    readonly property color cText:   colors.text || "#e0e1dd"
    readonly property color cDim:    colors.text_dim || "#6c757d"
    readonly property color cAccent: colors.accent || "#f4a261"
    readonly property color cAlert:  colors.alert || "#d62828"

    width: 320; height: 56; radius: 28
    color: Qt.rgba(cBg.r, cBg.g, cBg.b, 0.92)
    border.width: 1.5
    border.color: Qt.rgba(cAccent.r, cAccent.g, cAccent.b, 0.5)

    Text {
        id: ic
        anchors { left: parent.left; leftMargin: 20; verticalCenter: parent.verticalCenter }
        text: pill.icon
        font { family: "JetBrainsMono Nerd Font"; pixelSize: 24 }
        color: pill.muted ? pill.cDim : pill.cAccent
    }
    Rectangle {   // track
        id: track
        anchors { left: ic.right; leftMargin: 16; right: pct.left; rightMargin: 14; verticalCenter: parent.verticalCenter }
        height: 6; radius: 3
        color: Qt.rgba(pill.cDim.r, pill.cDim.g, pill.cDim.b, 0.35)
        Rectangle {   // fill
            width: parent.width * Math.max(0, Math.min(1, pill.level)); height: parent.height; radius: 3
            color: pill.muted ? pill.cDim : pill.level > 1.001 ? pill.cAlert : pill.cAccent
            Behavior on width { NumberAnimation { duration: 90; easing.type: Easing.OutCubic } }
        }
    }
    Text {
        id: pct
        anchors { right: parent.right; rightMargin: 20; verticalCenter: parent.verticalCenter }
        width: 46; horizontalAlignment: Text.AlignRight
        text: pill.label !== "" ? pill.label : Math.round(pill.level * 100) + "%"
        font { pixelSize: 15; bold: true }
        color: pill.muted ? pill.cDim : pill.cText
    }
}
