return {
    -- SchemaStore: 提供 JSON Schema
    {
        'b0o/SchemaStore.nvim',
        lazy = true,
        version = false -- 最新版本
    }, -- Mason: LSP 服务器管理器
    {
        'williamboman/mason.nvim',
        cmd = 'Mason',
        keys = {{'<leader>cm', '<cmd>Mason<cr>', desc = 'Mason'}},
        build = ':MasonUpdate',
        opts = {
            ensure_installed = {
                -- 'lua_ls',
                'stylua', 'shfmt', 'eslint-lsp', -- vscode-eslint-language-server
                'json-lsp' -- JSON 语言服务器
                -- 'vue-language-server', -- 移除，避免 vue_ls 冲突
            }
        },
        config = function(_, opts) require('mason').setup(opts) end
    },
    {
        'neovim/nvim-lspconfig',
        event = {'BufReadPost', 'BufNewFile', 'BufWritePre'},
        dependencies = {
            'mason.nvim'
            -- 'hrsh7th/cmp-nvim-lsp' 已移除，blink.cmp 提供 LSP 补全功能
        },
        opts = {
            inlay_hints = {
                enabled = true,
                -- 不再排除 Vue 文件，因为 vue_ls 现在处理 Vue 文件的 inlay hints
                exclude = {}
            },
            codelens = {enabled = false},
            document_highlight = {enabled = true},
            capabilities = {
                workspace = {
                    fileOperations = {didRename = true, willRename = true}
                }
            },
            format = {formatting_options = nil, timeout_ms = nil},
            setup = {},
            servers = {
                -- volar 配置已移至 config 函数中手动设置，避免重复配置
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = {
                                -- 告诉语言服务器使用的 Lua 版本
                                version = 'LuaJIT',
                                -- 设置 Lua 路径
                                path = vim.split(package.path, ';')
                            },
                            diagnostics = {
                                -- 获取语言服务器识别的全局变量
                                globals = {
                                    -- Vim 全局变量
                                    'vim', -- Neovim 特定全局变量
                                    'describe', 'it', 'before_each',
                                    'after_each', 'teardown', 'pending',
                                    -- 其他常用全局变量
                                    'awesome', 'client', 'root', 'screen'
                                },
                                -- 禁用特定的诊断
                                disable = {
                                    'trailing-space' -- 禁用尾随空格警告
                                }
                            },
                            workspace = {
                                checkThirdParty = false,
                                -- 让语言服务器了解你的 Neovim 运行时文件
                                library = {
                                    vim.fn.expand '$VIMRUNTIME/lua',
                                    vim.fn.stdpath 'config' .. '/lua'
                                },
                                -- 调整工作区诊断设置
                                diagnostics = {
                                    -- 自定义诊断严重性
                                    groupSeverity = {
                                        strong = 'Warning',
                                        strict = 'Warning'
                                    },
                                    groupFileStatus = {
                                        ['ambiguity'] = 'Opened',
                                        ['await'] = 'Opened',
                                        ['codestyle'] = 'None',
                                        ['duplicate'] = 'Opened',
                                        ['global'] = 'Opened',
                                        ['luadoc'] = 'Opened',
                                        ['redefined'] = 'Opened',
                                        ['strict'] = 'Opened',
                                        ['strong'] = 'Opened',
                                        ['type-check'] = 'Opened',
                                        ['unbalanced'] = 'Opened',
                                        ['unused'] = 'Opened'
                                    }
                                },
                                maxPreload = 2000,
                                preloadFileSize = 1000
                            },
                            completion = {
                                callSnippet = 'Replace',
                                keywordSnippet = 'Replace',
                                displayContext = 6, -- 显示更多上下文
                                postfix = '.' -- 启用后缀补全
                            },
                            format = {
                                enable = true,
                                defaultConfig = {
                                    indent_style = 'space',
                                    indent_size = '2',
                                    quote_style = 'double'
                                }
                            },
                            telemetry = {enable = false},
                            doc = {privateName = {'^_'}},
                            hint = {
                                enable = true,
                                setType = true, -- 显示变量类型
                                paramType = true, -- 显示参数类型
                                paramName = 'Literal', -- 显示参数名称
                                semicolon = 'All', -- 显示分号
                                arrayIndex = 'All' -- 显示数组索引
                            }
                        }
                    }
                },
                ts_ls = {enabled = false},
                vtsls = {
                    filetypes = {
                        'javascript', 'javascriptreact', 'javascript.jsx',
                        'typescript', 'typescriptreact', 'typescript.tsx'
                        -- 移除 vue 文件类型，避免与 volar 冲突
                    },
                    settings = {
                        complete_function_calls = true,
                        vtsls = {
                            enableMoveToFileCodeAction = true,
                            autoUseWorkspaceTsdk = true,
                            experimental = {
                                completion = {enableServerSideFuzzyMatch = true}
                            }
                        },
                        typescript = {
                            updateImportsOnFileMove = {enabled = 'always'},
                            suggest = {completeFunctionCalls = true},
                            inlayHints = {
                                enumMemberValues = {enabled = true},
                                functionLikeReturnTypes = {enabled = true},
                                parameterNames = {enabled = 'literals'},
                                parameterTypes = {enabled = true},
                                propertyDeclarationTypes = {enabled = true},
                                variableTypes = {enabled = false}
                            }
                        }
                    }
                    -- 移除 Vue TypeScript 插件配置，避免与 volar 冲突
                },
                jsonls = {
                    filetypes = {'json', 'jsonc', 'json5'}
                },
                pyright = {
                    settings = {
                        python = {analysis = {typeCheckingMode = 'basic'}}
                    }
                },
                eslint = {
                        settings = {
                            codeAction = {
                                disableRuleComment = {
                                    enable = true,
                                    location = 'separateLine'
                                },
                                showDocumentation = {enable = true}
                            },
                            codeActionOnSave = {enable = false, mode = 'all'},
                            experimental = {useFlatConfig = false},
                            format = true, -- 启用 ESLint 格式化，特别是对 Vue 文件
                            nodePath = '',
                            onIgnoredFiles = 'off',
                            packageManager = 'npm',
                            problems = {shortenToSingleLine = false},
                            quiet = false,
                            rulesCustomizations = {},
                            run = 'onType',
                            useESLintClass = false,
                            validate = 'on',
                            workingDirectory = {mode = 'location'}
                        },
                        filetypes = {
                            'javascript', 'javascriptreact', 'typescript',
                            'typescriptreact', 'vue'
                        },
                        root_dir = function(fname)
                            local lspconfig = require 'lspconfig'
                            return lspconfig.util.root_pattern('.eslintrc.js',
                                                               '.eslintrc.json',
                                                               '.eslintrc.yaml',
                                                               '.eslintrc.yml',
                                                               'eslint.config.js',
                                                               'package.json')(
                                       fname)
                        end,
                        on_attach = function(client, bufnr)
                            -- 对于 Vue 文件，启用 ESLint 的格式化功能
                            if vim.bo[bufnr].filetype == 'vue' then
                                client.server_capabilities
                                    .documentFormattingProvider = true
                                client.server_capabilities
                                    .documentRangeFormattingProvider = true
                            else
                                -- 对于其他文件类型，禁用 ESLint 的格式化功能，使用 null-ls 的 prettier
                                client.server_capabilities
                                    .documentFormattingProvider = false
                                client.server_capabilities
                                    .documentRangeFormattingProvider = false
                                -- 对于非 Vue 文件，禁用 ESLint 的诊断功能
                                client.server_capabilities.diagnosticProvider =
                                    false
                            end

                            -- 添加 ESLint 修复快捷键
                            vim.keymap.set('n', '<leader>ce', function()
                                -- 使用 LSP 执行 ESLint 修复命令
                                client.request('workspace/executeCommand', {
                                    command = 'eslint.applyAllFixes',
                                    arguments = {
                                        {
                                            uri = vim.uri_from_bufnr(bufnr),
                                            version = vim.lsp.util.buf_versions[bufnr]
                                        }
                                    }
                                }, function(err, result)
                                    if err then
                                        vim.notify(
                                            'ESLint 修复失败: ' ..
                                                tostring(err),
                                            vim.log.levels.ERROR)
                                    else
                                        vim.notify('ESLint 修复完成',
                                                   vim.log.levels.INFO)
                                    end
                                end)
                            end, {buffer = bufnr, desc = 'ESLint 修复所有'})
                        end
                    }
                },
                setup = {
                    jsonls = function()
                        -- 确保 .json 文件被识别为 json 文件类型
                        vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
                            pattern = '*.json',
                            callback = function()
                                vim.bo.filetype = 'json'
                            end
                        })
                        -- 确保 .jsonc 文件被识别为 jsonc 文件类型
                        vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
                            pattern = '*.jsonc',
                            callback = function()
                                vim.bo.filetype = 'jsonc'
                            end
                        })
                        return false -- 继续设置 LSP
                    end
                }
            },
            config = function(_, opts)
            -- 获取 TypeScript SDK 路径的辅助函数
            local function get_typescript_server_path(root_dir)
                local project_root = require('lspconfig.util').find_node_modules_ancestor(root_dir)
                return project_root and (require('lspconfig.util').path.join(project_root, 'node_modules', 'typescript', 'lib')) or ''
            end
            
            -- 设置基础 capabilities
            local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
            local capabilities = vim.tbl_deep_extend('force',
                                                     {},
                                                     vim.lsp.protocol
                                                         .make_client_capabilities(),
                                                     has_cmp and
                                                         cmp_nvim_lsp
                                                             .default_capabilities() or
                                                         {},
                                                     opts.capabilities or
                                                         {})
            
            -- 设置 volar (Vue 语言服务器)
            require('lspconfig').volar.setup({
                cmd = {'vue-language-server', '--stdio'},
                filetypes = {'vue'},
                root_dir = function(fname)
                    local lspconfig = require 'lspconfig'
                    return lspconfig.util.root_pattern('package.json',
                                                       'vue.config.js',
                                                       'vite.config.js',
                                                       '.git')(fname)
                end,
                capabilities = capabilities,
                init_options = {
                    vue = {
                        hybridMode = false
                    }
                },
                on_new_config = function(new_config, new_root_dir)
                    local ts_lib = get_typescript_server_path(new_root_dir)
                    if ts_lib and ts_lib ~= '' then
                        new_config.init_options.typescript = {
                            tsdk = ts_lib
                        }
                    end
                end
            })
            
            local servers = opts.servers

            local function setup(server)
                local server_opts = vim.tbl_deep_extend('force', {
                    capabilities = vim.deepcopy(capabilities)
                }, servers[server] or {})

                -- 特殊处理 jsonls 的 settings
                if server == 'jsonls' then
                    local ok, schemastore = pcall(require, 'schemastore')
                    if ok then
                        server_opts.settings = {
                            json = {
                                schemas = schemastore.json.schemas(),
                                validate = { enable = true },
                                format = { enable = true }
                            }
                        }
                    end
                end

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup['*'] then
                    if opts.setup['*'](server, server_opts) then
                        return
                    end
                end
                require('lspconfig')[server].setup(server_opts)
            end

                -- 手动设置其他 LSP 服务器（不使用 mason-lspconfig）
                for server, server_opts in pairs(servers) do
                    if server_opts and server ~= 'volar' then -- 跳过 volar，已经手动设置
                        server_opts = server_opts == true and {} or server_opts
                        setup(server)
                    end
                end

                if require('lsp.setup') then require('lsp.setup').setup(opts) end
            end
        },

        -- 自动补全已迁移到 blink.cmp (在 init.lua 中配置)
        -- blink.cmp 提供更好的性能和现代化的补全体验

        -- 代码片段 - 性能优化版本
        {
            'L3MON4D3/LuaSnip',
            event = 'InsertEnter', -- 延迟到插入模式时才加载
            build = 'make install_jsregexp',
            dependencies = {
                {
                    'rafamadriz/friendly-snippets',
                    config = function()
                        -- 延迟加载 friendly-snippets，减少启动时间
                        vim.defer_fn(function()
                            require('luasnip.loaders.from_vscode').lazy_load()
                        end, 100)
                    end
                }
            },
            opts = {
                history = true,
                delete_check_events = 'TextChanged',
                -- 性能优化：减少更新频率
                update_events = 'TextChanged,TextChangedI',
                -- 减少内存使用
                store_selection_keys = '<Tab>',
            },
            config = function(_, opts)
                require('luasnip').setup(opts)

                -- 延迟加载自定义代码片段，避免启动时加载大量片段
                vim.defer_fn(function()
                    -- 只在需要时加载特定语言的代码片段
                    local function load_snippets_for_filetype()
                        local ft = vim.bo.filetype
                        if ft and ft ~= '' then
                            local snippet_path = vim.fn.stdpath('config') .. '/lua/custom/snippets/' .. ft .. '.lua'
                            if vim.fn.filereadable(snippet_path) == 1 then
                                require('luasnip.loaders.from_lua').load({
                                    paths = { snippet_path }
                                })
                            end
                        end
                    end

                    -- 为当前文件类型加载代码片段
                    load_snippets_for_filetype()

                    -- 监听文件类型变化，动态加载对应的代码片段
                    vim.api.nvim_create_autocmd('FileType', {
                        group = vim.api.nvim_create_augroup('LuaSnipLazyLoad', { clear = true }),
                        callback = load_snippets_for_filetype,
                    })
                end, 200)
            end
        },

        
        -- 代码诊断
        -- {
        --   "nvimtools/none-ls.nvim",
        --   event = { "BufReadPre", "BufNewFile" },
        --   dependencies = { "mason.nvim" },
        --   config = function()
        --     require("lsp.null-ls")
        --   end,
        -- },

        -- LSP 进度显示
        {
            'j-hui/fidget.nvim',
            opts = {notification = {window = {winblend = 100}}}
        },

        -- 代码大纲
        {
            'stevearc/aerial.nvim',
            opts = {
                attach_mode = 'global',
                backends = {'lsp', 'treesitter', 'markdown', 'man'},
                layout = {min_width = 28},
                show_guides = true,
                filter_kind = false,
                guides = {
                    mid_item = '├─',
                    last_item = '└─',
                    nested_top = '│ ',
                    whitespace = '  '
                },
                keymaps = {
                    ['['] = 'actions.prev',
                    [']'] = 'actions.next',
                    ['<CR>'] = 'actions.jump',
                    ['q'] = 'actions.close'
                }
            }
        },

        -- 诊断列表
        {
            'folke/trouble.nvim',
            cmd = {'TroubleToggle', 'Trouble'},
            opts = {
                use_diagnostic_signs = true,
                action_keys = {
                    close = 'q',
                    cancel = '<esc>',
                    refresh = 'r',
                    jump = {'<cr>', '<tab>'},
                    jump_close = {'o'},
                    toggle_mode = 'm',
                    toggle_preview = 'P',
                    hover = 'K',
                    preview = 'p',
                    close_folds = {'zM', 'zm'},
                    open_folds = {'zR', 'zr'},
                    toggle_fold = {'zA', 'za'},
                    previous = 'k',
                    next = 'j',
                    auto_fold = false
                },
                auto_jump = {},
                auto_fold = false,
                auto_preview = true,
                signs = {
                    -- 图标
                    error = '',
                    warning = '',
                    hint = '',
                    information = '',
                    other = ''
                },
                win = {border = 'rounded'},
                regex = { -- 正则表达式匹配
                    -- 未使用的变量
                    ['variable'] = {
                        ['[%w_]+'] = {
                            match_diagnostics = {
                                severity = {min = vim.diagnostic.severity.HINT}
                            },
                            highlights = {'@variable'}
                        }
                    },
                    -- 未使用的参数
                    ['parameter'] = {
                        ['[%w_]+'] = {
                            match_diagnostics = {
                                severity = {min = vim.diagnostic.severity.HINT}
                            },
                            highlights = {'@parameter'}
                        }
                    }
                }
            }
        }
    }

