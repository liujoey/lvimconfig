local M = {}

M.config = function()
  local neoclip_req = { "kkharji/sqlite.lua", module = "sqlite" }
  if lvim.builtin.neoclip.enable_persistent_history == false then
    neoclip_req = {}
  end
  lvim.plugins = {
    { "sainnhe/edge" },
    -- Time based themes
    -- ================================================
    -- {
    --   "rose-pine/neovim",
    --   as = "rose-pine",
    --   config = function()
    --     require("user.theme").rose_pine()
    --     vim.cmd [[colorscheme rose-pine]]
    --   end,
    --   cond = function()
    --     local _time = os.date "*t"
    --     return (_time.hour >= 1 and _time.hour < 9) and lvim.builtin.time_based_themes
    --   end,
    -- },
    -- {
    --   "catppuccin/nvim",
    --   as = "catppuccin",
    --   run = ":CatppuccinCompile",
    --   config = function()
    --     require("user.theme").catppuccin()
    --     vim.cmd [[colorscheme catppuccin-mocha]]
    --   end,
    --   cond = function()
    --     local _time = os.date "*t"
    --     return (_time.hour >= 17 and _time.hour < 21) and lvim.builtin.time_based_themes
    --   end,
    -- },
    -- {
    --   "rebelot/kanagawa.nvim",
    --   config = function()
    --     require("user.theme").kanagawa()
    --     vim.cmd [[colorscheme kanagawa]]
    --   end,
    --   cond = function()
    --     local _time = os.date "*t"
    --     return ((_time.hour >= 21 and _time.hour < 24) or (_time.hour >= 0 and _time.hour < 1))
    --       and lvim.builtin.time_based_themes
    --   end,
    -- },
    {
      "ray-x/lsp_signature.nvim",
      config = function()
        require("user/lsp_signature").config()
      end,
      event = { "BufRead", "BufNew" },
    },
    {
      "folke/trouble.nvim",
      config = function()
        require("trouble").setup {
          auto_open = true,
          auto_close = true,
          padding = false,
          height = 10,
          use_diagnostic_signs = true,
        }
      end,
      cmd = "Trouble",
    },
    {
      "ggandor/lightspeed.nvim",
      config = function()
        require("user.lightspeed").config()
      end,
    },
    {
      "simrat39/symbols-outline.nvim",
      config = function()
        require("user.symbols_outline").config()
      end,
      event = "BufReadPost",
      disable = lvim.builtin.tag_provider ~= "symbols-outline",
    },
    {
      "tzachar/cmp-tabnine",
      run = "./install.sh",
      requires = "hrsh7th/nvim-cmp",
      config = function()
        local tabnine = require "cmp_tabnine.config"
        tabnine:setup {
          max_lines = 1000,
          max_num_results = 10,
          sort = true,
        }
      end,
      opt = true,
      event = "InsertEnter",
      disable = not lvim.builtin.tabnine.active,
    },
    {
      "kevinhwang91/nvim-bqf",
      config = function()
        require("user.bqf").config()
      end,
      event = "BufRead",
    },
    {
      "andymass/vim-matchup",
      event = "BufReadPost",
      config = function()
        vim.g.matchup_enabled = 1
        vim.g.matchup_surround_enabled = 1
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
      end,
    },
    {
      "windwp/nvim-spectre",
      event = "BufRead",
      config = function()
        require("user.spectre").config()
      end,
    },
    {
      "folke/persistence.nvim",
      event = "BufReadPre",
      module = "persistence",
      config = function()
        require("persistence").setup {
          dir = vim.fn.expand(get_cache_dir() .. "/sessions/"), -- directory where session files are saved
          options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
        }
      end,
      disable = not lvim.builtin.persistence.active,
    },
    { "mfussenegger/nvim-jdtls", ft = "java" },
    {
      "kristijanhusak/orgmode.nvim",
      keys = { "go", "gC" },
      ft = { "org" },
      config = function()
        require("user.orgmode").setup()
      end,
      disable = not lvim.builtin.orgmode.active,
    },
    {
      "AckslD/nvim-neoclip.lua",
      config = function()
        require("user.neoclip").config()
      end,
      opt = true,
      keys = "<leader>y",
      requires = neoclip_req,
      disable = not lvim.builtin.neoclip.active,
    },
    {
      "sindrets/diffview.nvim",
      opt = true,
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
      module = "diffview",
      keys = { "<leader>gd", "<leader>gh" },
      config = function()
        require("user.diffview").config()
      end,
      disable = not lvim.builtin.fancy_diff.active,
    },
    {
      "chipsenkbeil/distant.nvim",
      opt = true,
      run = { "DistantInstall" },
      cmd = { "DistantLaunch", "DistantRun" },
      config = function()
        require("distant").setup {
          ["*"] = vim.tbl_extend(
            "force",
            require("distant.settings").chip_default(),
            { mode = "ssh" } -- use SSH mode by default
          ),
        }
      end,
      disable = not lvim.builtin.remote_dev.active,
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    { "mtdl9/vim-log-highlighting", ft = { "text", "log" } },
    {
      "kevinhwang91/nvim-hlslens",
      config = function()
        require("user.hlslens").config()
      end,
      event = "BufReadPost",
      disable = not lvim.builtin.hlslens.active,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      after = "nvim-treesitter",
    },
    {
      "sidebar-nvim/sidebar.nvim",
      config = function()
        require("user.sidebar").config()
      end,
      -- event = "BufRead",
      disable = not lvim.builtin.sidebar.active,
    },
    {
      "j-hui/fidget.nvim",
      config = function()
        require("user.fidget_spinner").config()
      end,
      -- disable = lvim.builtin.noice.active,
    },
    {
      "hrsh7th/cmp-cmdline",
      disable = not lvim.builtin.fancy_wild_menu.active,
    },
    {
      "stevearc/dressing.nvim",
      config = function()
        require("user.dress").config()
      end,
      disable = not lvim.builtin.dressing.active,
      event = "BufWinEnter",
    },
    {
      "ThePrimeagen/refactoring.nvim",
      ft = { "typescript", "javascript", "lua", "c", "cpp", "go", "python", "java", "php" },
      event = "BufRead",
      config = function()
        require("refactoring").setup {}
      end,
      disable = not lvim.builtin.refactoring.active,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      requires = {
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("user.neotree").config()
      end,
    },
    {
        "max397574/better-escape.nvim",
        config = function()
            require("better_escape").setup {
                mapping = {"jk"},
                timeout = vim.o.timeoutlen,
                clear_empty_lines = false,
                keys = "<ESC>"
            }
        end,
    },
    { "tpope/vim-repeat" },
    { "tpope/vim-unimpaired" },
    { "tpope/vim-rsi" },
    { "tpope/vim-surround" },
    -- TODO: set this up when https://github.com/neovim/neovim/pull/20130 is merged
    -- {
    --   "lvimuser/lsp-inlayhints.nvim",
    --   branch = "anticonceal",
    --   config = function()
    --     require("lsp-inlayhints").setup()
    --   end,
    -- },
  }
end

return M
