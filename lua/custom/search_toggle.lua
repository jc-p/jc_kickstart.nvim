--[[
* 搜索功能快捷键切换器
* 
* 提供在精简模式和完整模式之间快速切换的功能
* 精简模式：只显示常用的搜索快捷键
* 完整模式：显示所有搜索快捷键
* 
* 使用方法：
* :lua require('custom.search_toggle').toggle_mode()
* 或者绑定快捷键：
* vim.keymap.set('n', '<leader>st', function() require('custom.search_toggle').toggle_mode() end, { desc = '切换搜索模式' })
--]]

local M = {}

-- 当前模式状态
local current_mode = 'full' -- 'essential' | 'full'

-- 常用搜索快捷键配置
local essential_keymaps = {
  -- 核心文件搜索功能 (Snacks)
  {
    '<leader>sf',
    function()
      Snacks.picker.files()
    end,
    desc = '📁 查找文件',
  },
  {
    '<leader>sg',
    function()
      Snacks.picker.grep()
    end,
    desc = '🔍 全局搜索',
  },
  {
    '<leader>sw',
    function()
      Snacks.picker.grep_word()
    end,
    desc = '🎯 搜索当前单词',
  },
  {
    '<leader>sr',
    function()
      Snacks.picker.recent()
    end,
    desc = '📄 最近文件',
  },
  {
    '<leader>sb',
    function()
      Snacks.picker.buffers()
    end,
    desc = '📋 缓冲区列表',
  },

  -- 系统功能 (Snacks)
  {
    '<leader>sc',
    function()
      Snacks.picker.command_history()
    end,
    desc = '📜 命令历史',
  },
  {
    '<leader>sd',
    function()
      Snacks.picker.diagnostics()
    end,
    desc = '🩺 诊断信息',
  },
  {
    '<leader>sh',
    function()
      Snacks.picker.help()
    end,
    desc = '📚 帮助搜索',
  },
  {
    '<leader>sk',
    function()
      Snacks.picker.keymaps()
    end,
    desc = '⌨️ 快捷键搜索',
  },
  {
    '<leader>ss',
    function()
      Snacks.picker.lsp_symbols()
    end,
    desc = '🏷️ LSP 符号',
  },
}

