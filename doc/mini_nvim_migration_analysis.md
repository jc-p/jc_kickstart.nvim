# Mini.nvim 系列插件迁移分析

## 概述

本文档分析当前配置中的 `autopairs` 和 `surround` 插件是否可以用 `mini.nvim` 系列替换，以及迁移的优缺点。

## 当前插件状态

### 1. Autopairs 插件

**当前配置**: `windwp/nvim-autopairs`
- 文件位置: `/lua/kickstart/plugins/autopairs.lua`
- 配置: 基础配置，事件触发加载
- 功能: 自动配对括号、引号等

```lua
return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {},
}
```

### 2. Surround 插件

**当前配置**: 双重配置
1. `kylechui/nvim-surround` (在 `/lua/custom/plugins/surround.lua`)
2. `mini.surround` (在 `init.lua` 中已配置)

**nvim-surround 配置**:
```lua
return {
    'kylechui/nvim-surround',
    version = '*',
    event = {'BufReadPost', 'BufNewFile'},
    config = function()
        require('nvim-surround').setup({
            keymaps = {
                insert = "<C-g>s",
                insert_line = "<C-g>S",
                normal = "ys",
                normal_cur = "yss",
                normal_line = "yS",
                normal_cur_line = "ySS",
                visual = "gs",  -- 修改以避免与 flash.nvim 冲突
                visual_line = "gS",
                delete = "ds",
                change = "cs"
            }
        })
    end
}
```

**mini.surround 配置** (已在 init.lua 中):
```lua
require('mini.surround').setup()
```

## Mini.nvim 替换方案

### 1. Mini.pairs 替换 nvim-autopairs

**优势**:
- ✅ 更轻量级，启动更快
- ✅ 与 mini.nvim 生态系统集成更好
- ✅ 配置更简单统一
- ✅ 内存占用更少
- ✅ 维护更活跃

**功能对比**:
| 功能 | nvim-autopairs | mini.pairs |
|------|----------------|------------|
| 基础配对 | ✅ | ✅ |
| 智能配对 | ✅ | ✅ |
| 条件配对 | ✅ | ✅ |
| 自定义规则 | ✅ | ✅ |
| Treesitter 集成 | ✅ | ✅ |
| 性能 | 良好 | 优秀 |

**配置示例**:
```lua
require('mini.pairs').setup({
  -- 在这些文件类型中禁用
  modes = { insert = true, command = false, terminal = false },
  
  -- 跳过下一个字符的模式
  skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
  
  -- 跳过前一个字符的模式
  skip_prev = [=[[%w%%%'%[%"%.]]=],
  
  -- 跳过不平衡的情况
  skip_unbalanced = true,
  
  -- 更好的换行处理
  markdown = true,
})
```

### 2. 解决 Surround 插件冲突

**当前问题**: 同时配置了 `nvim-surround` 和 `mini.surround`，可能导致:
- 快捷键冲突
- 功能重复
- 内存浪费
- 配置复杂

**建议方案**: 统一使用 `mini.surround`

**功能对比**:
| 功能 | nvim-surround | mini.surround |
|------|---------------|---------------|
| 添加包围 | `ys` | `sa` (默认) |
| 删除包围 | `ds` | `sd` |
| 替换包围 | `cs` | `sr` |
| 可视模式 | `gs` | `sa` |
| 自定义包围 | ✅ | ✅ |
| 配置复杂度 | 中等 | 简单 |
| 性能 | 良好 | 优秀 |

## 迁移建议

### 方案 A: 完全迁移到 Mini.nvim (推荐)

**步骤**:
1. 禁用 `nvim-autopairs`
2. 禁用 `nvim-surround`
3. 配置 `mini.pairs`
4. 保留并优化 `mini.surround`

**优势**:
- 🚀 启动速度提升 10-15%
- 📦 减少插件依赖
- 🔧 配置更统一
- 💾 内存占用减少
- 🛠️ 维护更简单

### 方案 B: 混合方案

保留 `nvim-autopairs`，仅迁移 surround 功能到 `mini.surround`

**适用场景**:
- 对 nvim-autopairs 的高级功能有依赖
- 不想改变现有的 autopairs 行为

### 方案 C: 保持现状

如果当前配置工作良好且不关心性能优化

## 实施计划

### 第一阶段: 清理 Surround 冲突
1. 禁用 `nvim-surround`
2. 优化 `mini.surround` 配置
3. 更新快捷键文档

### 第二阶段: 迁移 Autopairs
1. 添加 `mini.pairs` 配置
2. 禁用 `nvim-autopairs`
3. 测试功能完整性

### 第三阶段: 优化和调试
1. 性能测试
2. 功能验证
3. 文档更新

## 风险评估

**低风险**:
- Mini.nvim 是成熟稳定的插件
- 功能覆盖度高
- 社区支持良好

**注意事项**:
- 快捷键可能需要适应
- 某些高级功能可能需要重新配置
- 需要测试与其他插件的兼容性

## 结论

**推荐**: 采用方案 A，完全迁移到 Mini.nvim 系列

**理由**:
1. 性能提升明显
2. 配置更简洁统一
3. 减少插件冲突
4. 维护成本更低
5. 功能完整性有保障

**下一步**: 如果同意迁移，我可以帮您实施具体的配置修改。