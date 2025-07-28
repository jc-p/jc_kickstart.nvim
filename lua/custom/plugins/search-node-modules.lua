-- Snacks node_modules 搜索功能
return {
  'folke/snacks.nvim',
  opts = function(_, opts)
    -- 扩展 Snacks picker 配置以支持 node_modules 搜索
    opts.picker = opts.picker or {}
    opts.picker.sources = opts.picker.sources or {}
    
    -- 添加 node_modules 搜索源
    opts.picker.sources.node_modules = {
      name = "Node Modules",
      desc = "Search in node_modules directories",
      cmd = { "fd", "--type", "d", "--max-depth", "3", ".", "node_modules" },
      cwd = function()
        return vim.fn.getcwd()
      end,
      format = function(item)
        return item:gsub("^./node_modules/", "")
      end,
    }
    
    return opts
  end,
  
  keys = {
    {
      '<leader>sm',
      function()
        -- 使用 Snacks picker 搜索 node_modules
        require('snacks').picker.pick({
          name = "Node Modules",
          cmd = { "fd", "--type", "d", "--max-depth", "3", ".", "node_modules" },
          cwd = vim.fn.getcwd(),
          format = function(item)
            return item:gsub("^./node_modules/", "")
          end,
          actions = {
            default = function(item)
              -- 打开选中的 node_modules 目录
              vim.cmd('edit ' .. vim.fn.fnameescape(item))
            end,
          },
        })
      end,
      desc = '[S]earch node_[M]odules'
    },
  },
}