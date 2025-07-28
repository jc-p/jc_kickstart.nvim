--[[
* lazy.nvim 性能优化配置
* 
* 提供 lazy.nvim 插件管理器的性能优化设置
* 作者: pengjiecheng
* 最后更新: 2023
--]]

return {
  -- lazy.nvim 性能优化
  {
    "folke/lazy.nvim",
    -- 优化 lazy.nvim 自身性能
    init = function()
      -- 减少插件加载时的 UI 更新频率
      vim.g.lazy_ui_throttle = 100
      
      -- 设置插件加载优先级
      vim.g.lazy_load_plugins_priority = {
        -- 核心插件最高优先级
        ["nvim-treesitter"] = 100,
        ["plenary.nvim"] = 90,
        -- Git 插件较低优先级
        ["lazygit.nvim"] = 50,
        ["diffview.nvim"] = 40,
      }
    end,
    opts = {
      -- 性能相关设置
      performance = {
        -- 启用重置包路径缓存
        reset_packpath = true,
        
        -- 缓存设置
        cache = {
          enabled = true,
          path = vim.fn.stdpath("cache") .. "/lazy/cache",
          -- 增加缓存过期时间（小时）
          ttl = 5 * 60 * 60, -- 5 小时
        },
        
        -- 减少重新编译的频率
        rtp = {
          reset = false,
          -- 禁用一些运行时目录以提高性能
          disabled_plugins = {
            "gzip",
            "matchit",
            "matchparen",
            "netrwPlugin",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
          },
        },
      },
      
      -- 并行安装插件
      concurrency = 10, -- 同时安装的最大插件数
      
      -- 减少检查更新的频率
      checker = {
        enabled = true,
        frequency = 86400, -- 检查更新的频率（秒），设置为一天
        notify = false, -- 禁用更新通知
      },
      
      -- 更改默认超时时间
      install = {
        missing = true,
        colorscheme = { "habamax" }, -- 使用轻量级的配色方案
      },
      
      -- 优化 UI
      ui = {
        size = { width = 0.7, height = 0.7 }, -- 减小 UI 窗口大小
        throttle = 100, -- 减少 UI 更新频率
        custom_keys = {}, -- 禁用自定义按键以减少初始化时间
        icons = {
          loaded = "✓",
          not_loaded = "✗",
        },
      },
      
      -- 减少启动时间
      defaults = {
        lazy = true, -- 默认懒加载所有插件
        version = "*", -- 使用最新稳定版本
      },
      
      -- 减少日志记录
      profiling = {
        loader = false,
        require = false,
      },
    },
  },
}