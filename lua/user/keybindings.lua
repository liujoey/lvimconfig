local M = {}

M.set_terminal_keymaps = function()
  vim.cmd "tmapc"
end

M.set_lightspeed_keymaps = function()
  vim.cmd [[
nmap s <Plug>Lightspeed_s
nmap S <Plug>Lightspeed_S
nmap <expr> f reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_f" : "f"
nmap <expr> F reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_F" : "F"
nmap <expr> t reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_t" : "t"
nmap <expr> T reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_T" : "T"
  ]]
end

M.set_hlslens_keymaps = function()
  local opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap(
    "n",
    "n",
    "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>",
    opts
  )
  vim.api.nvim_set_keymap(
    "n",
    "N",
    "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
    opts
  )
  vim.api.nvim_set_keymap("n", "*", "*<Cmd>lua require('hlslens').start()<CR>", opts)
  vim.api.nvim_set_keymap("n", "#", "#<Cmd>lua require('hlslens').start()<CR>", opts)
  vim.api.nvim_set_keymap("n", "g*", "g*<Cmd>lua require('hlslens').start()<CR>", opts)
  vim.api.nvim_set_keymap("n", "g#", "g#<Cmd>lua require('hlslens').start()<CR>", opts)
end

local function set_bufferline_keymaps()
  lvim.keys.normal_mode["<S-q>"] = "<Cmd>lua require('user.bufferline').delete_buffer()<CR>"
  lvim.builtin.which_key.mappings["c"] = {}
  lvim.builtin.which_key.mappings.b = {
    name = "﩯Buffer",
    ["1"] = { "<Cmd>BufferLineGoToBuffer 1<CR>", "goto 1" },
    ["2"] = { "<Cmd>BufferLineGoToBuffer 2<CR>", "goto 2" },
    ["3"] = { "<Cmd>BufferLineGoToBuffer 3<CR>", "goto 3" },
    ["4"] = { "<Cmd>BufferLineGoToBuffer 4<CR>", "goto 4" },
    ["5"] = { "<Cmd>BufferLineGoToBuffer 5<CR>", "goto 5" },
    ["6"] = { "<Cmd>BufferLineGoToBuffer 6<CR>", "goto 6" },
    ["7"] = { "<Cmd>BufferLineGoToBuffer 7<CR>", "goto 7" },
    ["8"] = { "<Cmd>BufferLineGoToBuffer 8<CR>", "goto 8" },
    ["9"] = { "<Cmd>BufferLineGoToBuffer 9<CR>", "goto 9" },
    c = { "<Cmd>BufferLinePickClose<CR>", "close buffer" },
    p = { "<Cmd>BufferLineTogglePin<CR>", "toggle pin" },
    s = { "<Cmd>BufferLinePick<CR>", "pick buffer" },
    t = { "<Cmd>BufferLineGroupToggle docs<CR>", "toggle groups" },
    f = { "<cmd>Telescope buffers<cr>", "Find" },
    b = { "<cmd>b#<cr>", "Previous" },
    h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
    l = {
      "<cmd>BufferLineCloseRight<cr>",
      "Close all to the right",
    },
    D = {
      "<cmd>BufferLineSortByDirectory<cr>",
      "Sort by directory",
    },
    L = {
      "<cmd>BufferLineSortByExtension<cr>",
      "Sort by language",
    },
  }
end

