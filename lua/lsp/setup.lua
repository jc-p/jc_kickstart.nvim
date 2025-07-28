-- LSP 设置模块
-- 合并 init.lua 和 custom/plugins/lsp.lua 中的 LSP 配置

local M = {}

-- 设置 LSP 服务器
function M.setup(opts)
  -- 设置诊断选项
  vim.diagnostic.config(opts.diagnostics)

  -- 设置 inlay hints
  if opts.inlay_hints.enabled then
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-inlay-hints', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.inlayHintProvider then
          local buffer = args.buf
          local exclude = opts.inlay_hints.exclude or {}
          local filetype = vim.bo[buffer].filetype
          if not vim.tbl_contains(exclude, filetype) then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end
      end,
    })
  end

  -- 设置 codelens
  if opts.codelens.enabled then
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-codelens', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.codeLensProvider then
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
            buffer = args.buf,
            callback = vim.lsp.codelens.refresh,
          })
        end
      end,
    })
  end

  -- 设置 document highlight
  if opts.document_highlight.enabled then
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-document-highlight', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = args.buf,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = args.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })
  end

  -- 设置 LSP 服务器
  -- 使用 blink.cmp 的 LSP 能力配置（替代 cmp_nvim_lsp）
  local capabilities = vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    require('blink.cmp').get_lsp_capabilities(),
    opts.capabilities or {}
  )

  -- 设置服务器
  local servers = opts.servers or {}
  local setup_handlers = opts.setup or {}
  local lspconfig = require('lspconfig')

  for server_name, server_opts in pairs(servers) do
    -- 检查是否有自定义设置函数
    local setup_handler = setup_handlers[server_name]
    if setup_handler then
      -- 如果自定义设置函数返回 true，则跳过默认设置
      if setup_handler() then
        goto continue
      end
    end

    -- 合并默认能力和服务器特定能力
    local server_capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})
    server_opts.capabilities = server_capabilities

    -- 设置服务器
    lspconfig[server_name].setup(server_opts)

    ::continue::
  end
end

return M