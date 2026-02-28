-- Basic config
require("mappings")
-- require("plugins")
require("config")

-- Lazy config
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

-- vim.notify = require("local.tests.logger").log
require("plugins")

-- Local plugins config
require("local.termux_clipboard")
require("local.restore_cursor")
require("local.home_or_word")
-- require("local.hi_hex")
require("local.note")

