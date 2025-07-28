local opt = vim.opt

-- 全局变量声明
-- 声明 vim 相关的全局变量（这个总是可用的）
_G.vim = vim

-- 自定义全局变量命名空间
vim.g.my_globals = {
  snacks = 'Snacks',
  editor = 'neovim'
}

-- Snacks 全局变量将在插件加载后设置
vim.g.snacks_global = false -- 初始状态为 false，插件加载后会设置为 true

--自动重载
opt.autoread = true

-- 行号
opt.number = true
opt.relativenumber = true
opt.colorcolumn = '120'

--tab缩进配置
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 0

-- 启用鼠标
opt.mouse:append 'a'

-- 系统剪贴板
opt.clipboard:append 'unnamedplus'

-- 禁用 netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 性能优化选项
opt.synmaxcol = 200 -- 限制语法高亮的列数，提高大文件性能
opt.regexpengine = 1 -- 使用旧的正则引擎，在某些情况下更快

-- 更多性能优化
opt.lazyredraw = false -- 执行宏时不重绘屏幕，提高性能
opt.ttyfast = true -- 指示快速终端连接，提高性能
opt.updatetime = 150 -- 更快的更新时间，提高 git 标记响应速度
opt.timeout = true -- 启用超时
opt.timeoutlen = 300 -- 减少按键映射延迟
opt.ttimeoutlen = 10 -- 减少键码延迟

-- 缓冲区性能优化
opt.hidden = true -- 允许在未保存的情况下切换缓冲区
opt.history = 100 -- 减少历史记录大小，节省内存

-- 文件性能优化
vim.o.fsync = false -- 禁用 fsync，提高文件保存性能（注意：可能影响崩溃恢复）

-- Git 性能优化
vim.g.git_messenger_always_into_popup = true -- 提高 git 信息显示性能
vim.g.gitgutter_max_signs = 500 -- 限制 git 标记数量，提高性能

-- 会话选项
vim.o.sessionoptions = 'blank,buffers,folds,curdir,help,tabpages,winsize,winpos,terminal,localoptions'


vim.g.snacks_animate = false