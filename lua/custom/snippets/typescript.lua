-- TypeScript 代码片段 - 精简版本（常用片段）
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- 获取当前文件名（不带扩展名）
local get_filename = function()
  local filename = vim.fn.expand("%:t")
  return filename:match("(.+)%..+") or "Component"
end

-- TypeScript 常用代码片段集合（精简版）
return {
  -- 基础类
  s("tclass", fmt(
    [[class {} {{
  constructor({}) {{
    {}
  }}

  {}
}}]], 
    { i(1, "ClassName"), i(2), i(3), i(4) }
  )),

  -- 接口
  s("tinterface", fmt(
    [[interface {} {{
  {}
}}]], 
    { i(1, "InterfaceName"), i(2) }
  )),

  -- 类型别名
  s("ttype", fmt(
    [[type {} = {}]], 
    { i(1, "TypeName"), i(2, "any") }
  )),

  -- 函数
  s("tfn", fmt(
    [[function {}({}: {}): {} {{
  {}
  return {}
}}]], 
    { i(1, "functionName"), i(2, "param"), i(3, "any"), i(4, "any"), i(5), i(6, "result") }
  )),

  -- 箭头函数
  s("tafn", fmt(
    [[const {} = ({}: {}): {} => {{
  {}
  return {}
}}]], 
    { i(1, "functionName"), i(2, "param"), i(3, "any"), i(4, "any"), i(5), i(6, "result") }
  )),

  -- 异步函数
  s("tasync", fmt(
    [[async function {}({}: {}): Promise<{}> {{
  {}
  return {}
}}]], 
    { i(1, "functionName"), i(2, "param"), i(3, "any"), i(4, "any"), i(5), i(6, "result") }
  )),

  -- React 组件
  s("trc", fmt(
    [[interface {}Props {{
  {}
}}

const {}: React.FC<{}Props> = ({}) => {{
  {}

  return (
    <div>
      {}
    </div>
  )
}}

export default {}]], 
    { 
      f(get_filename, {}), i(1), 
      f(get_filename, {}), f(get_filename, {}), i(2), 
      i(3), i(4), 
      f(get_filename, {}) 
    }
  )),

  -- useState Hook
  s("tus", fmt(
    [[const [{}, set{}] = useState<{}>({})]], 
    { i(1, "state"), f(function(args) return args[1][1]:sub(1,1):upper() .. args[1][1]:sub(2) end, {1}), i(2, "any"), i(3, "initialValue") }
  )),

  -- useEffect Hook
  s("tue", fmt(
    [[useEffect(() => {{
  {}
}}, [{}])]], 
    { i(1), i(2) }
  )),

  -- 导入语句
  s("timp", fmt(
    [[import {{ {} }} from '{}']], 
    { i(1), i(2) }
  )),

  -- 默认导入
  s("timps", fmt(
    [[import {} from '{}']], 
    { i(1), i(2) }
  )),

  -- 导出
  s("texp", fmt(
    [[export {{ {} }}]], 
    { i(1) }
  )),

  -- 默认导出
  s("texps", fmt(
    [[export default {}]], 
    { i(1) }
  )),

  -- console.log
  s("tcl", fmt(
    [[console.log('{}:', {})]], 
    { i(1, "debug"), i(2) }
  )),

  -- try-catch
  s("ttry", fmt(
    [[try {{
  {}
}} catch (error) {{
  console.error('{}:', error)
  {}
}}]], 
    { i(1), i(2, "Error occurred"), i(3) }
  )),
}