--[[
* Mini.nvim 插件配置文件
* 
* 这是一个现代化的 Neovim 插件集合，提供了多种实用功能
* 包含：文本对象、环绕操作、自动配对、状态栏等
* 
* 作者: pengjiecheng
* 最后更新: 2024
--]]

return {
  -- Mini.pairs - 自动配对插件
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- 当下一个字符是以下字符之一时跳过自动配对
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- 当光标在这些 treesitter 节点内时跳过自动配对
      skip_ts = { "string" },
      -- 当下一个字符是闭合配对且闭合配对多于开放配对时跳过自动配对
      skip_unbalanced = true,
      -- 更好地处理 markdown 代码块
      markdown = true,
    },
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },

  -- Mini.ai - 增强文本对象
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    config = function()
      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- 代码块
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ -- 函数
            a = "@function.outer",
            i = "@function.inner",
          }),
          c = ai.gen_spec.treesitter({ -- 类
            a = "@class.outer",
            i = "@class.inner",
          }),
          t = { -- HTML/XML 标签
            "<([%p%w]-)%f[^<%w][^<>]->.-</%1>",
            "^<.->().*()</[^/]->$",
          },
          d = { "%f[%d]%d+" }, -- 数字
          e = { -- 带大小写的单词
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(), -- 函数调用
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- 不带点的函数名
        },
      })
    end,
  },

  -- Mini.surround - 环绕操作
  {
    "echasnovski/mini.surround",
    keys = {
      { "gsa", desc = "Add surrounding", mode = { "n", "v" } },
      { "gsd", desc = "Delete surrounding" },
      { "gsf", desc = "Find right surrounding" },
      { "gsF", desc = "Find left surrounding" },
      { "gsh", desc = "Highlight surrounding" },
      { "gsr", desc = "Replace surrounding" },
      { "gsn", desc = "Update `MiniSurround.config.n_lines`" },
    },
    opts = {
      mappings = {
        add = "gsa", -- 在普通和可视模式下添加环绕
        delete = "gsd", -- 删除环绕
        find = "gsf", -- 查找环绕（向右）
        find_left = "gsF", -- 查找环绕（向左）
        highlight = "gsh", -- 高亮环绕
        replace = "gsr", -- 替换环绕
        update_n_lines = "gsn", -- 更新 `n_lines`
      },
    },
  },
}
