return {
	{
		"williamboman/mason.nvim",
		config = function()
			require('mason').setup()
		end
	},
	{
		'williamboman/mason-lspconfig.nvim',
		config = function()

      local servers = {
        "pyright",
				"ts_ls",
				"buf_ls",
				"lua_ls",
				-- "rust_analyzer",
			}

      local has_go = vim.fn.executable("go") == 1
      if has_go then
				table.insert(servers, "gopls")
			end

			require("mason-lspconfig").setup(
			{
        ensure_installed = servers
			})
		end
	}
}
