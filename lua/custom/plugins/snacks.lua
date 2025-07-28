--[[
* Snacks.nvim 配置文件
* 
* 这是一个现代化的 Neovim 插件集合，提供了多种实用功能
* 为了避免插件冲突，以下插件已被禁用或配置为与 snacks.nvim 兼容：
* 
* 冲突插件处理：
* 1. alpha-nvim (dashboard) -> 已禁用，使用 snacks.dashboard
* 2. neo-tree (explorer) -> 已禁用，使用 snacks.explorer  
* 3. indent-blankline (indent) -> 已禁用，使用 snacks.indent + snacks.scope
* 4. noice.nvim (notifier) -> 已禁用，使用 snacks.notifier
* 5. lualine.nvim (statuscolumn) -> 保留，但可能需要调整以避免冲突
* 
* 作者: pengjiecheng
* 最后更新: 2024
--]] return {
    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- 大文件处理
            bigfile = {
                enabled = true,
                notify = true, -- 显示大文件通知
                size = 1.5 * 1024 * 1024 -- 1.5MB
            },

            -- 启动面板 (替代 alpha-nvim)
            dashboard = {
                enabled = true,
                preset = {
                    header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]],
                    keys = {
                        {
                            icon = ' ',
                            key = 'f',
                            desc = '查找文件',
                            action = ":lua Snacks.dashboard.pick('files')"
                        }, {
                            icon = ' ',
                            key = 'r',
                            desc = '最近文件',
                            action = ":lua Snacks.dashboard.pick('oldfiles')"
                        }, {
                            icon = ' ',
                            key = 'g',
                            desc = '全局搜索',
                            action = ":lua Snacks.dashboard.pick('live_grep')"
                        },
                        {
                            icon = ' ',
                            key = 'p',
                            desc = '项目列表',
                            action = ':Telescope projects'
                        },
                        {
                            icon = ' ',
                            key = 'm',
                            desc = '插件管理',
                            action = ':Lazy'
                        },
                        {
                            icon = ' ',
                            key = 's',
                            desc = '编辑配置',
                            action = ':e $MYVIMRC'
                        },
                        {icon = ' ', key = 'q', desc = '退出', action = ':qa'}
                    }
                }
            },

            -- 文件浏览器 (替代 neo-tree)
            explorer = {
                enabled = true,
                replace_netrw = true -- 替换 netrw
            },

            -- 缩进指示器 (替代 indent-blankline)
            indent = {
                enabled = true,
                char = '▏',
                blank = ' ',
                only_scope = false,
                only_current = false
            },

            -- 输入增强 - 舒适的浮动输入框
            input = {
                enabled = true,
                win = {
                    style = 'input',
                    position = 'float',
                    border = 'rounded',
                    backdrop = 60,
                    width = 60,
                    height = 1,
                    row = '50%',
                    col = '50%',
                    zindex = 50,
                    title_pos = 'center',
                    footer_pos = 'center'
                },
                expand = true,
                format = function(opts)
                    return {
                        prompt = opts.prompt or 'Input: ',
                        default = opts.default or '',
                        completion = opts.completion
                    }
                end
            },

            picker = {
                enabled = true,
                sources = {
                    explorer = {
                        auto_close = true, -- 选择文件后自动关闭
                        width = 36,
                        jump = {close = true, reuse = true},
                        position = 'left',
                        filters = {
                            dotfiles = false, -- 显示隐藏文件
                            custom = {'.git', 'node_modules'} -- 隐藏特定目录
                        }
                    }
                }
            },

            -- 通知系统 - 舒适的浮动通知 (与 noice.nvim 配合使用)
            notifier = {
                enabled = true,
                timeout = 4000, -- 增加显示时间
                width = { min = 50, max = 0.5 }, -- 增加最小宽度
                height = { min = 1, max = 0.3 }, -- 限制最大高度
                margin = { top = 1, right = 2, bottom = 1 }, -- 增加边距
                padding = true,
                sort = { "level", "added" },
                level = vim.log.levels.TRACE,
                style = 'compact', -- 紧凑样式
                top_down = true, -- 从上到下显示
                date_format = '%R', -- 时间格式
                more_format = ' ↓ %d more', -- 更多通知格式
                refresh = 50, -- 刷新频率
                icons = {
                    error = " ",
                    warn = " ",
                    info = " ",
                    debug = " ",
                    trace = " ",
                },
                keep = function(notif)
                    return vim.fn.getcmdpos() > 0
                end,
                -- 浮动窗口样式配置
                win = {
                    border = 'rounded',
                    backdrop = 60,
                    zindex = 100
                }
            },

            -- 快速文件操作
            quickfile = {enabled = true},

            -- 作用域高亮 (配合 indent 使用) - 性能优化
            scope = {
                enabled = true,
                animate = {enabled = false, duration = 100}, -- 禁用动画提升性能
                char = '▎',
                underline = false,
                only_current = true -- 只高亮当前作用域
            },

            -- 平滑滚动 - 性能优化
            scroll = {
                enabled = false, -- 禁用平滑滚动以提升性能
                animate = {
                    duration = {step = 10, total = 150}, -- 减少动画时长
                    easing = 'linear' -- 使用简单的线性动画
                }
            },

            -- 状态列 - 性能优化
            statuscolumn = {
                enabled = false,
                left = {'mark', 'sign'},
                right = {'fold'}, -- 移除 git 以减少计算开销
                folds = {open = true, git_hl = false}, -- 禁用 git 高亮
                git = {patterns = {}}, -- 清空 git 模式匹配
                refresh = 200 -- 增加刷新间隔
            },

            -- 单词高亮 - 性能优化
            words = {
                enabled = true,
                debounce = 300, -- 增加防抖时间
                notify_jump = false,
                notify_end = false, -- 禁用通知以减少开销
                foldopen = false, -- 禁用自动展开折叠
                jumplist = false, -- 禁用跳转列表
                modes = {'n'} -- 只在普通模式下启用
            },

            -- 终端管理 (可替代 toggleterm.nvim)
            terminal = {
                enabled = true,
                win = {
                    style = 'terminal',
                    position = 'float', -- 默认浮动窗口
                    border = 'rounded',
                    backdrop = 60
                },
                shell = vim.o.shell, -- 使用系统默认 shell
                auto_close = true, -- 进程退出时自动关闭
                auto_insert = true, -- 进入终端时自动插入模式
                start_insert = true -- 启动终端时自动插入模式
            }
        },
        keys = {
            -- Top Pickers & Explorer
            {
                '<leader><space>',
                function() Snacks.picker.smart() end,
                desc = 'Smart Find Files'
            },
            {
                '<leader>,',
                function() Snacks.picker.buffers() end,
                desc = 'Buffers'
            },
            {'<leader>/', function() Snacks.picker.grep() end, desc = 'Grep'},
            {'\\', function() Snacks.explorer() end, desc = 'File Explorer'}, -- find
            {
                '<leader>fb',
                function() Snacks.picker.buffers() end,
                desc = 'Buffers'
            }, {
                '<leader>fc',
                function()
                    Snacks.picker.files {cwd = vim.fn.stdpath 'config'}
                end,
                desc = 'Find Config File'
            },
            {
                '<leader>ff',
                function() Snacks.picker.files() end,
                desc = 'Find Files'
            }, {
                '<leader>fg',
                function() Snacks.picker.git_files() end,
                desc = 'Find Git Files'
            },
            {
                '<leader>fp',
                function() Snacks.picker.projects() end,
                desc = 'Projects'
            },
            {
                '<leader>fr',
                function() Snacks.picker.recent() end,
                desc = 'Recent'
            }, -- git
            {
                '<leader>gb',
                function() Snacks.picker.git_branches() end,
                desc = 'Git Branches'
            },
            {
                '<leader>gl',
                function() Snacks.picker.git_log() end,
                desc = 'Git Log'
            }, {
                '<leader>gL',
                function() Snacks.picker.git_log_line() end,
                desc = 'Git Log Line'
            },
            {
                '<leader>gs',
                function() Snacks.picker.git_status() end,
                desc = 'Git Status'
            },
            {
                '<leader>gS',
                function() Snacks.picker.git_stash() end,
                desc = 'Git Stash'
            }, {
                '<leader>gd',
                function() Snacks.picker.git_diff() end,
                desc = 'Git Diff (Hunks)'
            }, {
                '<leader>gf',
                function() Snacks.picker.git_log_file() end,
                desc = 'Git Log File'
            }, -- Grep
            {
                '<leader>sb',
                function() Snacks.picker.lines() end,
                desc = 'Buffer Lines'
            }, {
                '<leader>sB',
                function() Snacks.picker.grep_buffers() end,
                desc = 'Grep Open Buffers'
            },
            {'<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep'},
            {
                '<leader>sw',
                function() Snacks.picker.grep_word() end,
                desc = 'Visual selection or word',
                mode = {'n', 'x'}
            }, -- 🔍 常用搜索功能 (search)
            {
                '<leader>sc',
                function() Snacks.picker.command_history() end,
                desc = 'Command History'
            }, {
                '<leader>sd',
                function() Snacks.picker.diagnostics() end,
                desc = 'Diagnostics'
            },
            {
                '<leader>sh',
                function() Snacks.picker.help() end,
                desc = 'Help Pages'
            },
            {
                '<leader>sk',
                function() Snacks.picker.keymaps() end,
                desc = 'Keymaps'
            }, {
                'gd',
                function() Snacks.picker.lsp_definitions() end,
                desc = 'Goto Definition'
            }, {
                'gD',
                function() Snacks.picker.lsp_declarations() end,
                desc = 'Goto Declaration'
            }, {
                'gr',
                function() Snacks.picker.lsp_references() end,
                nowait = true,
                desc = 'References'
            }, {
                'gI',
                function() Snacks.picker.lsp_implementations() end,
                desc = 'Goto Implementation'
            }, {
                'gy',
                function() Snacks.picker.lsp_type_definitions() end,
                desc = 'Goto T[y]pe Definition'
            }, {
                '<leader>ss',
                function() Snacks.picker.lsp_symbols() end,
                desc = 'LSP Symbols'
            }, {
                '<leader>sS',
                function() Snacks.picker.lsp_workspace_symbols() end,
                desc = 'LSP Workspace Symbols'
            },
            {'<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit'},
            {
                '<leader>gl',
                function() Snacks.lazygit.log() end,
                desc = 'Lazygit 日志'
            },
            {
                '<leader>un',
                function() Snacks.notifier.hide() end,
                desc = '隐藏所有通知'
            },
            {
                '<leader>uN',
                function() Snacks.notifier.show_history() end,
                desc = '显示通知历史'
            },
            {
                '<leader>ud',
                function() 
                    Snacks.notifier.hide()
                    -- 同时清除 noice 历史（如果需要）
                    pcall(function() require('noice').cmd('dismiss') end)
                end,
                desc = '清除所有通知'
            },

            -- 🖥️ 终端管理 (替代 toggleterm.nvim)
            {
                '<leader>t',
                function() Snacks.terminal() end,
                desc = '切换终端'
            },
            {
                '<c-/>',
                function() Snacks.terminal() end,
                desc = '切换终端'
            },
            {
                '<c-_>',
                function() Snacks.terminal() end,
                desc = '切换终端'
            },
            {
                '<leader>tf',
                function()
                    Snacks.terminal(nil, {
                        win = { position = 'float', border = 'rounded' }
                    })
                end,
                desc = '浮动终端'
            },
            {
                '<leader>th',
                function()
                    Snacks.terminal(nil, {
                        win = { position = 'bottom', height = 0.3 }
                    })
                end,
                desc = '水平终端'
            },
            {
                '<leader>tv',
                function()
                    Snacks.terminal(nil, {
                        win = { position = 'right', width = 80 }
                    })
                end,
                desc = '垂直终端'
            }
        },

        -- 快捷键配置
        init = function()
            vim.api.nvim_create_autocmd('User', {
                pattern = 'VeryLazy',
                callback = function()
                    -- 设置 Snacks 为全局变量
                    _G.Snacks = require('snacks')
                    vim.g.snacks_global = true

                    -- 设置一些有用的快捷键
                    _G.dd = function(...)
                        Snacks.debug.inspect(...)
                    end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end
                    vim.print = _G.dd -- 覆盖 print 以使用 snacks 调试
                    
                    -- 设置终端模式下的快捷键 (替代 toggleterm 的终端快捷键)
                    _G.set_terminal_keymaps = function()
                        local opts = {buffer = 0}
                        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
                        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
                        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
                        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
                        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
                        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
                        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
                    end
                    
                    -- 为所有终端设置快捷键
                    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
                end
            })
        end
    }
}
