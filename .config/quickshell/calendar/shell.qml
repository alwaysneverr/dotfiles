// Calendar popup under the bar's top-right corner (Waybar: right-click the date).
// Esc or a click outside closes it; ←/→ or the wheel change month; Home jumps to today.
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

ShellRoot {
    id: root
    property var colors: ({})

    Process {   // current theme's palette
        running: true
        command: [Quickshell.env("HOME") + "/.local/bin/theme-list"]
        stdout: StdioCollector {
            onStreamFinished: {
                const t = JSON.parse(text).find(x => x.current)
                if (t) root.colors = t.colors
            }
        }
    }

    PanelWindow {
        id: win
        anchors { top: true; right: true }
        margins { top: 8; right: 8 }
        implicitWidth: card.width; implicitHeight: card.height
        color: "transparent"
        exclusiveZone: 0                       // sits below Waybar instead of over it
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "calendar"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        CalendarCard {
            id: card
            colors: root.colors
            focus: true
            opacity: 0
            Component.onCompleted: { opacity = 1; forceActiveFocus() }
            Behavior on opacity { NumberAnimation { duration: 140 } }
            Keys.onPressed: e => {
                if (e.key === Qt.Key_Escape) Qt.quit()
                else if (e.key === Qt.Key_Left || e.key === Qt.Key_H || e.key === Qt.Key_PageUp) card.shift(-1)
                else if (e.key === Qt.Key_Right || e.key === Qt.Key_L || e.key === Qt.Key_PageDown) card.shift(1)
                else if (e.key === Qt.Key_Home || e.key === Qt.Key_T) card.goToday()
                else return
                e.accepted = true
            }
        }
    }

    HyprlandFocusGrab {   // clicking anywhere else closes the calendar
        windows: [win]
        active: true
        onCleared: Qt.quit()
    }
}
