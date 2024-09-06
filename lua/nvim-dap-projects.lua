local M = {}

local defaults = {
    inherit_adapters = false, -- inherit adapter configuration from global
}

M.config_paths = { "./.nvim-dap/nvim-dap.lua", "./.nvim-dap.lua", "./.nvim/nvim-dap.lua" }

M.options = {}

function M.setup(user_options)
    M.options = vim.tbl_extend("force", defaults, user_options or {})
end

function M.search_project_config()
    if not pcall(require, "dap") then
        vim.notify("[nvim-dap-projects] Could not find nvim-dap, make sure you load it before nvim-dap-projects.", vim.log.levels.ERROR, nil)
        return
    end
    local project_config = ""
    for _, p in ipairs(M.config_paths) do
        local f = io.open(p)
        if f ~= nil then
            f:close()
            project_config = p
            break
        end
    end
    if project_config == "" then
        return
    end
    vim.notify("[nvim-dap-projects] Found nvim-dap configuration at." .. project_config, vim.log.levels.INFO, nil)

    -- default is false to not break existing configuration
    if not M.options.inherit_adapters then
        require('dap').adapters = (function() return {} end)()
    end

    require('dap').configurations = (function() return {} end)()
    vim.cmd(":luafile " .. project_config)
end

return M
