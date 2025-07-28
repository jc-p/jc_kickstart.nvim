--[[
* 全局变量使用示例
* 
* 这个文件展示了如何在 Neovim 配置中使用已声明的全局变量
* 包括 Snacks 和 vim 的全局变量使用方法
* 
* 作者: pengjiecheng
* 最后更新: 2024
--]]

local M = {}

-- 使用全局 Snacks 变量的函数
function M.test_snacks_global()
  -- 检查 Snacks 是否可用
  if _G.Snacks then
    print("✅ Snacks 全局变量可用")
    
    -- 使用 Snacks 的通知功能
    if _G.Snacks.notifier then
      _G.Snacks.notifier.notify("Hello from global Snacks!", "info")
    end
    
    -- 使用 Snacks 的调试功能
    if _G.Snacks.debug then
      _G.Snacks.debug.inspect({ message = "Testing global Snacks", status = "success" })
    end
    
    return true
  else
    print("❌ Snacks 全局变量不可用")
    return false
  end
end

-- 使用全局 vim 变量的函数
function M.test_vim_global()
  -- 检查 vim 是否可用（这个应该总是可用的）
  if _G.vim then
    print("✅ vim 全局变量可用")
    
    -- 使用全局 vim 变量
    local current_file = _G.vim.fn.expand("%:t")
    print("当前文件: " .. (current_file ~= "" and current_file or "无文件"))
    
    -- 访问 vim.g 中的自定义变量
    if _G.vim.g.my_globals then
      print("编辑器: " .. _G.vim.g.my_globals.editor)
      print("Snacks 标识: " .. _G.vim.g.my_globals.snacks)
    end
    
    return true
  else
    print("❌ vim 全局变量不可用")
    return false
  end
end

-- 检查所有全局变量状态
function M.check_all_globals()
  print("=== 全局变量状态检查 ===")
  
  -- 检查 Snacks 状态
  local snacks_status = vim.g.snacks_global and "已启用" or "未启用"
  print("Snacks 全局状态: " .. snacks_status)
  
  -- 检查各个全局变量
  local globals_status = {
    ["_G.Snacks"] = _G.Snacks ~= nil,
    ["_G.vim"] = _G.vim ~= nil,
    ["vim.g.snacks_global"] = vim.g.snacks_global == true,
    ["vim.g.my_globals"] = vim.g.my_globals ~= nil,
  }
  
  for name, status in pairs(globals_status) do
    local icon = status and "✅" or "❌"
    print(string.format("%s %s: %s", icon, name, status and "可用" or "不可用"))
  end
  
  return globals_status
end

-- 创建一个使用全局变量的实用函数
function M.smart_notify(message, level)
  level = level or "info"
  
  -- 优先使用 Snacks 通知
  if _G.Snacks and _G.Snacks.notifier then
    _G.Snacks.notifier.notify(message, level)
  -- 回退到 vim.notify
  elseif _G.vim and _G.vim.notify then
    local log_levels = {
      info = _G.vim.log.levels.INFO,
      warn = _G.vim.log.levels.WARN,
      error = _G.vim.log.levels.ERROR,
    }
    _G.vim.notify(message, log_levels[level] or log_levels.info)
  -- 最后回退到 print
  else
    print(string.format("[%s] %s", level:upper(), message))
  end
end

-- 创建一个使用全局变量的文件操作函数
function M.smart_file_picker()
  -- 优先使用 Snacks picker
  if _G.Snacks and _G.Snacks.picker then
    _G.Snacks.picker.smart()
    M.smart_notify("使用 Snacks 智能文件选择器", "info")
  -- 回退到 vim 内置功能
  elseif _G.vim then
    _G.vim.cmd("edit .")
    M.smart_notify("使用 vim 内置文件浏览器", "warn")
  else
    print("无可用的文件选择器")
  end
end

-- 导出测试命令
function M.run_tests()
  print("\n=== 开始全局变量测试 ===")
  
  -- 检查状态
  M.check_all_globals()
  
  print("\n=== 功能测试 ===")
  
  -- 测试 Snacks
  M.test_snacks_global()
  
  -- 测试 vim
  M.test_vim_global()
  
  -- 测试实用函数
  print("\n=== 实用函数测试 ===")
  M.smart_notify("这是一个测试通知", "info")
  
  print("\n=== 测试完成 ===")
end

-- 创建用户命令来运行测试
vim.api.nvim_create_user_command('TestGlobals', function()
  M.run_tests()
end, { desc = '测试全局变量功能' })

-- 创建快捷键来快速测试
vim.keymap.set('n', '<leader>tg', M.run_tests, { desc = '🧪 测试全局变量' })
vim.keymap.set('n', '<leader>tn', function() M.smart_notify("快捷键测试通知", "info") end, { desc = '📢 测试通知' })
vim.keymap.set('n', '<leader>tf', M.smart_file_picker, { desc = '📁 智能文件选择' })

return M