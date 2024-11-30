return {
  "nvim-telescope/telescope.nvim",

  tag = "0.1.5",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "smartpde/telescope-recent-files",
  },

  config = function()
    require('telescope').setup({
      defaults = {
        prompt_prefix = "🔍 ", -- Customize the prompt
        selection_caret = " ",
        path_display = { "truncate" }, -- Display file paths in truncated form
        sorting_strategy = "ascending",
      },
      extensions = {
        recent_files = {}
      },
      pickers = {
        git_files = {
          theme = "dropdown",
        },
        find_files = {
          theme = "dropdown",
        }
      }
    })

    local b = require('telescope.builtin')
    vim.keymap.set('n', '<leader>pf', b.git_files, {})
    vim.keymap.set('n', '<leader>ff', b.find_files, {})
    vim.keymap.set('n', '<leader>lf', ':lua require("telescope").extensions.recent_files.pick()<cr>', {})
    vim.keymap.set('n', '<leader>pws', function()
      local word = vim.fn.expand("<cword>")
      b.grep_string({ search = word })
    end)
    vim.keymap.set('n', '<leader>pWs', function()
      local word = vim.fn.expand("<cWORD>")
      b.grep_string({ search = word })
    end)
    vim.keymap.set('n', '<leader>ps', function()
      b.grep_string({ search = vim.fn.input("Grep > ") })
    end)
  end
}
