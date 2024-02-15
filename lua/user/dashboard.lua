local kind = require("user.kind")

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "custom"

local header = {
  type = "text",
  val = require("user.banners").dashboard(),
  opts = {
    position = "center",
    hl = "Special",
  },
}

local plugins = #lvim.plugins
local date = os.date("%a %d %b")
local plugin_count = {
  type = "text",
  val = "└─   " .. plugins .. " plugins in total   ─┘\n" .. " ",
  opts = {
    position = "center",
    hl = "Special",
  },
}

local org = {
  type = "text",
  val = "[fwrw]",
  opts = {
    position = "center",
    hl = "Function",
  },
}

local heading = {
  type = "text",
  val = "┌─ " .. kind.icons.calendar .. " Today is " .. date .. " ─┐",
  opts = {
    position = "center",
    hl = "Special",
  },
}

local fortune = require "alpha.fortune" ()
-- fortune = fortune:gsub("^%s+", ""):gsub("%s+$", "")
local footer = {
  type = "text",
  val = fortune,
  opts = {
    position = "center",
    hl = "Comment",
    hl_shortcut = "Comment",
  },
}

local function button(sc, txt, keybind)
  local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

  local opts = {
    position = "center",
    text = txt,
    shortcut = sc,
    cursor = 5,
    width = 24,
    align_shortcut = "right",
    hl_shortcut = "Number",
    hl = "Function",
  }
  if keybind then
    opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
  end

  return {
    type = "button",
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
      vim.api.nvim_feedkeys(key, "normal", false)
    end,
    opts = opts,
  }
end

local buttons = {
  type = "group",
  val = {
    button("f", " " .. kind.cmp_kind.Folder .. " Explore", ":Telescope find_files<CR>"),
    button("n", " " .. kind.cmp_kind.File .. " New file", ":ene <BAR> startinsert <CR>"),
    button("p", " " .. lvim.icons.ui.Project .. " Projects", "<CMD>Telescope projects<CR>"),
    button("s", " " .. kind.icons.magic .. " Restore", ":lua require('persistence').load()<cr>"),
    button(
      "g",
      " " .. kind.icons.git .. " Git Status",
      ":lua require('lvim.core.terminal')._exec_toggle({cmd = 'lazygit', count = 1, direction = 'float'})<CR>"
    ),
    button("r", " " .. kind.icons.clock .. " Recents", ":Telescope oldfiles<CR>"),
    button("c", " " .. kind.icons.settings .. " Config", ":e ~/.config/lvim/config.lua<CR>"),
    button("C", " " .. kind.cmp_kind.Color .. " Colorscheme Config", ":e ~/.config/lvim/lua/user/colorscheme.lua<CR>"),
    button("q", " " .. kind.icons.exit .. " Quit", ":q<CR>"),
  }
}

local section = {
  header = header,
  org = org,
  heading = heading,
  buttons = buttons,
  plugin_count = plugin_count,
  footer = footer,
}

lvim.builtin.alpha.custom = {
  config = {
    layout = {
      section.header,
      section.org,
      section.heading,
      section.plugin_count,
      section.buttons,
      section.footer,
    },
    opts = {
      margin = 5,
    },
  }
}
