-- 自定义自动命令配置
-- 创建自动命令组
local autocmd_group = vim.api.nvim_create_augroup('custom_autocmds', { clear = true })

-- 退出插入模式时自动保存文件
vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
  group = autocmd_group,
  pattern = '*',
  callback = function()
    -- 只在可修改的缓冲区中保存
    if vim.bo.modifiable and vim.bo.modified and vim.fn.expand '%' ~= '' then
      vim.cmd 'silent! write'
      -- 可选：显示保存消息
      -- vim.notify("文件已自动保存", vim.log.levels.INFO)
    end
  end,
  desc = '退出插入模式或文本变更时自动保存文件',
})

-- 失去焦点时自动保存文件
vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
  group = autocmd_group,
  pattern = '*',
  callback = function()
    -- 只在可修改的缓冲区中保存
    if vim.bo.modifiable and vim.bo.modified and vim.fn.expand '%' ~= '' then
      vim.cmd 'silent! write'
    end
  end,
  desc = '失去焦点或离开缓冲区时自动保存文件',
})

-- 创建自动命令，为特定文件类型设置折叠方法
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'vue', 'typescript', 'javascript', 'tsx', 'jsx' },
  callback = function()
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
  end,
})

-- 为 development 文件设置文件类型
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = autocmd_group,
  pattern = { '*.development', '*.dev' },
  callback = function()
    vim.bo.filetype = 'development'
    -- 设置默认的 commentstring
    vim.bo.commentstring = '# %s'
  end,
  desc = '为 development 文件设置文件类型和注释字符串',
})

local ime_autogroup = vim.api.nvim_create_augroup('ImeAutoGroup', { clear = true })

vim.api.nvim_create_autocmd('InsertLeave', {
  group = ime_autogroup,
  callback = function()
    vim.system({ 'macism' }, { text = true }, function(out)
      -- 用一个全局变量存储之前的语言
      PREVIOUS_IM_CODE_MAC = string.gsub(out.stdout, '\n', '')
    end)
    vim.cmd ":silent :!macism com.apple.keylayout.ABC"
    -- vim.cmd ':silent :!macism com.tencent.inputmethod.wetype.pinyin'
  end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
  group = ime_autogroup,
  callback = function()
    if PREVIOUS_IM_CODE_MAC then
      vim.cmd(':silent :!macism ' .. PREVIOUS_IM_CODE_MAC)
    end
    PREVIOUS_IM_CODE_MAC = nil
  end,
})
