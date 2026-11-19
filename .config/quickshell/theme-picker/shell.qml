// Theme picker: wallpaper cards with palette swatches.
// Run with `qs -c theme-picker` (Super+T). Keys: ←/→ choose, Enter apply,
// Shift+Enter apply + boot visuals, Esc close.
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

ShellRoot {
    id: root
    readonly property string home: Quickshell.env("HOME")
    property var themes: []
    property int sel: 0
    // chrome colours follow the active theme
    readonly property var cur: themes.find(t => t.current) || { colors: {} }
    readonly property color cBg: cur.colors.bg || "#12131a"
    readonly property color cSurface: cur.colors.surface || "#1e202e"
    readonly property color cText: cur.colors.text || "#e0e1dd"
    readonly property color cDim: cur.colors.text_dim || "#6c757d"
    readonly property color cAccent: cur.colors.accent || "#f4a261"

    Process {
        running: true
        command: [root.home + "/.local/bin/theme-list"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.themes = JSON.parse(text)
                const i = root.themes.findIndex(t => t.current)
                root.sel = i < 0 ? 0 : i
            }
        }
    }

    // colour with alpha; works on "#rrggbb" strings from theme.ini
    function a(c, x) { const q = Qt.lighter(c, 1.0); return Qt.rgba(q.r, q.g, q.b, x) }

    function apply(boot) {
        const t = themes[sel]
        if (!t) return
        const cmd = [home + "/.local/bin/theme-switch", t.id]
        if (boot && t.boot) cmd.push("--boot")
        Quickshell.execDetached(cmd)
        Qt.quit()
    }

    PanelWindow {
        id: win
        anchors { top: true; bottom: true; left: true; right: true }
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "theme-picker"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        Item {
            id: stage
            anchors.fill: parent
            focus: true
            opacity: 0
            Component.onCompleted: { opacity = 1; forceActiveFocus() }
            Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

            Keys.onPressed: e => {
                const n = root.themes.length
                if (e.key === Qt.Key_Escape) Qt.quit()
                else if (n && (e.key === Qt.Key_Right || e.key === Qt.Key_L || e.key === Qt.Key_Tab)) root.sel = (root.sel + 1) % n
                else if (n && (e.key === Qt.Key_Left || e.key === Qt.Key_H || e.key === Qt.Key_Backtab)) root.sel = (root.sel - 1 + n) % n
                else if (e.key === Qt.Key_Return || e.key === Qt.Key_Enter) root.apply(e.modifiers & Qt.ShiftModifier)
                else return
                e.accepted = true
            }

            // backdrop: the selected theme's wallpaper, crossfading, dimmed
            Rectangle { anchors.fill: parent; color: root.cBg }
            Repeater {
                model: root.themes
                Image {
                    required property var modelData
                    required property int index
                    anchors.fill: parent
                    source: modelData.wallpaper ? "file://" + modelData.wallpaper : ""
                    sourceSize.width: 1280
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    opacity: index === root.sel ? 0.45 : 0
                    Behavior on opacity { NumberAnimation { duration: 300 } }
                }
            }
            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: root.a(root.cBg, 0.35) }
                    GradientStop { position: 1.0; color: root.a(root.cBg, 0.9) }
                }
            }
            MouseArea { anchors.fill: parent; onClicked: Qt.quit() }   // click outside closes

            Column {
                anchors.centerIn: parent
                spacing: 28

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "THEME"
                    font { family: "Orbitron"; pixelSize: 22; letterSpacing: 8; bold: true }
                    color: root.cText
                }

                ListView {   // carousel: scrolls when there are more themes than fit
                    id: cards
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Math.min(Math.max(root.themes.length, 1) * 406 + 14, win.width - 160)
                    height: 370
                    orientation: ListView.Horizontal
                    spacing: 26
                    leftMargin: 20; rightMargin: 20
                    clip: false
                    cacheBuffer: 4000
                    interactive: false
                    model: root.themes
                    currentIndex: root.sel
                    highlightRangeMode: ListView.ApplyRange
                    preferredHighlightBegin: width / 2 - 200
                    preferredHighlightEnd: width / 2 + 200
                    highlightMoveDuration: 260

                    WheelHandler {
                        onWheel: e => {
                            const n = root.themes.length
                            if (!n) return
                            const d = (e.angleDelta.y || e.angleDelta.x) < 0 ? 1 : -1
                            root.sel = Math.max(0, Math.min(n - 1, root.sel + d))
                        }
                    }

                        delegate: Item {
                            id: card
                            required property var modelData
                            required property int index
                            readonly property bool picked: index === root.sel
                            readonly property var c: modelData.colors
                            width: 380; height: 330
                            y: (ListView.view.height - height) / 2
                            scale: picked ? 1.04 : (hover.containsMouse ? 1.02 : 0.97)
                            opacity: picked ? 1 : 0.75
                            Behavior on scale { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                            Behavior on opacity { NumberAnimation { duration: 160 } }

                            Rectangle {
                                anchors.fill: parent
                                radius: 14
                                color: root.a(card.c.bg, 0.92)
                                border.width: 2
                                border.color: card.picked ? card.c.accent : root.a(card.c.text_dim, 0.4)
                                Behavior on border.color { ColorAnimation { duration: 160 } }
                            }

                            Column {
                                anchors { fill: parent; margins: 10 }
                                spacing: 10

                                ClippingRectangle {
                                    width: parent.width; height: 203
                                    radius: 9
                                    color: card.c.surface
                                    Image {
                                        anchors.fill: parent
                                        source: card.modelData.wallpaper ? "file://" + card.modelData.wallpaper : ""
                                        sourceSize.width: 720
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true
                                    }
                                    Loader {   // animated wallpapers play while the card is selected or hovered
                                        anchors.fill: parent
                                        active: !!card.modelData.anim && (card.picked || hover.containsMouse)
                                        sourceComponent: AnimatedImage {
                                            source: "file://" + card.modelData.anim
                                            fillMode: Image.PreserveAspectCrop
                                            asynchronous: true
                                            playing: true
                                        }
                                    }
                                    Rectangle {   // fade so the emblem reads
                                        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                                        height: 90
                                        gradient: Gradient {
                                            GradientStop { position: 0.0; color: "transparent" }
                                            GradientStop { position: 1.0; color: root.a(card.c.bg, 0.85) }
                                        }
                                    }
                                    Image {
                                        anchors { left: parent.left; bottom: parent.bottom; margins: 10 }
                                        source: card.modelData.logo ? "file://" + card.modelData.logo : ""
                                        height: 52; width: 52
                                        sourceSize.height: 104
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    Rectangle {   // "current" chip
                                        visible: card.modelData.current
                                        anchors { right: parent.right; top: parent.top; margins: 8 }
                                        radius: 8; height: 22; width: chip.implicitWidth + 16
                                        color: root.a(card.c.bg, 0.8)
                                        border.color: card.c.good
                                        Text {
                                            id: chip
                                            anchors.centerIn: parent
                                            text: "current"
                                            font.pixelSize: 12
                                            color: card.c.good
                                        }
                                    }
                                }

                                Text {
                                    leftPadding: 4
                                    text: card.modelData.name
                                    font { family: "Orbitron"; pixelSize: 19; bold: true; letterSpacing: 2 }
                                    color: card.c.accent
                                }
                                Text {
                                    leftPadding: 4
                                    width: parent.width
                                    elide: Text.ElideRight
                                    text: card.modelData.tagline
                                    font { pixelSize: 13; italic: true }
                                    color: card.c.text_dim
                                }
                                Row {   // palette swatches
                                    leftPadding: 4
                                    spacing: 6
                                    Repeater {
                                        model: ["accent", "secondary", "alert", "good", "text", "surface_hi"]
                                        Rectangle {
                                            required property string modelData
                                            width: 26; height: 14; radius: 4
                                            color: card.c[modelData]
                                            border.color: root.a(card.c.text, 0.25)
                                        }
                                    }
                                }
                            }

                            MouseArea {
                                id: hover
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: root.sel = card.index
                                onDoubleClicked: { root.sel = card.index; root.apply(false) }
                            }
                        }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 14
                    Repeater {
                        model: [{ label: "Apply", boot: false }, { label: "Apply + boot", boot: true }]
                        Rectangle {
                            required property var modelData
                            // "Apply + boot" is greyed out for desktop-only themes
                            readonly property bool off: modelData.boot && !(root.themes[root.sel] || {}).boot
                            opacity: off ? 0.35 : 1
                            width: 170; height: 40; radius: 10
                            color: btn.containsMouse ? root.a(root.cAccent, 0.25) : root.a(root.cSurface, 0.85)
                            border.color: modelData.boot ? root.a(root.cAccent, 0.5) : root.cAccent
                            Text {
                                anchors.centerIn: parent
                                text: parent.modelData.label
                                font.pixelSize: 14
                                color: root.cText
                            }
                            MouseArea {
                                id: btn
                                anchors.fill: parent
                                hoverEnabled: true
                                enabled: !parent.off
                                onClicked: root.apply(parent.modelData.boot)
                            }
                        }
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: (root.themes.length ? (root.sel + 1) + " / " + root.themes.length + "   ·   " : "") + "←/→ choose   ·   Enter apply   ·   Shift+Enter apply + boot (asks for password)   ·   Esc close"
                    font.pixelSize: 12
                    color: root.cDim
                }
            }
        }
    }
}
