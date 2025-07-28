--[[
* Snacks Terminal 迁移测试脚本
* 
* 用于验证从 toggleterm.nvim 迁移到 snacks.nvim terminal 模块后的功能
* 
* 使用方法：
* :lua require('custom.plugins.terminal_migration_test').run_tests()
--]]

local M = {}

---测试基础终端功能
local function test_basic_terminal()
    print('🧪 测试基础终端功能...')
    
    -- 检查 Snacks 是否可用
    if not _G.Snacks then
        print('❌ Snacks 未加载')
        return false
    end
    
    if not _G.Snacks.terminal then
        print('❌ Snacks.terminal 模块未启用')
        return false
    end
    
    print('✅ Snacks.terminal 模块可用')
    return true
end

---测试快捷键映射
local function test_keymaps()
    print('🧪 测试快捷键映射...')
    
    local keymaps_to_test = {
        '<leader>t',
        '<leader>tf',
        '<leader>th',
        '<leader>tv',
        '<c-/>',
        '<c-_>'
    }
    
    local success_count = 0
    
    for _, key in ipairs(keymaps_to_test) do
        local keymap = vim.fn.maparg(key, 'n')
        if keymap ~= '' then
            print('✅ 快捷键 ' .. key .. ' 已映射')
            success_count = success_count + 1
        else
            print('❌ 快捷键 ' .. key .. ' 未映射')
        end
    end
    
    print(string.format('📊 快捷键测试结果: %d/%d 成功', success_count, #keymaps_to_test))
    return success_count == #keymaps_to_test
end

---测试终端配置
local function test_terminal_config()
    print('🧪 测试终端配置...')
    
    -- 检查 Snacks 是否已加载并包含 terminal 模块
    if _G.Snacks and _G.Snacks.terminal then
        print('✅ 终端配置已加载')
        print('✅ 终端模块已启用')
        
        -- 检查终端 API 是否可用
        if type(_G.Snacks.terminal) == 'function' then
            print('✅ 终端 API 可用')
        end
        
        return true
    else
        print('❌ 无法获取终端配置或模块未启用')
        return false
    end
end

---测试终端模式快捷键
local function test_terminal_keymaps()
    print('🧪 测试终端模式快捷键...')
    
    -- 检查是否有 TermOpen 自动命令设置
    local autocmds = vim.api.nvim_get_autocmds({event = 'TermOpen'})
    local has_terminal_keymaps = false
    
    for _, autocmd in ipairs(autocmds) do
        if autocmd.callback or (autocmd.command and autocmd.command:match('set_terminal_keymaps')) then
            has_terminal_keymaps = true
            break
        end
    end
    
    if has_terminal_keymaps then
        print('✅ 终端快捷键自动命令已设置')
        return true
    else
        print('❌ 终端快捷键自动命令未设置')
        return false
    end
end

---检查 toggleterm 是否已禁用
local function test_toggleterm_disabled()
    print('🧪 检查 ToggleTerm 是否已禁用...')
    
    -- 检查 ToggleTerm 命令是否存在
    local has_toggleterm_cmd = vim.fn.exists(':ToggleTerm') == 2
    
    if has_toggleterm_cmd then
        print('⚠️  ToggleTerm 命令仍然存在，可能未完全禁用')
        return false
    else
        print('✅ ToggleTerm 已禁用')
        return true
    end
end

---运行所有测试
function M.run_tests()
    print('🚀 开始 Snacks Terminal 迁移测试...')
    print('=' .. string.rep('=', 50))
    
    local tests = {
        { name = '基础终端功能', func = test_basic_terminal },
        { name = '快捷键映射', func = test_keymaps },
        { name = '终端配置', func = test_terminal_config },
        { name = '终端模式快捷键', func = test_terminal_keymaps },
        { name = 'ToggleTerm 禁用检查', func = test_toggleterm_disabled }
    }
    
    local passed = 0
    local total = #tests
    
    for _, test in ipairs(tests) do
        print('\n📋 ' .. test.name .. ':')
        if test.func() then
            passed = passed + 1
        end
    end
    
    print('\n' .. string.rep('=', 50))
    print(string.format('📊 测试结果: %d/%d 通过', passed, total))
    
    if passed == total then
        print('🎉 所有测试通过！Snacks Terminal 迁移成功！')
        print('\n💡 现在你可以：')
        print('  • 使用 <leader>t 切换终端')
        print('  • 使用 <leader>tf 打开浮动终端')
        print('  • 使用 <leader>th 打开水平终端')
        print('  • 使用 <leader>tv 打开垂直终端')
        print('  • 使用 <c-/> 或 <c-_> 快速切换终端')
    else
        print('❌ 部分测试失败，请检查配置')
        print('\n🔧 故障排除建议：')
        print('  1. 重启 Neovim')
        print('  2. 检查 snacks.lua 配置')
        print('  3. 确认 toggleterm.lua 已禁用')
        print('  4. 运行 :checkhealth 检查插件状态')
    end
end

---快速测试终端功能
function M.quick_test()
    print('⚡ 快速测试 Snacks Terminal...')
    
    if not _G.Snacks or not _G.Snacks.terminal then
        print('❌ Snacks Terminal 不可用')
        return
    end
    
    print('✅ Snacks Terminal 可用')
    print('🚀 尝试打开浮动终端...')
    
    -- 尝试打开浮动终端
    pcall(function()
        _G.Snacks.terminal(nil, {
            win = { position = 'float', border = 'rounded' }
        })
    end)
end

---显示迁移状态
function M.show_migration_status()
    print('📋 Snacks Terminal 迁移状态:')
    print('=' .. string.rep('=', 40))
    
    -- Snacks 状态
    if _G.Snacks then
        print('✅ Snacks 已加载')
        if _G.Snacks.terminal then
            print('✅ Terminal 模块可用')
        else
            print('❌ Terminal 模块不可用')
        end
    else
        print('❌ Snacks 未加载')
    end
    
    -- ToggleTerm 状态
    local has_toggleterm = vim.fn.exists(':ToggleTerm') == 2
    if has_toggleterm then
        print('⚠️  ToggleTerm 仍然活跃')
    else
        print('✅ ToggleTerm 已禁用')
    end
    
    -- 快捷键状态
    local leader_t = vim.fn.maparg('<leader>t', 'n')
    if leader_t ~= '' then
        if string.find(leader_t, 'Snacks') then
            print('✅ <leader>t 映射到 Snacks')
        elseif string.find(leader_t, 'ToggleTerm') then
            print('⚠️  <leader>t 仍映射到 ToggleTerm')
        else
            print('❓ <leader>t 映射到其他功能')
        end
    else
        print('❌ <leader>t 未映射')
    end
end

-- 创建用户命令
vim.api.nvim_create_user_command('TestSnacksTerminal', function()
    M.run_tests()
end, { desc = '测试 Snacks Terminal 迁移' })

vim.api.nvim_create_user_command('QuickTestTerminal', function()
    M.quick_test()
end, { desc = '快速测试终端功能' })

vim.api.nvim_create_user_command('TerminalMigrationStatus', function()
    M.show_migration_status()
end, { desc = '显示终端迁移状态' })

return M