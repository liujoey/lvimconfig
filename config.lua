--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- Neovim
-- ==============================================
lvim.format_on_save = false
lvim.leader = "space"
lvim.log.level = "warn"
lvim.colorscheme = "edge"
lvim.debug = false
vim.lsp.set_log_level "error"
require("user.neovim").config()
lvim.lsp.document_highlight = false
lvim.lsp.code_lens_refresh = true
lvim.lsp.automatic_servers_installation = false

-- Customization
-- ==============================================
lvim.builtin.illuminate.active = false
lvim.builtin.terminal.active = false
lvim.builtin.indentlines.active = false
lvim.builtin.lir.active = false
lvim.builtin.tabnine = { active = true }
lvim.builtin.lastplace = { active = true } -- remember where I left
lvim.builtin.persistence = { active = true } -- change to false if you don't want persistence
lvim.builtin.orgmode = { active = true }
lvim.builtin.dap.active = true
lvim.builtin.nvimtree.active = false
lvim.builtin.fancy_wild_menu = { active = true } -- enable/disable cmp-cmdline
lvim.builtin.fancy_diff = { active = true } -- enable/disable fancier git diff
lvim.builtin.lua_dev = { active = true }
lvim.builtin.neoclip = { active = true, enable_persistent_history = false }
lvim.builtin.remote_dev = { active = true } -- enable/disable remote development
lvim.builtin.hlslens = { active = true } -- enable/disable hlslens
lvim.builtin.sidebar = { active = true } -- enable/disable sidebar
lvim.builtin.tag_provider = "symbols-outline"
lvim.builtin.dressing = { active = true } -- enable to override vim.ui.input and vim.ui.select with telescope
lvim.builtin.refactoring = { active = true } -- enable to use refactoring.nvim code_actions

lvim.builtin.go_programming = { active = false } -- gopher.nvim + nvim-dap-go
lvim.builtin.python_programming = { active = false } -- swenv.nvim + nvim-dap-python
lvim.builtin.web_programming = { active = false } -- typescript.nvim + package-info.nvim
lvim.builtin.rust_programming = { active = false } -- rust_tools.nvim + crates.nvim

-- Override Lunarvim defaults
-- ==============================================
require("user.builtin").config()

-- Debugging
-- ==============================================
require("user.dap").config()

-- Language Specific
-- ==============================================
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {"jdtls"})
-- require("user.null_ls").config()

-- Additional Plugins
-- ==============================================
require("user.plugins").config()

-- Autocommands
-- ==============================================
-- require("user.autocommands").config()

-- Additional Keybindings
-- ==============================================
require("user.keybindings").config()
