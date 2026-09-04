-- Minimal zero-dependency test runner for this config.
-- Usage: nvim --headless "+lua require('salar.tests.run')" "+qa"
local M = {}

local passed = 0
local failed = 0
local failures = {}

local function log(msg)
  io.write(msg .. "\n")
  io.flush()
end

local function ok(cond, name)
  if cond then
    passed = passed + 1
    log(string.format("  PASS: %s", name))
  else
    failed = failed + 1
    failures[#failures + 1] = name
    log(string.format("  FAIL: %s", name))
  end
end

local function equals(a, b, name)
  local a_str = vim.inspect(a)
  local b_str = vim.inspect(b)
  if a_str == b_str then
    passed = passed + 1
    log(string.format("  PASS: %s (%s)", name, a_str))
  else
    failed = failed + 1
    failures[#failures + 1] = name
    log(string.format("  FAIL: %s (expected %s, got %s)", name, b_str, a_str))
  end
end

local function section(name)
  log(string.format("\n# %s", name))
end

-- Set up a temp workspace
local function make_fixture()
  local tmp = vim.fn.tempname()
  vim.fn.mkdir(tmp, "p")
  vim.fn.writefile({
    "fn main() {",
    '    println!("hello world");',
    "}",
  }, tmp .. "/main.rs")
  vim.fn.writefile({ "print('hello python')" }, tmp .. "/test.py")
  return tmp
end

M.run = function()
  log("=== salar config tests ===")

  section("log module")
  local ok_log, logmod = pcall(require, "salar.core.log")
  ok(ok_log, "log module loads")
  if ok_log then
    equals(logmod.level, vim.log.levels.INFO, "default log level is info")
    ok(type(logmod.info) == "function", "log.info exists")
    ok(type(logmod.error) == "function", "log.error exists")
  end

  section("options")
  local ok_opts, opts = pcall(require, "salar.core.options")
  ok(ok_opts, "options module loads")
  if ok_opts then
    equals(vim.o.tabstop, 4, "tabstop is 4")
    equals(vim.o.shiftwidth, 4, "shiftwidth is 4")
    equals(vim.o.softtabstop, 4, "softtabstop is 4")
    equals(vim.o.expandtab, true, "expandtab is on")
  end

  section("telescope highlighter compat")
  require("lazy").load({ plugins = { "telescope.nvim" } })
  local ok_utils, utils = pcall(require, "telescope.previewers.utils")
  ok(ok_utils, "telescope previewers utils load")
  if ok_utils then
    equals(type(utils.ts_highlighter), "function", "ts_highlighter is a function")
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "fn main() {}" })
    vim.bo[buf].filetype = "rust"
    local ok_hl, _ = pcall(utils.ts_highlighter, buf, "rust")
    ok(ok_hl, "ts_highlighter does not crash on rust buffer")
  end

  section("telescope live_grep_args")
  local ok_lga, lga = pcall(require, "telescope-live-grep-args.prompt_parser")
  ok(ok_lga, "prompt_parser loads")
  if ok_lga then
    local parsed = lga.parse("def -g *.cpp", false)
    equals(parsed, { "def", "-g", "*.cpp" }, "flags split with auto_quoting=false")
  end

  section("telescope rg pipeline")
  local fixture = make_fixture()
  local ok_conf, conf = pcall(require, "telescope.config")
  if ok_conf then
    local cmd = {}
    for _, v in ipairs(conf.values.vimgrep_arguments) do
      cmd[#cmd + 1] = v
    end
    cmd[#cmd + 1] = "hello"
    cmd[#cmd + 1] = fixture
    local out = vim.fn.system(cmd)
    equals(vim.v.shell_error, 0, "rg exits 0")
    ok(out:find("main.rs", 1, true) ~= nil, "rg finds main.rs")
    ok(out:find("hello", 1, true) ~= nil, "rg finds hello")
  end

  section("which-key")
  local ok_wk, _ = pcall(require, "which-key")
  ok(ok_wk, "which-key loads")

  section("spectre")
  local ok_sp, _ = pcall(require, "spectre")
  ok(ok_sp, "spectre loads")

  log(string.format("\n=== %d passed, %d failed ===", passed, failed))
  if #failures > 0 then
    for _, f in ipairs(failures) do
      log("  FAILED: " .. f)
    end
  end

  vim.g.salar_test_passed = passed
  vim.g.salar_test_failed = failed
  -- Escape if input is consuming events (avoids hang in headless)
  vim.defer_fn(function()
    vim.cmd("qa!")
  end, 3000)
end

return M