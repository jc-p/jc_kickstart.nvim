--[[
* Git 相关插件配置
* 
* 包含以下插件:

*  diffview.nvim - Git 差异查看器
*  lazygit.nvim - Git 界面
*
* 作者: pengjiecheng
* 最后更新: 2023
--]]
return {

  --[[
  * Diffview - 高级 Git 差异查看器
  * 
  * 功能:
  * - 提供文件差异查看
  * - 支持文件历史浏览
  * - 支持合并冲突解决
  * - 提供文件面板和历史面板
  * - 自定义布局和快捷键
  --]]
  {
    'sindrets/diffview.nvim',
    cmd = {
      'DiffviewOpen',
      'DiffviewFileHistory',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
    },
    keys = {
      -- Git 差异查看 - 优先级高
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '打开 Git 差异' },
      { '<leader>gD', '<cmd>DiffviewClose<cr>', desc = '关闭 Git 差异' },
      {
        '<leader>gh',
        '<cmd>DiffviewFileHistory %<cr>',
        desc = '当前文件历史',
      },
    },
    opts = {
      enhanced_diff_hl = true, -- 增强差异高亮
      git_cmd = { 'git' }, -- Git 命令
      hg_cmd = { 'hg' }, -- Mercurial 命令
      diff_binaries = false, -- 不比较二进制文件
      show_help_hints = false, -- 不显示帮助提示
      watch_index = true, -- 监视 Git 索引变化
      icons = { folder_closed = '', folder_open = '' },
      signs = { fold_closed = '', fold_open = '', done = '✓' },

      -- 视图配置
      view = {
        -- 默认视图配置
        default = {
          layout = 'diff2_horizontal', -- 水平双栏布局
          disable_diagnostics = true,
          winbar_info = false,
        },
        -- 合并工具视图配置
        merge_tool = {
          layout = 'diff3_horizontal', -- 水平三栏布局
          disable_diagnostics = true,
          winbar_info = true,
        },
        -- 文件历史视图配置
        file_history = {
          layout = 'diff2_horizontal',
          disable_diagnostics = true,
          winbar_info = false,
        },
      },

      -- 文件面板配置
      file_panel = {
        listing_style = 'tree', -- 树形列表样式
        tree_options = {
          flatten_dirs = true,
          folder_statuses = 'only_folded',
        },
        win_config = {
          position = 'left', -- 面板位置
          width = 35, -- 面板宽度
          win_opts = {},
        },
      },

      -- 文件历史面板配置
      file_history_panel = {
        log_options = {
          git = {
            single_file = { diff_merges = 'combined' },
            multi_file = { diff_merges = 'first-parent' },
          },
          hg = { single_file = {}, multi_file = {} },
        },
        win_config = {
          position = 'bottom', -- 面板位置
          height = 16, -- 面板高度
          win_opts = {},
        },
      },

      -- 提交日志面板配置
      commit_log_panel = { win_config = { win_opts = {} } },

      -- 默认参数
      default_args = { DiffviewOpen = {}, DiffviewFileHistory = {} },

      hooks = {},

      -- 快捷键配置
      keymaps = {
        disable_defaults = false, -- 不禁用默认快捷键

        -- 视图模式快捷键
        view = {
          {
            'n',
            '<tab>',
            '<cmd>DiffviewToggleFiles<cr>',
            { desc = '切换文件面板' },
          },
          {
            'n',
            '<leader>co',
            '<cmd>DiffviewConflictChooseOurs<cr>',
            { desc = '选择我方版本' },
          },
          {
            'n',
            '<leader>ct',
            '<cmd>DiffviewConflictChooseTheirs<cr>',
            { desc = '选择他方版本' },
          },
          {
            'n',
            '<leader>cb',
            '<cmd>DiffviewConflictChooseBoth<cr>',
            { desc = '选择双方版本' },
          },
          {
            'n',
            '<esc>',
            '<cmd>DiffviewClose<cr>',
            { desc = '关闭 Diffview' },
          },
        },

        -- 文件面板快捷键
        file_panel = {
          {
            'n',
            'j',
            "<cmd>lua require'diffview.actions'.next_entry()<cr>",
            { desc = '下一个文件' },
          },
          {
            'n',
            'k',
            "<cmd>lua require'diffview.actions'.prev_entry()<cr>",
            { desc = '上一个文件' },
          },
          {
            'n',
            '<cr>',
            "<cmd>lua require'diffview.actions'.select_entry()<cr>",
            { desc = '打开差异' },
          },
          {
            'n',
            '-',
            "<cmd>lua require'diffview.actions'.toggle_stage_entry()<cr>",
            { desc = '暂存/取消暂存' },
          },
          {
            'n',
            '<esc>',
            '<cmd>DiffviewClose<cr>',
            { desc = '关闭 Diffview' },
          },
        },

        -- 文件历史面板快捷键
        file_history_panel = {
          {
            'n',
            'j',
            "<cmd>lua require'diffview.actions'.next_entry()<cr>",
            { desc = '下一个条目' },
          },
          {
            'n',
            'k',
            "<cmd>lua require'diffview.actions'.prev_entry()<cr>",
            { desc = '上一个条目' },
          },
          {
            'n',
            '<cr>',
            "<cmd>lua require'diffview.actions'.select_entry()<cr>",
            { desc = '打开差异' },
          },
          {
            'n',
            'y',
            "<cmd>lua require'diffview.actions'.copy_hash()<cr>",
            { desc = '复制提交哈希' },
          },
          {
            'n',
            '<esc>',
            '<cmd>DiffviewClose<cr>',
            { desc = '关闭 Diffview' },
          },
        },

        -- 选项面板快捷键
        option_panel = {
          {
            'n',
            '<tab>',
            "<cmd>lua require'diffview.actions'.select_entry()<cr>",
            { desc = '更改选项' },
          },
          {
            'n',
            '<esc>',
            "<cmd>lua require'diffview.actions'.close()<cr>",
            { desc = '关闭面板' },
          },
        },

        -- 帮助面板快捷键
        help_panel = {
          {
            'n',
            '<esc>',
            "<cmd>lua require'diffview.actions'.close()<cr>",
            { desc = '关闭帮助' },
          },
        },
      },
    },
  },

  --[[
  * Telescope Git 分支管理
  * 
  * 功能:
  * - 分支切换
  * - 分支创建
  * - 分支删除
  * - 分支重命名
  --]]
  {
    'nvim-telescope/telescope.nvim',
    optional = true,
    disabled = true,
    keys = {
      -- Git 分支管理
      {
        '<leader>gb',
        function()
          require('telescope.builtin').git_branches({
            prompt_title = 'Git 分支',
            attach_mappings = function(prompt_bufnr, map)
              local actions = require('telescope.actions')
              local action_state = require('telescope.actions.state')
              
              -- 默认行为：切换分支
              actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                if selection then
                  actions.close(prompt_bufnr)
                  local branch_name = selection.value
                  -- 移除 origin/ 前缀（如果存在）
                  branch_name = branch_name:gsub('^origin/', '')
                  
                  vim.fn.system('git checkout ' .. branch_name)
                  local exit_code = vim.v.shell_error
                  if exit_code == 0 then
                    vim.notify('已切换到分支: ' .. branch_name, vim.log.levels.INFO)
                    -- 刷新所有缓冲区
                    vim.cmd('checktime')
                  else
                    vim.notify('切换分支失败: ' .. branch_name, vim.log.levels.ERROR)
                  end
                end
              end)
              
              -- Ctrl+n: 创建新分支
              map('i', '<C-n>', function()
                actions.close(prompt_bufnr)
                vim.ui.input({
                  prompt = '新分支名称: ',
                }, function(branch_name)
                  if branch_name and branch_name ~= '' then
                    vim.fn.system('git checkout -b ' .. branch_name)
                    local exit_code = vim.v.shell_error
                    if exit_code == 0 then
                      vim.notify('已创建并切换到分支: ' .. branch_name, vim.log.levels.INFO)
                    else
                      vim.notify('创建分支失败: ' .. branch_name, vim.log.levels.ERROR)
                    end
                  end
                end)
              end)
              
              -- Ctrl+d: 删除分支
              map('i', '<C-d>', function()
                local selection = action_state.get_selected_entry()
                if selection then
                  local branch_name = selection.value:gsub('^origin/', '')
                  local current_branch = vim.fn.system('git branch --show-current'):gsub('\n', '')
                  
                  if branch_name == current_branch then
                    vim.notify('不能删除当前分支', vim.log.levels.WARN)
                    return
                  end
                  
                  vim.ui.select({'是', '否'}, {
                    prompt = '确定要删除分支 "' .. branch_name .. '" 吗?',
                  }, function(choice)
                    if choice == '是' then
                      actions.close(prompt_bufnr)
                      vim.fn.system('git branch -d ' .. branch_name)
                      local exit_code = vim.v.shell_error
                      if exit_code == 0 then
                        vim.notify('已删除分支: ' .. branch_name, vim.log.levels.INFO)
                      else
                        -- 尝试强制删除
                        vim.ui.select({'是', '否'}, {
                          prompt = '分支可能有未合并的更改，强制删除吗?',
                        }, function(force_choice)
                          if force_choice == '是' then
                            vim.fn.system('git branch -D ' .. branch_name)
                            vim.notify('已强制删除分支: ' .. branch_name, vim.log.levels.INFO)
                          end
                        end)
                      end
                    end
                  end)
                end
              end)
              
              return true
            end,
          })
        end,
        desc = 'Git 分支管理',
      },
    },
  },
}