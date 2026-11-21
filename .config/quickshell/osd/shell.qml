// Volume / brightness OSD daemon. Started at login (qs -c osd).
// Volume and mute (speakers and mic) are watched through PipeWire, so any change shows up.
// Brightness has no change events in /sys, so the brightness keys call:  qs ipc -c osd call osd brightness
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pipewire

ShellRoot {
    id: root
    property var colors: ({})
    property bool ready: false          // ignore the initial values PipeWire reports at startup
    Timer { interval: 1500; running: true; onTriggered: root.ready = true }

    // the active theme's colours, re-read each time the OSD appears (themes can change)
    Process {
        id: palette
        command: [Quickshell.env("HOME") + "/.local/bin/theme-list"]
        stdout: StdioCollector {
            onStreamFinished: { const t = JSON.parse(text).find(x => x.current); if (t) root.colors = t.colors }
        }
    }
    Component.onCompleted: palette.running = true

    function show(icon, level, muted, label) {
        card.icon = icon; card.level = level; card.muted = muted; card.label = label || ""
        if (!win.visible) palette.running = true
        win.visible = true
        hideTimer.restart()
    }
    Timer { id: hideTimer; interval: 1600; onTriggered: win.visible = false }

    // ---- volume (default output) ----
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    PwObjectTracker { objects: [root.sink, root.source] }
    function volIcon(v, m) { return m || v <= 0 ? "󰖁" : v < 0.34 ? "󰕿" : v < 0.67 ? "󰖀" : "󰕾" }
    function showVolume() {
        if (!root.ready || !root.sink || !root.sink.audio) return
        const a = root.sink.audio
        root.show(root.volIcon(a.volume, a.muted), a.volume, a.muted, a.muted ? "Muted" : "")
    }
    Connections {
        target: root.sink ? root.sink.audio : null
        function onVolumeChanged() { root.showVolume() }
        function onMutedChanged() { root.showVolume() }
    }
    Connections {   // microphone mute
        target: root.source ? root.source.audio : null
        function onMutedChanged() {
            if (!root.ready) return
            const m = root.source.audio.muted
            root.show(m ? "󰍭" : "󰍬", m ? 0 : 1, m, m ? "Muted" : "On")
        }
    }

    // ---- brightness (asked for by the keybinds over IPC) ----
    Process {
        id: bright
        command: ["brightnessctl", "-m"]      // name,class,current,percent%,max
        stdout: StdioCollector {
            onStreamFinished: {
                const p = parseInt(text.split(",")[3]) / 100
                root.show(p < 0.34 ? "󰃞" : p < 0.67 ? "󰃟" : "󰃠", p, false, "")
            }
        }
    }
    IpcHandler {
        target: "osd"
        function brightness(): void { bright.running = true }
        function volume(): void { root.showVolume() }
    }

    PanelWindow {
        id: win
        visible: false
        anchors.bottom: true
        margins.bottom: 90
        implicitWidth: card.width; implicitHeight: card.height
        color: "transparent"
        exclusiveZone: 0
        mask: Region {}                       // clicks pass straight through
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "osd"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        OsdCard { id: card; colors: root.colors }
    }
}
