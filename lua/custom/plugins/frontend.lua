-- 前端开发插件配置
return {
  -- TypeScript 工具
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {
      on_attach = function(client, bufnr)
        -- 禁用格式化，使用 prettier
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = {},
        tsserver_path = nil,
        tsserver_plugins = {},
        tsserver_max_memory = "auto",
        tsserver_format_options = {},
        tsserver_file_preferences = {},
        tsserver_locale = "en",
        complete_function_calls = false,
        include_completions_with_insert_text = true,
        code_lens = "off",
        disable_member_code_lens = true,
        jsx_close_tag = {
          enable = false,
          filetypes = { "javascriptreact", "typescriptreact" },
        },
      },
    },
  },

  -- Vue 支持
  {
    "posva/vim-vue",
    ft = "vue",
    config = function()
      vim.g.vue_pre_processors = { "pug", "scss" }
    end,
  },

  -- React 支持
  {
    "maxmellon/vim-jsx-pretty",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      vim.g.vim_jsx_pretty_colorful_config = 1
    end,
  },

  -- CSS 颜色预览
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "scss", "sass", "html", "javascript", "typescript", "vue" },
    opts = {
      "css",
      "scss",
      "sass",
      "html",
      "javascript",
      "typescript",
      "vue",
      html = { mode = "foreground" },
    },
  },

  -- Tailwind CSS 支持
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    ft = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
  },

  -- 自动重命名标签
  {
    "AndrewRadev/tagalong.vim",
    ft = { "html", "xml", "jsx", "tsx", "vue", "svelte", "php", "erb" },
    config = function()
      vim.g.tagalong_additional_filetypes = { "jsx", "tsx" }
    end,
  },



}