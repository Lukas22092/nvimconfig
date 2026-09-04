local M = {}

local LEVELS = {
  trace = 0,
  debug = 1,
  info = 2,
  warn = 3,
  error = 4,
}

M.level = LEVELS[vim.g.salar_log_level or "info"] or LEVELS.info
M.enabled = vim.g.salar_log_enabled ~= false

M.filename = vim.fs.normalize(vim.fn.stdpath("cache") .. "/salar.log")

local function ensure_dir()
  vim.fn.mkdir(vim.fn.fnamemodify(M.filename, ":h"), "p")
end

local function write(level, msg)
  if not M.enabled then return end

  local ok, formatted = pcall(vim.inspect, msg)
  local text = ok and formatted or tostring(msg)

  ensure_dir()
  local fd = io.open(M.filename, "a")
  if not fd then return end

  local line = string.format(
    "[%s] [%s] %s\n",
    os.date("%Y-%m-%d %H:%M:%S"),
    level:upper(),
    text
  )
  fd:write(line)
  fd:close()
end

function M.trace(msg) if M.level <= LEVELS.trace then write("trace", msg) end end
function M.debug(msg) if M.level <= LEVELS.debug then write("debug", msg) end end
function M.info(msg) if M.level <= LEVELS.info then write("info", msg) end end
function M.warn(msg) if M.level <= LEVELS.warn then write("warn", msg) end end
function M.error(msg) if M.level <= LEVELS.error then write("error", msg) end end

function M.open()
  vim.cmd("edit " .. M.filename)
end

function M.clear()
  ensure_dir()
  local fd = io.open(M.filename, "w")
  if fd then fd:close() end
end

vim.api.nvim_create_user_command("SalarLog", function(opts)
  if opts.args == "open" then
    M.open()
  elseif opts.args == "clear" then
    M.clear()
  elseif opts.args == "level" then
    vim.notify("Current log level: " .. tostring(M.level), vim.log.levels.INFO)
  else
    M.open()
  end
end, {
  nargs = "?",
  complete = function()
    return { "open", "clear", "level" }
  end,
})

vim.api.nvim_create_user_command("SalarLogLevel", function(opts)
  if opts.args then
    local lvl = opts.args
    if LEVELS[lvl] then
      M.level = LEVELS[lvl]
      M.warn("Log level changed to " .. lvl)
    else
      vim.notify("Invalid level: " .. lvl, vim.log.levels.ERROR)
    end
  end
end, {
  nargs = 1,
  complete = function()
    return { "trace", "debug", "info", "warn", "error" }
  end,
})

return M