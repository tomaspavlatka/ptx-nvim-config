return {
  "nvim-telescope/telescope.nvim",

  tag = "0.1.5",

  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    }
  },
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
  keys = {
    {
      '<leader>ff',
      function() require("telescope.builtin").find_files() end,
      mode = { "n" }
    },
    {
      '<leader>pf',
      function() require('telescope.builtin').git_files() end,
      mode = { "n" }
    },
    {
      '<leader>pws',
      function()
        local word = vim.fn.expand("<cword>")
        require('telescope.builtin').grep_string({ search = word })
      end,
      mode = { "n" },
    },
    {
      '<leader>pWs',
      function()
        local word = vim.fn.expand("<cWORD>")
        require('telescope.builtin').grep_string({ search = word })
      end,
      mode = { "n" },
    },
    {
      '<leader>ps',
      function()
        require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") })
      end,
      mode = { "n" },
    },
  },
  opts = {
    defaults = {
      prompt_prefix = "🔍 ", -- Customize the prompt
      selection_caret = " ",
      path_display = { "truncate" }, -- Display file paths in truncated form
      sorting_strategy = "ascending",
    },
    pickers = {
      git_files = {
        theme = "dropdown",
      },
      find_files = {
        theme = "dropdown",
      }
    },
    extensions = {
      fzf = {
        fuzzy = true,                   -- Enable fuzzy search
        override_generic_sorter = true, -- Override the generic sorter
        override_file_sorter = true,    -- Override the file sorter
        case_mode = "smart_case",       -- Use "smart_case" | "ignore_case" | "respect_case"
      },
    }
  },
  config = function()
    require('telescope').load_extension('fzf')
  end,
}
