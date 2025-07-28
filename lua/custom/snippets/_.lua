-- 全局代码片段（适用于所有文件类型）
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

-- 全局代码片段集合
return {
  -- 日期
  s(
    "date",
    f(function()
      return os.date("%Y-%m-%d")
    end)
  ),

  -- 时间
  s(
    "time",
    f(function()
      return os.date("%H:%M:%S")
    end)
  ),

  -- 日期和时间
  s(
    "datetime",
    f(function()
      return os.date("%Y-%m-%d %H:%M:%S")
    end)
  ),

  -- 用户名
  s(
    "user",
    f(function()
      return vim.fn.expand("$USER")
    end)
  ),

  -- 文件名
  s(
    "filename",
    f(function()
      return vim.fn.expand("%:t")
    end)
  ),

  -- 文件路径
  s(
    "filepath",
    f(function()
      return vim.fn.expand("%:p")
    end)
  ),

  -- 文件名（不带扩展名）
  s(
    "filebase",
    f(function()
      return vim.fn.expand("%:t:r")
    end)
  ),

  -- 文件扩展名
  s(
    "fileext",
    f(function()
      return vim.fn.expand("%:e")
    end)
  ),

  -- 当前目录
  s(
    "dirname",
    f(function()
      return vim.fn.expand("%:p:h:t")
    end)
  ),

  -- 完整目录路径
  s(
    "dirpath",
    f(function()
      return vim.fn.expand("%:p:h")
    end)
  ),

  -- UUID v4
  s(
    "uuid",
    f(function()
      math.randomseed(os.time())
      local random = math.random
      local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
      return string.gsub(template, "[xy]", function(c)
        local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
        return string.format("%x", v)
      end)
    end)
  ),

  -- 随机数
  s(
    "rand",
    f(function()
      math.randomseed(os.time())
      return tostring(math.random(1, 100))
    end)
  ),

  -- 随机字符串
  s(
    "randstr",
    f(function()
      math.randomseed(os.time())
      local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      local length = 10
      local result = ""
      for i = 1, length do
        local rand = math.random(1, #chars)
        result = result .. string.sub(chars, rand, rand)
      end
      return result
    end)
  ),

  -- 简单注释块
  s(
    "comm",
    fmt(
      [[/**
 * {}
 */]],
      {
        i(1, "注释内容"),
      }
    )
  ),

  -- TODO 注释
  s(
    "todo",
    fmt(
      [[// TODO: {} - {}]],
      {
        i(1, "待办事项"),
        f(get_date),
      }
    )
  ),

  -- FIXME 注释
  s(
    "fixme",
    fmt(
      [[// FIXME: {} - {}]],
      {
        i(1, "需要修复的问题"),
        f(get_date),
      }
    )
  ),

  -- NOTE 注释
  s(
    "note",
    fmt(
      [[// NOTE: {} - {}]],
      {
        i(1, "注意事项"),
        f(get_date),
      }
    )
  ),

  -- HACK 注释
  s(
    "hack",
    fmt(
      [[// HACK: {} - {}]],
      {
        i(1, "临时解决方案"),
        f(get_date),
      }
    )
  ),

  -- 分隔线
  s(
    "line",
    t({
      "// -----------------------------------------------",
    })
  ),

  -- 带标题的分隔线
  s(
    "section",
    fmt(
      [[// -------------------- {} --------------------]],
      {
        i(1, "标题"),
      }
    )
  ),

  -- 箭头
  s(
    "arrow",
    t("→")
  ),

  -- 双箭头
  s(
    "darrow",
    t("⇒")
  ),

  -- 勾选框
  s(
    "check",
    t("☑")
  ),

  -- 未勾选框
  s(
    "uncheck",
    t("☐")
  ),

  -- 星号
  s(
    "star",
    t("★")
  ),

  -- 空心星号
  s(
    "ostar",
    t("☆")
  ),

  -- 笑脸
  s(
    "smile",
    t("☺")
  ),

  -- 心形
  s(
    "heart",
    t("♥")
  ),

  -- 版权符号
  s(
    "copy",
    t("©")
  ),

  -- 注册商标
  s(
    "reg",
    t("®")
  ),

  -- 商标
  s(
    "tm",
    t("™")
  ),

  -- 度数
  s(
    "deg",
    t("°")
  ),

  -- 欧元
  s(
    "euro",
    t("€")
  ),

  -- 英镑
  s(
    "pound",
    t("£")
  ),

  -- 日元
  s(
    "yen",
    t("¥")
  ),

  -- 美分
  s(
    "cent",
    t("¢")
  ),

  -- 无穷大
  s(
    "inf",
    t("∞")
  ),

  -- 约等于
  s(
    "approx",
    t("≈")
  ),

  -- 不等于
  s(
    "neq",
    t("≠")
  ),

  -- 小于等于
  s(
    "leq",
    t("≤")
  ),

  -- 大于等于
  s(
    "geq",
    t("≥")
  ),

  -- 加减
  s(
    "pm",
    t("±")
  ),

  -- 平方根
  s(
    "sqrt",
    t("√")
  ),

  -- 立方根
  s(
    "cbrt",
    t("∛")
  ),

  -- 四次方根
  s(
    "qdrt",
    t("∜")
  ),

  -- 求和
  s(
    "sum",
    t("∑")
  ),

  -- 求积
  s(
    "prod",
    t("∏")
  ),

  -- 积分
  s(
    "int",
    t("∫")
  ),

  -- 偏导数
  s(
    "partial",
    t("∂")
  ),

  -- 空集
  s(
    "empty",
    t("∅")
  ),

  -- 属于
  s(
    "in",
    t("∈")
  ),

  -- 不属于
  s(
    "notin",
    t("∉")
  ),

  -- 包含
  s(
    "contains",
    t("⊃")
  ),

  -- 被包含
  s(
    "subset",
    t("⊂")
  ),

  -- 交集
  s(
    "cap",
    t("∩")
  ),

  -- 并集
  s(
    "cup",
    t("∪")
  ),

  -- 逻辑与
  s(
    "land",
    t("∧")
  ),

  -- 逻辑或
  s(
    "lor",
    t("∨")
  ),

  -- 逻辑非
  s(
    "lnot",
    t("¬")
  ),

  -- 存在量词
  s(
    "exists",
    t("∃")
  ),

  -- 任意量词
  s(
    "forall",
    t("∀")
  ),

  -- 因为
  s(
    "because",
    t("∵")
  ),

  -- 所以
  s(
    "therefore",
    t("∴")
  ),

  -- 希腊字母 Alpha
  s(
    "alpha",
    t("α")
  ),

  -- 希腊字母 Beta
  s(
    "beta",
    t("β")
  ),

  -- 希腊字母 Gamma
  s(
    "gamma",
    t("γ")
  ),

  -- 希腊字母 Delta
  s(
    "delta",
    t("δ")
  ),

  -- 希腊字母 Epsilon
  s(
    "epsilon",
    t("ε")
  ),

  -- 希腊字母 Zeta
  s(
    "zeta",
    t("ζ")
  ),

  -- 希腊字母 Eta
  s(
    "eta",
    t("η")
  ),

  -- 希腊字母 Theta
  s(
    "theta",
    t("θ")
  ),

  -- 希腊字母 Iota
  s(
    "iota",
    t("ι")
  ),

  -- 希腊字母 Kappa
  s(
    "kappa",
    t("κ")
  ),

  -- 希腊字母 Lambda
  s(
    "lambda",
    t("λ")
  ),

  -- 希腊字母 Mu
  s(
    "mu",
    t("μ")
  ),

  -- 希腊字母 Nu
  s(
    "nu",
    t("ν")
  ),

  -- 希腊字母 Xi
  s(
    "xi",
    t("ξ")
  ),

  -- 希腊字母 Omicron
  s(
    "omicron",
    t("ο")
  ),

  -- 希腊字母 Pi
  s(
    "pi",
    t("π")
  ),

  -- 希腊字母 Rho
  s(
    "rho",
    t("ρ")
  ),

  -- 希腊字母 Sigma
  s(
    "sigma",
    t("σ")
  ),

  -- 希腊字母 Tau
  s(
    "tau",
    t("τ")
  ),

  -- 希腊字母 Upsilon
  s(
    "upsilon",
    t("υ")
  ),

  -- 希腊字母 Phi
  s(
    "phi",
    t("φ")
  ),

  -- 希腊字母 Chi
  s(
    "chi",
    t("χ")
  ),

  -- 希腊字母 Psi
  s(
    "psi",
    t("ψ")
  ),

  -- 希腊字母 Omega
  s(
    "omega",
    t("ω")
  ),
}