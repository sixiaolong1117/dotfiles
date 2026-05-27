local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.default_prog = { "/bin/zsh", "-l" }
config.automatically_reload_config = true
config.check_for_updates = false

config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  "SF Mono",
  "Menlo",
  "PingFang SC",
})
config.font_size = 14.0
config.line_height = 1.15

config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.92
config.macos_window_background_blur = 24
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 12,
  right = 12,
  top = 10,
  bottom = 8,
}

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 28
config.show_new_tab_button_in_tab_bar = false

config.scrollback_lines = 10000
config.audible_bell = "Disabled"
config.native_macos_fullscreen_mode = true
config.adjust_window_size_when_changing_font_size = false

config.window_close_confirmation = "NeverPrompt"

local act = wezterm.action

config.keys = {
  { key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = false }) },
  { key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "[", mods = "CMD", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "CMD", action = act.ActivateTabRelative(1) },
  { key = "LeftArrow", mods = "OPT", action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "OPT", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow", mods = "OPT", action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow", mods = "OPT", action = act.ActivatePaneDirection("Down") },
  { key = "h", mods = "OPT", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "OPT", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "OPT", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "OPT", action = act.ActivatePaneDirection("Right") },
  { key = "Enter", mods = "CMD", action = act.ToggleFullScreen },
  { key = "k", mods = "CMD", action = act.ClearScrollback("ScrollbackAndViewport") },
  { key = "f", mods = "CMD", action = act.Search({ CaseSensitiveString = "" }) },
  { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
  { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
}

return config
