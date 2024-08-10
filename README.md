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

> [!NOTE]
> This plugin uses Retro Bar appearance to work, that means you need to have
> configured the `tab_bar` [color properties](https://github.com/wez/wezterm/blob/56a27e93a9ee50aab50ff4d78308f9b3154b5122/docs/config/appearance.md?plain=1#L319)

```lua
config.colors = {
  tab_bar = {
    -- The color of the strip that goes along the top of the window
    -- (does not apply when fancy tab bar is in use)
    background = '#0b0022',

    -- The active tab is the one that has focus in the window
    active_tab = {
      -- The color of the background area for the tab
      bg_color = '#2b2042',
      -- The color of the text for the tab
      fg_color = '#c0c0c0',

      -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
      -- label shown for this tab.
      -- The default is "Normal"
      intensity = 'Normal',

      -- Specify whether you want "None", "Single" or "Double" underline for
      -- label shown for this tab.
      -- The default is "None"
      underline = 'None',

      -- Specify whether you want the text to be italic (true) or not (false)
      -- for this tab.  The default is false.
      italic = false,

      -- Specify whether you want the text to be rendered with strikethrough (true)
      -- or not for this tab.  The default is false.
      strikethrough = false,
    },

    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
      bg_color = '#1b1032',
      fg_color = '#808080',

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
      bg_color = '#3b3052',
      fg_color = '#909090',
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab_hover`.
    },

    -- The new tab button that let you create new tabs
    new_tab = {
      bg_color = '#1b1032',
      fg_color = '#808080',

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over the new tab button
    new_tab_hover = {
      bg_color = '#3b3052',
      fg_color = '#909090',
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab_hover`.
    },
  },
}
```

# Available configurations

- *tabs*: Configures some of the properties of the tab.
- *ui*: Allows to configure the separators between tabs.
- *icons*: If the process running is supported, it will show a icon.

The current defaults are:

```lua

local config = {
  tabs = {
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
