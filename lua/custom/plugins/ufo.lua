-- 添加 nvim-ufo 插件，提供更好的代码折叠体验
return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async',
    'nvim-treesitter/nvim-treesitter',
  },
  event = 'VeryLazy',
  opts = {
    -- 使用 treesitter 作为主要提供者，fallback 到 indent
    provider_selector = function(bufnr, filetype, buftype)
      return { 'treesitter', 'indent' }
    end,
    -- 自定义折叠文本显示
    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = ('  %d 行'):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- 如果还有空间，添加更多文本
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end,
  },
  init = function()
    -- 使用 UFO 的折叠设置
    vim.o.foldcolumn = '1' -- 显示折叠列，设为 '0' 可以隐藏
    vim.o.foldlevel = 99 -- 默认展开所有折叠
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  config = function(_, opts)
    -- 设置折叠快捷键
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = '打开所有折叠' })
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = '关闭所有折叠' })
    vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = '打开当前折叠' })
    vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = '关闭当前折叠' })
    vim.keymap.set('n', 'zp', require('ufo').peekFoldedLinesUnderCursor, { desc = '预览折叠内容' })
    
    require('ufo').setup(opts)
  end,
}