--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/

  And then you can explore or search through `:help lua-guide`


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Linter configuration
    "rshkarin/mason-nvim-lint",
    dependencies = {
      "mfussenegger/nvim-lint",
    }
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '|' },
        change = { text = '|' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      numhl = true,
      on_attach = function(bufnr)
        vim.keymap.set(
          'n', '<leader>gph',
          require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious [H]unk' }
        )
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>rh', require('gitsigns').reset_hunk, { buffer = bufnr, desc = '[R]eset [H]unk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  {
    'doums/darcula',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'darcula'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'ayu_mirage',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { '%f' },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      }
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = "ibl",
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  -- Perform telescope functions in selected directories
  { "princejoogie/dir-telescope.nvim", },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects', },
    build = ':TSUpdate',
  },

  {
    'nvim-neotest/neotest',
    lazy = true,
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',
      'olimorris/neotest-rspec',
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rspec")({
            rspec_cmd = function()
              return vim.tbl_flatten({
                "bundle",
                "exec",
                "spring",
                "rspec",
              })
            end,
          }),
        },
      })
    end
  },

  -- Interact with the file system through a vim buffer.
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Auto close brackets, parenthesis, quotes, etc
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equivalent to setup({}) function
  },

  {
    'windwp/nvim-ts-autotag',
    opts = {}
  },

  -- Preview markdown files in a browser
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- Git worktree interactions
  {
    "ThePrimeagen/git-worktree.nvim"
  },

  -- Refactor code to variable, method, etc.
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup()
    end,
  },

  {
    "tpope/vim-projectionist"
  },

  -- Neorg: note taking plugin
  {
    "nvim-neorg/neorg",
    dependencies = { "luarocks.nvim" },
    lazy = false,      -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "8.9.0", -- Pin Neorg to the latest stable release
    config = true,
  },

  -- Luarocks: Neorg dependency
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  },

  -- Noice: Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },

  -- Harpoon: Quick switch to a list of files
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  -- Winshift: Window rearranger
  { 'sindrets/winshift.nvim' },

  -- nvim-window-picker: Select window
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require 'window-picker'.setup({
        hint = 'floating-big-letter',
        filter_rules = {
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { 'NvimTree', 'neo-tree', 'notify' },
            -- if the buffer type is one of following, the window will be ignored
            buftype = {},
          }
        }
      })
    end,
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--
-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Set the minimum width of the line numbers area
vim.o.numberwidth = 2

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Show the name of the edited file as the title for Vim
vim.o.title = true

-- Set folding to be based on the indentation
vim.o.foldmethod = "indent"

-- Set how wide the fold column is
vim.o.foldcolumn = "0"

-- Max line length marker
vim.o.colorcolumn = "120"

-- Enable spell check
vim.o.spell = true

-- Disable mouse
vim.o.mouse = ""

-- Set the character for lines the buffer that have no content from a file
-- vim.opt.fillchars = { eob = " " }
vim.o.fillchars = [[eob: ,foldopen:,foldclose:]]

-- Display diagnostics
vim.diagnostic.enable = true
vim.diagnostic.config({
  virtual_text = true,
})

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

require('ibl').setup({
  indent = {
    char = '┊',
  },
})

