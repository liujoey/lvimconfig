local M = {}

M.config = function()
  local disabled_plugins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
  }
  for _, plugin in pairs(disabled_plugins) do
    vim.g["loaded_" .. plugin] = 1
  end
  vim.opt.completeopt = { "menu", "menuone", "noselect" }
  vim.opt.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "hiddenoff",
    "algorithm:minimal",
  }
  vim.opt.wrap = true
  vim.opt.termguicolors = true
  vim.opt.updatetime = 100
  vim.opt.timeoutlen = 250
  vim.opt.redrawtime = 1500
  vim.opt.ttimeoutlen = 10
  vim.opt.wrapscan = true -- Searches wrap around the end of the file
  vim.o.secure = true -- Disable autocmd etc for project local vimrc files.
  vim.o.exrc = false -- Allow project local vimrc files example .nvimrc see :h exrc
  vim.o.whichwrap = "b,s"
  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
  vim.wo.foldlevel = 4
  vim.wo.foldtext =
    [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
  vim.wo.foldnestmax = 3
  vim.wo.foldminlines = 1
  vim.opt.guifont = "FiraCode Nerd Font:h13"
  vim.opt.cmdheight = 1
  vim.g.dashboard_enable_session = 0
  vim.g.dashboard_disable_statusline = 1
  vim.opt.pumblend = 10
  vim.opt.joinspaces = false
  vim.opt.list = true
  vim.opt.confirm = true -- make vim prompt me to save before doing destructive things
  vim.opt.autowriteall = true -- automatically :write before running commands and changing files
  vim.opt.clipboard = "unnamedplus"
  vim.opt.fillchars = {
    fold = " ",
    eob = " ", -- suppress ~ at EndOfBuffer
    diff = "╱", -- alternatives = ⣿ ░ ─
    msgsep = "‾",
    foldopen = "▾",
    foldsep = "│",
    foldclose = "▸",
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┫",
    vertright = "┣",
    verthoriz = "╋",
  }
  vim.opt.wildignore = {
    "*.aux,*.out,*.toc",
    "*.o,*.obj,*.dll,*.jar,*.pyc,__pycache__,*.rbc,*.class",
    -- media
    "*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp",
    "*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm",
    "*.eot,*.otf,*.ttf,*.woff",
    "*.doc,*.pdf",
    -- archives
    "*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz",
    -- temp/system
    "*.*~,*~ ",
    "*.swp,.lock,.DS_Store,._*,tags.lock",
    -- version control
    ".git,.svn",
  }
  vim.opt.shortmess = {
    t = true, -- truncate file messages at start
    A = true, -- ignore annoying swap file messages
    o = true, -- file-read message overwrites previous
    O = true, -- file-read message overwrites previous
    T = true, -- truncate non-file messages in middle
    f = true, -- (file x of x) instead of just (x of x
    F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
    s = true,
    c = true,
    W = true, -- Don't show [w] or written when writing
  }
  vim.opt.formatoptions = {
    ["1"] = true,
    ["2"] = true, -- Use indent from 2nd line of a paragraph
    q = true, -- continue comments with gq"
    c = true, -- Auto-wrap comments using textwidth
    r = true, -- Continue comments when pressing Enter
    n = true, -- Recognize numbered lists
    t = false, -- autowrap lines using text width value
    j = true, -- remove a comment leader when joining lines.
    -- Only break if the line was not longer than 'textwidth' when the insert
    -- started and only at a white character that has been entered during the
    -- current insert command.
    l = true,
    v = true,
  }
  vim.opt.listchars = {
    eol = nil,
    tab = "→ ",
    extends = "⟩", -- Alternatives: … »
    precedes = "⟨", -- Alternatives: … «
    trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
  }
  vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
  vim.o.cursorline = false
end

-- credit: https://github.com/nyngwang/NeoZoom.lua
function M.maximize_current_split()
  local cur_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_var("non_float_total", 0)
  vim.cmd "windo if &buftype != 'nofile' | let g:non_float_total += 1 | endif"
  vim.api.nvim_set_current_win(cur_win or 0)
  if vim.api.nvim_get_var "non_float_total" == 1 then
    if vim.fn.tabpagenr "$" == 1 then
      return
    end
    vim.cmd "tabclose"
  else
    local last_cursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd "tabedit %:p"
    vim.api.nvim_win_set_cursor(0, last_cursor)
  end
end

function _G.qftf(info)
  local fn = vim.fn
  local items
  local ret = {}
  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local limit = 25
  local fname_fmt1, fname_fmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
  local valid_fmt, invalid_fmt = "%s |%5d:%-3d|%s %s", "%s"
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ""
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = vim.api.nvim_buf_get_name(e.bufnr)
        if fname == "" then
          fname = "[No Name]"
        else
          fname = fname:gsub("^" .. vim.env.HOME, "~")
        end
        if fn.strwidth(fname) <= limit then
          fname = fname_fmt1:format(fname)
        else
          fname = fname_fmt2:format(fname:sub(1 - limit, -1))
        end
      end
      local lnum = e.lnum > 99999 and "inf" or e.lnum
      local col = e.col > 999 and "inf" or e.col
      local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
      str = valid_fmt:format(fname, lnum, col, qtype, e.text)
    else
      str = invalid_fmt:format(e.text)
    end
    table.insert(ret, str)
  end
  return ret
end

return M
