# conky

conky-top

```javascript
conky.config = {
    -- Position: top left corner, no indentation
    alignment = 'top_left',
    gap_x = 0,
    gap_y = 0,

    -- Strip size: full screen width (1920), height 20px
    minimum_width = 1920,
    maximum_width = 1920,
    minimum_height = 20,

    -- A Dedicated Window
    own_window = true,
    own_window_type = 'dock',          -- top panel, reserves space (KWin's rule is to keep it above the panel)
    own_window_hints = 'above,sticky',
    own_window_transparent = true,
    own_window_argb_visual = true,
    own_window_argb_value = 0,         -- 0 = completely transparent background (not used when `transparent=true`)
    own_window_colour = '000000',      -- black background of the strip

    -- Borders/shadows
    double_buffer = true,
    border_width = 0,
    border_inner_margin = 0,
    border_outer_margin = 0,
    draw_shades = false,
    draw_outline = false,

    -- Fonts
    use_xft = true,
    font = 'SF Pro Text:size=9',
    default_color = 'FFFFFF',

    background = false,
    update_interval = 1,

    -- Lua-scrypt: kernel output transform (cachyos -> arch1-1)
    lua_load = '/home/topsh/.config/conky/kernel.lua',
}

-- Each module begins with the absolute ${goto N} => does not depend on the width of its neighbors
conky.text = [[
${image /home/topsh/.config/conky/img/arch.png -p 2,1 -s 16x16}${goto 22}${voffset 1}${color FFFFFF}ArchLinux${voffset -1}${goto 80}${voffset 1}${color 2092d0}${font FontAwesome:size=9}${offset 5}${font}${offset 4}Kernel:${color FFFFFF} ${lua_parse kernel_release}${goto 240}${color 2092d0}${font FontAwesome:size=9}${font}${offset 4}${voffset -1}Up:${color FFFFFF} ${execi 10 awk '{s=$1; h=int(s/3600); m=int((s%3600)/60); printf "%dh %dm", h, m}' /proc/uptime}${goto 330}${color 2092d0}${font FontAwesome:size=9}${font}${offset 4}${voffset -1}CPU:${color 00FF00} ${execi 300 grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | cut -c2-20} ${if_match ${cpu cpu0} < 10} ${cpu cpu0}%${else}${cpu cpu0}%${endif}${goto 545}${color 2092d0}${font FontAwesome:size=9}${font}${offset 4}${voffset -1}GPU:${color FF0000} ${execi 300 nvidia-smi --query-gpu=name --format=csv,noheader | head -1 | cut -c1-18}${offset 4}${execi 5 sh -c "printf '%2d%%' $(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | tr -d ' %')"}${goto 750}${color 2092d0}${font FontAwesome:size=9}${font}${offset 4}${voffset -1}Mem:${color FFFFFF} ${mem} / ${memmax}${goto 915}${voffset -1}${color 2092d0}${font FontAwesome:size=9}${font}${offset 4}Shell:${color FFFFFF} ${execi 300 basename $SHELL}${goto 1010}${voffset -1}${color 2092d0}${font FontAwesome:size=9}${font}${offset 4}Res:${color FFFFFF} ${execi 300 xrandr --current 2>/dev/null | grep '*' | awk '{print $1}' | head -1}${goto 1130}${voffset -1}${color 2092d0}${font FontAwesome:size=9}${font}${offset 4}Pkgs:${color FFFFFF} ${execi 600 pacman -Qq | wc -l}${goto 1220}${voffset -1}${color 2092d0}${font FontAwesome:size=9}${voffset 1}${voffset -1}${font}${offset 4}Disk:${color FFFFFF} ${fs_used /} / ${fs_size /}${goto 1380}${voffset -1}${color 2092d0}${font FontAwesome:size=9}${font}${offset 4}Swap:${color FFFFFF} ${swap} / ${swapmax}${goto 1540}${voffset -1}${color 2092d0}${font FontAwesome:size=9}${font}${offset 4}LAN:${color FFFFFF} ↓${downspeed enp2s0} ↑${upspeed enp2s0}${goto 1750}${voffset -1}${color 2092d0}${font FontAwesome:size=9}${font}${offset 4}Neko:${color FFFFFF} ${execi 2 bash /home/topsh/.config/conky/proxy_traffic.sh}
]]
```




Archive with icons/imgs/scrypts
[Archive.tar.gz](https://github.com/user-attachments/files/32159270/Archive.tar.gz)

