--[[
* Neovim 启动性能优化配置
* 
* 提供 Neovim 启动和运行时的性能优化设置
* 作者: pengjiecheng
* 最后更新: 2023
--]] return {
    -- 文件类型检测优化
    {
        "nathom/filetype.nvim",
        priority = 1000, -- 最高优先级
        config = function()
            require("filetype").setup({
                overrides = {
                    extensions = {
                        -- 常见文件类型快速检测
                        lua = "lua",
                        js = "javascript",
                        ts = "typescript",
                        jsx = "javascriptreact",
                        tsx = "typescriptreact",
                        vue = "vue",
                        json = "json",
                        md = "markdown"
                    }
                }
            })
        end
    }, -- 会话管理优化
    {
        "rmagatti/auto-session",
        lazy = false, -- 需要在启动时加载
        opts = {
            log_level = "error", -- 仅记录错误
            auto_session_suppress_dirs = {"~/", "/"}, -- 不在根目录保存会话
            auto_session_use_git_branch = false, -- 不使用 git 分支
            auto_session_enable_last_session = false, -- 不自动加载最后的会话
            auto_session_enabled = true, -- 启用自动会话
            auto_save_enabled = true, -- 启用自动保存
            auto_restore_enabled = true, -- 启用自动恢复
            auto_session_create_enabled = false, -- 不自动创建会话
            session_lens = {
                load_on_setup = false, -- 不在设置时加载
                theme_conf = {border = true},
                previewer = false -- 禁用预览器
            }
        }
    }, -- 通知管理优化
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy", -- 延迟加载
        opts = {
            timeout = 2000, -- 减少通知超时时间
            max_height = function()
                return math.floor(vim.o.lines * 0.5) -- 减少最大高度
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.5) -- 减少最大宽度
            end,
            on_open = function(win)
                vim.api.nvim_win_set_config(win, {zindex = 100})
            end,
            background_colour = "#000000", -- 使用简单的背景色
            fps = 20, -- 进一步降低帧率
            render = "minimal", -- 使用最小渲染
            stages = "static", -- 使用静态显示，避免动画开销
            level = vim.log.levels.WARN -- 只显示警告及以上级别
        }
    }

    -- 性能监控和优化 (暂时禁用，避免网络问题)
    -- {
    --   "dstein64/nvim-startuptime",
    --   cmd = "StartupTime",
    --   config = function()
    --     vim.g.startuptime_tries = 3 -- 减少测试次数
    --     vim.g.startuptime_exe_args = { "+let g:auto_session_enabled = 0" }
    --   end,
    -- },
}
