-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--  NATIVE HYPRLAND LUA CONFIG - HSIN/ASUS M415D OPTIMIZED --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

------------------
---- MONITORS ----
------------------
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "hyprlauncher"
local shot_script = "~/.config/hypr/screenshot.sh"

----------------------------------
---- ENVIRONMENT RUN HELPER ------
----------------------------------
-- Helper function to launch apps safely with or without a UWSM systemd tree context
local function launch(cmd)
    if os.getenv("UWSM_ID") then
        return hl.dsp.exec_cmd("uwsm app -- " .. cmd)
    else
        return hl.dsp.exec_cmd(cmd)
    end
end

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function ()
    -- Dynamic backend environment check to prevent desktop load panel lockups
    if os.getenv("UWSM_ID") then
	hl.exec_cmd("uwsm finalize")

	hl.exec_cmd("uwsm app -- kitty")
        hl.exec_cmd("uwsm app -- waybar")
        hl.exec_cmd("uwsm app -- hyprpaper")
        hl.exec_cmd("uwsm app -- hypridle")
        hl.exec_cmd("uwsm app -- dunst")
        hl.exec_cmd("uwsm app -- wl-paste --type text --watch cliphist store")
        hl.exec_cmd("uwsm app -- wl-paste --type image --watch cliphist store")
        hl.exec_cmd("uwsm app -- bluetoothctl power on")
        hl.exec_cmd("uwsm app -- hyprlauncher -d")

        hl.exec_cmd("uwsm app -- steam -silent -nochatui -nofriendsui")
        hl.exec_cmd("uwsm app -- sh -c 'sleep 2 && env GDK_BACKEND=wayland blueman-applet'")
    else
	hl.exec_cmd("kitty")
        hl.exec_cmd("waybar &")
        hl.exec_cmd("hyprpaper &")
        hl.exec_cmd("hypridle &")
        hl.exec_cmd("dunst &")
        hl.exec_cmd("bluetoothctl power on &")
        hl.exec_cmd("hyprlauncher -d &")
        hl.exec_cmd("steam -silent -nochatui -nofriendsui &")
    end
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
-- File association fix for Dolphin file manager
hl.env("XDG_MENU_PREFIX", "arch-")


-----------------------
----- PERMISSIONS -----
-----------------------
hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/slurp", "screencopy", "allow")

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 15,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(d62828ee)", "rgba(f4a261ee)"}, angle = 45 }, -- Hsin Crimson & Gold
            inactive_border = "rgba(1e202eee)", -- Midnight Ink
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Hsin Smooth Fluid Bezier Curves
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

hl.config({
    dwindle = { preserve_split = true },
    master  = { new_status = "master" },
    scrolling = { fullscreen_on_one_column = true },
    misc = { allow_session_lock_restore = true, force_default_wallpaper = 0, disable_hyprland_logo = true, background_color = "0x12131a" },
})

---------------
---- INPUT ----
---------------
hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = false },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

---------------------
---- KEYBINDINGS ----
---------------------
local mainMod = "SUPER"

-- Core System App Launchers (Auto-detects active environment context)
hl.bind(mainMod .. " + Q",        launch(terminal))
hl.bind(mainMod .. " + C",        hl.dsp.window.close())
hl.bind(mainMod .. " + E",        launch(fileManager))
hl.bind(mainMod .. " + R",        launch(menu))
hl.bind(mainMod .. " + SHIFT + F", launch("firefox"))

-- Stop and Log out safely matching session context hooks
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("uwsm stop || hyprctl dispatch exit"))


-- Securely Lock Laptop Screen
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- Window Geometry Controls
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Move Focus Navigation
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Numeric Workspace Switching Array Matrix
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special Scratchpad Workspaces (Cleaned conflict here)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))

-- Mouse Navigation Rules
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- Hardware Functional Multimedia Keys (Audio & Brightness tracking)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Playerctl Background Music Controls
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

---------------------
---- SCREENSHOTS ----
---------------------
-- 1. Evaluated instantly at load-time (completely non-blocking on keypress)
local is_uwsm = os.getenv("UWSM_ID") ~= nil

-- 2. Build the target path commands cleanly without nested quote escaping
local shot_region = is_uwsm and ("uwsm app -- " .. shot_script .. " region") or (shot_script .. " region")
local shot_full   = is_uwsm and ("uwsm app -- " .. shot_script .. " full")   or (shot_script .. " full")
local shot_window = is_uwsm and ("uwsm app -- " .. shot_script .. " window") or (shot_script .. " window")

-- 3. Pass clean, native, non-blocking string dispatchers directly to the API
hl.bind("Print",               hl.dsp.exec_cmd(shot_region))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(shot_full))
hl.bind(mainMod .. " + X",     hl.dsp.exec_cmd(shot_window))

----------------------
---- WINDOW RULES ----
----------------------
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false },
    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})
-- Pixel-perfect window rule for Visual Novels via Lutris/UMU in v0.56.2
hl.window_rule({
    match = {
        class = "^umu%-default$" -- Safely targets the exact UMU runtime wrapper class
    },
    fullscreen = true,
    no_blur = true,
    nearest_neighbor = true
})
-- Background management rules for silent Steam tracking in v0.56.2
hl.window_rule({
    match = {
        class = "^steam$", title = "^Steam$"
    },
    float = true,
    -- Pass a string argument directly to apply specific engine behaviors
    suppress_event = "activate",
    workspace = "emptyn silent"
})
-- Force Vita3K into fullscreen upon launch
hl.window_rule({
    name  = "vita3k-fullscreen",
    match = { 
        class = "^Vita3K$" 
    },
    fullscreen = true,
})

-- Syncplay
hl.bind(mainMod .. " + ALT + S", launch("/usr/bin/syncplay --clear-gui-data -g"))
hl.window_rule({ name = "syncplay-float", match = { class = "^(syncplay)$" }, float = true })

-- wifi
hl.window_rule({ name = "nmtui-float", match = { class = "^(nmtui-float)$" }, float = true })

-- Media server (CIFS automount)
hl.bind(mainMod .. " + SHIFT + V", launch("dolphin " .. os.getenv("HOME") .. "/M710q/Videos"))

-- Pinned calendar (Waybar clock right-click)
hl.window_rule({ name = "calendar-float", match = { class = "^(zenity)$" }, float = true })

-- ASUS touchpad key
hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd("~/.local/bin/touchpad-toggle"))

-- ASUS screenshot key (sends Super+Shift+S)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(shot_region))

-- ASUS MyASUS key (Fn+F12)
hl.bind("XF86Launch1", hl.dsp.exec_cmd("~/.local/bin/power-menu"))

-- Clipboard history and notification center
hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd("~/.local/bin/clip-menu"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("~/.local/bin/notif-center"))