-- 完整搜索快捷键配置
local full_keymaps = {
  -- 核心文件搜索功能 (Snacks)
  {
    '<leader>sf',
    function()
      Snacks.picker.files()
    end,
    desc = '📁 查找文件',
  },
  {
    '<leader>sg',
    function()
      Snacks.picker.grep()
    end,
    desc = '🔍 全局搜索',
  },
  {
    '<leader>sw',
    function()
      Snacks.picker.grep_word()
    end,
    desc = '🎯 搜索当前单词',
  },
  {
    '<leader>sr',
    function()
      Snacks.picker.recent()
    end,
    desc = '📄 最近文件',
  },
  {
    '<leader>sb',
    function()
      Snacks.picker.buffers()
    end,
    desc = '📋 缓冲区列表',
  },
  {
    '<leader>sn',
    function()
      Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
    end,
    desc = '⚙️ 配置文件',
  },

  -- 系统功能 (Snacks)
  {
    '<leader>sc',
    function()
      Snacks.picker.command_history()
    end,
    desc = '📜 命令历史',
  },
  {
    '<leader>sd',
    function()
      Snacks.picker.diagnostics()
    end,
    desc = '🩺 诊断信息',
  },
  {
    '<leader>sh',
    function()
      Snacks.picker.help()
    end,
    desc = '📚 帮助搜索',
  },
  {
    '<leader>sk',
    function()
      Snacks.picker.keymaps()
    end,
    desc = '⌨️ 快捷键搜索',
  },
  {
    '<leader>ss',
    function()
      Snacks.picker.lsp_symbols()
    end,
    desc = '🏷️ LSP 符号',
  },
  {
    '<leader>sS',
    function()
      Snacks.picker.lsp_workspace_symbols()
    end,
    desc = '🌐 工作区符号',
  },

  -- 进阶功能 (Snacks)
  {
    '<leader>s"',
    function()
      Snacks.picker.registers()
    end,
    desc = '📋 寄存器',
  },
  {
    '<leader>s/',
    function()
      Snacks.picker.search_history()
    end,
    desc = '🔍 搜索历史',
  },
  {
    '<leader>sa',
    function()
      Snacks.picker.autocmds()
    end,
    desc = '⚡ 自动命令',
  },
  {
    '<leader>sl',
    function()
      Snacks.picker.lines()
    end,
    desc = '📄 缓冲区行',
  },
  {
    '<leader>sC',
    function()
      Snacks.picker.commands()
    end,
    desc = '⌨️ 命令',
  },
  {
    '<leader>sD',
    function()
      Snacks.picker.diagnostics_buffer()
    end,
    desc = '🩺 缓冲区诊断',
  },
  {
    '<leader>sH',
    function()
      Snacks.picker.highlights()
    end,
    desc = '🎨 高亮组',
  },
  {
    '<leader>si',
    function()
      Snacks.picker.icons()
    end,
    desc = '🎭 图标',
  },
  {
    '<leader>sj',
    function()
      Snacks.picker.jumps()
    end,
    desc = '🦘 跳转列表',
  },
  {
    '<leader>sL',
    function()
      Snacks.picker.loclist()
    end,
    desc = '📍 位置列表',
  },
  {
    '<leader>sM',
    function()
      Snacks.picker.marks()
    end,
    desc = '🏷️ 标记',
  },
  {
    '<leader>sp',
    function()
      Snacks.picker.lazy()
    end,
    desc = '🔌 插件规格',
  },
  {
    '<leader>sq',
    function()
      Snacks.picker.qflist()
    end,
    desc = '🔧 快速修复',
  },
  {
    '<leader>sR',
    function()
      Snacks.picker.resume()
    end,
    desc = '🔄 恢复搜索',
  },
  {
    '<leader>su',
    function()
      Snacks.picker.undo()
    end,
    desc = '↩️ 撤销历史',
  },
  {
    '<leader>uC',
    function()
      Snacks.picker.colorschemes()
    end,
    desc = '🎨 配色方案',
  },
}

-- 存储当前绑定的快捷键，用于清理
local current_keymaps = {}

---清理当前的快捷键绑定
local function clear_keymaps()
  for _, keymap in ipairs(current_keymaps) do
    pcall(vim.keymap.del, 'n', keymap.lhs)
  end
  current_keymaps = {}
end

---设置快捷键绑定
---@param keymaps table 快捷键配置列表
local function set_keymaps(keymaps)
  clear_keymaps()

  for _, keymap in ipairs(keymaps) do
    vim.keymap.set('n', keymap[1], keymap[2], { desc = keymap.desc })
    table.insert(current_keymaps, { lhs = keymap[1] })
  end
end

---获取当前模式
---@return string 当前模式 ('essential' | 'full')
function M.get_mode()
  return current_mode
end

---设置为精简模式
function M.set_essential_mode()
  current_mode = 'essential'
  set_keymaps(essential_keymaps)
  -- vim.notify('🔍 搜索模式: 精简模式 (常用功能)', vim.log.levels.INFO)
end

---设置为完整模式
function M.set_full_mode()
  current_mode = 'full'
  set_keymaps(full_keymaps)
  vim.notify('🔍 搜索模式: 完整模式 (所有功能)', vim.log.levels.INFO)
end

---切换搜索模式
function M.toggle_mode()
  if current_mode == 'essential' then
    M.set_full_mode()
  else
    M.set_essential_mode()
  end
end

