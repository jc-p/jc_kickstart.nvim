-- Node modules 搜索功能 - 使用 Telescope 作为后备方案
return {
  {
    'nvim-telescope/telescope-node-modules.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension('node_modules')
    end,
  },
  {
    'folke/snacks.nvim',
    keys = {
      {
        '<leader>sm',
        function()
          -- 优先尝试使用 Snacks picker，失败则使用 Telescope
          local function search_node_modules()
            -- 检查当前目录及父目录是否有 node_modules
            local function find_node_modules()
              local cwd = vim.fn.getcwd()
              local paths_to_check = {
                cwd .. '/node_modules',
                cwd .. '/../node_modules',
                cwd .. '/../../node_modules',
              }
              
              for _, path in ipairs(paths_to_check) do
                if vim.fn.isdirectory(path) == 1 then
                  return vim.fn.fnamemodify(path, ':p')
                end
              end
              return nil
            end
            
            local node_modules_path = find_node_modules()
            if not node_modules_path then
              vim.notify('未找到 node_modules 目录', vim.log.levels.WARN)
              return
            end
            
            -- 尝试使用 Snacks picker
            local snacks = require('snacks')
            if snacks and snacks.picker and snacks.picker.files then
              snacks.picker.files({
                cwd = node_modules_path,
                prompt_title = '🔍 Node Modules',
                preview_title = '📦 Module Contents',
              })
            else
              -- 后备方案：使用 Telescope
              local telescope_ok, telescope = pcall(require, 'telescope')
              if telescope_ok and telescope.extensions.node_modules then
                telescope.extensions.node_modules.list({
                  search_dirs = { node_modules_path },
                  depth = 2,
                })
              else
                vim.notify('Snacks picker 和 Telescope node_modules 都不可用', vim.log.levels.ERROR)
              end
            end
          end
          
          search_node_modules()
        end,
        desc = '🔍 搜索 Node Modules',
      },
    },
  },
}