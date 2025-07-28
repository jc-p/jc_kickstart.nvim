return {
    'kylechui/nvim-surround',
    enabled = false,
    version = '*', -- 使用最新的稳定版本
    event = {'BufReadPost', 'BufNewFile'}, -- 在打开或创建文件时加载
    config = function()
        require('nvim-surround').setup({
            -- 修改配置以避免与 flash.nvim 冲突
            keymaps = {
                insert = "<C-g>s",
                insert_line = "<C-g>S",
                normal = "ys",
                normal_cur = "yss",
                normal_line = "yS",
                normal_cur_line = "ySS",
                -- 将 visual 模式下的快捷键从 S 改为 gs 以避免与 flash.nvim 冲突
                visual = "gs",
                visual_line = "gS",
                delete = "ds",
                change = "cs"
            }
        })
    end
}
