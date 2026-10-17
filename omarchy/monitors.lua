-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 2
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

-- TV: 4K60 needs Input Signal Plus enabled on the Samsung's HDMI 2 input.
hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@60", position = "0x0", scale = 2 })

-- VNC display (KubeVirt) is off; the TV on the passed-through 3090 Ti is the only screen.
hl.monitor({ output = "Virtual-1", disabled = true })
