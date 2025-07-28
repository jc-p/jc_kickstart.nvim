-- ESLint 诊断脚本
-- 用于检查 eslint_d 配置和状态

local M = {}

-- 检查 eslint_d 是否安装
function M.check_eslint_d_installation()
  print("🔍 检查 eslint_d 安装状态...")
  
  local handle = io.popen("which eslint_d")
  local result = handle:read("*a")
  handle:close()
  
  if result and result ~= "" then
    print("✅ eslint_d 已安装: " .. result:gsub("\n", ""))
    
    -- 检查版本
    local version_handle = io.popen("eslint_d --version")
    local version = version_handle:read("*a")
    version_handle:close()
    print("📦 版本: " .. (version or "未知"):gsub("\n", ""))
  else
    print("❌ eslint_d 未安装")
    print("💡 安装命令: npm install -g eslint_d")
  end
end

-- 检查当前目录的 ESLint 配置
function M.check_eslint_config()
  print("\n🔧 检查 ESLint 配置文件...")
  
  local config_files = {
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json",
    "eslint.config.js",
    "eslint.config.ts",
  }
  
  local found_configs = {}
  for _, config in ipairs(config_files) do
    if vim.fn.filereadable(config) == 1 then
      table.insert(found_configs, config)
    end
  end
  
  if #found_configs > 0 then
    print("✅ 找到 ESLint 配置文件:")
    for _, config in ipairs(found_configs) do
      print("   - " .. config)
    end
  else
    print("❌ 未找到 ESLint 配置文件")
    print("💡 请确保项目根目录有 ESLint 配置文件")
  end
end

-- 检查 conform 配置
function M.check_conform_config()
  print("\n⚙️  检查 Conform 配置...")
  
  local ok, conform = pcall(require, "conform")
  if not ok then
    print("❌ Conform 插件未加载")
    return
  end
  
  -- 获取 eslint_d 格式化器配置
  local formatters = conform.list_formatters(0)
  local has_eslint_d = false
  
  for _, formatter in ipairs(formatters) do
    if formatter.name == "eslint_d" then
      has_eslint_d = true
      print("✅ eslint_d 格式化器已配置")
      print("   可用: " .. (formatter.available and "是" or "否"))
      if not formatter.available then
        print("   原因: " .. (formatter.available_msg or "未知"))
      end
      break
    end
  end
  
  if not has_eslint_d then
    print("❌ eslint_d 格式化器未配置")
  end
end

-- 测试 eslint_d 命令
function M.test_eslint_d_command()
  print("\n🧪 测试 eslint_d 命令...")
  
  -- 创建测试文件
  local test_content = "const a=1;let b = 2;console.log(a+b)"
  local test_file = "/tmp/eslint_test.js"
  
  local file = io.open(test_file, "w")
  if file then
    file:write(test_content)
    file:close()
    
    -- 测试 eslint_d 命令
    local cmd = string.format("eslint_d --fix %s 2>&1", test_file)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    local success = handle:close()
    
    if success then
      print("✅ eslint_d 命令执行成功")
      
      -- 读取修复后的文件
      local fixed_file = io.open(test_file, "r")
      if fixed_file then
        local fixed_content = fixed_file:read("*a")
        fixed_file:close()
        
        if fixed_content ~= test_content then
          print("✅ 文件已被格式化")
          print("   原始: " .. test_content)
          print("   修复: " .. fixed_content:gsub("\n", ""))
        else
          print("⚠️  文件未被修改（可能没有格式问题或配置问题）")
        end
      end
    else
      print("❌ eslint_d 命令执行失败")
      print("   错误: " .. (result or "未知错误"))
    end
    
    -- 清理测试文件
    os.remove(test_file)
  else
    print("❌ 无法创建测试文件")
  end
end

-- 检查 cwd 函数
function M.test_cwd_function()
  print("\n📁 测试 cwd 函数...")
  
  local ok, conform_util = pcall(require, "conform.util")
  if not ok then
    print("❌ 无法加载 conform.util")
    return
  end
  
  -- 模拟 ctx 对象
  local current_file = vim.fn.expand("%:p")
  local ctx = {
    filename = (current_file ~= "") and current_file or "/tmp/test.js"
  }
  
  local root = conform_util.root_file(ctx, {
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json",
    "eslint.config.js",
    "eslint.config.ts",
  })
  
  local final_cwd = root or vim.fn.fnamemodify(ctx.filename, ":h") or vim.fn.getcwd()
  
  print("✅ cwd 函数测试结果:")
  print("   文件: " .. tostring(ctx.filename))
  print("   根目录: " .. tostring(root or "未找到"))
  print("   最终 cwd: " .. tostring(final_cwd))
  print("   类型: " .. type(final_cwd))
end

-- 运行所有诊断
function M.run_all_diagnostics()
  print("🚀 ESLint 诊断开始...")
  print("=" .. string.rep("=", 50))
  
  M.check_eslint_d_installation()
  M.check_eslint_config()
  M.check_conform_config()
  M.test_cwd_function()
  M.test_eslint_d_command()
  
  print("\n" .. string.rep("=", 50))
  print("✅ ESLint 诊断完成！")
end

-- 创建用户命令
vim.api.nvim_create_user_command("EslintDiagnostic", function()
  M.run_all_diagnostics()
end, { desc = "运行 ESLint 诊断" })

-- 创建快捷键
vim.keymap.set("n", "<leader>ed", function()
  M.run_all_diagnostics()
end, { desc = "ESLint 诊断" })

return M