require("czn")

vim.cmd("set number")
vim.cmd("set relativenumber")

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local uv = vim.uv or vim.loop

-- Auto-install lazy.nvim if not present
if not uv.fs_stat(lazypath) then
  print('Installing lazy.nvim....')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
  print('Done.')
end

vim.opt.rtp:prepend(lazypath)

local lazy = require('lazy')

lazy.setup({
  spec = {
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v3.x',
      lazy = true,
      config = false,
    },
    {
      'neovim/nvim-lspconfig',
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate"
    },
    {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
      'nvim-telescope/telescope.nvim', tag = '0.1.6',
-- or                              , branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { 'mbbill/undotree' },
    { 'ThePrimeagen/git-worktree.nvim' },
    { 'nvim-lualine/lualine.nvim' },
    { 'nvim-lua/popup.nvim' },
    { 'nvim-telescope/telescope-fzy-native.nvim' },
    { 'christoomey/vim-tmux-navigator' },
    { 'NeogitOrg/neogit', config = true },
    {
        "kdheepak/lazygit.nvim",
    	cmd = {
    		"LazyGit",
    		"LazyGitConfig",
    		"LazyGitCurrentFile",
    		"LazyGitFilter",
    		"LazyGitFilterCurrentFile",
    	},
    },
    { 'alexxGmZ/e-ink.nvim' },
    { 'catppuccin/nvim' },
    {
      'akinsho/flutter-tools.nvim',
      lazy = false,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
      },
    },
    {
      'saghen/blink.cmp',
      version = '1.*',
      dependencies = { 'rafamadriz/friendly-snippets' },
      build = 'cargo build --release',
      opts = {
        fuzzy = { implementation = "prefer_rust" },
        keymap = { preset = 'super-tab' },
        appearance = { nerd_font_variant = 'mono' },
        completion = { documentation = { auto_show = false } },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        signature = { enabled = true },
      },
    },
    {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        require("lsp_lines").setup()
          vim.diagnostic.config({
            virtual_text = false, -- lsp_lines replaces inline virtual text
          })
      end,
    },
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
        require("toggleterm").setup({
          direction = "float",
          float_opts = {
            border = "curved",
            title_pos = "left"
          }
        })
      end,
    },
    {
      "nyoom-engineering/oxocarbon.nvim"
    },
    {
      'kkrampis/codex.nvim',
      lazy = true,
      cmd = { 'Codex', 'CodexToggle' }, -- Optional: Load only on command execution
      keys = {
        {
          '<leader>cc', -- Change this to your preferred keybinding
          function() require('codex').toggle() end,
          desc = 'Toggle Codex popup or side-panel',
          mode = { 'n', 't' }
        },
      },
      opts = {
        keymaps = {
          toggle = nil, -- Keybind to toggle Codex window (Disabled by default, watch out for conflicts)
          quit = '<C-q>', -- Keybind to close the Codex window (default: Ctrl + q)
        },         -- Disable internal default keymap (<leader>cc -> :CodexToggle)
        border      = 'rounded',  -- Options: 'single', 'double', or 'rounded'
        width       = 0.8,        -- Width of the floating window (0.0 to 1.0)
        height      = 0.8,        -- Height of the floating window (0.0 to 1.0)
        model       = nil,        -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
        autoinstall = true,       -- Automatically install the Codex CLI if not found
        panel       = false,      -- Open Codex in a side-panel (vertical split) instead of floating window
        use_buffer  = false,      -- Capture Codex stdout into a normal buffer instead of a terminal buffer
      },
    } 
  },
  { import = "plugins" }
}) -- neovim/lspconfig

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    local name = vim.api.nvim_buf_get_name(0)
    if name:lower():match("codex") then
      vim.keymap.set("t", "<Up>", "<Up>", { buffer = true })
      vim.keymap.set("t", "<Down>", "<Down>", { buffer = true })
    end
  end,
})


vim.diagnostic.config({
  virtual_text = false,
})

vim.o.updatetime = 250

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
  end,
})

vim.keymap.set("n", "<leader>pn", ":ToggleTerm<CR>")

local capabilities = require('blink.cmp').get_lsp_capabilities()
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

--- if you want to know more about lsp-zero and mason.nvim
--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { "tsserver", "eslint", "pyright", "lua_ls", "rust_analyzer", "html", "gopls" },
    handlers = {
      function(server_name)
        require('lspconfig')[server_name].setup({
          capabilities = capabilities,
        })
      end,
    },
})

lsp_zero.setup({})

vim.o.tabstop = 2 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2 -- Number of spaces inserted when indenting


