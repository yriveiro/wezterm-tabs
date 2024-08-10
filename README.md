# WezTerm Tabs

This project provides a configurable tab bar for [WezTerm](https://wezfurlong.org/wezterm/index.html),
a GPU-accelerated terminal emulator.

# Installation

This project works with the native plugin system provided by WezTerm.

Modify your WezTerm configuration file (~/.config/wezterm/wezterm.lua) to include
the status bar script:

```lua

    local wezterm = require 'wezterm'
    local config = wezterm.config_builder()

    ...

    wezterm.plugin
      .require('https://github.com/yriveiro/wezterm-tabs')
      .apply_to_config(config)
```

# Setup

To customize the plugin, the method `apply_to_config` accepts a second argument
for the plugin options.

In this example, we are configuring the position of the tab bar.

```lua

    local wezterm = require 'wezterm'
    local config = wezterm.config_builder()

    ...

    wezterm.plugin
      .require('https://github.com/yriveiro/wezterm-tabs')
      .apply_to_config(config, { tabs = { tab_bar_at_bottom = false } })
```

# Available configurations

- *tabs*: Configures some of the properties of the tab.
- *ui*: Allows to configure the separators between tabs.
- *icons*: If the process running is supported, it will show a icon.

The current defaults are:

```lua

local config = {
  tabs = {
    use_fancy_tab_bar = false,
    tab_bar_at_bottom = true,
    hide_tab_bar_if_only_one_tab = false,
    tab_max_width = 32,
    unzoom_on_switch_pane = true,
  },
  ui = {
    separators = {
      arrow_solid_left = '\u{e0b0}',
      arrow_solid_right = '\u{e0b2}',
      arrow_thin_left = '\u{e0b1}',
      arrow_thin_right = '\u{e0b3}',
    },
    icons = {
      ['debug'] = wezterm.nerdfonts.cod_debug_console,
      ['bash'] = wezterm.nerdfonts.cod_terminal_bash,
      ['cargo'] = wezterm.nerdfonts.dev_rust,
      ['curl'] = wezterm.nerdfonts.md_waves,
      ['docker'] = wezterm.nerdfonts.linux_docker,
      ['docker-compose'] = wezterm.nerdfonts.linux_docker,
      ['gh'] = wezterm.nerdfonts.dev_github_badge,
      ['git'] = wezterm.nerdfonts.dev_git,
      ['go'] = wezterm.nerdfonts.seti_go,
      ['kubectl'] = wezterm.nerdfonts.linux_docker,
      ['lua'] = wezterm.nerdfonts.seti_lua,
      ['make'] = wezterm.nerdfonts.seti_makefile,
      ['node'] = wezterm.nerdfonts.md_hexagon,
      ['nvim'] = wezterm.nerdfonts.custom_vim,
      ['sudo'] = wezterm.nerdfonts.fa_hashtag,
      ['vim'] = wezterm.nerdfonts.dev_vim,
      ['wget'] = wezterm.nerdfonts.md_arrow_down_box,
      ['zsh'] = wezterm.nerdfonts.dev_terminal,
    },
  },
}
```

# Usage

Once configured, the tab bar will automatically update with the relevant
information when WezTerm is running.

# Contributing

Contributions are welcome! Please open an issue or submit a pull request with your improvements.

# License

This project is licensed under the MIT License. See the LICENSE file for details.

