-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

-- Neo-tree 文件浏览器插件
return {
    'nvim-neo-tree/neo-tree.nvim',
    enabled = true, -- 重新启用 neo-tree
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    -- filesystem = {
    --   window = {
    --     mappings = {
    --       ['\\'] = 'close_window',
    --     },
    --   },
    -- },
    close_if_last_window = false, -- 如果是最后一个窗口则关闭 Neo-tree
    popup_border_style = 'NC', -- 弹出窗口边框样式
    enable_git_status = true, -- 启用 Git 状态
    enable_diagnostics = true, -- 启用诊断信息

    -- 默认配置
    default_component_configs = {
      indent = {
        indent_size = 2, -- 缩进大小
        padding = 1, -- 额外填充
        with_markers = true, -- 显示缩进标记
        indent_marker = '│', -- 缩进标记
        last_indent_marker = '└', -- 最后一个缩进标记
        highlight = 'NeoTreeIndentMarker', -- 高亮组
      },
      icon = {
        folder_closed = '', -- 文件夹关闭图标
        folder_open = '', -- 文件夹打开图标
        folder_empty = '󰜌', -- 空文件夹图标
        -- default = "*", -- 默认图标
        provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
          if node.type == 'file' or node.type == 'terminal' then
            local success, web_devicons = pcall(require, 'nvim-web-devicons')
            local name = node.type == 'terminal' and 'terminal' or node.name
            if success then
              local devicon, hl = web_devicons.get_icon(name)
              icon.tet = devicon or icon.text
              icon.highlight = hl or icon.highlight
            end
          end
        end,
      },
      name = {
        trailing_slash = false, -- 是否在文件夹后添加斜杠
        use_git_status_colors = true, -- 使用 Git 状态颜色
      },
      git_status = {
        symbols = {
          -- 修改状态
          added = '✚',
          modified = '',
          deleted = '✖',
          renamed = '󰁕',
          -- 状态
          untracked = '',
          ignored = '',
          unstaged = '󰄱',
          staged = '',
          conflict = '',
        },
      },
    },

    -- 窗口配置
    window = {
      position = 'left', -- 位置：左侧
      width = 36, -- 宽度
      mapping_options = {
        noremap = true, -- 非递归映射
        nowait = true, -- 不等待
      },
      mappings = {
        ['\\'] = 'close_window',
        -- 常用操作
        ['<space>'] = 'toggle_node', -- 切换节点展开/折叠
        ['o'] = 'open', -- 打开文件/文件夹
        ['<esc>'] = 'cancel', -- 取消操作
        ['P'] = { 'toggle_preview', config = { use_float = true } }, -- 切换预览
        ['S'] = 'open_split', -- 在分割窗口中打开
        ['s'] = 'open_vsplit', -- 在垂直分割窗口中打开
        ['t'] = 'open_tabnew', -- 在新标签页中打开

        -- 文件操作
        ['c'] = 'copy', -- 复制
        ['m'] = 'move', -- 移动
        ['d'] = 'delete', -- 删除
        ['a'] = 'add', -- 添加
        ['A'] = 'add_directory', -- 添加目录
        ['r'] = 'rename', -- 重命名

        -- 其他操作
        ['R'] = 'refresh', -- 刷新
        ['?'] = 'show_help', -- 显示帮助
        ['<'] = 'prev_source', -- 上一个源
        ['>'] = 'next_source', -- 下一个源
      },
    },

    -- 文件系统配置
    filesystem = {
      filtered_items = {
        visible = true, -- 是否显示被过滤的项目
        hide_dotfiles = false, -- 隐藏点文件
        hide_gitignored = false, -- 隐藏被 gitignore 的文件
        hide_hidden = true, -- 隐藏隐藏文件 (仅对 Windows 有效)
        hide_by_name = { '.DS_Store', 'thumbs.db', 'node_modules' },
        never_show = { -- 永不显示
          '.DS_Store',
          'thumbs.db',
        },
      },
      follow_current_file = {
        enabled = true, -- 跟随当前文件
      },
      hijack_netrw_behavior = 'open_default', -- 接管 netrw 行为
      use_libuv_file_watcher = true, -- 使用 libuv 文件监视器
    },

    -- 缓冲区配置
    buffers = {
      follow_current_file = {
        enabled = true, -- 跟随当前文件
      },
      group_empty_dirs = true, -- 分组空目录
      show_unloaded = true, -- 显示未加载的缓冲区
    },

    -- Git 配置
    git_status = {
      window = {
        position = 'float', -- 位置：浮动
      },
    },

    -- 事件处理器
    event_handlers = {
      {
        event = 'file_opened',
        handler = function()
          -- 自动关闭
           require('neo-tree.command').execute { action = 'close' }
        end,
      },
    },
  },
}
