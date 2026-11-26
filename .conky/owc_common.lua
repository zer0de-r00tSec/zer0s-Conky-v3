-- Gemeinsame Einstellungen fuer alle drei OWC-Conky-Fenster
-- Farben/Fonts hier aendern -> wirkt ueberall.

local base = {
    background = true,
    update_interval = 1,
    total_run_times = 0,

    cpu_avg_samples = 2,
    net_avg_samples = 2,
    temperature_unit = 'celsius',

    double_buffer = true,
    no_buffers = true,
    text_buffer_size = 4096,

    own_window = true,
    own_window_class = 'Conky',
    own_window_type = 'desktop',
    own_window_transparent = true,
    own_window_argb_visual = true,
    own_window_hints = 'undecorated,sticky,skip_taskbar,skip_pager,below',

    alignment = 'top_right',
    border_inner_margin = 0,
    border_outer_margin = 0,

    draw_shades = true,
    default_shade_color = '000000',
    draw_outline = false,
    draw_borders = false,
    draw_graph_borders = true,

    override_utf8_locale = true,
    use_xft = true,
    xftalpha = 1,
    uppercase = false,
    -- Monospace fuer Werte, damit Zahlen nicht springen.
    -- Ueberschriften nutzen Caviar Dreams (siehe conky.text).
    font = 'DejaVu Sans Mono:size=8',

    -- OWC-Neon-Palette
    default_color = 'E8FFE8',
    color1 = '3DFF6E',  -- Neongruen: Ueberschriften, Balken, Highlights
    color2 = 'E8FFE8',  -- Werte
    color3 = '1F7A35',  -- Dunkelgruen: Trennlinien
    color4 = '6B7A6B',  -- gedimmt
    color5 = '9FB59F',  -- Beschriftungen
}

function owc_config(overrides)
    local c = {}
    for k, v in pairs(base) do c[k] = v end
    for k, v in pairs(overrides) do c[k] = v end
    return c
end
