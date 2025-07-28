-- 会话管理
return {
  'rmagatti/auto-session',
  lazy = false,
  keys = {
    { '<leader>rs', '<cmd>SessionSave<cr>', desc = '保存会话' },
    { '<leader>rr', '<cmd>SessionRestore<cr>', desc = '恢复会话' },
    { '<leader>rd', '<cmd>SessionDelete<cr>', desc = '删除会话' },
  },
  opts = {
    log_level = 'error',
    auto_session_enable_last_session = false,
    auto_session_root_dir = vim.fn.stdpath 'data' .. '/sessions/',
    auto_session_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = false,
    auto_session_suppress_dirs = {
      '~/',
      '~/Projects',
      '~/Downloads',
      '~/work',
    },
    auto_session_use_git_branch = true,
    -- 自定义保存前后钩子
    pre_save_cmds = { 'Neotree close' }, -- 保存前关闭 Neo-tree
    post_restore_cmds = {}, -- 恢复后执行的命令
    -- 错误处理配置
    continue_restore_on_error = true, -- 即使有错误也继续加载会话
    -- 自定义错误处理函数，忽略折叠错误
    restore_error_handler = function(err)
      -- 如果是折叠错误，忽略它
      if string.find(err, 'fold') or string.find(err, 'E16') then
        return true -- 返回 true 表示继续保存会话
      end
      -- 其他错误显示并禁用自动保存
      vim.notify('auto-session 错误: ' .. err, vim.log.levels.ERROR)
      return false
    end,
  },
}