M.config = function()
  -- Additional keybindings
  -- =========================================
  lvim.keys.normal_mode["<CR>"] = {
    "<cmd>lua require('user.neovim').maximize_current_split()<CR>",
    { noremap = true, silent = true, nowait = true },
  }
  lvim.keys.normal_mode["<BS>"] = ":noh<cr>"
  lvim.keys.normal_mode["<RIGHT>"] = ":BufferLineCycleNext<CR>"
  lvim.keys.normal_mode["<LEFT>"] = ":BufferLineCyclePrev<CR>"
  lvim.keys.normal_mode["<UP>"] = ":tabprevious<CR>"
  lvim.keys.normal_mode["<DOWN>"] = ":tabnext<CR>"
  lvim.keys.insert_mode["<A-a>"] = "<ESC>ggVG<CR>"
  lvim.keys.insert_mode["<C-s>"] = "<cmd>lua vim.lsp.buf.signature_help()<cr>"
  lvim.keys.command_mode["w!!"] = "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!"
  lvim.keys.normal_mode["]d"] = "<cmd>lua vim.diagnostic.goto_next()<cr>"
  lvim.keys.normal_mode["[d"] = "<cmd>lua vim.diagnostic.goto_prev()<cr>"
  lvim.keys.normal_mode["<A-a>"] = "<C-a>"
  lvim.keys.normal_mode["<A-x>"] = "<C-x>"
  lvim.keys.normal_mode["<C-n>i"] = { "<C-i>", { noremap = true } }
  if vim.fn.has "mac" == 1 then
    lvim.keys.normal_mode["gx"] =
      [[<cmd>lua os.execute("open " .. vim.fn.shellescape(vim.fn.expand "<cWORD>")); vim.cmd "redraw!"<cr>]]
  elseif vim.fn.has "linux" then
    lvim.keys.normal_mode["gx"] =
      [[<cmd>lua os.execute("xdg-open " .. vim.fn.shellescape(vim.fn.expand "<cWORD>")); vim.cmd "redraw!"<cr>]]
  end
  if lvim.builtin.bufferline.active then
    set_bufferline_keymaps()
  end
  if lvim.builtin.sidebar.active then
    lvim.keys.normal_mode["E"] = ":SidebarNvimToggle<cr>"
  end
  lvim.keys.normal_mode["Y"] = "y$"
  lvim.keys.normal_mode["gv"] =
    "<cmd>vsplit | lua vim.lsp.buf.definition({on_list = function(items) vim.fn.setqflist({}, 'r', items) vim.cmd('cfirst') end})<cr>"
  lvim.keys.visual_mode["<A-a>"] = "<C-a>"
  lvim.keys.visual_mode["<A-x>"] = "<C-x>"
  lvim.keys.visual_mode["p"] = [["_dP]]
  lvim.keys.visual_mode["ga"] = "<esc><Cmd>lua vim.lsp.buf.range_code_action()<CR>"
  lvim.keys.visual_mode["<leader>st"] = "<Cmd>lua require('user.telescope').grep_string_visual()<CR>"

  -- WhichKey keybindings
  -- =========================================
  lvim.builtin.which_key.mappings[";"] = { "<cmd>Alpha<CR>", "舘Dashboard" }
  if lvim.builtin.dap.active then
    lvim.builtin.which_key.mappings["de"] = { "<cmd>lua require('dapui').eval()<cr>", "Eval" }
  end
  lvim.builtin.which_key.mappings["F"] = {
    name = " Find",
    b = { "<cmd>lua require('user.telescope').builtin()<cr>", "Builtin" },
    f = { "<cmd>lua require('user.telescope').curbuf()<cr>", "Current Buffer" },
    g = { "<cmd>lua require('user.telescope').git_files()<cr>", "Git Files" },
    i = { "<cmd>lua require('user.telescope').installed_plugins()<cr>", "Installed Plugins" },
    l = {
      "<cmd>lua require('telescope.builtin').resume()<cr>",
      "Last Search",
    },
    p = { "<cmd>lua require('user.telescope').project_search()<cr>", "Project" },
    s = { "<cmd>lua require('user.telescope').git_status()<cr>", "Git Status" },
    z = { "<cmd>lua require('user.telescope').search_only_certain_files()<cr>", "Certain Filetype" },
  }

  lvim.builtin.which_key.mappings["gg"] = { "<cmd>lua require 'user.terminal'.lazygit_toggle()<cr>", "Lazygit" }
  if lvim.builtin.fancy_diff.active then
    lvim.builtin.which_key.mappings["gd"] = { "<cmd>DiffviewOpen<cr>", "diffview: diff HEAD" }
    lvim.builtin.which_key.mappings["gh"] = { "<cmd>DiffviewFileHistory<cr>", "diffview: filehistory" }
  else
    lvim.builtin.which_key.mappings["gh"] = { "<cmd>Telescope git_bcommits<cr>", "file history" }
  end

  lvim.builtin.which_key.mappings["H"] = " Help"
  lvim.builtin.which_key.mappings["h"] = { "<cmd>nohlsearch<CR>", " No Highlight" }
  lvim.builtin.which_key.mappings.g.name = " Git"
  lvim.builtin.which_key.mappings.l.name = " LSP"
  lvim.builtin.which_key.mappings["f"] = nil
  lvim.builtin.which_key.mappings["<space>"] = {
    require("user.telescope").find_project_files,
    " Find File",
  }
  lvim.builtin.which_key.mappings["e"] = { "<cmd>NeoTreeRevealToggle<CR>", " Explorer" }
  local ok, _ = pcall(require, "vim.diagnostic")
  if ok then
    lvim.builtin.which_key.mappings["l"]["j"] = {
      "<cmd>lua vim.diagnostic.goto_next({float = {border = 'rounded', focusable = false, source = 'always'}, severity = {min = vim.diagnostic.severity.WARN}})<cr>",
      "Next Diagnostic",
    }
    lvim.builtin.which_key.mappings["l"]["k"] = {
      "<cmd>lua vim.diagnostic.goto_prev({float = {border = 'rounded', focusable = false, source = 'always'}, severity = {min = vim.diagnostic.severity.WARN}})<cr>",
      "Prev Diagnostic",
    }
  end

  lvim.builtin.which_key.vmappings["l"] = {
    name = "+Lsp",
    r = { "<ESC><CMD>lua vim.lsp.buf.rename()<CR>", "Rename" },
  }
  lvim.builtin.which_key.mappings["lp"] = {
    name = "Peek",
    d = { "<cmd>lua require('user.peek').Peek('definition')<cr>", "Definition" },
    t = { "<cmd>lua require('user.peek').Peek('typeDefinition')<cr>", "Type Definition" },
    i = { "<cmd>lua require('user.peek').Peek('implementation')<cr>", "Implementation" },
  }
  lvim.builtin.which_key.mappings["lh"] = {
    "<cmd>hi LspReferenceRead cterm=bold ctermbg=red guibg=#24283b<cr><cmd>hi LspReferenceText cterm=bold ctermbg=red guibg=#24283b<cr><cmd>hi LspReferenceWrite cterm=bold ctermbg=red guibg=#24283b<cr>",
    "Clear HL",
  }
  if lvim.builtin.persistence then
    lvim.builtin.which_key.mappings["q"] = {
      name = " Quit",
      d = { "<cmd>lua require('persistence').stop()<cr> | :qa!<cr>", "Quit without saving session" },
      l = { "<cmd>lua require('persistence').load(last=true)<cr>", "Restore last session" },
      s = { "<cmd>lua require('persistence').load()<cr>", "Restore for current dir" },
    }
  end
  lvim.builtin.which_key.mappings["N"] = { "<cmd>Telescope file_create<CR>", " Create new file" }
  lvim.builtin.which_key.mappings["o"] = { "<cmd>SymbolsOutline<cr>", " Symbol Outline" }
  lvim.builtin.which_key.mappings.L.name = " LunarVim"
  lvim.builtin.which_key.mappings.p.name = " Packer"
  lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", " Projects" }
  lvim.builtin.which_key.mappings["R"] = {
    name = " Replace",
    f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Current Buffer" },
    p = { "<cmd>lua require('spectre').open()<cr>", "Project" },
    w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
  }
  lvim.builtin.which_key.mappings.s.name = " Search"
  lvim.builtin.which_key.mappings["ss"] = {
    "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",
    "String",
  }
  lvim.builtin.which_key.mappings["T"] = {
    name = "飯Trouble",
    d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnosticss" },
    f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
    l = { "<cmd>Trouble loclist<cr>", "LocationList" },
    q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
    r = { "<cmd>Trouble lsp_references<cr>", "References" },
    t = { "<cmd>TodoLocList <cr>", "Todo" },
    w = { "<cmd>Trouble workspace_diagnostics<cr>", "Diagnosticss" },
  }
  lvim.builtin.which_key.mappings["w"] = { "<cmd>w!<CR>", " Save" }
  lvim.builtin.which_key.vmappings["g"] = {
    name = " Git",
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
  }
end

return M