-- [[ Configure Oil ]]
require("oil").setup()

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      -- height = function(_, max_columns)
      --local percentage = 0.75
      --local max = 50
      -- return math.min(math.floor(percentage * max_columns), max)
      --end
      horizontal = {
        width = 0.65,
        height = 0.55,
        anchor = 'N'
      }
    },
    file_ignore_patterns = {
      ".git",
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

require("telescope").load_extension("dir")

-- Git worktree setup
require("git-worktree").setup()
require("telescope").load_extension("git_worktree")

-- Harpoon setup
local harpoon = require("harpoon")
harpoon:setup()

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find,
  { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gs', require('telescope.builtin').git_status, { desc = 'Search [G]it [S]tatus' })
vim.keymap.set('n', '<leader>gb', function() vim.cmd('Git blame') end, { desc = '[G]it [B]lame' })
vim.keymap.set('n', '<leader>gpu', function() vim.cmd('!git push --set-upstream origin $(git branch --show-current)') end,
  { desc = '[G]it [P][u]sh' })
vim.keymap.set('n', '<leader>gpl', function() vim.cmd('Git pull') end, { desc = '[G]it [P]u[l]l' })
vim.keymap.set('n', '<leader>gc', function() vim.cmd('Git commit -a') end, { desc = '[G]it [C]ommit' })
vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = '[H]arpoon [A]dd' })
vim.keymap.set("n", "<leader>hr", function() harpoon:list():remove() end, { desc = '[H]arpoon [R]emove' })
vim.keymap.set("n", "<leader>hc", function() harpoon:list():clear() end, { desc = '[H]arpoon [C]lear' })
vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
  { desc = '[H]arpoon [L]ist' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch existing [b]uffers' })
vim.keymap.set("n", "<leader>sh", function() toggle_telescope(harpoon:list()) end, { desc = "[S]earch [H]arpoon" })
vim.keymap.set(
  'n', '<leader><space>',
  function() require('telescope.builtin').find_files({ hidden = true }) end,
  { desc = '[ ] Search Files' }
)
vim.keymap.set('n', '<leader>sif', require("telescope").extensions.dir.find_files,
  { desc = '[S]earch [i]n directory for [f]iles' })
vim.keymap.set('n', '<leader>sig', require("telescope").extensions.dir.live_grep,
  { desc = '[S]earch [i]n directory [g]rep' })
vim.keymap.set('n', '<leader>se', require('telescope.builtin').help_tags, { desc = '[S]earch H[e]lp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set(
  'n', '<C-w>f',
  function()
    vim.api.nvim_win_set_height(0, 100000)
    vim.api.nvim_win_set_width(0, 100000)
  end,
  { desc = '[F]ull width and height window' }
)

-- Git worktree telescope keymaps
vim.keymap.set(
  'n', '<leader>wl',
  require('telescope').extensions.git_worktree.git_worktrees,
  { desc = 'Git [W]orktree [L]ist' }
)

vim.keymap.set(
  'n', '<leader>wc',
  require('telescope').extensions.git_worktree.create_git_worktree,
  { desc = 'Git [W]orktree [C]reate' }
)

-- Refactoring keymaps
require("telescope").load_extension("refactoring")

vim.keymap.set(
  { "n", "x" },
  "<leader>ro",
  function() require('telescope').extensions.refactoring.refactors() end,
  { desc = '[R]efactoring [o]ptions' }
)

vim.keymap.set('n', '<C-W><C-M>', function() vim.cmd('WinShift') end, { desc = 'Winshift' })
vim.keymap.set(
  'n', '<leader>;',
  function()
    local picked_window_id = require('window-picker').pick_window() or vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(picked_window_id)
  end,
  { desc = 'Pick window' }
)

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'bash',
    'embedded_template',
    'html',
    'gdscript',
    'java',
    'javascript',
    'kotlin',
    'lua',
    'markdown',
    'markdown_inline',
    'norg',
    'python',
    'regex',
    'ruby',
    'scss',
    'swift',
    'terraform',
    'typescript',
    'vimdoc',
    'vim',
    'vue',
    'xml',
  },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Test keymaps
vim.keymap.set('n', '<leader>tn', function() require('neotest').run.run() end,
  { desc = 'Run [T]est [n]earest the crusor' })

vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand("%")) end,
  { desc = '[T]est current [f]ile' })

vim.keymap.set('n', '<leader>ts', function() require('neotest').run.stop() end,
  { desc = '[T]est [s]top. Stop curently running test' })

vim.keymap.set('n', '<leader>tp', function() require('neotest').output_panel.toggle() end,
  { desc = 'Toggle [T]est output [p]anel' })

vim.keymap.set('n', '<leader>tcp', function() require('neotest').output_panel.clear() end,
  { desc = '[T]est [c]lear output [p]anel' })

vim.keymap.set('n', '<leader>tw', function() require('neotest').output.open() end,
  { desc = 'Toggle [T]est output [w]indow' })

