# im-select.nvim 使用指南

## 简介

`im-select.nvim` 是一个 Neovim 插件，用于自动切换输入法。当你从插入模式切换到普通模式时，它会自动将输入法切换为英文输入法，这对于使用中文等非英文输入法的用户特别有用。

## 安装依赖

### macOS

在 macOS 上，你需要安装 `im-select` 命令行工具：

```bash
# 使用 Homebrew 安装
brew tap daipeihust/tap
brew install im-select
```

或者手动下载安装：

1. 从 [im-select 仓库](https://github.com/daipeihust/im-select) 下载最新版本
2. 将可执行文件放入 PATH 路径中（如 `/usr/local/bin/`）
3. 确保文件有执行权限：`chmod +x /usr/local/bin/im-select`

### 验证安装

安装完成后，在终端中运行以下命令验证：

```bash
im-select
```

应该会输出当前的输入法标识符，例如 `com.apple.keylayout.ABC`。

## 配置说明

当前配置位于 `/Users/pengjiecheng/.config/nvim/lua/custom/plugins/im-select.lua`：

```lua
-- 输入法自动切换插件
return {
  "keaising/im-select.nvim",
  lazy = false, -- 确保插件立即加载
  config = function()
    -- 配置 im-select 插件
    require("im-select").setup({
      -- 默认输入法（英文输入法）
      -- macOS 中通常为 "com.apple.keylayout.ABC"
      default_im_select = "com.apple.keylayout.ABC",
      
      -- 默认命令
      default_command = "im-select",
      
      -- 设置在不同模式下自动切换输入法
      set_default_events = {"VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave"},
      
      -- 设置忽略的文件类型
      ignore_filetype = {"TelescopePrompt", "neo-tree", "alpha", "dashboard"},
      
      -- 是否自动管理输入法
      manage_backend = false,
      
      -- 是否在启动时检查 im-select 命令是否可用
      check_command = true,
    })
  end,
}
```

### 配置选项说明

- `default_im_select`：默认输入法，通常是英文输入法的标识符
- `default_command`：im-select 命令的名称
- `set_default_events`：触发切换到默认输入法的事件
- `ignore_filetype`：忽略自动切换的文件类型
- `manage_backend`：是否自动管理后端
- `check_command`：是否在启动时检查命令是否可用

## 使用方法

安装并配置好插件后，它会自动工作，无需手动操作：

1. 当你从插入模式切换到普通模式时，输入法会自动切换为英文
2. 当你进入插入模式时，之前的输入法状态会被保留

## 故障排除

如果插件不能正常工作，请检查：

1. 确保 `im-select` 命令已正确安装并可在终端中运行
2. 检查 `default_im_select` 设置是否正确
   - 在终端中运行 `im-select` 获取当前输入法的标识符
   - 切换到英文输入法，再次运行 `im-select` 获取英文输入法的标识符
3. 检查 Neovim 日志中是否有相关错误信息

## 自定义配置

### 获取输入法标识符

在 macOS 上，你可以使用以下命令获取当前输入法的标识符：

```bash
im-select
```

常见的输入法标识符：
- 英文输入法：`com.apple.keylayout.ABC`
- 简体拼音：`com.apple.inputmethod.SCIM.ITABC`
- 繁体拼音：`com.apple.inputmethod.TCIM.Pinyin`
- 搜狗拼音：`com.sogou.inputmethod.sogou.pinyin`

### 自定义事件

如果你想在其他事件触发时切换输入法，可以修改 `set_default_events` 选项。例如：

```lua
set_default_events = {"VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "CursorHold"}
```

## 更多信息

更多详细信息，请参考 [im-select.nvim GitHub 仓库](https://github.com/keaising/im-select.nvim)。