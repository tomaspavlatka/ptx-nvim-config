return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp"
    }
  },

  config = function()
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities())

    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          }
        end,
      }
    })

    -- I could not manage to load the snippets from another file, so as ugly as it might be
    -- they all will leave here for the time being
    local ls = require("luasnip")
    local lss = ls.snippet
    local lst = ls.text_node
    local lsi = ls.insert_node
    local lsrep = require("luasnip.extras").rep

    ls.add_snippets("typescript", {
      lss("tecommand", {
        lst({ "import { ContextAwareException } from '@common/exceptions/context-aware.exception';" }),
        lst({ "", "import { Injectable } from '@nestjs/common';" }),
        lst({ "", "import { Either } from '@common/either';" }),
        lst({ "", "", "@Injectable()", "export class " }),
        lsi(1, "Command"),
        lst({ " {", "  constructor() {}" }),
        lst({ "", "  async execute(): Promise<Either<ContextAwareException, >> {", "  }" }),
        lst({ "", "}" }),
      }),

      lss("tedto", {
        lst({ "import { plainToInstance } from 'class-transformer';", "", "export class " }),
        lsi(1, "Dto"),
        lst({ " {", "  static create(data: Required<" }),
        lsrep(1),
        lst({ ">) {", "    return plainToInstance(" }),
        lsrep(1),
        lst({ ", data);" }),
        lst({ "", "  }", "}" }),
      }),

      lss("tenotimplementedexception", {
        lst({ "return Either.left(NotImplementedException.create());" }),
      }),
    });

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-i>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-u>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),

      sources = cmp.config.sources({
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
      })
    })


    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })

    local opts = { buffer = false }
    vim.keymap.set('n', '<leader>gr', '<cmd>Telescope lsp_references<cr>', opts)
    vim.keymap.set('n', '<leader>gd', '<cmd>Telescope lsp_definitions<cr>', opts)
    vim.keymap.set('n', '<leader>gi', '<cmd>Telescope lsp_implementations<cr>', opts)
    vim.keymap.set('n', '<leader>dl', '<cmd>Telescope diagnostics<cr>')
  end
}
