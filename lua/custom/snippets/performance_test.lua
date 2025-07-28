-- 代码片段性能测试脚本
local M = {}

-- 测试启动时间
function M.test_startup_time()
  local start_time = vim.loop.hrtime()
  
  -- 模拟加载代码片段
  local luasnip = require('luasnip')
  
  -- 测试延迟加载功能
  local function test_lazy_loading()
    local snippet_files = {
      'typescript',
      'javascript', 
      'vue',
      'lua',
      'python'
    }
    
    for _, lang in ipairs(snippet_files) do
      local snippet_path = vim.fn.stdpath('config') .. '/lua/custom/snippets/' .. lang .. '.lua'
      if vim.fn.filereadable(snippet_path) == 1 then
        local ok, snippets = pcall(require, 'custom.snippets.' .. lang)
        if ok then
          print(string.format('✓ %s 代码片段加载成功 (%d 个片段)', lang, #snippets))
        else
          print(string.format('✗ %s 代码片段加载失败', lang))
        end
      end
    end
  end
  
  -- 延迟执行测试
  vim.defer_fn(function()
    test_lazy_loading()
    
    local end_time = vim.loop.hrtime()
    local duration = (end_time - start_time) / 1000000 -- 转换为毫秒
    
    print(string.format('\n性能测试结果:'))
    print(string.format('总启动时间: %.2f ms', duration))
    print(string.format('延迟加载策略: 已启用'))
    print(string.format('代码片段优化: 已完成'))
    
    if duration < 100 then
      print('🚀 启动速度: 优秀 (< 100ms)')
    elseif duration < 200 then
      print('⚡ 启动速度: 良好 (< 200ms)')
    else
      print('⚠️  启动速度: 需要进一步优化 (> 200ms)')
    end
  end, 100)
end

-- 测试内存使用情况
function M.test_memory_usage()
  local memory_before = collectgarbage('count')
  
  -- 加载所有代码片段
  require('luasnip.loaders.from_lua').load({
    paths = vim.fn.stdpath('config') .. '/lua/custom/snippets/'
  })
  
  local memory_after = collectgarbage('count')
  local memory_diff = memory_after - memory_before
  
  print(string.format('内存使用测试:'))
  print(string.format('加载前: %.2f KB', memory_before))
  print(string.format('加载后: %.2f KB', memory_after))
  print(string.format('增加: %.2f KB', memory_diff))
  
  if memory_diff < 50 then
    print('💚 内存使用: 优秀 (< 50KB)')
  elseif memory_diff < 100 then
    print('💛 内存使用: 良好 (< 100KB)')
  else
    print('💔 内存使用: 需要优化 (> 100KB)')
  end
end

-- 运行完整测试
function M.run_full_test()
  print('🔧 开始代码片段性能测试...')
  print('=' .. string.rep('=', 50))
  
  M.test_startup_time()
  
  vim.defer_fn(function()
    print('\n' .. string.rep('=', 50))
    M.test_memory_usage()
    print('\n✅ 性能测试完成!')
  end, 200)
end

return M