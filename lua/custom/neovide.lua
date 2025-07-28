-- Neovide 配置文件
-- 这个文件会在 Neovim 启动时被加载，无论是否在 Neovide 中运行
-- 检查是否在 Neovide 中运行
if vim.g.neovide then
    -- 基础设置
    vim.g.neovide_cursor_animation_length = 0.05 -- 光标动画长度
    vim.g.neovide_cursor_trail_size = 0.5 -- 光标拖尾大小
    vim.g.neovide_cursor_antialiasing = true -- 光标抗锯齿
    vim.g.neovide_cursor_vfx_mode = "pixiedust" -- 光标特效模式: railgun, torpedo, pixiedust, sonicboom, ripple, wireframe
    vim.g.neovide_cursor_vfx_opacity = 100 -- 特效不透明度
    vim.g.neovide_cursor_vfx_particle_lifetime = 1.2 -- 粒子生命周期
    vim.g.neovide_cursor_vfx_particle_density = 10 -- 粒子密度
    vim.g.neovide_cursor_vfx_particle_speed = 10 -- 粒子速度

    -- 外观设置
    vim.g.neovide_opacity = 0.9 -- 窗口不透明度（替代已弃用的transparency）
    vim.g.neovide_input_macos_option_key_is_meta = true -- 将Option键设为Meta键
    vim.g.neovide_scroll_animation_length = 0.3 -- 滚动动画长度
    vim.g.neovide_hide_mouse_when_typing = true -- 输入时隐藏鼠标
    vim.g.neovide_underline_automatic_scaling = true -- 下划线自动缩放
    vim.g.neovide_theme = 'dark' -- 主题跟随系统
    -- 完全隐藏标题栏和边框
    vim.g.neovide_window_blurred = true
    vim.g.neovide_floating_blur_amount = 0 -- 禁用浮动窗口模糊
    -- macOS 专属无边框设置
    vim.g.neovide_cursor_animate_in_insert_mode = false

    -- 性能设置
    vim.g.neovide_refresh_rate = 60 -- 刷新率
    vim.g.neovide_refresh_rate_idle = 5 -- 空闲时刷新率
    vim.g.neovide_no_idle = false -- 禁用空闲
    vim.g.neovide_confirm_quit = true -- 退出时确认
    vim.g.neovide_fullscreen = false -- 全屏模式
    vim.g.neovide_remember_window_size = true -- 记住窗口大小

    -- 字体设置
    vim.o.guifont = "JetBrainsMono Nerd Font:h20" -- 设置字体和大小

    -- 快捷键
    vim.keymap.set('n', '<D-s>', ':w<CR>') -- CMD+S 保存
    vim.keymap.set('v', '<D-c>', '"+y') -- CMD+C 复制
    vim.keymap.set('n', '<D-v>', '"+P') -- CMD+V 粘贴
    vim.keymap.set('i', '<D-v>', '<C-R>+') -- 插入模式下粘贴
    vim.keymap.set('c', '<D-v>', '<C-R>+') -- 命令模式下粘贴
    vim.keymap.set('n', '<D-z>', 'u') -- CMD+Z 撤销
    vim.keymap.set('n', '<D-S-z>', '<C-r>') -- CMD+Shift+Z 重做
    
    -- 注释快捷键
    vim.keymap.set('n', '<D-/>', 'gcc', { noremap = false }) -- CMD+/ 注释当前行
    vim.keymap.set('v', '<D-/>', 'gc', { noremap = false }) -- CMD+/ 注释选中区域

    -- 打印确认信息
    vim.notify("Neovide 配置已加载", vim.log.levels.SUCCESS)
end

return {}
