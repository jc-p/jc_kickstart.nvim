--[[
* Flash.nvim 插件配置文件
* 
* Flash 是一个快速导航插件，提供了增强的搜索和跳转功能
* 支持字符级精确跳转、搜索增强、Treesitter 集成等
* 
* 作者: pengjiecheng
* 最后更新: 2024
--]]

return {
  -- Flash.nvim - 快速导航和跳转插件
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      -- 标签配置
      labels = "asdfghjklqwertyuiopzxcvbnm",
      -- 搜索配置
      search = {
        -- 搜索模式：search, fuzzy, exact
        mode = "exact",
        -- 增量搜索
        incremental = false,
        -- 排除的文件类型
        exclude = {
          "notify",
          "cmp_menu",
          "noice",
          "flash_prompt",
          function(win)
            -- 排除非正常窗口
            return not vim.api.nvim_win_get_config(win).focusable
          end,
        },
        -- 自动跳转到唯一匹配
        auto_jump = false,
        -- 换行搜索
        wrap = true,
        -- 前向搜索
        forward = true,
        -- 多窗口搜索
        multi_window = true,
      },
      -- 跳转配置
      jump = {
        -- 跳转后自动进入插入模式
        jumplist = true,
        -- 跳转位置：start, end
        pos = "start",
        -- 历史记录
        history = false,
        -- 寄存器
        register = false,
        -- 不自动跳转
        nohlsearch = false,
        -- 自动跳转到唯一匹配
        autojump = false,
      },
      -- 标签配置
      label = {
        -- 标签位置：before, after, inline
        before = true,
        after = true,
        -- 标签样式
        style = "overlay", -- overlay, inline, eol
        -- 重用标签
        reuse = "lowercase",
        -- 距离权重
        distance = true,
        -- 最小模式长度
        min_pattern_length = 0,
        -- 彩虹标签
        rainbow = {
          enabled = false,
          shade = 5,
        },
      },
      -- 高亮配置
      highlight = {
        -- 背景高亮
        backdrop = true,
        -- 匹配高亮
        matches = true,
      },
      -- 动作配置
      action = nil,
      -- 模式配置
      modes = {
        -- 搜索模式
        search = {
          enabled = true,
        },
        -- 字符模式
        char = {
          enabled = true,
          -- 配置 f, F, t, T 键
          config = function(opts)
            -- 自动隐藏在操作符待定模式下
            opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")
            
            -- 禁用在 cmdline 中使用
            opts.search.exclude = opts.search.exclude or {}
            table.insert(opts.search.exclude, function(win)
              return vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "cmdline"
            end)
          end,
          -- 字符跳转键位
          keys = { "f", "F", "t", "T", ";", "," },
          -- 搜索换行
          search = { wrap = false },
          -- 高亮配置
          highlight = { backdrop = true },
          -- 跳转配置
          jump = { register = false },
        },
        -- 行模式
        line = {
          enabled = true,
          -- 标签配置
          label = { after = { 0, 0 } },
          -- 搜索配置
          search = {
            mode = "search",
            max_length = 0,
          },
          -- 高亮配置
          highlight = { backdrop = false, matches = false },
          -- 跳转配置
          jump = { history = true, register = true, nohlsearch = true },
        },
        -- Treesitter 模式
        treesitter = {
          enabled = true,
          -- 标签配置
          labels = "abcdefghijklmnopqrstuvwxyz",
          -- 跳转配置
          jump = { pos = "range" },
          -- 搜索配置
          search = { incremental = false },
          -- 标签配置
          label = { before = true, after = true, style = "inline" },
          -- 高亮配置
          highlight = {
            backdrop = false,
            matches = false,
          },
        },
        -- 远程模式
        remote = {
          enabled = true,
          -- 远程操作
          remote_op = { restore = true, motion = true },
        },
      },
      -- 提示配置
      prompt = {
        enabled = true,
        prefix = { { "⚡", "FlashPromptIcon" } },
        win_config = {
          relative = "editor",
          width = 1, -- 当 <=1 时，将被视为窗口宽度的百分比
          height = 1,
          row = -1, -- 当负数时，从底部开始计算
          col = 0,
          zindex = 1000,
        },
      },
      -- 远程 Flash 配置
      remote_op = {
        -- 恢复窗口视图
        restore = true,
        -- 运动
        motion = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
    config = function(_, opts)
      require("flash").setup(opts)
      
      -- 与 Snacks picker 集成
      local function setup_snacks_integration()
        local ok, snacks = pcall(require, "snacks")
        if not ok then return end
        
        -- 为 Snacks picker 添加 flash 支持
        if snacks.picker then
          snacks.picker.config = vim.tbl_deep_extend("force", snacks.picker.config or {}, {
            win = {
              input = {
                keys = {
                  ["<a-s>"] = { "flash", mode = { "n", "i" } },
                  ["s"] = { "flash" },
                },
              },
            },
            actions = {
              flash = function(picker)
                require("flash").jump({
                  pattern = "^",
                  label = { after = { 0, 0 } },
                  search = {
                    mode = "search",
                    exclude = {
                      function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                      end,
                    },
                  },
                  action = function(match)
                    local idx = picker.list:row2idx(match.pos[1])
                    picker.list:_move(idx, true, true)
                  end,
                })
              end,
            },
          })
        end
      end
      
      -- 延迟设置 Snacks 集成
      vim.defer_fn(setup_snacks_integration, 100)
    end,
  },
}

