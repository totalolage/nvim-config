vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

local function ensure_base46_cache_is_fresh()
  local cache_dir = vim.g.base46_cache
  if type(cache_dir) ~= "string" or cache_dir == "" then
    return
  end

  local cache_defaults = cache_dir .. "defaults"

  local function mtime_is_newer(a, b)
    if not a or not b then
      return false
    end

    if a.sec ~= b.sec then
      return a.sec > b.sec
    end

    return (a.nsec or 0) > (b.nsec or 0)
  end

  -- If the cache isn't present, we must compile before dofile().
  if not vim.uv.fs_stat(cache_defaults) then
    local ok, base46 = pcall(require, "base46")
    if ok and type(base46.compile) == "function" then
      base46.compile()
    end
    return
  end

  -- NvChad base46 writes our theme/highlight overrides into cache files.
  -- When config changes (e.g. transparency overrides in chadrc.lua), the
  -- cache can become stale and keep old solid background values.
  local chadrc_path = vim.fn.stdpath("config") .. "/lua/chadrc.lua"
  local chadrc_stat = vim.uv.fs_stat(chadrc_path)
  local defaults_stat = vim.uv.fs_stat(cache_defaults)

  if not chadrc_stat or not defaults_stat then
    return
  end

  if not mtime_is_newer(chadrc_stat.mtime, defaults_stat.mtime) then
    return
  end

  local ok, base46 = pcall(require, "base46")
  if ok and type(base46.compile) == "function" then
    base46.compile()
  end
end

local function load_base46_cache_file(cache_name)
  local cache_dir = vim.g.base46_cache
  if type(cache_dir) ~= "string" or cache_dir == "" then
    return false
  end

  local cache_path = cache_dir .. cache_name
  local uv = vim.uv or vim.loop
  if not (uv and type(uv.fs_stat) == "function" and uv.fs_stat(cache_path)) then
    vim.notify(
      ("base46 cache missing (%s); continuing without it"):format(cache_path),
      vim.log.levels.WARN
    )
    return false
  end

  local ok = pcall(dofile, cache_path)
  if ok then
    return true
  end

  local ok_base46, base46 = pcall(require, "base46")
  if not (ok_base46 and type(base46.compile) == "function") then
    vim.notify(
      "base46 not available to recompile cache; continuing without cache",
      vim.log.levels.WARN
    )
    return false
  end

  vim.notify(
    ("base46 cache corrupt/stale (%s); recompiling"):format(cache_path),
    vim.log.levels.WARN
  )

  local ok_compile = pcall(base46.compile)
  if not ok_compile then
    return false
  end

  local ok_retry, err_retry = pcall(dofile, cache_path)
  if ok_retry then
    return true
  end

  vim.notify(
    ("base46 cache still failing (%s); continuing without it: %s"):format(cache_path, tostring(err_retry)),
    vim.log.levels.ERROR
  )

  return false
end

-- load theme
ensure_base46_cache_is_fresh()
load_base46_cache_file("defaults")
load_base46_cache_file("statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