-- [[ Configure LSP ]]
-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- cssls = {},
  -- emmet_ls = {},
  -- solargraph = {},
  kotlin_language_server = {},
  pylsp = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  -- ts_ls = {},
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

-- Setup linters
require('lint').linters_by_ft = {
  gdscript = { "gdlint" },
}

require("mason-nvim-lint").setup({
  ensure_installed = { "gdscript" },
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- Set up Godot LSP
-- paths to check for project.godot file
local paths_to_check = { '/', '/../' }
local is_godot_project = false
local cwd = vim.fn.getcwd()

-- iterate over paths and check
for _, value in pairs(paths_to_check) do
  if vim.uv.fs_stat(cwd .. value .. 'project.godot') then
    is_godot_project = true
    break
  end
end

local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  nmap('<leader>fb', function() vim.lsp.buf.format() end, '[F]ormat current [b]uffer with LSP')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

vim.lsp.config('*', {
  on_attach = on_attach
})

-- godot lsp
if is_godot_project then
  vim.lsp.enable('gdscript')
end

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  experimental = {
    ghost_text = true
  }
}

-- Configure projectionist
vim.g.projectionist_heuristics = {
  ["*.rb"] = {
    alternate = "spec/{}_spec.rb",
    type = "source",
  },

  ["spec/*.rb"] = {
    alternate = "{}.rb",
    type = "test"
  },
}

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  views = {
    cmdline_popup = {
      border = {
        style = "none",
        padding = { 1, 2 },
      },
      filter_options = {},
      win_options = {
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      },
    },
  },
  ---@type NoicePresets
  presets = {
    command_palette = true,       -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false,       -- add a border to hover docs and signature help
  },
})

require("notify").setup({
  background_colour = "#000000"
})

-- Set up Winshift
require("winshift").setup({
  highlight_moving_win = true, -- Highlight the window being moved
  focused_hl_group = "Visual", -- The highlight group used for the moving window
  moving_win_options = {
    -- These are local options applied to the moving window while it's
    -- being moved. They are unset when you leave Win-Move mode.
    wrap = false,
    cursorline = false,
    cursorcolumn = false,
    colorcolumn = "",
  },
  keymaps = {
    disable_defaults = false, -- Disable the default keymaps
    win_move_mode = {
      ["h"] = "left",
      ["j"] = "down",
      ["k"] = "up",
      ["l"] = "right",
      ["H"] = "far_left",
      ["J"] = "far_down",
      ["K"] = "far_up",
      ["L"] = "far_right",
      ["<left>"] = "left",
      ["<down>"] = "down",
      ["<up>"] = "up",
      ["<right>"] = "right",
      ["<S-left>"] = "far_left",
      ["<S-down>"] = "far_down",
      ["<S-up>"] = "far_up",
      ["<S-right>"] = "far_right",
    },
  },
  ---A function that should prompt the user to select a window.
  ---
  ---The window picker is used to select a window while swapping windows with
  ---`:WinShift swap`.
  ---@return integer? winid # Either the selected window ID, or `nil` to
  ---   indicate that the user cancelled / gave an invalid selection.
  window_picker = function()
    return require("winshift.lib").pick_window({
      -- A string of chars used as identifiers by the window picker.
      picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
      filter_rules = {
        -- This table allows you to indicate to the window picker that a window
        -- should be ignored if its buffer matches any of the following criteria.
        cur_win = true, -- Filter out the current window
        floats = true,  -- Filter out floating windows
        filetype = {},  -- List of ignored file types
        buftype = {},   -- List of ignored buftypes
        bufname = {},   -- List of vim regex patterns matching ignored buffer names
      },
      ---A function used to filter the list of selectable windows.
      ---@param winids integer[] # The list of selectable window IDs.
      ---@return integer[] filtered # The filtered list of window IDs.
      filter_func = nil,
    })
  end,
})

-- Set background to be transparent. I believe this must be run after setting the color scheme.
vim.api.nvim_set_hl(0, "Normal", { ctermbg = 'NONE' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
