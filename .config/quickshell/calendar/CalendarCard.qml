// Month calendar card: Monday first, ISO week numbers on the right, today highlighted.
// Wheel or ‹ › change month, click the title (or press Home) to jump back to today.
import QtQuick

Rectangle {
    id: card
    property var colors: ({})
    readonly property color cBg:     colors.bg || "#12131a"
    readonly property color cSurf:   colors.surface || "#1e202e"
    readonly property color cText:   colors.text || "#e0e1dd"
    readonly property color cDim:    colors.text_dim || "#6c757d"
    readonly property color cAccent: colors.accent || "#f4a261"
    readonly property color cSec:    colors.secondary || "#a8dedc"
    readonly property color cAlert:  colors.alert || "#d62828"

    property date today: new Date()
    property int year: today.getFullYear()
    property int month: today.getMonth()          // 0-11
    function shift(n) { const d = new Date(year, month + n, 1); year = d.getFullYear(); month = d.getMonth() }
    function goToday() { today = new Date(); year = today.getFullYear(); month = today.getMonth() }

    function isoWeek(d) {
        const t = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()))
        const day = t.getUTCDay() || 7
        t.setUTCDate(t.getUTCDate() + 4 - day)
        const y0 = new Date(Date.UTC(t.getUTCFullYear(), 0, 1))
        return Math.ceil(((t - y0) / 86400000 + 1) / 7)
    }
    // 42 cells (6 weeks), starting on the Monday on/before the 1st
    readonly property var cells: {
        const first = new Date(year, month, 1)
        const start = new Date(year, month, 1 - ((first.getDay() + 6) % 7))
        const out = []
        for (let i = 0; i < 42; i++) out.push(new Date(start.getFullYear(), start.getMonth(), start.getDate() + i))
        return out
    }

    width: 360; height: col.implicitHeight + 36
    radius: 16
    color: Qt.rgba(cBg.r, cBg.g, cBg.b, 0.96)
    border.width: 1.5
    border.color: Qt.rgba(cAccent.r, cAccent.g, cAccent.b, 0.55)

    WheelHandler { onWheel: e => card.shift((e.angleDelta.y || e.angleDelta.x) < 0 ? 1 : -1) }

    Column {
        id: col
        anchors { top: parent.top; left: parent.left; right: parent.right; margins: 18 }
        spacing: 10

        Item {   // header
            width: parent.width; height: 34
            Text {
                anchors.centerIn: parent
                text: Qt.formatDate(new Date(card.year, card.month, 1), "MMMM yyyy")
                font { pixelSize: 18; bold: true; letterSpacing: 1 }
                color: card.cAccent
                MouseArea { anchors.fill: parent; anchors.margins: -6; cursorShape: Qt.PointingHandCursor; onClicked: card.goToday() }
            }
            Repeater {
                model: [["‹", -1], ["›", 1]]
                Rectangle {
                    required property var modelData
                    width: 30; height: 30; radius: 15
                    anchors.verticalCenter: parent.verticalCenter
                    x: modelData[1] < 0 ? 0 : parent.width - width
                    color: ma.containsMouse ? Qt.rgba(card.cAccent.r, card.cAccent.g, card.cAccent.b, 0.18) : "transparent"
                    Text { anchors.centerIn: parent; text: parent.modelData[0]; font.pixelSize: 20; color: card.cText }
                    MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true; onClicked: card.shift(parent.modelData[1]) }
                }
            }
        }

        Grid {   // weekday names + week-number column
            columns: 8; columnSpacing: 0; rowSpacing: 2
            Repeater {
                model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su", "Wk"]
                Text {
                    required property string modelData
                    required property int index
                    width: 40; height: 22
                    horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                    text: modelData
                    font { pixelSize: 12; bold: index < 7 }
                    color: index === 7 ? card.cDim : index >= 5 ? card.cSec : card.cDim
                }
            }
            Repeater {
                model: 48   // 6 rows x (7 days + week number)
                Item {
                    required property int index
                    readonly property int row: Math.floor(index / 8)
                    readonly property int c: index % 8
                    readonly property var day: c < 7 ? card.cells[row * 7 + c] : card.cells[row * 7]
                    readonly property bool inMonth: day.getMonth() === card.month
                    readonly property bool isToday: c < 7 && day.toDateString() === card.today.toDateString()
                    width: 40; height: 34
                    Rectangle {
                        anchors.centerIn: parent
                        width: 30; height: 30; radius: 15
                        visible: parent.isToday
                        color: card.cAccent
                    }
                    Text {
                        anchors.centerIn: parent
                        text: parent.c < 7 ? parent.day.getDate() : card.isoWeek(parent.day)
                        font { pixelSize: parent.c < 7 ? 14 : 11; bold: parent.isToday }
                        color: parent.isToday ? card.cBg
                             : parent.c === 7 ? card.cDim
                             : !parent.inMonth ? Qt.rgba(card.cDim.r, card.cDim.g, card.cDim.b, 0.5)
                             : parent.c >= 5 ? card.cSec : card.cText
                    }
                }
            }
        }

        Rectangle { width: parent.width; height: 1; color: Qt.rgba(card.cDim.r, card.cDim.g, card.cDim.b, 0.35) }

        Text {   // today, spelled out
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDate(card.today, "dddd, d MMMM yyyy")
            font.pixelSize: 13
            color: card.cText
        }
    }

    Timer {   // keep "today" right across midnight
        interval: 60000; running: true; repeat: true
        onTriggered: { const n = new Date(); if (n.toDateString() !== card.today.toDateString()) card.today = n }
    }
}
