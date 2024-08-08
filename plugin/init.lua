local ipairs = ipairs
local string = string

---@class Config: Wezterm
local wezterm = require 'wezterm'

--- Merges two tables recursively
---@package
---@param t1 table The first table to merge into
---@param t2 table The second table to merge from
---@return table table The merged table
local function tableMerge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == 'table' then
      if type(t1[k] or false) == 'table' then
        tableMerge(t1[k] or {}, t2[k] or {})
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

---@class WeztermTabConfig
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
      arrow_solid_left = ' \u{e0b0}',
      arrow_solid_right = ' \u{e0b2}',
      arrow_thin_left = ' \u{e0b1}',
      arrow_thin_right = ' \u{e0b3}',
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

--- Returns the title for the tab
---@package
---@nodiscard
---@param tab MuxTabObj
---@return string title Title for the tab
local function tab_title(tab, max_width)
  local title = tab:get_title()

  title = (title and #title > 0) and title or tab:active_pane():get_title()

  local process, custom = title:match '^(%S+)%s*%-?%s*%s*(.*)$'
  local icon = ''

  local proc = string.lower(process)

  if config.ui.icons[proc] then
    icon = (config.ui.icons[proc] or wezterm.nerdfonts.cod_workspace_unknown) .. ' '
  end

  local is_zoomed = false

  for _, pane in ipairs(tab:panes_with_info()) do
    if pane.is_zoomed then
      is_zoomed = true
      break
    end
  end

  if custom ~= '' then
    title = custom
  end

  if is_zoomed then -- or (#tab.panes > 1 and not tab.is_active) then
    title = ' ' .. title
  end

  title = wezterm.truncate_right(title, max_width - 3)

  return ' ' .. icon .. title .. ' '
end

--- Returns the current tab index
---@package
---@nodiscard
---@param tab MuxTabObj
---@param tabs MuxTabObj[]
---@return number tab_index
local function tab_current_idx(tabs, tab)
  local tab_idx = 1

  for i, t in ipairs(tabs) do
    if t.tab_id == tab.tab_id then
      tab_idx = i
      break
    end
  end

  return tab_idx
end

local M = {}

--- Applies configuration to Wezterm
---@param wezterm_config Config
---@param opts? WeztermTabConfig
function M.apply_to_config(wezterm_config, opts)
  wezterm_config.use_fancy_tab_bar = config.tabs.use_fancy_tab_bar
  wezterm_config.tab_bar_at_bottom = config.tabs.tab_bar_at_bottom
  wezterm_config.hide_tab_bar_if_only_one_tab = config.tabs.hide_tab_bar_if_only_one_tab
  wezterm_config.tab_max_width = config.tabs.tab_max_width
  wezterm_config.unzoom_on_switch_pane = config.tabs.unzoom_on_switch_pane

  config = tableMerge(config, opts or {})
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, wezterm_config, hover, max_width)
    local tab_bar = wezterm_config.color_schemes[wezterm_config.color_scheme].tab_bar

    local active_bg = tab_bar.active_tab.bg_color
    local active_fg = tab_bar.active_tab.fg_color
    local inactive_bg = tab_bar.inactive_tab.bg_color
    local inactive_fg = tab_bar.inactive_tab.fg_color

    local title = tab_title(tab, max_width)
    local tab_idx = tab_current_idx(tabs, tab)

    local is_last = tab_idx == #tabs
    local is_first = tab_idx == 1
    local next_tab = tabs[tab_idx + 1]

    local format_item = {}

    if tab.is_active then
      return {
        { Background = { Color = active_bg } },
        { Foreground = { Color = active_fg } },
        { Attribute = { Intensity = 'Bold' } },
        { Text = ' ' .. tab_idx .. ' ' .. config.ui.separators.arrow_thin_left .. title },
        { Background = { Color = tab_bar.background } },
        { Foreground = { Color = tab_bar.active_tab.bg_color } },
        { Text = config.ui.separators.arrow_solid_left },
        {
          Background = {
            Color = is_last and tab_bar.background or tab_bar.inactive_tab.bg_color,
          },
        },
        { Foreground = { Color = tab_bar.background } },
        { Text = M.arrow_solid },
      }
    end

    if is_first then
      format_item = {
        { Background = { Color = inactive_bg } },
        { Foreground = { Color = inactive_fg } },
        { Text = ' ' .. tab_idx .. ' ' .. M.arrow_thin .. title },
        { Background = { Color = tab_bar.background } },
        { Foreground = { Color = tab_bar.inactive_tab.bg_color } },
        { Text = M.arrow_solid },
        {
          Background = {
            Color = tab.is_active and tab_bar.active_tab.bg_color
              or next_tab.is_active and tab_bar.active_tab.bg_color
              or tab_bar.inactive_tab.bg_color,
          },
        },
        { Foreground = { Color = tab_bar.background } },
        { Text = M.arrow_solid },
      }
    elseif is_last then
      format_item = {
        { Background = { Color = inactive_bg } },
        { Foreground = { Color = inactive_fg } },
        { Text = ' ' .. tab_idx .. ' ' .. M.arrow_thin .. title },
        { Background = { Color = tab_bar.background } },
        { Foreground = { Color = tab_bar.inactive_tab.bg_color } },
        { Text = M.arrow_solid },
        { Background = { Color = tab_bar.background } },
        { Foreground = { Color = tab_bar.background } },
        { Text = M.arrow_solid },
      }
    else
      format_item = {
        { Background = { Color = inactive_bg } },
        { Foreground = { Color = inactive_fg } },
        { Text = ' ' .. tab_idx .. ' ' .. M.arrow_thin .. title },
        { Background = { Color = tab_bar.background } },
        { Foreground = { Color = tab_bar.inactive_tab.bg_color } },
        { Text = M.arrow_solid },
        {
          Background = {
            Color = next_tab.is_active and tab_bar.active_tab.bg_color
              or tab_bar.inactive_tab.bg_color,
          },
        },
        { Foreground = { Color = tab_bar.background } },
        { Text = M.arrow_solid },
      }
    end

    return format_item
  end
)

return M
