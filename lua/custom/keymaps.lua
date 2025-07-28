local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

--快速搜索单个选中
-- 可视模式下按 / 搜索选中内容（支持含空格的文本）
vim.keymap.set('v', '/', '"vy/<C-r>v<CR>', { noremap = true })
-- 缓冲区导航
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- 插入模式下使用 jk 退出到普通模式
keymap("i", "jk", "<ESC>", opts)

-- 快速移动行
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)
keymap("i", "<A-j>", "<ESC>:m .+1<CR>==gi", opts)
keymap("i", "<A-k>", "<ESC>:m .-2<CR>==gi", opts)
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- 向下复制当前行
keymap("n", "<leader>yd", "yyp", { desc = "向下复制当前行" })

-- 向上复制当前行
keymap("n", "<leader>yD", "yyP", { desc = "向上复制当前行" })


-- 窗口管理
-- 注意：窗口导航快捷键 <C-h>, <C-j>, <C-k>, <C-l> 已在 init.lua 中定义

-- 窗口大小调整
keymap("n", "<C-Up>", ":resize -2<CR>", { desc = "减小窗口高度" })
keymap("n", "<C-Down>", ":resize +2<CR>", { desc = "增加窗口高度" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "减小窗口宽度" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "增加窗口宽度" })

-- 搜索优化
keymap("n", "<leader>h", ":nohlsearch<CR>", { desc = "清除搜索高亮" })
keymap("n", "n", "nzzzv", { desc = "下一个搜索结果并居中" })
keymap("n", "N", "Nzzzv", { desc = "上一个搜索结果并居中" })

-- 缩进保持选择
keymap("v", "<", "<gv", { desc = "减少缩进并保持选择" })
keymap("v", ">", ">gv", { desc = "增加缩进并保持选择" })

-- 粘贴不覆盖寄存器
keymap("v", "p", '"_dP', { desc = "粘贴不覆盖寄存器" })

-- 在插入模式下快速移动
keymap("i", "<C-h>", "<Left>", { desc = "向左移动" })
keymap("i", "<C-j>", "<Down>", { desc = "向下移动" })
keymap("i", "<C-k>", "<Up>", { desc = "向上移动" })
keymap("i", "<C-l>", "<Right>", { desc = "向右移动" })

-- 终端模式快捷键
-- 注意：<Esc><Esc> 用于退出终端模式已在 init.lua 中定义
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "终端模式移动到左侧窗口" })
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "终端模式移动到下方窗口" })
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "终端模式移动到上方窗口" })
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "终端模式移动到右侧窗口" })

-- 代码折叠
keymap("n", "<leader>z", "za", { desc = "切换当前折叠" })
keymap("n", "<leader>Z", "zA", { desc = "递归切换当前折叠" })

-- 快速跳转
keymap("n", "<C-d>", "<C-d>zz", { desc = "向下滚动半页并居中" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "向上滚动半页并居中" })

-- 全选
keymap("n", "<C-a>", "gg<S-v>G", { desc = "全选" })

-- 缓冲区操作
keymap("n", "<leader>x", ":bdelete<CR>", { desc = "删除当前缓冲区" })
keymap("n", "<leader>bn", ":bnext<CR>", { desc = "下一个缓冲区" })
keymap("n", "<leader>bp", ":bprevious<CR>", { desc = "上一个缓冲区" })
keymap("n", "<leader>bf", ":bfirst<CR>", { desc = "第一个缓冲区" })
keymap("n", "<leader>bl", ":blast<CR>", { desc = "最后一个缓冲区" })

-- 标签页操作
keymap("n", "<leader>tc", ":tabclose<CR>", { desc = "关闭当前窗口页签" })
keymap("n", "<leader>tn", ":tabnew<CR>", { desc = "新建标签页" })
keymap("n", "<leader>to", ":tabonly<CR>", { desc = "关闭其他标签页" })
keymap("n", "<leader>]]", ":tabnext<CR>", { desc = "下一个标签页" })
keymap("n", "<leader>[[", ":tabprevious<CR>", { desc = "上一个标签页" })

-- 快速编辑常用配置文件
keymap("n", "<leader>ev", ":e $MYVIMRC<CR>", { desc = "编辑 Neovim 配置文件" })
keymap("n", "<leader>ek", ":e ~/.config/nvim/lua/custom/keymaps.lua<CR>", { desc = "编辑快捷键配置" })
keymap("n", "<leader>ep", ":e ~/.config/nvim/lua/custom/plugins/snacks.lua<CR>", { desc = "编辑插件snacks配置" })

-- 快速重载配置
keymap("n", "<leader>so", ":source $MYVIMRC<CR>", { desc = "重新加载配置文件" })

-- 项目管理快捷-- LSP 相关快捷键
-- 注意：init.lua 中已经定义了一些 LSP 相关快捷键
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "转到定义" })
keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "查找引用" })
