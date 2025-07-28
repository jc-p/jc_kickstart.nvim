-- 颜色高亮 - 显示颜色代码的实际颜色
return {
  'norcalli/nvim-colorizer.lua',
  event = 'VeryLazy',
  config = function()
    require('colorizer').setup({
      '*', -- 高亮所有文件
      css = { rgb_fn = true }, -- 启用 CSS 中的 rgb(...) 函数
      html = { names = false }, -- 禁用 HTML 中的颜色名称
    }, {
      RGB = true, -- #RGB 十六进制代码
      RRGGBB = true, -- #RRGGBB 十六进制代码
      names = true, -- "Name" 代码，如 Blue
      RRGGBBAA = true, -- #RRGGBBAA 十六进制代码
      rgb_fn = true, -- CSS rgb() 和 rgba() 函数
      hsl_fn = true, -- CSS hsl() 和 hsla() 函数
      css = true, -- 启用所有 CSS 功能：rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = true, -- 启用所有 CSS *函数*：rgb_fn, hsl_fn
      mode = 'background', -- 设置显示模式：'foreground', 'background'
    })
  end,
}