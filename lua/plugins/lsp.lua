-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
-- -- Sntup language servers.
-- local lspconfig = require('lspconfig')
-- lspconfig.pyright.setup {}




-- Настройка Mason и LSP
-- require("mason").setup()
-- require("mason-lspconfig").setup({
--   ensure_installed = { "pyright" },
-- })
--
-- local lspconfig = require("lspconfig")
--
-- -- Автоматическое подключение серверов
-- require("mason-lspconfig").setup_handlers({
--   function(server)
--     lspconfig[server].setup({
--       capabilities = require("cmp_nvim_lsp").default_capabilities(),
--       on_attach = function(_, bufnr)
--         local opts = { buffer = bufnr, noremap = true, silent = true }
--         vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
--         vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
--         vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
--       end,
--     })
--   end,
-- })

-- ~/.config/nvim/lua/plugins/lsp.lua

-- -- Настройка автодополнения
-- local cmp = require("cmp")
-- cmp.setup({
--   snippet = {
--     expand = function(args)
--       require("luasnip").lsp_expand(args.body)
--     end,
--   },
--     ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.abort(),
--     ['<CR>'] = cmp.mapping.confirm({ select = true }), mapping = cmp.mapping.preset.insert({
--     -- ['<Tab>'] = cmp.mapping.select_next_item(),
--     -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
--     -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
--   }),
--   sources = {
--     { name = "nvim_lsp" },
--     { name = "luasnip" },
--     { name = "buffer" },
--   },
-- })
-- local cmp = require("cmp")
-- cmp.setup({
--   snippet = {
--     expand = function(args)
--       require("luasnip").lsp_expand(args.body)
--     end,
--   },
--   mapping = cmp.mapping.preset.insert({
--     ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.abort(),
--     ['<CR>'] = cmp.mapping.confirm({ select = true }),
--     -- ['<Tab>'] = cmp.mapping.select_next_item(),
--     -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
--   }),
--   sources = {
--     { name = "nvim_lsp" },
--     { name = "luasnip" },
--     { name = "buffer" },
--   },
-- })




-- require("mason").setup()
-- require("mason-lspconfig").setup({
--   ensure_installed = { "pyright" }, -- или другие LSP серверы
-- })
--
-- -- Настройка LSP серверов через lspconfig
-- local lspconfig = require("lspconfig")
-- lspconfig.pyright.setup({}) -- пример для Python
-- local cmp = require("cmp")
--
-- cmp.setup({
--   snippet = {
--     expand = function(args)
--       require("luasnip").lsp_expand(args.body)
--     end,
--   },
--   mapping = cmp.mapping.preset.insert({
--     ["<C-b>"] = cmp.mapping.scroll_docs(-4),
--     ["<C-f>"] = cmp.mapping.scroll_docs(4),
--     ["<C-Space>"] = cmp.mapping.complete(),
--     ["<C-e>"] = cmp.mapping.abort(),
--     ["<CR>"] = cmp.mapping.confirm({ select = true }),
--     -- ["<Tab>"] = cmp.mapping.select_next_item(), -- раскомментируйте, если нужно
--     -- ["<S-Tab>"] = cmp.mapping.select_prev_item(),
--   }),
--   sources = cmp.config.sources({
--     { name = "nvim_lsp" },
--     { name = "luasnip" },
--     { name = "buffer" },
--   }),
-- })
--
-- return {}
--
-- return {
--   {
--     "neovim/nvim-lspconfig",
--     config = function()
--       require("plugins.config.lsp")
--     end,
--   },
-- }

return {
	{
		"neovim/nvim-lspconfig",
		config = function()
      vim.lsp.config["lua_ls"] = { cmd = { "lua-language-server" } }
      vim.lsp.config["gopls"] = { cmd = { "gopls" } }
      vim.lsp.config["ts_ls"] = { cmd = { "typescript-language-server", "--stdio" } }
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Symbol" })
					vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<Leader>lf", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},
}
