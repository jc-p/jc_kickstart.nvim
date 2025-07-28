-- 搜索替换工具
return {
  'chrisgrieser/nvim-rip-substitute',
  cmd = 'RipSubstitute',
  opts = {},
  keys = {
    {
      '<leader>rf',
      function()
        require('rip-substitute').sub()
      end,
      mode = { 'n', 'x' },
      desc = '搜索替换 (当前缓冲区)',
    },
    {
      '<leader>rt',
      function()
        require('rip-substitute').sub()
      end,
      mode = 'x',
      desc = '搜索替换 (选中文本)',
    },
  },
  config = function()
    -- 安装 regex treesitter 解析器以提供语法高亮
    local has_treesitter, parsers = pcall(require, 'nvim-treesitter.parsers')
    if has_treesitter then
      local parser_config = parsers.get_parser_configs()
      if parser_config and not parsers.has_parser 'regex' then
        vim.cmd 'TSInstall regex'
      end
    end

    require('rip-substitute').setup {}
  end,
}