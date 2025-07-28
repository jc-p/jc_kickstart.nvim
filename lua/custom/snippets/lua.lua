-- Lua 代码片段
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

-- 获取当前文件名（不带扩展名）
local get_filename = function()
  local filename = vim.fn.expand("%:t")
  return filename:match("(.+)%..+")
end

-- 获取当前日期
local get_date = function()
  return os.date("%Y-%m-%d")
end

-- 获取当前时间
local get_time = function()
  return os.date("%H:%M:%S")
end

-- 获取当前用户名
local get_username = function()
  return vim.fn.expand("$USER")
end

-- 代码片段集合
return {
  -- 函数定义
  s(
    "fn",
    fmt(
      [[function {}({})
  {}
  return {}
end]],
      {
        i(1, "function_name"),
        i(2, "args"),
        i(3, "-- function body"),
        i(4, "result"),
      }
    )
  ),

  -- 局部函数定义
  s(
    "lfn",
    fmt(
      [[local function {}({})
  {}
  return {}
end]],
      {
        i(1, "function_name"),
        i(2, "args"),
        i(3, "-- function body"),
        i(4, "result"),
      }
    )
  ),

  -- 匿名函数
  s(
    "afn",
    fmt(
      [[function({})
  {}
  return {}
end]],
      {
        i(1, "args"),
        i(2, "-- function body"),
        i(3, "result"),
      }
    )
  ),

  -- 局部变量
  s("local", fmt([[local {} = {}]], { i(1, "name"), i(2, "value") })),

  -- 条件语句
  s(
    "if",
    fmt(
      [[if {} then
  {}
end]],
      {
        i(1, "condition"),
        i(2, "-- body"),
      }
    )
  ),

  -- if-else 语句
  s(
    "ife",
    fmt(
      [[if {} then
  {}
else
  {}
end]],
      {
        i(1, "condition"),
        i(2, "-- if body"),
        i(3, "-- else body"),
      }
    )
  ),

  -- if-elseif-else 语句
  s(
    "ifee",
    fmt(
      [[if {} then
  {}
elseif {} then
  {}
else
  {}
end]],
      {
        i(1, "condition1"),
        i(2, "-- if body"),
        i(3, "condition2"),
        i(4, "-- elseif body"),
        i(5, "-- else body"),
      }
    )
  ),

  -- for 循环
  s(
    "for",
    fmt(
      [[for {} = {}, {} do
  {}
end]],
      {
        i(1, "i"),
        i(2, "1"),
        i(3, "10"),
        i(4, "-- body"),
      }
    )
  ),

  -- for pairs 循环
  s(
    "forp",
    fmt(
      [[for {}, {} in pairs({}) do
  {}
end]],
      {
        i(1, "k"),
        i(2, "v"),
        i(3, "table"),
        i(4, "-- body"),
      }
    )
  ),

  -- for ipairs 循环
  s(
    "fori",
    fmt(
      [[for {}, {} in ipairs({}) do
  {}
end]],
      {
        i(1, "i"),
        i(2, "v"),
        i(3, "table"),
        i(4, "-- body"),
      }
    )
  ),

  -- while 循环
  s(
    "while",
    fmt(
      [[while {} do
  {}
end]],
      {
        i(1, "condition"),
        i(2, "-- body"),
      }
    )
  ),

  -- repeat-until 循环
  s(
    "repeat",
    fmt(
      [[repeat
  {}
until {}]],
      {
        i(1, "-- body"),
        i(2, "condition"),
      }
    )
  ),

  -- 表定义
  s(
    "table",
    fmt(
      [[local {} = {{
  {} = {},
  {} = {},
}}]],
      {
        i(1, "tbl"),
        i(2, "key1"),
        i(3, "value1"),
        i(4, "key2"),
        i(5, "value2"),
      }
    )
  ),

  -- 模块定义
  s(
    "module",
    fmt(
      [[local {} = {{}}

{}

return {}]],
      {
        i(1, "M"),
        i(2, "-- module body"),
        rep(1),
      }
    )
  ),

  -- 文件头注释
  s(
    "header",
    fmt(
      [[---
-- @file: {}
-- @brief: {}
-- @author: {}
-- @date: {}
-- @time: {}
---

{}]],
      {
        f(function() return vim.fn.expand("%:t") end),
        i(1, "文件描述"),
        f(get_username),
        f(get_date),
        f(get_time),
        i(0),
      }
    )
  ),

  -- 函数注释
  s(
    "doc",
    fmt(
      [[---
-- @desc: {}
-- @param: {} {}
-- @return: {} {}
---]],
      {
        i(1, "函数描述"),
        i(2, "param_name"),
        i(3, "param_type"),
        i(4, "return_type"),
        i(5, "return_desc"),
      }
    )
  ),

  -- Neovim 插件配置
  s(
    "plugin",
    fmt(
      [[{{
  "{}",
  dependencies = {{
    {}
  }},
  event = "{}",
  config = function()
    {}
  end,
}}]],
      {
        i(1, "plugin/name"),
        i(2, "-- dependencies"),
        i(3, "VeryLazy"),
        i(4, "-- config"),
      }
    )
  ),

  -- Neovim 键位映射
  s(
    "keymap",
    fmt(
      [[vim.keymap.set("{}", "{}", {}, {{ desc = "{}" }})]],
      {
        c(1, { t("n"), t("i"), t("v"), t("t"), t("c") }),
        i(2, "lhs"),
        i(3, "rhs"),
        i(4, "description"),
      }
    )
  ),

  -- Neovim 自动命令
  s(
    "autocmd",
    fmt(
      [[vim.api.nvim_create_autocmd("{}", {{
  pattern = "{}",
  callback = function()
    {}
  end,
}})]],
      {
        i(1, "event"),
        i(2, "pattern"),
        i(3, "-- callback body"),
      }
    )
  ),

  -- Neovim 用户命令
  s(
    "usercmd",
    fmt(
      [[vim.api.nvim_create_user_command("{}", function(opts)
  {}
end, {{
  {}
}})]],
      {
        i(1, "CommandName"),
        i(2, "-- command body"),
        i(3, "-- command options"),
      }
    )
  ),

  -- 打印调试
  s("print", fmt([[print("{}:", {})]],
    {
      i(1, "debug"),
      i(2, "value"),
    }
  )),

  -- vim.inspect 打印
  s("inspect", fmt([[print("{}:", vim.inspect({}))]],
    {
      i(1, "debug"),
      i(2, "value"),
    }
  )),

  -- 错误处理
  s(
    "pcall",
    fmt(
      [[local {}, {} = pcall(function()
  {}
end)

if not {} then
  {}
end]],
      {
        i(1, "ok"),
        i(2, "result"),
        i(3, "-- function body"),
        rep(1),
        i(4, "-- error handling"),
      }
    )
  ),

  -- 表插入
  s(
    "tins",
    fmt(
      [[table.insert({}, {})]],
      {
        i(1, "tbl"),
        i(2, "value"),
      }
    )
  ),

  -- 表删除
  s(
    "trem",
    fmt(
      [[table.remove({}, {})]],
      {
        i(1, "tbl"),
        i(2, "index"),
      }
    )
  ),

  -- 表连接
  s(
    "tconcat",
    fmt(
      [[table.concat({}, {})]],
      {
        i(1, "tbl"),
        i(2, "\", \""),
      }
    )
  ),

  -- 表排序
  s(
    "tsort",
    fmt(
      [[table.sort({}, function({}, {})
  return {} < {}
end)]],
      {
        i(1, "tbl"),
        i(2, "a"),
        i(3, "b"),
        rep(2),
        rep(3),
      }
    )
  ),

  -- 字符串格式化
  s(
    "fmt",
    fmt(
      [[string.format("{}", {})]],
      {
        i(1, "%s"),
        i(2, "value"),
      }
    )
  ),

  -- 字符串查找
  s(
    "find",
    fmt(
      [[string.find({}, {})]],
      {
        i(1, "str"),
        i(2, "pattern"),
      }
    )
  ),

  -- 字符串匹配
  s(
    "match",
    fmt(
      [[string.match({}, {})]],
      {
        i(1, "str"),
        i(2, "pattern"),
      }
    )
  ),

  -- 字符串替换
  s(
    "gsub",
    fmt(
      [[string.gsub({}, {}, {})]],
      {
        i(1, "str"),
        i(2, "pattern"),
        i(3, "replacement"),
      }
    )
  ),

  -- 字符串分割
  s(
    "split",
    fmt(
      [[local function split(str, sep)
  local fields = {}
  local pattern = string.format("([^%s]+)", sep)
  str:gsub(pattern, function(c) fields[#fields + 1] = c end)
  return fields
end

local {} = split({}, {})]],
      {
        i(1, "result"),
        i(2, "str"),
        i(3, "\",\""),
        i(0),  -- 添加一个空的插入节点作为第四个参数
      }
    )
  ),

  -- Neovim 定时器
  s(
    "timer",
    fmt(
      [[local timer = vim.loop.new_timer()
timer:start({}, {}, vim.schedule_wrap(function()
  {}
end))]],
      {
        i(1, "1000"),  -- 延迟（毫秒）
        i(2, "0"),     -- 间隔（毫秒，0表示不重复）
        i(3, "-- timer callback"),
      }
    )
  ),

  -- Neovim 异步任务
  s(
    "async",
    fmt(
      [[vim.schedule(function()
  {}
end)]],
      {
        i(1, "-- async code"),
      }
    )
  ),

  -- Neovim 浮动窗口
  s(
    "float",
    fmt(
      [[local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(buf, 0, -1, true, {{"{}"}})

local width = {}
local height = {}
local ui = vim.api.nvim_list_uis()[1]
local opts = {{
  relative = "editor",
  width = width,
  height = height,
  col = (ui.width - width) / 2,
  row = (ui.height - height) / 2,
  style = "minimal",
  border = "{}",
}}

local win = vim.api.nvim_open_win(buf, true, opts)]],
      {
        i(1, "Floating window content"),
        i(2, "30"),
        i(3, "10"),
        c(4, { t("rounded"), t("single"), t("double"), t("shadow") }),
      }
    )
  ),

  -- Neovim 弹出菜单
  s(
    "popup",
    fmt(
      [[local items = {{
  "{}",
  "{}",
  "{}",
}}

vim.ui.select(items, {{
  prompt = "{}",
  format_item = function(item)
    return item
  end,
}}, function(choice)
  if choice then
    {}
  end
end)]],
      {
        i(1, "Item 1"),
        i(2, "Item 2"),
        i(3, "Item 3"),
        i(4, "Select an item:"),
        i(5, "-- handle selection"),
      }
    )
  ),

  -- Neovim 输入框
  s(
    "input",
    fmt(
      [[vim.ui.input({{
  prompt = "{}",
  default = "{}",
}}, function(input)
  if input then
    {}
  end
end)]],
      {
        i(1, "Enter value:"),
        i(2, "default value"),
        i(3, "-- handle input"),
      }
    )
  ),
}