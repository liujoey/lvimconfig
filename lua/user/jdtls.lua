M = {}
M.json_decode = vim.json and vim.json.decode or vim.fn.json_decode

local function _load_json(jsonstr)
  local data = M.json_decode(jsonstr)
  if data and data["java.test.config"] then
    return data["java.test.config"]
  end
end

local function _run_test(mode)
  local status_ok, jdtls = pcall(require, "jdtls")
  if not status_ok then
    vim.notify("Failed to load jdtls", vim.log.levels.ERROR)
    return
  end

  local cb = function (setting)
    local overrides = {config_overrides=setting}
    if mode == "method" then
      jdtls.test_nearest_method(overrides)
    elseif mode == "class" then
      jdtls.test_class(overrides)
    end
  end

  return cb
end

local function load_test_settings()
  local resolved_path = vim.fn.getcwd() .. '/.vscode/settings.json'
  if not vim.loop.fs_stat(resolved_path) then
    return
  end
  local lines = {}
  for line in io.lines(resolved_path) do
    if not vim.startswith(vim.trim(line), '//') then
      table.insert(lines, line)
    end
  end
  local contents = table.concat(lines, '\n')
  local configurations = _load_json(contents)

  assert(configurations, "settings.json must have a \"java.test.config\" key")
  return configurations
end

M.load_launchjs = function ()
  local status_ok, dap, dapext
  status_ok, dap = pcall(require, "dap")
  if not status_ok then
    return
  end
  if dap.configurations.java then
    return
  end
  status_ok, dapext = pcall(require, "dap.ext.vscode")
  if not status_ok then
    return
  end
  dapext.load_launchjs()
end

M.start_test = function (mode)
  local test_settings = load_test_settings()
  print(vim.inspect(#test_settings))
  if test_settings and #test_settings == 1 then
    _run_test(mode)(test_settings[1])
    return
  end
  vim.ui.select(test_settings,
    {
      prompt = "Select test configuration",
      format_item = function(x)
        return x.name
      end
    },
    _run_test(mode)
  )
end

return M