---显示当前模式状态
function M.show_status()
  local mode_name = current_mode == 'essential' and '精简模式' or '完整模式'
  local keymap_count = #current_keymaps

  local status = string.format(
    '🔍 搜索功能状态:\n' .. '  模式: %s\n' .. '  快捷键数量: %d\n' .. '  切换命令: :lua require("custom.search_toggle").toggle_mode()',
    mode_name,
    keymap_count
  )

  vim.notify(status, vim.log.levels.INFO)
end

---创建搜索菜单
function M.create_search_menu()
  local actions = {
    {
      '⚡ 智能查找文件',
      function()
        Snacks.picker.smart()
      end,
    },
    {
      '📁 查找文件',
      function()
        Snacks.picker.files()
      end,
    },
    {
      '🔍 全局搜索',
      function()
        Snacks.picker.grep()
      end,
    },
    {
      '🎯 搜索当前单词',
      function()
        Snacks.picker.grep_word()
      end,
    },
    {
      '📄 最近文件',
      function()
        Snacks.picker.recent()
      end,
    },
    {
      '📋 缓冲区列表',
      function()
        Snacks.picker.buffers()
      end,
    },
    {
      '📦 Node 模块 (Telescope)',
      function()
        require('telescope').extensions.node_modules.list()
      end,
    },
    {
      '⚙️ 配置文件',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
    },
    {
      '📚 搜索帮助',
      function()
        Snacks.picker.help()
      end,
    },
    {
      '⌨️ 搜索快捷键',
      function()
        Snacks.picker.keymaps()
      end,
    },
    {
      '🩺 诊断信息',
      function()
        Snacks.picker.diagnostics()
      end,
    },
    {
      '📜 命令历史',
      function()
        Snacks.picker.command_history()
      end,
    },
  }

  vim.ui.select(actions, {
    prompt = '🔍 选择搜索功能:',
    format_item = function(item)
      return item[1]
    end,
  }, function(choice)
    if choice then
      choice[2]()
    end
  end)
end

---获取快捷键使用统计
function M.get_usage_stats()
  local stats = {
    essential_count = #essential_keymaps,
    full_count = #full_keymaps,
    hidden_count = #full_keymaps - #essential_keymaps,
    current_mode = current_mode,
  }

  return stats
end

---显示使用统计
function M.show_usage_stats()
  local stats = M.get_usage_stats()

  local message = string.format(
    '📊 搜索功能统计:\n'
      .. '  精简模式快捷键: %d 个\n'
      .. '  完整模式快捷键: %d 个\n'
      .. '  已隐藏快捷键: %d 个\n'
      .. '  当前模式: %s\n\n'
      .. '💡 提示: 使用 :lua require("custom.search_toggle").toggle_mode() 切换模式',
    stats.essential_count,
    stats.full_count,
    stats.hidden_count,
    stats.current_mode == 'essential' and '精简模式' or '完整模式'
  )

  vim.notify(message, vim.log.levels.INFO)
end

-- 初始化为精简模式
-- M.set_essential_mode()
M.set_full_mode()

-- 创建用户命令
vim.api.nvim_create_user_command('SearchToggle', function()
  M.toggle_mode()
end, { desc = '切换搜索模式' })

vim.api.nvim_create_user_command('SearchStatus', function()
  M.show_status()
end, { desc = '显示搜索模式状态' })

vim.api.nvim_create_user_command('SearchMenu', function()
  M.create_search_menu()
end, { desc = '打开搜索菜单' })

vim.api.nvim_create_user_command('SearchStats', function()
  M.show_usage_stats()
end, { desc = '显示搜索功能统计' })

-- 设置快捷键
vim.keymap.set('n', '<leader>st', M.toggle_mode, { desc = '🔄 切换搜索模式' })
vim.keymap.set('n', '<leader>S', M.create_search_menu, { desc = '🔍 搜索菜单' })
vim.keymap.set('n', '<leader>s?', M.show_status, { desc = '❓ 搜索状态' })

return M
