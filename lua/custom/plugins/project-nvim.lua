-- 项目管理
return {
  'ahmedkhalf/project.nvim',
  event = 'VeryLazy',
  opts = {
    manual_mode = false,
    detection_methods = { 'lsp', 'pattern' },
    patterns = {
      '.git',
      '_darcs',
      '.hg',
      '.bzr',
      '.svn',
      'Makefile',
      'package.json',
    },
    ignore_lsp = {},
    exclude_dirs = {},
    show_hidden = false,
    silent_chdir = true,
    scope_chdir = 'global',
  },
  config = function(_, opts)
    require('project_nvim').setup(opts)
  end,
}