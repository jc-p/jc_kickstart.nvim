-- JavaScript 代码片段 - 精简版本（常用片段）
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

-- JavaScript 常用代码片段集合（精简版）
return {
  -- 函数声明
  s("fn", fmt(
    "function {}({}) {{\n  {}\n  return {}\n}}", 
    { i(1, "functionName"), i(2, "params"), i(3), i(4, "result") }
  )),

  -- 箭头函数
  s("afn", fmt(
    "const {} = ({}) => {{\n  {}\n  return {}\n}}", 
    { i(1, "functionName"), i(2, "params"), i(3), i(4, "result") }
  )),

  -- 单行箭头函数
  s("sfn", fmt(
    "const {} = ({}) => {}", 
    { i(1, "functionName"), i(2, "params"), i(3, "expression") }
  )),

  -- 异步函数
  s("async", fmt(
    "async function {}({}) {{\n  {}\n  return {}\n}}", 
    { i(1, "functionName"), i(2, "params"), i(3), i(4, "result") }
  )),

  -- 控制台日志
  s("log", fmt(
    "console.log({})", 
    { i(1, "'message'") }
  )),

  -- 带变量的控制台日志
  s("logv", fmt(
    "console.log('{}:', {})", 
    { i(1, "variable"), rep(1) }
  )),

  -- for 循环
  s("for", fmt(
    "for (let {} = 0; {} < {}; {}++) {{\n  {}\n}}", 
    { i(1, "i"), rep(1), i(2, "length"), rep(1), i(3) }
  )),

  -- for...of 循环
  s("forof", fmt(
    "for (const {} of {}) {{\n  {}\n}}", 
    { i(1, "item"), i(2, "items"), i(3) }
  )),

  -- forEach
  s("foreach", fmt(
    "{}.forEach(({}) => {{\n  {}\n}})", 
    { i(1, "array"), i(2, "item"), i(3) }
  )),

  -- map
  s("map", fmt(
    "const {} = {}.map(({}) => {{\n  {}\n  return {}\n}})", 
    { i(1, "result"), i(2, "array"), i(3, "item"), i(4), i(5, "item") }
  )),

  -- filter
  s("filter", fmt(
    "const {} = {}.filter(({}) => {})", 
    { i(1, "result"), i(2, "array"), i(3, "item"), i(4, "condition") }
  )),

  -- if 语句
  s("if", fmt(
    "if ({}) {{\n  {}\n}}", 
    { i(1, "condition"), i(2) }
  )),

  -- try...catch
  s("try", fmt(
    "try {{\n  {}\n}} catch (error) {{\n  console.error('{}:', error)\n  {}\n}}", 
    { i(1), i(2, "Error occurred"), i(3) }
  )),

  -- Promise
  s("promise", fmt(
    "new Promise((resolve, reject) => {{\n  {}\n}})", 
    { i(1) }
  )),

  -- 对象解构
  s("dest", fmt(
    "const {{{}}} = {}", 
    { i(1, "property"), i(2, "object") }
  )),

  -- 导入
  s("imp", fmt(
    "import {{{}}} from '{}'", 
    { i(1), i(2) }
  )),

  -- 默认导入
  s("imps", fmt(
    "import {} from '{}'", 
    { i(1), i(2) }
  )),

  -- 导出
  s("exp", fmt(
    "export {{{}}}", 
    { i(1) }
  )),

  -- 默认导出
  s("exps", fmt(
    "export default {}", 
    { i(1) }
  )),

  -- 类
  s("class", fmt(
    "class {} {{\n  constructor({}) {{\n    {}\n  }}\n\n  {}() {{\n    {}\n  }}\n}}", 
    { i(1, "ClassName"), i(2), i(3), i(4, "method"), i(5) }
  )),

  -- setTimeout
  s("timeout", fmt(
    "setTimeout(() => {{\n  {}\n}}, {})", 
    { i(1), i(2, "1000") }
  )),
}
